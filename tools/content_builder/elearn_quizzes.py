"""For every topic in inventory.json: fetch its resource page (textbook link +
page index) and all quiz questions (one per page, answer in a hidden field).
Writes <out>/books/<bookId>.json incrementally, so it can be resumed."""
import html
import json
import os
import re
import sys
import time
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor

OUT = sys.argv[1]
BASE = "https://www.elearn.gov.pk/elearn_app"
UA = {"User-Agent": "Mozilla/5.0 (compatible; school-assessment-content-builder)"}
os.makedirs(f"{OUT}/books", exist_ok=True)
sys.stdout.reconfigure(encoding="utf-8")


def get(url, tries=4):
    url = urllib.parse.quote(url, safe=":/?=&#%")
    for i in range(tries):
        try:
            with urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=40) as r:
                time.sleep(0.2)
                return r.read().decode("utf-8", "replace")
        except Exception as e:  # noqa
            if i == tries - 1:
                print("FAIL", url, e, flush=True)
                return None
            time.sleep(3 * (i + 1))


def text(s):
    return re.sub(r"\s+", " ", html.unescape(re.sub(r"<[^>]+>", " ", s))).strip()


def clean_title(t):
    return re.sub(r"^.*?>", "", t).strip() if "class=" in t else t


def parse_question(h):
    m = re.search(r'<div class="modal-body">(.*?)</form>', h, re.S)
    if not m:
        return None
    body = m.group(1)
    q = re.search(r"<span[^>]*>(.*?)</span>", body, re.S)
    ans = re.search(r'name="answer"\s+value="(.*?)"\s*/?>', body, re.S)
    opts = re.findall(r'name="option"\s+value="(.*?)"[^>]*>(.*?)(?:<br\s*/?>|</label>|$)', body, re.S)
    imgs = re.findall(r'<img[^>]+src="([^"]+)"', body)
    if not q or not ans:
        return None
    return {
        "text": text(q.group(1)),
        "answerValue": html.unescape(ans.group(1)).strip(),
        "options": [{"value": html.unescape(v).strip(), "label": text(lbl)} for v, lbl in opts],
        "images": imgs,
    }


def topic(t):
    rid, lvl, x = t["resId"], t["medium"], t["x"]
    h = get(f"{BASE}/resources/{rid}/{lvl}/{x}") or ""
    book = re.search(r'href="([^"]*onlinepdf[^"]*?)(?:#p=(\d+))?"', h)
    has_quiz = f"/quizzes/{rid}/{lvl}/{x}" in h
    res = {"resId": rid, "level": lvl, "x": x, "title": clean_title(t["title"]),
           "bookUrl": book.group(1) if book else None,
           "page": int(book.group(2)) if book and book.group(2) else None,
           "hasVideo": f"/videos/{rid}/" in h, "questions": []}
    if has_quiz:
        first = get(f"{BASE}/quizzes/{rid}/{lvl}/{x}") or ""
        pages = [int(p) for p in re.findall(r"\?page=(\d+)", first)]
        n = max(pages) if pages else 1
        htmls = [first] + [get(f"{BASE}/quizzes/{rid}/{lvl}/{x}?page={p}") or "" for p in range(2, n + 1)]
        for qh in htmls:
            q = parse_question(qh)
            if q:
                res["questions"].append(q)
    return res


def main():
    inv = json.load(open(f"{OUT}/inventory.json", encoding="utf-8"))
    for b in inv:
        path = f"{OUT}/books/{b['bookId']}.json"
        if os.path.exists(path):
            continue
        t0 = time.time()
        out = {k: b[k] for k in ("bookId", "grade", "name")}
        out["chapters"] = []
        for ch in b["chapters"]:
            with ThreadPoolExecutor(4) as ex:
                tops = list(ex.map(topic, ch["topics"]))
            out["chapters"].append({"number": ch["number"], "title": ch["title"], "topics": tops})
        json.dump(out, open(path + ".tmp", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
        os.replace(path + ".tmp", path)
        nq = sum(len(t["questions"]) for c in out["chapters"] for t in c["topics"])
        print(f"done grade {b['grade']} {b['name']}: {nq} questions in {time.time()-t0:.0f}s", flush=True)
    print("ALL_DONE", flush=True)


if __name__ == "__main__":
    main()
