"""Contact sheet of page thumbnails with page numbers.
usage: sheet.py <key> <from> <to>  -> view/<key>_sheet_<from>.jpg (6 columns)"""
import sys

from PIL import Image, ImageDraw

key, a, b = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
cols, tw = 6, 200
thumbs = []
for p in range(a, b + 1):
    try:
        im = Image.open(f"C:/dev/content/pages_pectaa/{key}/{p:04d}.jpg").convert("RGB")
    except FileNotFoundError:
        continue
    im = im.crop((0, 0, im.width, int(im.height * 0.45)))  # top part shows the lesson header
    im = im.resize((tw, round(im.height * tw / im.width)))
    d = ImageDraw.Draw(im)
    d.rectangle((0, 0, 44, 22), fill="black")
    d.text((4, 4), str(p), fill="yellow")
    thumbs.append(im)
th = max(t.height for t in thumbs)
rows = (len(thumbs) + cols - 1) // cols
sheet = Image.new("RGB", (cols * (tw + 6), rows * (th + 6)), "white")
for i, t in enumerate(thumbs):
    sheet.paste(t, ((i % cols) * (tw + 6), (i // cols) * (th + 6)))
out = f"C:/dev/content/pectaa/view/{key}_sheet_{a}.jpg"
sheet.save(out, "JPEG", quality=70)
print(out)
