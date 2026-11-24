"""Add supplementary MCQs for an eLearn (Maths/Science) book.
usage: python -I eq.py <key> < batch.txt
line format: ch|question|correct|wrong1|wrong2|wrong3|explanation
Stored in extra/<key>.json as [[ch, text, [4 opts], correctIndex, explanation], ...]
"""
import hashlib, json, os, sys
sys.stdout.reconfigure(encoding="utf-8"); sys.stdin.reconfigure(encoding="utf-8")
key = sys.argv[1]
D = os.path.dirname(os.path.abspath(__file__))
cat = json.load(open(f"{D}/../repo_content/catalog.json", encoding="utf-8"))
book = next(b for b in cat["books"] if b["key"] == key)
chs = {c["number"] for c in book["chapters"]}
path = f"{D}/{key}.json"
data = json.load(open(path, encoding="utf-8")) if os.path.exists(path) else []
seen = {q[1].strip().lower() for q in data}
added = bad = 0
for line in sys.stdin.read().splitlines():
    line = line.strip()
    if not line or line.startswith("#"):
        continue
    p = [x.strip() for x in line.split("|")]
    if len(p) != 7 or not p[0].isdigit() or int(p[0]) not in chs:
        bad += 1; print("BAD", line[:80]); continue
    ch, text, ok, w1, w2, w3, ex = int(p[0]), p[1], p[2], p[3], p[4], p[5], p[6]
    opts = [ok, w1, w2, w3]
    if len(set(opts)) != 4 or not all(opts) or not text:
        bad += 1; print("BAD opts", line[:80]); continue
    if text.lower() in seen:
        continue
    pos = int(hashlib.md5(text.encode()).hexdigest(), 16) % 4
    o = [w1, w2, w3]; o.insert(pos, ok)
    data.append([ch, text, o, pos, ex]); seen.add(text.lower()); added += 1
json.dump(data, open(path, "w", encoding="utf-8"), ensure_ascii=False, indent=0)
from collections import Counter
c = Counter(q[0] for q in data)
print(key, "added", added, "bad", bad, "total", len(data), dict(sorted(c.items())))
