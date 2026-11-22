"""Inventory of eLearn Punjab (official PITB/PCTB site): grades -> books ->
chapters -> topics -> resource ids. Writes inventory.json into argv[1]."""
import html
import json
import re
import sys
import time
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor

BASE = "https://www.elearn.gov.pk/elearn_app"
OUT = sys.argv[1]
UA = {"User-Agent": "Mozilla/5.0 (compatible; school-assessment-content-builder)"}


def get(url, tries=4):
    url = urllib.parse.quote(url, safe=":/?=&#%")
    for i in range(tries):
        try:
            with urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=40) as r:
                time.sleep(0.15)
                return r.read().decode("utf-8", "replace")
        except Exception as e:  # noqa
            if i == tries - 1:
                print("FAIL", url, e, flush=True)
                return ""
            time.sleep(2 * (i + 1))


def text(s):
    return re.sub(r"\s+", " ", html.unescape(re.sub(r"<[^>]+>", " ", s))).strip()


def books_of(grade):
    h = get(f"{BASE}/grades/{grade}")
    out = []
    # each book: <a href=".../chapters/ID"> ... <img src=".../images/NAME.png">
    for m in re.finditer(r'href="[^"]*/chapters/(\d+)"(.*?)</a>', h, re.S):
        img = re.search(r'images/([^"/]+)\.(?:png|jpg)', m.group(2))
        name = text(m.group(2)) or (img.group(1) if img else "")
        if not name and img:
            name = img.group(1)
        out.append({"bookId": int(m.group(1)), "name": name or (img.group(1) if img else "?")})
    return out


def chapters_of(book_id):
    h = get(f"{BASE}/chapters/{book_id}")
    # <a href=".../topics/B/N"><img .../></a> <a href="#" class="d-block tp">N.Title</a>
    nums = [int(n) for n in re.findall(r'/topics/%d/(\d+)"' % book_id, h)]
    titles = [text(t) for t in re.findall(r'class="d-block tp"[^>]*>(.*?)</a>', h, re.S)]
    out = []
    for i, n in enumerate(nums):
        t = titles[i] if i < len(titles) else f"Chapter {n}"
        t = re.sub(r"^\s*\d+\s*[.\-:)]\s*", "", t).strip()
        out.append({"number": n, "title": t})
    return out


def book_names(grade):
    h = get(f"{BASE}/grades/{grade}")
    out = {}
    for m in re.finditer(r'/chapters/(\d+)"(.*?)</a>', h, re.S):
        img = re.search(r'images/([^"]+?)\.(?:png|jpg)', m.group(2))
        out[int(m.group(1))] = html.unescape(img.group(1)) if img else "?"
    return out


def topics_of(book_id, ch):
    h = get(f"{BASE}/topics/{book_id}/{ch}")
    out = []
    for m in re.finditer(r'href="[^"]*/resources/(\d+)/(\d+)/(\d+)"(.*?)</a>', h, re.S):
        out.append({"resId": int(m.group(1)), "medium": int(m.group(2)),
                    "x": int(m.group(3)), "title": text(m.group(4)).lstrip("> ").strip()})
    return out


def main():
    sys.stdout.reconfigure(encoding="utf-8")
    inv = []
    for g in range(3, 11):
        bs = books_of(g)
        names = book_names(g)
        for b in bs:
            b["name"] = names.get(b["bookId"], b["name"])
        print("grade", g, [b["name"] for b in bs], flush=True)
        for b in bs:
            b["grade"] = g
            b["chapters"] = chapters_of(b["bookId"])
            with ThreadPoolExecutor(4) as ex:
                tops = list(ex.map(lambda c: topics_of(b["bookId"], c["number"]), b["chapters"]))
            for c, t in zip(b["chapters"], tops):
                c["topics"] = t
            print("  ", b["name"], len(b["chapters"]), "chapters",
                  sum(len(c["topics"]) for c in b["chapters"]), "topic links", flush=True)
            inv.append(b)
    with open(f"{OUT}/inventory.json", "w", encoding="utf-8") as f:
        json.dump(inv, f, ensure_ascii=False, indent=1)


if __name__ == "__main__":
    main()
