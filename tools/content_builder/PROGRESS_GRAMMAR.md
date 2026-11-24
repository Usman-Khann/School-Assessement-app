# Grammar MCQ expansion: progress checkpoint (2026-11-24)

Goal (from the user): add as many MCQs per chapter as possible. In English and Urdu, about 85% must be
grammar/composition questions taken from each lesson's exercises. Lesson (comprehension) questions are trimmed
to about 5 per chapter.

## Done
| Book | Total MCQs | Grammar | % |
|---|---|---|---|
| English 3–10 | 3,233 | — | 85.6 |
| Urdu 3 | 754 | 645 | 85.5 |
| Urdu 4 | 749 | 639 | 85.3 |
| Urdu 5 | 721 | 606 | 84.0 |
| Urdu 6 | 605 | 505 | 83.5 |
| Urdu 7 | 573 | 473 | 82.5 |
| Urdu 8 (lessons 3–17 only) | 461 | 361 | 78.3 |

## Remaining (pick up here)
1. **Urdu 8**: lessons 18, 19 and 20, plus 1 and 2 (حمد/نعت). Exercise images are already rendered in
   `C:/dev/content/pectaa/view/g8_urdu_ex{18,19,20,1}.jpg`.
2. **Urdu 9** (19 lessons) and **Urdu 10** (20 lessons): about 25–30 grammar MCQs per lesson.
3. **Bring Urdu 5–8 to 85% or above**: either add top-ups or run `trim.py <key> 4` (4 lesson questions per chapter).
4. **Maths and Science (eLearn books)**: add more MCQs per chapter. A method still needs designing; the likely
   approach is an extra-question JSON per book, merged in `build_catalog.py`.
5. **Rebuild and release**:
   - Run `build_catalog.py`.
   - Copy the output to the app assets and to `content/`.
   - Run `flutter test`.
   - Bump the version to 2.2.0+4.
   - Build the split APKs and replace those in `release/`.
   - Update `OPUS_HANDOVER.md` and `content/README.md`, including the new `kind` field (`"g"` = grammar).

## Workflow
- To view an exercise: `python -I ex.py <key> <chapter> 3` writes `view/<key>_ex<chapter>.jpg`.
- To add questions: write `batches/<file>.txt` with one MCQ per line in the form
  `ch|question|correct|wrong1|wrong2|wrong3|explanation`.
- To import: `python -I gq.py <key> < batches/<file>.txt`. This prints the [lesson, grammar] count for each chapter.
- The working copies live in `C:/dev/content/pectaa/`. `content/pectaa_sources/` holds a copy of them.
