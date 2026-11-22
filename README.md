# School Assessment (Punjab, classes 3–10)

An offline-first Android app for teachers: assess students with MCQs taken from
the official Punjab textbooks, explain every answer, keep each student's full
history, compare progress over time, and generate printable exam papers.

* **Works without internet.** No account needed (guest mode). Everything is
  stored on the phone.
* **Official content built in:** 23 PCTB textbooks (Mathematics and Science for
  classes 3–10; Physics, Chemistry, Biology, General Mathematics and General
  Science for 9–10), with chapters, topics, page numbers and **2,364 reviewed
  MCQs**. See [`content/README.md`](content/README.md).
* **Read the book inside the app**, opened at the exact page of the topic, after
  a one-time download of that book.
* **English and Urdu** interface; Urdu is shown in Nastaliq script.

## Download the app

The latest Android build is in [`release/`](release/). On the phone, open the
`.apk` file and allow installing from this source.

## Repository layout

| Path | Contents |
|---|---|
| `lib/` | Flutter app source (Dart) |
| `assets/content/` | Copy of the catalog and MCQs bundled inside the app |
| `assets/fonts/` | Nunito, Noto Nastaliq Urdu, Noto Naskh Arabic (SIL Open Font License) |
| `content/` | Content the app downloads when online: catalog, MCQ packs, textbook PDFs |
| `tools/content_builder/` | Python scripts that built the content from eLearn Punjab |
| `test/` | Automated tests |
| `docs/` | Design notes (sync, question-pack format, cloud schema draft) |
| `OPUS_HANDOVER.md` | Detailed developer handover: what is done, what is next |

## Build

```
flutter pub get
flutter test
flutter build apk --release --split-per-abi
```

See `OPUS_HANDOVER.md` for the exact toolchain and known issues.

## Copyright

The textbooks and their questions belong to the Punjab Curriculum and Textbook
Board (PCTB) and the Punjab Information Technology Board (PITB). They are
included only for use in this free educational app.
