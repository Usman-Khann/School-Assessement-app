"""Keep at most N lesson (comprehension) questions per chapter. usage: trim.py key [N=5]"""
import json, sys
key = sys.argv[1]; N = int(sys.argv[2]) if len(sys.argv) > 2 else 5
p = f"C:/dev/content/pectaa/{key}.json"; b = json.load(open(p, encoding="utf-8"))
cnt, out = {}, []
for q in b["questions"]:
    kind = q[5] if len(q) > 5 else "lesson"
    if kind == "lesson":
        cnt[q[0]] = cnt.get(q[0], 0) + 1
        if cnt[q[0]] > N:
            continue
    out.append(q)
print(key, "before", len(b["questions"]), "after", len(out))
b["questions"] = out
json.dump(b, open(p, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
