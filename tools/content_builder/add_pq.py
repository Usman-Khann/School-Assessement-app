"""Append MCQs to a PECTAA book file.
stdin: JSON list of [chapterNumber, text, [o1,o2,o3,o4], correctIndex, explanation]
Validates: 4 distinct non-empty options, index 0-3, chapter exists."""
import json
import sys

sys.stdout.reconfigure(encoding="utf-8")
key = sys.argv[1]
p = f"C:/dev/content/pectaa/{key}.json"
book = json.load(open(p, encoding="utf-8"))
chapters = {c[0] for c in book["chapters"]}
qs = book.setdefault("questions", [])
seen = {q[1] for q in qs}
new = json.loads(sys.stdin.buffer.read().decode("utf-8"))
added = 0
for q in new:
    ch, text, opts, ci, expl = q
    assert ch in chapters, f"unknown chapter {ch}: {text}"
    assert len(opts) == 4 and all(o.strip() for o in opts), f"need 4 options: {text}"
    assert len({o.strip().lower() for o in opts}) == 4, f"duplicate options: {text}"
    assert 0 <= ci <= 3, f"bad index: {text}"
    if text in seen:
        continue
    qs.append(q)
    seen.add(text)
    added += 1
json.dump(book, open(p, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
per = {}
for q in qs:
    per[q[0]] = per.get(q[0], 0) + 1
print(key, "added", added, "total", len(qs), "per chapter", per)
