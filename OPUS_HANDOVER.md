# OPUS_HANDOVER

Offline-first School Assessment & Student Progress app (Flutter, Android-first, Punjab classes 3-10).
Round 1 (16-17 Nov 2026, Claude Fable 5.2): app foundation. Round 2 (22 Nov 2026, Claude Opus 5.5):
official textbook content, online content sync, in-app reader, visual redesign.
This file states only what was actually built and checked.

Repository: https://github.com/Usman-Khann/School-Assessement-app (public). App source at the root,
downloadable content in `content/`.

## 0. Read this first
- **Build from a short path.** The Claude session folder has a very long path and Dart's build tools fail
  there. Working copy: `C:\dev\school_assess`; the git checkout used for pushing is `C:\dev\repo`.
- Toolchain (nothing system-wide changed): Flutter 3.50.0 `C:\dev\flutter`, Temurin JDK 17 `C:\dev\jdk`,
  Android SDK `C:\dev\android-sdk`, Python venv with Pillow/img2pdf/pypdf `C:\dev\pyenv`.
- Verified: `flutter analyze` 0 errors/warnings; `flutter test` 16/16 pass; screenshots of 7 screens in
  English and Urdu rendered with the real fonts and reviewed (`test_screenshots/`).
  **Not verified on a real phone**: file picker, PDF reader (pdfx), printing/sharing, book download,
  connectivity chip. Do that first.

## 1. Textbook content (round 2)

### Sources checked
| Source | Result |
|---|---|
| pectaa.edu.pk | reCAPTCHA on first visit (the teacher ticked it once in the built-in browser; never bypassed). The Curriculum Compliance page links each Urdu/English book to Google Drive; downloaded via `drive.usercontent.google.com/download?id=..&confirm=t`. |
| pctb.punjab.gov.pk | "Website under maintenance" on 22 Nov 2026. |
| elearn.gov.pk (PITB) | Works. Per book: chapters, topics, a flipbook of the PCTB textbook (page images), topic quizzes with the answer in the HTML. |

eLearn has **Mathematics + (General) Science for classes 3-10** (class 3 has Maths and a General Knowledge
book in Urdu with no quiz/book file), and **Physics, Chemistry, Biology, General Mathematics, General
Science for 9-10**. **No Urdu or English subject books.** Practical notebooks (9-10) were skipped.

### Pipeline (`tools/content_builder/`, outputs under `C:\dev\content`)
1. `elearn_inventory.py` – grades -> books -> chapters -> topics -> resource ids.
2. `elearn_quizzes.py` – per topic: flipbook URL + page index, all quiz questions (one per page).
3. `elearn_books.py` – downloads all page images (re-compressed, width 1100, JPEG q58) and builds one PDF
   per book. Classes 3-5: each chapter folder is the whole book. Classes 6-10: each chapter folder is a
   separate flipbook, so chapters are joined and a page **offset per folder** is recorded.
4. `build_catalog.py` + `mathtext.py` – cleans questions (HTML/MathML/LaTeX -> Unicode text: x², √2,
   matrices as [a b; c d]), validates (4 distinct options, exactly one matching answer), de-duplicates,
   applies `review_fixes.json`, maps topic pages into the joined PDF, writes `catalog.json`,
   `packs/<book>.json`.
5. `add_fixes.py` – helper used during the manual review.

### Numbers
- 3,280 quiz questions collected -> 690 duplicates, 28 broken on import (unconvertible markup / pictures),
  **198 removed in review**, **187 corrected in review** -> **2,364 MCQs in 23 books**.
- Every remaining question was read by Claude. Typical official errors fixed: wrong keyed answer
  ("3/15 + 4/15 = 7/30", "speed of sound is maximum in air", "Na-K widow share reversed"), wording with the
  blank missing, options turned into dates/times by a spreadsheet, stray "%" signs.
  Reasons are in `content/review/review_fixes.json` (keyed by the first 8 hex chars of the question hash).
- 65 corrected questions have a short student explanation; the rest show the correct answer plus a
  "Read this in the textbook (page N)" button.
- **Chapter titles bug found and fixed**: eLearn puts odd and even chapter titles in different elements;
  the first parse shifted 251 titles. Now matched by chapter number.
- PDFs: 23 books, 71-317 pages, 6-30 MB each, ~430 MB total, no missing pages.

### Catalog format
`content/catalog.json`: `{format, version (yyyymmddHHMM), note, books:[{id "el-b<id>", key, grade,
subject, title, publisher, sourceUrl, pdf "books/<key>.pdf", pdfBytes, pages, pack, questionCount,
chapters:[{id, number, title, pageStart, pageEnd, topics:[{id, title, page}]}]}]}`.
Pack: `{bookId, questions:[{id "<bookId>-elq-<hash16>", chapterId, topicId, type, text, options,
correctIndex, page, difficulty, source "elearn", reviewNote?, explanation?}]}`.
Page numbers are positions in the PDF file, not printed page numbers.

### Round 3: PECTAA Urdu + English, classes 3-10
- 16 books (`pe-<key>`, e.g. `pe-g7_urdu`). PDFs had no text layer: pages rendered with pypdfium2
  (`tools/content_builder/pectaa_pages.py`, 1100 px JPEG -> img2pdf A4 width).
- English: Windows OCR (`ocr.ps1`) to read units; Urdu: lesson pages read from images.
- Per book `C:\dev\content\pectaa\<key>.json` = `{key, grade, subject, language, title, offset,
  chapters:[[n, title, pdfPage]], questions:[[chapter, text, [4 options], correctIndex, explanation]]}`;
  `add_pq.py` validates and appends; `build_catalog.py` turns them into catalog entries and packs
  (chapter pageEnd = next start - 1; question ids `pe-<key>-pq-<hash16>`).
- 1,898 MCQs: English 125/144/99/80/81/71/84/69, Urdu 184/145/190/137/127/127/127/125 (classes 3..10).
- APK v2.1.0 bundles all 39 books' question packs.

### Round 4 (v2.2.0): question bank expansion, 12,959 MCQs
- PECTAA English and Urdu: grammar and composition MCQs were written from each lesson's exercise pages.
  - Urdu exercise pages were viewed as images with `tools/content_builder/ex.py <key> <ch> 3`.
  - Batches are `tools/content_builder/batches/*.txt` (`ch|q|correct|w1|w2|w3|explanation`), imported with `gq.py`.
  - Lesson questions were trimmed with `trim.py <key> N`: N = 5 for English and Urdu 3–4, N = 4 for Urdu 5–10.
  - Result: English 3,233 (85.6% grammar); Urdu 4,997 (every book ≥ 85% grammar).
  - A question's 6th element `"g"` becomes `"kind": "g"` in the packs; lesson questions get `"kind": "lesson"`.
- eLearn Maths and Science: 2,365 supplementary MCQs were added (about 10–15 per chapter; every chapter now has questions).
  - Files: `content/extra/<key>.json`, built with `content/extra/eq.py` / `imp.py` from `b_*.txt`.
  - `build_catalog.py` merges them after the official questions: id `<bookId>-xelq-<hash>`, `"source": "extra"`, with an explanation.
- Progress notes and workflow: `tools/content_builder/PROGRESS_GRAMMAR.md`.
- APK v2.2.0+4.

## 2. App changes in round 2
| Area | What |
|---|---|
| `lib/services/content_service.dart` | Imports the catalog bundled in `assets/content/` on first launch (if newer than installed); `checkOnline()` fetches `content/catalog.json` from the repo (raw.githubusercontent.com) and imports newer packs; `downloadBook()` streams a PDF with progress into app storage; `removeBookFile()`. Idempotent upserts by stable ids; keeps teacher data (downloaded file, applicable flag); questions dropped from the catalog are soft-deleted. |
| Online trigger | `App._setOnline` runs `content.checkOnline()` when internet returns; Settings has "Check for new content". |
| `lib/ui/reader_screen.dart` | In-app PDF reader (package `pdfx`, Android's own renderer) opening at a page; `openBook()` downloads first if needed. Used from Library, Book screen (each chapter/topic) and answer feedback. |
| Theme (`lib/ui/theme.dart`) | Emerald brand + amber accent, colour and icon per subject, colour per class, bolder type (w600 body / w800 titles), rounded cards. Fonts bundled: **Nunito** (English) with **Noto Nastaliq Urdu** fallback, so Urdu always renders in Nastaliq and English in Nunito in both UI languages. |
| Screens | New home (gradient header, stats, gradient tiles); colourful library book cards with MCQ count and download/read button; chapter badges; coloured A-D answer options; score ring on results; subject colours in setup and progress. |
| PDFs | Urdu in generated papers/reports uses bundled **Noto Naskh Arabic** (offline). The `pdf` package cannot shape Nastaliq correctly. |
| DB | schemaVersion 2: `textbooks.remoteFile`, `textbooks.remoteBytes`, `questions.reviewNote` (migration in `database.dart`). |
| Sample book | No longer offered in the UI (`App.loadDemo` kept for tests only). |
| Tests | `test/content_test.dart` (bundled import, every MCQ valid, idempotent re-import, assessment from an official chapter). Screenshot generator: `flutter test test_screenshots/screenshot_test.dart --update-goldens`. |

## 3. Earlier foundation (round 1, unchanged and still tested)
Guest mode, optional school/teacher profile, students (duplicate prevention, soft delete), textbook
library with versions and "applicable syllabus" flag, chapter/topic editor, question bank (5 types,
JSON pack import), MCQ assessment (multi-subject, strict chapter/topic scoping, immediate or end
feedback), permanent history with per-answer snapshots, progress analytics and PDF report, exam paper
generator with answer key/marking scheme, sync outbox (`SyncQueue`) + `CloudBackend` interface (no
backend), AI generation interface (no server). See `lib/` and `docs/`.

## 4. Files (main ones)
```
lib/main.dart                         theme + locale
lib/core/core.dart                    ids, tr(en, ur), RTL detection, grades, subjects
lib/data/db/tables.dart, database.dart  Drift schema v2 (+ generated database.g.dart)
lib/data/repos/*.dart                 students, library, attempts
lib/services/app.dart                 service locator, startup, connectivity
lib/services/content_service.dart     catalog import, online update, book download
lib/services/assessment_engine.dart   picking, ShownQuestion snapshot (now includes bookId)
lib/services/progress_engine.dart, paper_generator.dart, pdf_builder.dart, sync_engine.dart
lib/ui/theme.dart, reader_screen.dart, home_screen.dart, library_screen.dart, book_screen.dart, ...
assets/content/                       bundled catalog + packs (keep in step with content/)
assets/fonts/                         Nunito, NotoNastaliqUrdu, NotoNaskhArabic + OFL licences
content/                              what the app downloads (catalog, packs, books, review)
tools/content_builder/                Python pipeline
test/, test_screenshots/
```

## 5. How to update the content
1. Re-run the pipeline (or edit `review_fixes.json`) and `build_catalog.py`; it writes a new `version`.
2. Copy `catalog.json` + `packs/` into **both** `content/` (online) and `assets/content/` (bundled).
3. Commit and push. Phones pick it up the next time they are online.

## 6. Run, test, build (Git Bash)
```
export PATH="/c/dev/flutter/bin:/c/dev/jdk/bin:$PATH" JAVA_HOME="C:/dev/jdk" ANDROID_HOME="C:/dev/android-sdk"
cd /c/dev/school_assess
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # only after changing tables.dart
flutter analyze
flutter test
flutter build apk --release --split-per-abi                 # app-arm64-v8a-release.apk for most phones
```
`android/build.gradle.kts` disables `lintVital*` (crashes on JDK 17; needs JDK 21). Release builds are
signed with the debug key: create a real keystore before publishing.

## 7. Known issues / limits
- Urdu/English (PECTAA) MCQs were written by Claude from the lesson text, not from an official quiz bank;
  their chapters have no topics, and questions open the reader at the chapter start.
- The emulator test was not done (SDK emulator download was paused); test on a real phone.
- eLearn editions may be older than the newest printed PCTB books (notably classes 6-10).
- MCQs are marked "not verified by a teacher"; only 65 have written explanations.
- Topic page = first page where eLearn links the topic; a few links in class 6 Science point slightly past
  the joined PDF end (reader clamps).
- Book PDFs are served from raw.githubusercontent.com: fine for a school, but heavy use could hit GitHub
  bandwidth limits; move PDFs to GitHub Releases or another host if needed (only `contentUrl()` changes).
- The `pdfrx` reader was tried and dropped: its native build needs Visual Studio on the build PC.
- Changing language resets navigation to Home. Interrupted assessments lose the subject in progress.
- Flutter 3.50 shows "material.dart is deprecated" infos (migrate to `material_ui` later).

## 8. Next steps for Opus, in order
1. Install `release/` APK on a phone: Textbooks -> download a book -> read; Assess -> wrong answer ->
   "Read this in the textbook"; Exam paper print/share; Settings -> Check for new content.
2. Teacher review of the PECTAA Urdu/English MCQs (source files `C:\dev\content\pectaa\<key>.json`,
   copies of the tools in `tools/content_builder/`).
3. Add explanations for the remaining MCQs (server-side AI per `docs/SYNC_DESIGN.md`, teacher-reviewed).
4. Real release keystore; app icon and name; Play Store listing if wanted.
5. Cloud backup (Supabase) per `docs/SYNC_DESIGN.md`.
6. Check newer PCTB editions when pctb.punjab.gov.pk is back; import as new versions (old kept).

Rules to keep: never pull questions from unselected chapters/topics; never overwrite attempts; never
invent official content or page numbers; never ship secret keys; do not rewrite working modules.
