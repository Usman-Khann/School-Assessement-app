"""Make side-by-side reading images of two consecutive pages.
usage: pair.py <key> <pdfPage> [<pdfPage> ...]  -> C:/dev/content/pectaa/view/<key>_<p>.jpg"""
import os
import sys

from PIL import Image

key = sys.argv[1]
os.makedirs("C:/dev/content/pectaa/view", exist_ok=True)
for a in sys.argv[2:]:
    a = int(a)
    ims = []
    for p in (a, a + 1):
        f = f"C:/dev/content/pages_pectaa/{key}/{p:04d}.jpg"
        if os.path.exists(f):
            im = Image.open(f)
            # crop a little margin, scale to 620 px wide
            w, h = im.size
            im = im.crop((int(w * 0.04), int(h * 0.03), int(w * 0.96), int(h * 0.97)))
            im = im.resize((620, round(im.height * 620 / im.width)))
            ims.append(im)
    W = sum(i.width for i in ims) + 10 * (len(ims) - 1)
    H = max(i.height for i in ims)
    out = Image.new("RGB", (W, H), "white")
    x = 0
    for im in reversed(ims):  # Urdu books read right-to-left: first page on the right
        out.paste(im, (x, 0))
        x += im.width + 10
    out.save(f"C:/dev/content/pectaa/view/{key}_{a}.jpg", "JPEG", quality=72)
    print(f"view/{key}_{a}.jpg")
