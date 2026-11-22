"""Download every page image of each official eLearn textbook and build one
compressed PDF per book: <out>/pdf/<key>.pdf

Two layouts exist on eLearn:
  * whole book: every chapter folder holds the same full flipbook (SNC 3-5)
  * per chapter: each chapter folder is a separate flipbook (classes 6-10)
For per-chapter books the chapters are joined in chapter order and the page
offset of every folder is recorded, so topic pages map into the joined PDF.
Resumable: pages already on disk are reused."""
import io
import json
import os
import re
import sys
import time
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor

import img2pdf
from PIL import Image

OUT = sys.argv[1]
ONLY = sys.argv[2:]  # optional book keys
UA = {"User-Agent": "Mozilla/5.0 (compatible; school-assessment-content-builder)"}
sys.stdout.reconfigure(encoding="utf-8")


def fetch(url, tries=5):
    url = urllib.parse.quote(url, safe=":/?=&#%")
    for i in range(tries):
        try:
            with urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=60) as r:
                return r.read()
        except urllib.error.HTTPError as e:
            if e.code == 404:
                return None
            time.sleep(3 * (i + 1))
        except Exception:  # noqa
            time.sleep(3 * (i + 1))
    print("FAIL", url, flush=True)
    return None


def slug(s):
    return re.sub(r"[^a-z0-9]+", "_", s.lower()).strip("_")


def folder_of(url):
    return re.sub(r"/mobile/index\.html.*$", "/", url.split("#")[0])


def folder_info(base):
    cfg = (fetch(base + "mobile/javascript/config.js") or b"").decode("utf-8", "replace")
    n = re.search(r"totalPageCount=(\d+)", cfg)
    t = re.search(r'bookTitle="([^"]*)"', cfg)
    return (int(n.group(1)) if n else 0), (t.group(1) if t else "")


def download_pages(base, n, pdir):
    os.makedirs(pdir, exist_ok=True)

    def page(i):
        p = f"{pdir}/{i:04d}.jpg"
        if os.path.exists(p) and os.path.getsize(p) > 0:
            return p
        data = fetch(f"{base}files/mobile/{i}.jpg")
        if not data:
            return None
        im = Image.open(io.BytesIO(data)).convert("RGB")
        if im.width > 1100:
            im = im.resize((1100, round(im.height * 1100 / im.width)), Image.LANCZOS)
        im.save(p, "JPEG", quality=58, optimize=True, progressive=True)
        time.sleep(0.1)
        return p

    with ThreadPoolExecutor(4) as ex:
        return list(ex.map(page, range(1, n + 1)))


def main():
    os.makedirs(f"{OUT}/pdf", exist_ok=True)
    mpath = f"{OUT}/pdf_meta.json"
    meta = json.load(open(mpath, encoding="utf-8")) if os.path.exists(mpath) else {}
    for f in sorted(os.listdir(f"{OUT}/books"), key=lambda x: int(x.split(".")[0])):
        b = json.load(open(f"{OUT}/books/{f}", encoding="utf-8"))
        if "Practical" in b["name"]:
            continue
        key = f"g{b['grade']}_{slug(b['name'])}"
        if ONLY and key not in ONLY:
            continue
        if str(b["bookId"]) in meta and meta[str(b["bookId"])].get("layout") and not ONLY:
            continue
        # folder used by each chapter, in chapter order
        chap_folders = []
        for c in b["chapters"]:
            fs = [folder_of(t["bookUrl"]) for t in c["topics"] if t.get("bookUrl")]
            chap_folders.append((c["number"], fs[0] if fs else None))
        folders = []
        for _, fo in chap_folders:
            if fo and fo not in folders:
                folders.append(fo)
        if not folders:
            print("no book link:", key, flush=True)
            continue
        t0 = time.time()
        infos = {fo: folder_info(fo) for fo in folders}
        counts = {v[0] for v in infos.values()}
        whole = len(folders) == 1 or (len(counts) == 1 and len({v[1] for v in infos.values()}) == 1
                                      and next(iter(counts)) > 60)
        files, offsets = [], {}
        if whole:
            fo = folders[0]
            files = download_pages(fo, infos[fo][0], f"{OUT}/pages/{key}")
            for x in folders:
                offsets[x] = 0
        else:
            for i, fo in enumerate(folders):
                offsets[fo] = len([p for p in files if p])
                files += download_pages(fo, infos[fo][0], f"{OUT}/pages/{key}/f{i:02d}")
        missing = sum(1 for p in files if not p)
        files = [p for p in files if p]
        pdf = f"{OUT}/pdf/{key}.pdf"
        with open(pdf, "wb") as fh:
            fh.write(img2pdf.convert(files))
        size = os.path.getsize(pdf)
        meta[str(b["bookId"])] = {"key": key, "layout": "whole" if whole else "per-chapter",
                                  "pages": len(files), "missingPages": missing,
                                  "offsets": offsets, "sourceBase": folders[0],
                                  "pdf": f"books/{key}.pdf", "bytes": size}
        json.dump(meta, open(mpath, "w", encoding="utf-8"), indent=1)
        print(f"{key}: {'whole' if whole else str(len(folders)) + ' chapter files'}, "
              f"{len(files)} pages, missing {missing}, {size/1048576:.1f} MB, {time.time()-t0:.0f}s", flush=True)
    print("ALL_DONE", flush=True)


if __name__ == "__main__":
    main()
