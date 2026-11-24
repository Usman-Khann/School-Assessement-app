"""Exercise view: last N pages of a lesson side by side (RTL). usage: ex.py key ch [N=2]"""
import json, os, sys
from PIL import Image
key, ch = sys.argv[1], int(sys.argv[2]); N = int(sys.argv[3]) if len(sys.argv) > 3 else 2
b = json.load(open(f"C:/dev/content/pectaa/{key}.json", encoding="utf-8"))
chs = sorted(b["chapters"], key=lambda c: c[2]); d = f"C:/dev/content/pages_pectaa/{key}"
npg = len([f for f in os.listdir(d) if f.endswith(".jpg")])
i = [c[0] for c in chs].index(ch); s = chs[i][2]; e = chs[i+1][2]-1 if i+1 < len(chs) else min(s+7, npg)
pages = list(range(max(s, e-N+1), e+1))
ims = []
for p in pages:
    im = Image.open(f"{d}/{p:04d}.jpg"); w, h = im.size
    im = im.crop((int(w*.04), int(h*.03), int(w*.96), int(h*.97))); im = im.resize((640, round(im.height*640/im.width))); ims.append(im)
W = sum(x.width for x in ims) + 10*(len(ims)-1); H = max(x.height for x in ims)
out = Image.new("RGB", (W, H), "white"); x = 0
for im in reversed(ims): out.paste(im, (x, 0)); x += im.width + 10
f = f"C:/dev/content/pectaa/view/{key}_ex{ch}.jpg"; out.save(f, quality=72); print(f, pages)
