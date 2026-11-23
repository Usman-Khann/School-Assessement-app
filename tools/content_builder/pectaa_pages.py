"""For one downloaded PECTAA book PDF (vector or image pages):
 - renders every page to <pages>/<key>/NNNN.jpg (1100 px wide) for the repo PDF
 - writes previews <pages>/<key>/small/NNNN.jpg (760 px) for reading
 - builds the compressed PDF <pdfdir>/<key>.pdf
Usage: pectaa_pages.py <book.pdf> <key> <pages_dir> <pdf_dir>"""
import os
import sys

import img2pdf
import pypdfium2 as pdfium

src, key, pages_dir, pdf_dir = sys.argv[1:5]
out = os.path.join(pages_dir, key)
os.makedirs(os.path.join(out, "small"), exist_ok=True)
os.makedirs(pdf_dir, exist_ok=True)
doc = pdfium.PdfDocument(src)
files = []
for i in range(len(doc)):
    p = os.path.join(out, f"{i + 1:04d}.jpg")
    if not os.path.exists(p) or os.path.getsize(p) < 10000:
        page = doc[i]
        w, _ = page.get_size()
        im = page.render(scale=1100 / w).to_pil().convert("RGB")
        im.save(p, "JPEG", quality=60, optimize=True, progressive=True)
        sm = im.resize((760, round(im.height * 760 / im.width)))
        sm.save(os.path.join(out, "small", f"{i + 1:04d}.jpg"), "JPEG", quality=70)
    files.append(p)
pdf = os.path.join(pdf_dir, f"{key}.pdf")
with open(pdf, "wb") as fh:
    fh.write(img2pdf.convert(files, layout_fun=img2pdf.get_layout_fun((img2pdf.mm_to_pt(210), None))))
print(key, len(doc), "pages ->", round(os.path.getsize(pdf) / 1048576, 1), "MB", flush=True)
