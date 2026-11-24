"""Build the app content catalog from the scraped eLearn data.
Output (in <out>/repo_content):
  catalog.json            books, chapters, topics, page refs, file names
  packs/<key>.json        MCQs for one book
  report.txt              what was skipped and why
Stable string ids are used so re-imports update rows instead of duplicating."""
import hashlib
import json
import os
import re
import sys
from datetime import datetime, timezone

sys.path.insert(0, "C:/dev/tools")
from mathtext import convert  # noqa: E402

SRC = sys.argv[1]
OUT = f"{SRC}/repo_content"
os.makedirs(f"{OUT}/packs", exist_ok=True)
sys.stdout.reconfigure(encoding="utf-8")

# Teacher-style review decisions, keyed by question id:
#   {"correctIndex": n, "note": "..."} -> official answer was wrong, fixed
#   {"drop": "reason"}                  -> question removed (broken/ambiguous)
#   {"text": "...", "options": [...]}   -> wording repaired
FIXES_PATH = f"{SRC}/review_fixes.json"
FIXES = json.load(open(FIXES_PATH, encoding="utf-8")) if os.path.exists(FIXES_PATH) else {}


def folder_of(url):
    return re.sub(r"/mobile/index\.html.*$", "/", (url or "").split("#")[0])

SUBJECTS = {
    "snc mathematics": "Mathematics", "math": "Mathematics",
    "general math": "General Mathematics",
    "snc general science": "General Science", "science": "General Science",
    "general science": "General Science",
    "physics": "Physics", "chemistry": "Chemistry", "biology": "Biology",
}


def norm(s):
    return re.sub(r"\s+", " ", (s or "").replace(" ", " ")).strip()


def clean_title(t):
    t = norm(t).replace("â€™", "’")
    if "class=" in t:
        t = re.sub(r"^.*?>", "", t).strip()
    return t


def qid(text, opts):
    return "elq-" + hashlib.sha1((text + "|" + "|".join(opts)).encode("utf-8")).hexdigest()[:16]


def main():
    meta = json.load(open(f"{SRC}/pdf_meta.json", encoding="utf-8")) if os.path.exists(f"{SRC}/pdf_meta.json") else {}
    books, report = [], []
    totals = {"kept": 0, "dup": 0, "bad": 0}
    for f in sorted(os.listdir(f"{SRC}/books"), key=lambda x: int(x.split(".")[0])):
        b = json.load(open(f"{SRC}/books/{f}", encoding="utf-8"))
        if "Practical" in b["name"]:
            continue
        subject = SUBJECTS.get(norm(b["name"]).lower())
        if not subject:
            report.append(f"skip book {b['grade']} {b['name']}: unknown subject")
            continue
        m = meta.get(str(b["bookId"]), {})
        key = m.get("key") or f"g{b['grade']}_" + re.sub(r"[^a-z0-9]+", "_", b["name"].lower()).strip("_")
        bid = f"el-b{b['bookId']}"
        chapters, questions, seen = [], [], set()
        for c in b["chapters"]:
            cid = f"{bid}-c{c['number']}"
            topics, pages = [], []
            for t in c["topics"]:
                tid = f"{bid}-t{t['resId']}-{t['level']}"
                title = clean_title(t["title"])
                page = None
                if t.get("page"):
                    off = (m.get("offsets") or {}).get(folder_of(t.get("bookUrl")))
                    if off is not None:
                        page = off + t["page"]
                        pages.append(page)
                if not any(x["id"] == tid for x in topics):
                    topics.append({"id": tid, "title": title, "page": page})
                for q in t["questions"]:
                    text, ok1 = convert(norm(q["text"]))
                    conv = [convert(norm(o["label"])) for o in q["options"]]
                    labels = [x[0] for x in conv]
                    values = [norm(o["value"]) for o in q["options"]]
                    vconv = [convert(v)[0] for v in values]
                    ans = norm(q["answerValue"])
                    ansc = convert(ans)[0]
                    why = None
                    if not ok1 or not all(x[1] for x in conv):
                        why = "maths markup could not be converted"
                    elif not text:
                        why = "empty question"
                    elif len(labels) != 4:
                        why = f"{len(labels)} options"
                    elif any(not x for x in labels):
                        why = "empty option"
                    elif len({x.lower() for x in labels}) != 4:
                        why = "duplicate options"
                    elif q["images"]:
                        why = "needs a picture"
                    ci = None
                    if not why:
                        hits = [i for i, v in enumerate(values) if v == ans] or \
                               [i for i, v in enumerate(values) if v.lower() == ans.lower()] or \
                               [i for i, v in enumerate(vconv) if v.lower() == ansc.lower()] or \
                               [i for i, v in enumerate(labels) if v.lower() == ansc.lower()]
                        if len(hits) != 1:
                            why = f"answer '{ans}' not matched to one option"
                        else:
                            ci = hits[0]
                    if why:
                        totals["bad"] += 1
                        report.append(f"skip g{b['grade']} {subject} ch{c['number']}: {why}: {text[:70]}")
                        continue
                    k = qid(text, sorted(x.lower() for x in labels))
                    if k in seen:
                        totals["dup"] += 1
                        continue
                    seen.add(k)
                    item = {"id": f"{bid}-{k}", "chapterId": cid, "topicId": tid, "type": "mcq",
                            "text": text, "options": labels, "correctIndex": ci,
                            "page": page, "difficulty": 2, "source": "elearn"}
                    fx = FIXES.get(k[4:12])
                    if fx:
                        if "drop" in fx:
                            totals.setdefault("dropped_in_review", 0)
                            totals["dropped_in_review"] += 1
                            continue
                        for f2 in ("text", "options", "correctIndex"):
                            if f2 in fx:
                                item[f2] = fx[f2]
                        note = fx.get("note", "corrected in review")
                        item["reviewNote"] = note
                        # The reasoning part of a note doubles as a student explanation.
                        why = re.split(r";\s*(?:official|no official)|\s*\(official", note)[0].strip()
                        if why and not re.match(r"(?i)corrected|official|stray|options were|unit was|word|typo|wording|rotation|blank|% signs", why):
                            item["explanation"] = why[0].upper() + why[1:] + ("" if why.endswith(".") else ".")
                        totals.setdefault("fixed_in_review", 0)
                        totals["fixed_in_review"] += 1
                    totals["kept"] += 1
                    questions.append(item)
            chapters.append({"id": cid, "number": c["number"], "title": clean_title(c["title"]),
                             "pageStart": min(pages) if pages else None,
                             "pageEnd": None, "topics": topics})
        # Supplementary MCQs written for this book (content/extra/<key>.json).
        xp = f"{SRC}/extra/{key}.json"
        if os.path.exists(xp):
            bych = {ch["number"]: ch for ch in chapters}
            for x in json.load(open(xp, encoding="utf-8")):
                ch = bych.get(x[0])
                if not ch:
                    continue
                k = qid(x[1], sorted(o.lower() for o in x[2]))
                if k in seen:
                    continue
                seen.add(k)
                questions.append({"id": f"{bid}-x{k}", "chapterId": ch["id"],
                                  "topicId": ch["topics"][0]["id"] if ch["topics"] else None,
                                  "type": "mcq", "text": x[1], "options": x[2], "correctIndex": x[3],
                                  "page": ch["pageStart"], "difficulty": 2, "source": "extra",
                                  "explanation": x[4]})
                totals.setdefault("extra", 0)
                totals["extra"] += 1
        # Chapter page ranges: up to the page before the next chapter starts.
        starts = [ch["pageStart"] for ch in chapters]
        for i, ch in enumerate(chapters):
            nxt = [s for s in starts[i + 1:] if s]
            if ch["pageStart"] and nxt and nxt[0] > ch["pageStart"]:
                ch["pageEnd"] = nxt[0] - 1
            elif ch["pageStart"] and m.get("pages"):
                ch["pageEnd"] = m["pages"] if i == len(chapters) - 1 else None
        os.makedirs(f"{SRC}/review", exist_ok=True)
        with open(f"{SRC}/review/{key}.txt", "w", encoding="utf-8") as rv:
            for q in questions:
                rv.write(q["id"].split("elq-")[1][:8] + " " + q["text"] + " || " + " | ".join(
                    ("*" if j == q["correctIndex"] else "") + o for j, o in enumerate(q["options"])) + "\n")
        pack = f"packs/{key}.json"
        json.dump({"bookId": bid, "questions": questions},
                  open(f"{OUT}/{pack}", "w", encoding="utf-8"), ensure_ascii=False, separators=(",", ":"))
        books.append({
            "id": bid, "key": key, "grade": b["grade"], "subject": subject,
            "title": f"{subject} {b['grade']} (PCTB)" if subject != "Mathematics" or b["grade"] > 5 else f"SNC Mathematics {b['grade']} (PCTB)",
            "eLearnName": b["name"], "language": "en",
            "publisher": "Punjab Curriculum & Textbook Board (PCTB) - web version via eLearn Punjab",
            "sourceUrl": m.get("sourceBase") or "https://www.elearn.gov.pk/elearn_app/",
            "pdf": m.get("pdf"), "pdfBytes": m.get("bytes"), "pages": m.get("pages"),
            "pack": pack, "questionCount": len(questions), "chapters": chapters,
        })
        print(f"g{b['grade']:<2} {subject:<20} ch {len(chapters):>2}  mcq {len(questions):>4}", flush=True)
    # ---- PECTAA books (Urdu / English), built by hand from the official PDFs ----
    import glob as _glob
    for pf in sorted(_glob.glob(f"{SRC}/pectaa/*.json")):
        pb = json.load(open(pf, encoding="utf-8"))
        qs_raw = pb.get("questions") or []
        pdf_path = f"{SRC}/pdf/{pb['key']}.pdf"
        if not qs_raw or not os.path.exists(pdf_path):
            continue
        key = pb["key"]
        bid = f"pe-{key}"
        off = pb.get("offset", 0)
        npages = len([f for f in os.listdir(f"{SRC}/pages_pectaa/{key}") if f.endswith(".jpg")])
        chs = sorted(pb["chapters"], key=lambda c: c[2])
        chapters = []
        for i, (num, title, start) in enumerate(chs):
            s0 = start + off
            nxt = chs[i + 1][2] + off - 1 if i + 1 < len(chs) else npages
            chapters.append({"id": f"{bid}-c{num}", "number": num, "title": title,
                             "pageStart": s0, "pageEnd": nxt, "topics": []})
        start_of = {c["number"]: c["pageStart"] for c in chapters}
        questions = []
        for q in qs_raw:
            ch, text, opts, ci, expl = q[:5]
            h = hashlib.sha1((text + "|" + "|".join(sorted(o.lower() for o in opts))).encode("utf-8")).hexdigest()[:16]
            questions.append({"id": f"{bid}-pq-{h}", "chapterId": f"{bid}-c{ch}", "topicId": None,
                              "type": "mcq", "text": text, "options": opts, "correctIndex": ci,
                              "page": start_of.get(ch), "difficulty": 2, "source": "pectaa",
                              "explanation": expl, "kind": (q[5] if len(q) > 5 else "lesson")})
        pack = f"packs/{key}.json"
        json.dump({"bookId": bid, "questions": questions},
                  open(f"{OUT}/{pack}", "w", encoding="utf-8"), ensure_ascii=False, separators=(",", ":"))
        books.append({
            "id": bid, "key": key, "grade": pb["grade"], "subject": pb["subject"],
            "title": pb["title"], "language": pb.get("language", "en"),
            "publisher": "Punjab Education, Curriculum, Training and Assessment Authority (PECTAA)",
            "sourceUrl": pb.get("sourceUrl", "https://pectaa.edu.pk/curriculum-compliance/"),
            "pdf": f"books/{key}.pdf", "pdfBytes": os.path.getsize(pdf_path), "pages": npages,
            "pack": pack, "questionCount": len(questions), "chapters": chapters,
        })
        print(f"g{pb['grade']:<2} {pb['subject']:<20} ch {len(chapters):>2}  mcq {len(questions):>4}  (PECTAA)", flush=True)

    catalog = {
        "format": 1,
        "version": datetime.now(timezone.utc).strftime("%Y%m%d%H%M"),
        "generatedAt": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "note": ("Maths and Science: chapters, topics, page numbers and MCQs from eLearn Punjab "
                 "(elearn.gov.pk, PITB/PCTB), reviewed and corrected. Urdu and English: official "
                 "PECTAA textbooks (pectaa.edu.pk); MCQs written from each lesson. Page numbers "
                 "are page positions in the book file. Not yet checked by a teacher."),
        "books": books,
    }
    json.dump(catalog, open(f"{OUT}/catalog.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    open(f"{OUT}/report.txt", "w", encoding="utf-8").write("\n".join(report))
    print("TOTALS", totals, "books", len(books))


if __name__ == "__main__":
    main()
