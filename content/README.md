# School Assessment app – textbook content

This folder is read by the School Assessment app. When a phone is online, the
app downloads `catalog.json`; if its `version` is newer than what the phone
has, it downloads the changed question packs. Book PDFs are downloaded only
when a teacher taps **Download book**, and are then kept on the phone for
offline reading.

| Path | What it is |
|---|---|
| `catalog.json` | Every book: class, subject, chapters, topics, the page where each topic starts, and file names |
| `packs/<book>.json` | Multiple-choice questions for one book |
| `books/<book>.pdf` | The textbook itself |
| `review/review_fixes.json` | Every correction made to the original questions, with the reason |
| `review/skipped_on_import.txt` | Original questions left out because they were broken |

## Where the content comes from

All books, chapters, topics, page positions and MCQs were taken from
**eLearn Punjab** (https://www.elearn.gov.pk/elearn_app/), the official
e-learning site of the Punjab Government (PITB), which shows the
**Punjab Curriculum and Textbook Board (PCTB)** textbooks page by page.

* The PDFs were assembled from the page images that eLearn shows publicly. Each
  page carries PCTB's own watermark ("Web version of PCTB Textbook").
  **The textbooks are the property of PCTB.** They are included here only so
  teachers can use them inside this free assessment app.
* eLearn offers Mathematics and Science for classes 3-10 (General Knowledge in
  Urdu for class 3, with no quiz or book file), and Physics, Chemistry,
  Biology, General Mathematics and General Science for classes 9-10.
  eLearn has no Urdu or English subject books.
* **Urdu and English for classes 3-10** (16 books) are the official PECTAA
  textbooks, downloaded from https://pectaa.edu.pk/curriculum-compliance/
  (Google Drive links on that page). Chapters were read from each book's
  contents and lesson pages. Their MCQs were **written by Claude from the
  lesson text** (comprehension, vocabulary, grammar boxes shown in the book);
  each has an explanation quoting or pointing to the book.
* eLearn's editions may be older than the newest printed books for some
  classes. A teacher can import a newer PDF in the app; old versions are kept.
* Page numbers in the catalog are positions inside the PDF file (page 1 = the
  first page of the file), not the number printed on the page.

## Quality review of the MCQs

The eLearn quizzes were collected (3,280 questions), duplicates were removed,
and **every remaining question was read and checked**:

* 187 questions were corrected: a wrong official answer (for example
  "3/15 + 4/15 = 7/30", "speed of sound is maximum in air"), a missing blank,
  or options garbled by a spreadsheet (e.g. "8:12:9" shown as a clock time).
* 198 questions were removed: no correct option, two correct options,
  missing figure, or unreadable.
* Maths written in LaTeX/MathML was converted to plain text (x², √2, ½ …).

Result: **2,364 reviewed eLearn MCQs across 23 books**. Every change is listed in
`review/review_fixes.json` with its reason, so a teacher can check it.

## Question bank expansion (v2.2.0)

* **Maths and Science (23 eLearn books):** 2,365 extra MCQs were written by
  Claude, about 10–15 per chapter. These cover chapters that had no official
  quiz at all, such as Maths 9 chapters 10–17 and Maths 10 chapters 8–12.
  Source files are `extra/<book>.json` (`[chapter, text, [4 options],
  correctIndex, explanation]`), created from `extra/b_*.txt` with `extra/eq.py`.
  They are marked `"source": "extra"` in the packs.
* **Urdu and English (16 PECTAA books):** at least 85% of each book's MCQs are
  now **grammar and composition** questions taken from that lesson's own
  exercises (مشق / قواعد / grammar boxes). Each chapter keeps 4–5 lesson
  (comprehension) questions. In the source files a 6th element `"g"` marks
  a grammar question. In the packs this becomes `"kind": "g"` (grammar) or
  `"kind": "lesson"`.

| Subject | MCQs |
|---|---|
| English 3–10 | 3,233 (85.6% grammar) |
| Urdu 3–10 | 4,997 (every book 85–87% grammar) |
| Mathematics + General Mathematics | 2,172 |
| Science (General Science, Physics, Chemistry, Biology) | 2,557 |
| **Total (39 books)** | **12,959** |

All questions are still marked "not verified by a teacher" in the app.
