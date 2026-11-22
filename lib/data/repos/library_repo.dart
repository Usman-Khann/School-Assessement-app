import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/core.dart';
import '../db/database.dart';

/// What the teacher ticked: whole chapters and/or individual topics.
/// A question is in scope only if its chapter is in [chapterIds] or its
/// topic is in [topicIds]. Nothing else is ever used.
class ContentSelection {
  final Set<String> chapterIds;
  final Set<String> topicIds;
  ContentSelection({Set<String>? chapterIds, Set<String>? topicIds})
      : chapterIds = chapterIds ?? {},
        topicIds = topicIds ?? {};
  bool get isEmpty => chapterIds.isEmpty && topicIds.isEmpty;
  bool matches(Question q) =>
      chapterIds.contains(q.chapterId) ||
      (q.topicId != null && topicIds.contains(q.topicId));
}

class ChapterWithTopics {
  final Chapter chapter;
  final List<Topic> topics;
  ChapterWithTopics(this.chapter, this.topics);
}

class LibraryRepo {
  final AppDatabase db;
  LibraryRepo(this.db);

  // ---------- Textbooks ----------
  Stream<List<Textbook>> watchBooks({int? grade}) {
    final q = db.select(db.textbooks);
    if (grade != null) q.where((t) => t.grade.equals(grade));
    q.orderBy([
      (t) => OrderingTerm(expression: t.grade),
      (t) => OrderingTerm(expression: t.subject),
      (t) => OrderingTerm(expression: t.version, mode: OrderingMode.desc),
    ]);
    return q.watch();
  }

  Future<List<Textbook>> booksFor(int grade, String subject) =>
      (db.select(db.textbooks)
            ..where((t) => t.grade.equals(grade) & t.subject.equals(subject))
            ..orderBy([
              (t) => OrderingTerm(
                  expression: t.importedAt, mode: OrderingMode.desc)
            ]))
          .get();

  /// Book used by default for a class + subject: the one marked as the
  /// officially applicable syllabus, otherwise the latest imported version.
  Future<Textbook?> bestBook(int grade, String subject) async {
    final all = await booksFor(grade, subject);
    if (all.isEmpty) return null;
    for (final b in all) {
      if (b.isApplicable) return b;
    }
    for (final b in all) {
      if (b.isCurrent) return b;
    }
    return all.first;
  }

  Future<List<String>> subjectsWithBooks(int grade) async {
    final rows = await (db.select(db.textbooks)
          ..where((t) => t.grade.equals(grade)))
        .get();
    final s = <String>{...defaultSubjectsFor(grade)};
    s.addAll(rows.map((e) => e.subject));
    return s.toList();
  }

  Future<Textbook?> book(String id) =>
      (db.select(db.textbooks)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<Textbook>> versions(String seriesId) =>
      (db.select(db.textbooks)
            ..where((t) => t.seriesId.equals(seriesId))
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.version, mode: OrderingMode.desc)
            ]))
          .get();

  /// Adds a book. When [previousVersionOf] is given, the new row becomes the
  /// next version in the same series; the old version is kept (never
  /// replaced or deleted) and merely loses its "latest" flag.
  Future<Textbook> addBook({
    required int grade,
    required String subject,
    required String title,
    String academicYear = '',
    String edition = '',
    String publisher = '',
    String language = 'en',
    required String sourceType,
    String sourceUrl = '',
    String? filePath,
    String? fileSha256,
    int? fileSize,
    String notes = '',
    Textbook? previousVersionOf,
    bool copyStructure = true,
  }) async {
    final id = newId();
    var version = 1;
    var series = newId();
    await db.transaction(() async {
      if (previousVersionOf != null) {
        series = previousVersionOf.seriesId;
        final vs = await versions(series);
        version = (vs.isEmpty ? 0 : vs.first.version) + 1;
        await (db.update(db.textbooks)..where((t) => t.seriesId.equals(series)))
            .write(const TextbooksCompanion(isCurrent: Value(false)));
      }
      await db.into(db.textbooks).insert(TextbooksCompanion.insert(
            id: id,
            seriesId: series,
            version: Value(version),
            grade: grade,
            subject: subject,
            title: title.trim(),
            academicYear: Value(academicYear.trim()),
            edition: Value(edition.trim()),
            publisher: Value(publisher.trim()),
            language: Value(language),
            sourceType: sourceType,
            sourceUrl: Value(sourceUrl.trim()),
            filePath: Value(filePath),
            fileSha256: Value(fileSha256),
            fileSize: Value(fileSize),
            importedAt: DateTime.now(),
            notes: Value(notes),
          ));
      if (previousVersionOf != null && copyStructure) {
        for (final c in await chaptersWithTopics(previousVersionOf.id)) {
          final cid = await addChapter(id,
              number: c.chapter.number,
              title: c.chapter.title,
              pageStart: c.chapter.pageStart,
              pageEnd: c.chapter.pageEnd);
          for (final t in c.topics) {
            await addTopic(cid,
                title: t.title, pageStart: t.pageStart, pageEnd: t.pageEnd);
          }
        }
      }
    });
    return (await book(id))!;
  }

  Future<void> updateBookMeta(String id, TextbooksCompanion c) =>
      (db.update(db.textbooks)..where((t) => t.id.equals(id))).write(c);

  /// Marks one book as the officially applicable syllabus for its class +
  /// subject (and un-marks the others).
  Future<void> setApplicable(Textbook b, bool value) async {
    await db.transaction(() async {
      await (db.update(db.textbooks)
            ..where(
                (t) => t.grade.equals(b.grade) & t.subject.equals(b.subject)))
          .write(const TextbooksCompanion(isApplicable: Value(false)));
      if (value) {
        await (db.update(db.textbooks)..where((t) => t.id.equals(b.id)))
            .write(const TextbooksCompanion(isApplicable: Value(true)));
      }
    });
  }

  // ---------- Chapters & topics ----------
  Future<List<Chapter>> chapters(String bookId) => (db.select(db.chapters)
        ..where((t) => t.textbookId.equals(bookId))
        ..orderBy([(t) => OrderingTerm(expression: t.number)]))
      .get();

  Future<List<Topic>> topics(String chapterId) => (db.select(db.topics)
        ..where((t) => t.chapterId.equals(chapterId))
        ..orderBy([(t) => OrderingTerm(expression: t.orderNo)]))
      .get();

  Future<List<ChapterWithTopics>> chaptersWithTopics(String bookId) async {
    final out = <ChapterWithTopics>[];
    for (final c in await chapters(bookId)) {
      out.add(ChapterWithTopics(c, await topics(c.id)));
    }
    return out;
  }

  Future<String> addChapter(String bookId,
      {required int number,
      required String title,
      int? pageStart,
      int? pageEnd}) async {
    final id = newId();
    await db.into(db.chapters).insert(ChaptersCompanion.insert(
        id: id,
        textbookId: bookId,
        number: number,
        title: title.trim(),
        pageStart: Value(pageStart),
        pageEnd: Value(pageEnd)));
    return id;
  }

  Future<void> updateChapter(String id,
          {required int number,
          required String title,
          int? pageStart,
          int? pageEnd}) =>
      (db.update(db.chapters)..where((t) => t.id.equals(id))).write(
          ChaptersCompanion(
              number: Value(number),
              title: Value(title.trim()),
              pageStart: Value(pageStart),
              pageEnd: Value(pageEnd)));

  Future<String> addTopic(String chapterId,
      {required String title, int? pageStart, int? pageEnd}) async {
    final id = newId();
    final n = (await topics(chapterId)).length;
    await db.into(db.topics).insert(TopicsCompanion.insert(
        id: id,
        chapterId: chapterId,
        orderNo: Value(n),
        title: title.trim(),
        pageStart: Value(pageStart),
        pageEnd: Value(pageEnd)));
    return id;
  }

  Future<void> updateTopic(String id,
          {required String title, int? pageStart, int? pageEnd}) =>
      (db.update(db.topics)..where((t) => t.id.equals(id))).write(
          TopicsCompanion(
              title: Value(title.trim()),
              pageStart: Value(pageStart),
              pageEnd: Value(pageEnd)));

  /// Deleting structure soft-deletes its questions; saved assessment history
  /// is unaffected because every answer stores its own question snapshot.
  Future<void> deleteTopic(String id) async {
    await db.transaction(() async {
      await (db.update(db.questions)..where((t) => t.topicId.equals(id)))
          .write(const QuestionsCompanion(deleted: Value(true)));
      await (db.delete(db.topics)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<void> deleteChapter(String id) async {
    await db.transaction(() async {
      await (db.update(db.questions)..where((t) => t.chapterId.equals(id)))
          .write(const QuestionsCompanion(deleted: Value(true)));
      await (db.delete(db.topics)..where((t) => t.chapterId.equals(id))).go();
      await (db.delete(db.chapters)..where((t) => t.id.equals(id))).go();
    });
  }

  // ---------- Questions ----------
  Future<int> mcqCount() async {
    final c = db.questions.id.count();
    final q = db.selectOnly(db.questions)
      ..addColumns([c])
      ..where(db.questions.deleted.equals(false) & db.questions.type.equals('mcq'));
    return (await q.getSingle()).read(c) ?? 0;
  }

  Future<List<Question>> questions(String bookId,
      {String? chapterId, String? topicId, String? type}) {
    final q = db.select(db.questions)
      ..where((t) => t.textbookId.equals(bookId) & t.deleted.equals(false));
    if (chapterId != null) q.where((t) => t.chapterId.equals(chapterId));
    if (topicId != null) q.where((t) => t.topicId.equals(topicId));
    if (type != null) q.where((t) => t.type.equals(type));
    q.orderBy([(t) => OrderingTerm(expression: t.createdAt)]);
    return q.get();
  }

  /// Questions strictly inside the teacher's selection.
  Future<List<Question>> pool(String bookId, ContentSelection sel,
      {String? type}) async {
    if (sel.isEmpty) return [];
    final all = await questions(bookId, type: type);
    return all.where(sel.matches).toList();
  }

  Future<Map<String, int>> countsByChapter(String bookId,
      {String? type}) async {
    final m = <String, int>{};
    for (final q in await questions(bookId, type: type)) {
      m[q.chapterId] = (m[q.chapterId] ?? 0) + 1;
    }
    return m;
  }

  Future<String> saveQuestion({
    String? id,
    required Textbook book,
    required String chapterId,
    String? topicId,
    required String type,
    required String body,
    List<String> options = const [],
    int? correctIndex,
    String answer = '',
    String shortExplanation = '',
    String conceptExplanation = '',
    int? pageRef,
    int difficulty = 2,
    String source = 'manual',
    bool verified = false,
  }) async {
    final qid = id ?? newId();
    final c = QuestionsCompanion.insert(
      id: qid,
      textbookId: book.id,
      chapterId: chapterId,
      topicId: Value(topicId),
      grade: book.grade,
      subject: book.subject,
      type: type,
      body: body.trim(),
      optionsJson: Value(jsonEncode(options.map((e) => e.trim()).toList())),
      correctIndex: Value(correctIndex),
      answer: Value(answer.trim()),
      shortExplanation: Value(shortExplanation.trim()),
      conceptExplanation: Value(conceptExplanation.trim()),
      pageRef: Value(pageRef),
      difficulty: Value(difficulty.clamp(1, 3)),
      source: Value(source),
      verified: Value(verified),
      language: Value(isRtlText(body) ? 'ur' : 'en'),
      createdAt: DateTime.now(),
    );
    await db.into(db.questions).insertOnConflictUpdate(c);
    return qid;
  }

  Future<void> deleteQuestion(String id) =>
      (db.update(db.questions)..where((t) => t.id.equals(id)))
          .write(const QuestionsCompanion(deleted: Value(true)));

  /// Imports a question pack (see docs/QUESTION_PACK_FORMAT.md) into [book].
  /// Chapters/topics are matched by number/title and created when missing.
  /// Invalid questions are skipped and reported, never "repaired" by guessing.
  Future<ImportReport> importPack(Textbook book, String jsonText,
      {String source = 'import'}) async {
    final rep = ImportReport();
    final dynamic root = jsonDecode(jsonText);
    if (root is! Map || root['chapters'] is! List) {
      throw const FormatException('Pack must contain a "chapters" list.');
    }
    await db.transaction(() async {
      final existing = await chapters(book.id);
      for (final rawC in root['chapters'] as List) {
        if (rawC is! Map) continue;
        final chNo = (rawC['number'] as num?)?.toInt() ?? existing.length + 1;
        final title = (rawC['title'] ?? 'Chapter $chNo').toString();
        var chap = existing.where((c) => c.number == chNo).firstOrNull;
        String chapId;
        if (chap == null) {
          chapId = await addChapter(book.id,
              number: chNo,
              title: title,
              pageStart: (rawC['pageStart'] as num?)?.toInt(),
              pageEnd: (rawC['pageEnd'] as num?)?.toInt());
          existing.addAll(await (db.select(db.chapters)
                ..where((t) => t.id.equals(chapId)))
              .get());
          rep.chapters++;
        } else {
          chapId = chap.id;
        }
        Future<void> addAll(List? qs, String? topicId) async {
          for (final rq in qs ?? const []) {
            if (rq is! Map) continue;
            final err = await _importOne(book, chapId, topicId, rq, source);
            if (err == null) {
              rep.questions++;
            } else {
              rep.skipped.add(err);
            }
          }
        }

        await addAll(rawC['questions'] as List?, null);
        final existingTopics = await topics(chapId);
        for (final rawT in (rawC['topics'] as List?) ?? const []) {
          if (rawT is! Map) continue;
          final tTitle = (rawT['title'] ?? '').toString().trim();
          if (tTitle.isEmpty) continue;
          var tid = existingTopics
              .where((t) => t.title.toLowerCase() == tTitle.toLowerCase())
              .firstOrNull
              ?.id;
          if (tid == null) {
            tid = await addTopic(chapId,
                title: tTitle,
                pageStart: (rawT['pageStart'] as num?)?.toInt(),
                pageEnd: (rawT['pageEnd'] as num?)?.toInt());
            rep.topics++;
          }
          await addAll(rawT['questions'] as List?, tid);
        }
      }
    });
    return rep;
  }

  Future<String?> _importOne(Textbook book, String chapId, String? topicId,
      Map rq, String source) async {
    final type = (rq['type'] ?? 'mcq').toString();
    final body = (rq['text'] ?? rq['question'] ?? '').toString().trim();
    String short(String s) => s.length > 40 ? '${s.substring(0, 40)}…' : s;
    if (body.isEmpty) return 'Empty question text';
    if (!kQuestionTypes.contains(type)) return '"${short(body)}": bad type';
    var options = ((rq['options'] as List?) ?? const [])
        .map((e) => e.toString())
        .toList();
    int? ci = (rq['correctIndex'] as num?)?.toInt();
    if (type == 'mcq') {
      if (options.length != 4) return '"${short(body)}": needs 4 options';
      if (options.map((e) => e.trim().toLowerCase()).toSet().length != 4) {
        return '"${short(body)}": duplicate options';
      }
      if (ci == null || ci < 0 || ci > 3) {
        return '"${short(body)}": correctIndex must be 0-3';
      }
    } else if (type == 'tf') {
      options = const ['True', 'False'];
      final a = rq['answer'];
      if (ci == null && a is bool) ci = a ? 0 : 1;
      if (ci == null || ci < 0 || ci > 1) {
        return '"${short(body)}": true/false answer missing';
      }
    } else {
      options = const [];
      ci = null;
    }
    await saveQuestion(
      book: book,
      chapterId: chapId,
      topicId: topicId,
      type: type,
      body: body,
      options: options,
      correctIndex: ci,
      answer: rq['answer'] is String ? rq['answer'] as String : '',
      shortExplanation: (rq['shortExplanation'] ?? '').toString(),
      conceptExplanation: (rq['conceptExplanation'] ?? '').toString(),
      pageRef: (rq['page'] as num?)?.toInt(),
      difficulty: (rq['difficulty'] as num?)?.toInt() ?? 2,
      source: source,
      verified: rq['verified'] == true,
    );
    return null;
  }
}

class ImportReport {
  int chapters = 0, topics = 0, questions = 0;
  final List<String> skipped = [];
}

List<String> optionsOf(Question q) =>
    (jsonDecode(q.optionsJson) as List).map((e) => e.toString()).toList();
