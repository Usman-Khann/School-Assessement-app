"""Append grammar/composition MCQs. usage: gq.py key < lines
line: ch|question|correct|wrong1|wrong2|wrong3|explanation   (correct answer is shuffled in deterministically)"""
import hashlib, json, sys
sys.stdout.reconfigure(encoding="utf-8")
key = sys.argv[1]; kind = sys.argv[2] if len(sys.argv) > 2 else "g"
p = f"C:/dev/content/pectaa/{key}.json"; b = json.load(open(p, encoding="utf-8"))
chapters = {c[0] for c in b["chapters"]}
qs = b.setdefault("questions", []); seen = {q[1] + "|" + q[2][q[3]] for q in qs}
added = bad = 0
for line in sys.stdin.buffer.read().decode("utf-8").splitlines():
    line = line.strip()
    if not line or line.startswith("#"):
        continue
    parts = [x.strip() for x in line.split("|")]
    if len(parts) != 7:
        print("BAD FIELDS:", line[:80]); bad += 1; continue
    ch, text, c, w1, w2, w3, expl = parts
    ch = int(ch)
    opts = [c, w1, w2, w3]
    if ch not in chapters or len(set(opts)) != 4 or not all(opts):
        print("BAD:", line[:80]); bad += 1; continue
    if text + "|" + c in seen:
        continue
    pos = int(hashlib.md5(text.encode("utf-8")).hexdigest(), 16) % 4
    opts = [w1, w2, w3]; opts.insert(pos, c)
    qs.append([ch, text, opts, pos, expl, kind]); seen.add(text + "|" + c); added += 1
json.dump(b, open(p, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
per = {}
for q in qs:
    k = q[5] if len(q) > 5 else "lesson"
    per.setdefault(q[0], [0, 0])[0 if k == "lesson" else 1] += 1
print(key, "added", added, "bad", bad, "total", len(qs), "ch:[lesson,grammar]", per)
