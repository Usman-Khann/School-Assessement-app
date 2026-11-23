"""Grammar/composition headings per unit from OCR. usage: gtopics.py key"""
import json, re, sys
sys.stdout.reconfigure(encoding="utf-8")
key = sys.argv[1]
b = json.load(open(f"C:/dev/content/pectaa/{key}.json", encoding="utf-8"))
chs = sorted(b["chapters"], key=lambda c: c[2])
pages = {}; cur = None
for line in open(f"C:/dev/content/pectaa/{key}.ocr.txt", encoding="utf-8"):
    m = re.match(r"=== page (\d+)", line)
    if m: cur = int(m.group(1)); continue
    pages.setdefault(cur, []).append(line.strip())
KW = re.compile(r"(noun|pronoun|verb|adjective|adverb|tense|article|preposition|conjunction|punctuation|capital|sentence|singular|plural|gender|synonym|antonym|homophone|prefix|suffix|apostrophe|comma|question mark|full stop|vowel|consonant|digraph|syllable|dictionary|alphabetical|letter writing|paragraph|story|invitation|note|diary|email|application|essay|direct|indirect|active|passive|clause|phrase|modal|interjection|degree|comparative|superlative|countable|collective|possessive|contraction|compound|rhym|simile|metaphor|personification|idiom|tense|subject|object|determiner|quantifier|gerund|infinitive|participle|transition|summary|dialogue|report|writing|grammar|spell)", re.I)
for i, (n, t, s) in enumerate(chs):
    e = chs[i+1][2]-1 if i+1 < len(chs) else max(k for k in pages if k)
    hits = []
    for p in range(s, e+1):
        for l in pages.get(p, []):
            if 6 < len(l) < 70 and KW.search(l) and not re.search(r"(students|Ask |Tell |Guide|Encourage|Have them|will be able)", l):
                if l not in hits: hits.append(l)
    print(f"## {n} {t}: " + " ; ".join(hits[:22]))
