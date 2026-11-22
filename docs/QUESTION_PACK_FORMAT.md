# Question pack format (JSON)

A pack adds chapters, topics and questions to ONE book that already exists in the library
(Textbooks > open the book > "Import question pack"). The same format is what a future
server-side AI generator must return.

```json
{
  "chapters": [
    {
      "number": 1,
      "title": "Chapter title exactly as in the textbook",
      "pageStart": 1,
      "pageEnd": 14,
      "questions": [ /* questions on the whole chapter (no topic) */ ],
      "topics": [
        {
          "title": "Topic title",
          "pageStart": 3,
          "pageEnd": 5,
          "questions": [
            {
              "type": "mcq",
              "text": "Question text",
              "options": ["A", "B", "C", "D"],
              "correctIndex": 1,
              "shortExplanation": "One or two sentences.",
              "conceptExplanation": "Simple, age-appropriate explanation of the idea.",
              "page": 4,
              "difficulty": 2,
              "verified": true
            },
            { "type": "tf",    "text": "Statement.", "answer": true },
            { "type": "fill",  "text": "The ____ is ...", "answer": "word" },
            { "type": "short", "text": "Question?", "answer": "Model answer / marking points" },
            { "type": "long",  "text": "Question?", "answer": "Marking scheme" }
          ]
        }
      ]
    }
  ]
}
```

Rules enforced on import (`LibraryRepo.importPack`):

- Chapters are matched by `number`; topics by title (case-insensitive). Missing ones are created.
- `mcq`: exactly 4 different options and `correctIndex` 0-3, otherwise the question is skipped and listed in the report.
- `tf`: `answer` true/false (or `correctIndex` 0 = True, 1 = False).
- `page` is optional. Give it only when checked against the printed book. It is never guessed.
- `difficulty`: 1 easy, 2 medium, 3 hard (default 2).
- `verified`: true only when a person has checked the question against the textbook (default false).
- Urdu text is written directly in the JSON (UTF-8); direction is detected automatically.
