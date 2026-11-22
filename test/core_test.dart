import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_assess/core/core.dart';
import 'package:school_assess/data/db/database.dart';
import 'package:school_assess/data/demo_pack.dart';
import 'package:school_assess/data/repos/library_repo.dart';
import 'package:school_assess/data/repos/student_repo.dart';
import 'package:school_assess/services/app.dart';
import 'package:school_assess/services/assessment_engine.dart';
import 'package:school_assess/services/paper_generator.dart';
import 'package:school_assess/services/pdf_builder.dart';

Future<List<ShownQuestion>> _present(Textbook b, ContentSelection sel, int n,
    {Map<String, int> seen = const {}}) async {
  final pool = await App.library.pool(b.id, sel, type: 'mcq');
  final ch = {
    for (final c in await App.library.chaptersWithTopics(b.id)) c.chapter.id: c
  };
  return [
    for (final q in App.engine.pick(pool, n, seenCounts: seen))
      App.engine.present(q,
          chapter: ch[q.chapterId]!.chapter,
          topic: ch[q.chapterId]!.topics.where((t) => t.id == q.topicId).firstOrNull)
  ];
}

void main() {
  setUp(() async {
    await App.init(
        database: AppDatabase.forTesting(NativeDatabase.memory()),
        watchNetwork: false,
        importBundledContent: false);
  });
  tearDown(() => App.dispose());

  test('guest bootstrap creates one school and teacher with blank names', () async {
    expect(App.schoolId, isNotEmpty);
    expect((await App.school()).name, '');
    expect((await App.teacher()).name, '');
  });

  test('students: optional fields, unique ids, no duplicates', () async {
    final a = await App.students.add(grade: 5);
    final b = await App.students.add(grade: 5);
    expect(a.id, isNot(b.id));
    expect(a.code, startsWith('STU-'));

    final ali =
        await App.students.add(name: 'Ali Khan', rollNo: '12', grade: 5, section: 'A');
    expect(
        () => App.students
            .add(name: ' ali  khan ', rollNo: '12', grade: 5, section: 'a'),
        throwsA(isA<DuplicateStudent>()
            .having((e) => e.existing.id, 'existing', ali.id)));
    // Same name in a different class is a different student.
    await App.students.add(name: 'Ali Khan', rollNo: '12', grade: 6, section: 'A');
    expect((await App.students.list()).length, 4);

    await App.students.edit(ali.id,
        name: 'Ali Khan', rollNo: '13', grade: 5, section: 'A', academicYear: '2026');
    expect((await App.students.get(ali.id))!.rollNo, '13');
    expect((await App.students.watch(query: 'ali').first).length, 2);
  });

  test('textbooks: versions are kept; applicable is separate from latest', () async {
    final v1 = await App.library.addBook(
        grade: 5, subject: kMath, title: 'Maths 5', sourceType: 'no_file');
    await App.library.addChapter(v1.id, number: 1, title: 'Numbers');
    await App.library.setApplicable(v1, true);
    final v2 = await App.library.addBook(
        grade: 5,
        subject: kMath,
        title: 'Maths 5 (new)',
        sourceType: 'no_file',
        previousVersionOf: v1);
    final vs = await App.library.versions(v1.seriesId);
    expect(vs.map((e) => e.version), [2, 1]);
    expect(vs.first.isCurrent, true);
    expect(vs.last.isCurrent, false);
    expect((await App.library.chapters(v2.id)).single.title, 'Numbers');
    // The applicable (older) book is still the default for assessments.
    expect((await App.library.bestBook(5, kMath))!.id, v1.id);
    await App.library.setApplicable(v1, false);
    expect((await App.library.bestBook(5, kMath))!.id, v2.id);
  });

  test('pack import validates questions', () async {
    final b = await App.library
        .addBook(grade: 4, subject: kScience, title: 'T', sourceType: 'no_file');
    final rep = await App.library.importPack(
        b,
        jsonEncode({
          'chapters': [
            {
              'number': 1,
              'title': 'C1',
              'questions': [
                {'text': 'ok', 'options': ['a', 'b', 'c', 'd'], 'correctIndex': 2},
                {'text': 'three options', 'options': ['a', 'b', 'c'], 'correctIndex': 0},
                {'text': 'dup', 'options': ['a', 'a', 'c', 'd'], 'correctIndex': 0},
                {'text': 'no answer', 'options': ['a', 'b', 'c', 'd']},
                {'type': 'tf', 'text': 'tf ok', 'answer': false},
              ]
            }
          ]
        }));
    expect(rep.questions, 2);
    expect(rep.skipped.length, 3);
    final tf = (await App.library.questions(b.id, type: 'tf')).single;
    expect(tf.correctIndex, 1);
    expect(tf.pageRef, isNull);
  });

  test('assessment uses only the selected chapters and topics', () async {
    final b = await App.loadDemo(5);
    final chapters = await App.library.chaptersWithTopics(b.id);
    final ch1 = chapters[0], ch2 = chapters[1];
    expect((await App.library.questions(b.id, type: 'mcq')).length, 14);

    // One topic only.
    final topic = ch1.topics.first;
    final qs = await _present(b, ContentSelection(topicIds: {topic.id}), 20);
    expect(qs.length, 4);
    expect(qs.every((q) => q.topicId == topic.id), true);

    // Whole chapter 2.
    final qs2 =
        await _present(b, ContentSelection(chapterIds: {ch2.chapter.id}), 5);
    expect(qs2.length, 5);
    expect(qs2.every((q) => q.chapterId == ch2.chapter.id), true);
    expect(qs2.map((q) => q.questionId).toSet().length, 5);

    // Empty selection gives nothing.
    expect(await _present(b, ContentSelection(), 20), isEmpty);
  });

  test('shuffled options keep the right answer', () async {
    final b = await App.loadDemo(5);
    final all = await App.library.questions(b.id, type: 'mcq');
    final ch = (await App.library.chapters(b.id)).first;
    for (final q in all) {
      final s = App.engine.present(q, chapter: ch);
      expect(s.options.toSet(), optionsOf(q).toSet());
      expect(s.options[s.correctIndex], optionsOf(q)[q.correctIndex!]);
    }
  });

  test('history is permanent and progress compares previous with latest', () async {
    final b = await App.loadDemo(5);
    final st = await App.students.add(name: 'Sara', grade: 5);
    final sel = ContentSelection(
        chapterIds: {for (final c in await App.library.chapters(b.id)) c.id});

    Future<void> sit(int correct, DateTime at) async {
      final qs = await _present(b, sel, 10,
          seen: await App.attempts.seenCounts(st.id));
      for (var i = 0; i < qs.length; i++) {
        qs[i].selected =
            i < correct ? qs[i].correctIndex : (qs[i].correctIndex + 1) % 4;
      }
      await App.attempts.save(
          student: st,
          book: b,
          selection: sel,
          questions: qs,
          startedAt: at,
          finishedAt: at.add(const Duration(minutes: 5)),
          sessionId: newId(),
          feedbackMode: 'immediate');
    }

    await sit(4, DateTime(2026, 1, 10));
    await sit(7, DateTime(2026, 2, 10));

    final attempts = await App.attempts.forStudent(st.id);
    expect(attempts.map((a) => a.percentage), [40.0, 70.0]);
    expect(attempts.first.timeTakenSec, 300);
    expect((await App.attempts.answers(attempts.first.id)).length, 10);

    final p = (await App.attempts.progress(st.id)).single;
    expect(p.subject, kMath);
    expect(p.previous!.percentage, 40);
    expect(p.latest!.percentage, 70);
    expect(p.delta, 30);
    expect(p.chapters.fold<int>(0, (s, c) => s + c.total), 20);
    expect(p.chapters.fold<int>(0, (s, c) => s + c.correct), 11);

    // Stored answers keep the student's original choice and the question.
    final ans = (await App.attempts.answers(attempts.first.id)).last;
    final shown = ShownQuestion.fromAnswer(ans);
    expect(ans.isCorrect, false);
    expect(shown.selected, isNot(shown.correctIndex));
    expect(shown.text, isNotEmpty);
    expect(shown.conceptExplanation, isNotEmpty);

    // Deleting the question bank does not touch history.
    for (final c in await App.library.chapters(b.id)) {
      await App.library.deleteChapter(c.id);
    }
    expect((await App.attempts.progress(st.id)).single.delta, 30);

    // Each change is queued once for later upload.
    final queue = await App.db.select(App.db.syncQueue).get();
    expect(queue.where((q) => q.entity == 'attempts').length, 2);
    expect(queue.where((q) => q.entity == 'students').length, 1);
  });

  test('paper generator reports shortfalls and never leaves the selection', () async {
    final b = await App.loadDemo(5);
    final chapters = await App.library.chapters(b.id);
    final ch1 = chapters[0], ch2 = chapters[1];

    final p1 = await App.papers.generate(PaperConfig(
        grade: 5,
        subject: kMath,
        bookId: b.id,
        chapterIds: {ch1.id},
        counts: {'mcq': 20, 'short': 2, 'long': 0, 'fill': 0, 'tf': 0}));
    expect(p1.sections['mcq']!.length, 8);
    expect(p1.shortfalls, {'mcq': 12, 'short': 2});
    expect(p1.sections['mcq']!.every((q) => q.chapterTitle == ch1.title), true);

    final p2 = await App.papers.generate(PaperConfig(
        title: 'Monthly Test',
        grade: 5,
        subject: kMath,
        bookId: b.id,
        chapterIds: {ch2.id},
        counts: {'mcq': 5, 'fill': 2, 'tf': 2, 'short': 2, 'long': 1}));
    expect(p2.shortfalls, isEmpty);
    expect(p2.totalQuestions, 12);
    expect(p2.totalMarks, 5 + 2 + 2 + 4 + 5);

    // Saved papers round-trip, and both PDFs build offline.
    final id = await App.savePaper(p2);
    final row = (await App.watchPapers().first).single;
    expect(row.id, id);
    final back = GeneratedPaper.fromStored(row.configJson, row.contentJson);
    expect(back.totalMarks, p2.totalMarks);
    expect((await PdfBuilder.paper(back)).length, greaterThan(1000));
    expect((await PdfBuilder.answerKey(back)).length, greaterThan(1000));
  });

  test('demo pack answers are internally consistent', () {
    for (final c in kDemoPack['chapters'] as List) {
      for (final t in (c['topics'] as List)) {
        for (final q in (t['questions'] as List)) {
          expect((q['options'] as List).toSet().length, 4, reason: q['text']);
          expect(q['correctIndex'], inInclusiveRange(0, 3));
        }
      }
    }
  });
}
