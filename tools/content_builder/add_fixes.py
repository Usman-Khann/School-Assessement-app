"""Merge review fixes (JSON object on stdin) into C:/dev/content/review_fixes.json."""
import json
import sys

P = "C:/dev/content/review_fixes.json"
cur = json.load(open(P, encoding="utf-8"))
new = json.loads(sys.stdin.buffer.read().decode("utf-8"))
cur.update(new)
json.dump(cur, open(P, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print(len(new), "added;", len(cur), "total;",
      sum(1 for v in cur.values() if "drop" in v), "dropped")
