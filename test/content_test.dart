import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:school_assess/core/core.dart';
import 'package:school_assess/data/db/database.dart';
import 'package:school_assess/data/repos/library_repo.dart';
import 'package:school_assess/services/app.dart';
import 'package:school_assess/services/content_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await App.init(
        database: AppDatabase.forTesting(NativeDatabase.memory()),
        watchNetwork: false);
  });
  tearDown(() => App.dispose());

  test('bundled official catalog is imported on first launch', () async {
    final cat = jsonDecode(await rootBundle.loadString('assets/content/catalog.json'))
        as Map<String, dynamic>;
    final books = await App.library.watchBooks().first;
    expect(books.length, (cat['books'] as List).length);
    expect(books.length, greaterThanOrEqualTo(20));
    expect(await App.content.installedVersion(), cat['version']);
    final expected =
        (cat['books'] as List).fold<int>(0, (s, b) => s + (b['questionCount'] as int));
    expect(await App.library.mcqCount(), expected);

    // Every class 3-10 has at least a Mathematics book.
    for (final g in kGrades) {
      expect(await App.library.bestBook(g, kMath), isNotNull, reason: 'grade $g');
    }
    // Catalog books know where their PDF lives in the repository.
    final g9 = books.firstWhere((b) => b.grade == 9 && b.subject == kMath);
    expect(g9.remoteFile, 'books/g9_math.pdf');
    expect(g9.remoteBytes, greaterThan(1000000));
    expect(g9.filePath, isNull);
    expect(contentUrl(g9.remoteFile!),
        'https://raw.githubusercontent.com/$kContentRepo/main/content/books/g9_math.pdf');
  });

  test('every bundled MCQ is valid and points into its own book', () async {
    for (final b in await App.library.watchBooks().first) {
      final chapters = {for (final c in await App.library.chapters(b.id)) c.id};
      for (final q in await App.library.questions(b.id, type: 'mcq')) {
        final o = optionsOf(q);
        expect(o.length, 4, reason: q.body);
        expect(o.toSet().length, 4, reason: q.body);
        expect(q.correctIndex, inInclusiveRange(0, 3), reason: q.body);
        expect(chapters.contains(q.chapterId), true, reason: q.body);
        expect(q.body.contains('<') && q.body.contains('>'), false, reason: q.body);
      }
    }
  });

  test('re-import is idempotent and keeps teacher data', () async {
    final books = await App.library.watchBooks().first;
    final b = books.first;
    await (App.db.update(App.db.textbooks)..where((t) => t.id.equals(b.id))).write(
        const TextbooksCompanion(filePath: Value('/data/book.pdf')));
    await App.library.setApplicable(b, true);
    final before = await App.library.mcqCount();

    final cat = jsonDecode(await rootBundle.loadString('assets/content/catalog.json'))
        as Map<String, dynamic>;
    await App.content.importCatalog(
        cat, (p) => rootBundle.loadString('assets/content/$p'));

    expect((await App.library.watchBooks().first).length, books.length);
    expect(await App.library.mcqCount(), before);
    final again = (await App.library.book(b.id))!;
    expect(again.filePath, '/data/book.pdf');
    expect(again.isApplicable, true);
  });

  test('an assessment can be built from an official chapter', () async {
    final b = (await App.library.bestBook(9, 'Physics'))!;
    final ch = (await App.library.chaptersWithTopics(b.id)).first;
    final pool = await App.library
        .pool(b.id, ContentSelection(chapterIds: {ch.chapter.id}), type: 'mcq');
    expect(pool, isNotEmpty);
    final qs = App.engine.pick(pool, 10).map((q) => App.engine.present(q,
        chapter: ch.chapter,
        topic: ch.topics.where((t) => t.id == q.topicId).firstOrNull));
    for (final s in qs) {
      expect(s.chapterId, ch.chapter.id);
      expect(s.bookId, b.id);
      expect(s.options[s.correctIndex], isNotEmpty);
    }
    expect(qs.where((s) => s.page != null), isNotEmpty);
  });
}
