import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_assess/data/db/database.dart';
import 'package:school_assess/data/demo_pack.dart';
import 'package:school_assess/main.dart';
import 'package:school_assess/services/app.dart';
import 'package:school_assess/ui/assess_run_screen.dart';
import 'package:school_assess/ui/assess_setup_screen.dart';
import 'package:school_assess/ui/paper_screen.dart';
import 'package:school_assess/ui/progress_screen.dart';
import 'package:school_assess/services/paper_generator.dart';

/// Drives the real screens against an in-memory database to catch runtime
/// and layout errors (phone-sized surface).
void main() {
  late Student student;
  late Textbook book;

  Future<void> boot(WidgetTester tester) async {
    tester.view.physicalSize = const Size(411, 890);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    await tester.runAsync(() async {
      await App.init(
          database: AppDatabase.forTesting(NativeDatabase.memory()),
          watchNetwork: false,
          importBundledContent: false);
      await App.markSetupDone();
      book = await App.loadDemo(5);
      student = await App.students.add(name: 'Ayesha', rollNo: '7', grade: 5);
      await App.setPref('last_grade', '5');
    });
  }

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> finish(WidgetTester tester) async {
    // Unmount the screens and let their database streams unwind. The
    // in-memory database is simply dropped (closing it here can deadlock
    // with stream teardown under the test clock).
    await tester.pumpWidget(const SizedBox());
    await settle(tester);
  }

  testWidgets('home, students and library screens open', (tester) async {
    await boot(tester);
    await tester.pumpWidget(const SchoolAssessApp());
    await settle(tester);
    expect(find.text('Assess a Student'), findsOneWidget);
    expect(find.text('Offline'), findsOneWidget);
    expect(find.textContaining('Guest mode'), findsOneWidget);

    await tester.tap(find.text('Students').last);
    await settle(tester);
    expect(find.text('Ayesha'), findsOneWidget);
    await tester.pageBack();
    await settle(tester);

    await tester.tap(find.text('Textbooks'));
    await settle(tester);
    expect(find.text(kDemoBookTitle), findsOneWidget);
    await tester.tap(find.text(kDemoBookTitle));
    await settle(tester);
    expect(find.text('Chapters and topics'), findsOneWidget);
    expect(find.textContaining('SAMPLE - not an official textbook'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await finish(tester);
  });

  testWidgets('assessment gives immediate feedback and saves history',
      (tester) async {
    await boot(tester);
    late SubjectPlan plan;
    await tester.runAsync(() async {
      final chapters = await App.library.chaptersWithTopics(book.id);
      plan = SubjectPlan(book.subject, book, chapters, {})..enabled = true;
      plan.selection.chapterIds.addAll(chapters.map((c) => c.chapter.id));
      final pool = await App.library.pool(book.id, plan.selection, type: 'mcq');
      final byId = {for (final c in chapters) c.chapter.id: c.chapter};
      plan.questions = [
        for (final q in App.engine.pick(pool, 3))
          App.engine.present(q, chapter: byId[q.chapterId]!)
      ];
    });
    await tester.pumpWidget(MaterialApp(
        home: AssessRunScreen(
            student: student,
            plans: [plan],
            feedbackMode: 'immediate',
            practice: false)));
    await settle(tester);

    for (var i = 0; i < 3; i++) {
      expect(find.text('Question ${i + 1} / 3'), findsOneWidget);
      final q = plan.questions[i];
      // Answer the first correctly and the rest wrongly.
      final pick = i == 0 ? q.correctIndex : (q.correctIndex + 1) % 4;
      await tester.tap(find.text(q.options[pick]).first);
      await settle(tester);
      expect(find.text(i == 0 ? 'Correct!' : 'Incorrect'), findsOneWidget);
      expect(find.text('Correct answer'), findsOneWidget);
      expect(find.text('Understand the concept'), findsOneWidget);
      await tester.tap(find.text(i == 2 ? 'Finish' : 'Next'));
      await settle(tester);
    }
    // Result screen, read back from the database.
    expect(find.textContaining('Result'), findsOneWidget);
    expect(find.textContaining('1 / 3 '), findsOneWidget);
    expect(find.text('First assessment in this subject.'), findsOneWidget);
    late List<Attempt> saved;
    await tester.runAsync(
        () async => saved = await App.attempts.forStudent(student.id));
    expect(saved.single.correct, 1);
    expect(saved.single.total, 3);

    await tester.pumpWidget(MaterialApp(key: UniqueKey(), home: ProgressScreen(student: student)));
    await settle(tester);
    expect(find.text('Mathematics'), findsOneWidget);
    expect(find.text('Latest'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await finish(tester);
  });

  testWidgets('assessment setup and paper preview render', (tester) async {
    await boot(tester);
    await tester.pumpWidget(MaterialApp(home: AssessSetupScreen(student: student)));
    await settle(tester);
    expect(find.text('Ayesha'), findsOneWidget);
    expect(find.text('Mathematics'), findsOneWidget);
    expect(find.textContaining('No textbook added for this subject'), findsWidgets);
    await tester.tap(find.text('Mathematics'));
    await settle(tester);
    expect(find.text('Select all chapters'), findsOneWidget);
    expect(tester.takeException(), isNull);

    late GeneratedPaper paper;
    await tester.runAsync(() async {
      final ch = await App.library.chapters(book.id);
      paper = await App.papers.generate(PaperConfig(
          grade: 5,
          subject: book.subject,
          bookId: book.id,
          chapterIds: {ch[1].id},
          counts: {'mcq': 3, 'fill': 2, 'tf': 1, 'short': 1, 'long': 5}));
    });
    await tester.pumpWidget(MaterialApp(key: UniqueKey(), home: PaperPreviewScreen(paper: paper)));
    await settle(tester);
    expect(find.text('Print paper'), findsOneWidget);
    expect(find.textContaining('Not enough questions'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await finish(tester);
  });
}
