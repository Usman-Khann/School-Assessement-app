# Question bank expansion: COMPLETE (v2.2.0, 2026-11-24)

Goal (from the user):
- Add as many MCQs per chapter as possible.
- In English and Urdu, about 85% of the MCQs must be grammar/composition questions taken from each lesson's exercises.

## Final counts
| Book | MCQs | Grammar % |
|---|---|---|
| English 3–10 | 3,233 | 85.6 |
| Urdu 3 / 4 / 5 / 6 / 7 / 8 / 9 / 10 | 754 / 749 / 698 / 585 / 553 / 548 / 541 / 569 | 85.5 / 85.3 / 86.8 / 86.3 / 85.5 / 85.4 / 86.0 / 85.9 |
| Maths + General Maths (eLearn) | 2,172 | — |
| Science, Physics, Chemistry, Biology (eLearn) | 2,557 | — |
| **Total, 39 books** | **12,959** | |

## Workflow (for future additions)
- **Urdu/English (PECTAA):**
  1. Run `python -I ex.py <key> <ch> 3` to render the lesson's exercise pages to `view/`.
  2. Write `batches/<file>.txt`, one MCQ per line: `ch|question|correct|w1|w2|w3|explanation`.
  3. Import with `python -I gq.py <key> < batches/<file>.txt`.
  4. Use `trim.py <key> N` to cap the lesson questions per chapter.
- **Maths/Science (eLearn):**
  1. Write `content/extra/b_*.txt`, with `#<key>` section headers and the same line format.
  2. Import with `python -I content/extra/imp.py <file>`.
  3. `build_catalog.py` merges `content/extra/<key>.json` into the packs.
- **Then:**
  1. Run `build_catalog.py`.
  2. Copy `catalog.json` and `packs/` to `assets/content/` and `content/`.
  3. Run `flutter test`.
  4. Bump the version and build the split APKs.
