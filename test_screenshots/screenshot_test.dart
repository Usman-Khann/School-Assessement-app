// Renders key screens to PNG files (test/goldens/*.png) with the real fonts,
// so the design can be reviewed without a phone:
//   flutter test test/screenshot_test.dart --update-goldens

library;

import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';
import 'package:school_assess/core/core.dart';
import 'package:school_assess/data/db/database.dart';
import 'package:school_assess/main.dart';
import 'package:school_assess/services/app.dart';
import 'package:school_assess/ui/assess_run_screen.dart';
import 'package:school_assess/ui/assess_setup_screen.dart';
import 'package:school_assess/ui/book_screen.dart';
import 'package:school_assess/ui/library_screen.dart';
import 'package:school_assess/ui/progress_screen.dart';
import 'package:school_assess/ui/result_screen.dart';
import 'package:school_assess/ui/theme.dart';

Future<void> _loadFonts() async {
  Future<void> load(String family, List<String> files) async {
    final l = FontLoader(family);
    for (final f in files) {
      l.addFont(File(f).readAsBytes().then((b) => ByteData.view(b.buffer)));
    }
    await l.load();
  }

  await load('Nunito', [
    for (final w in [400, 600, 700, 800]) 'assets/fonts/Nunito-$w.ttf'
  ]);
  await load('NotoNastaliqUrdu', [
    'assets/fonts/NotoNastaliqUrdu-400.ttf',
    'assets/fonts/NotoNastaliqUrdu-700.ttf'
  ]);
  final flutterRoot = Platform.environment['FLUTTER_ROOT'] ?? 'C:/dev/flutter';
  await load('MaterialIcons',
      ['$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf']);
}

void main() {
  late Student student;

  Future<void> boot(WidgetTester tester, {String lang = 'en'}) async {
    tester.view.physicalSize = const Size(820, 1780);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    await tester.runAsync(() async {
      await _loadFonts();
      await App.init(
          database: AppDatabase.forTesting(NativeDatabase.memory()),
          watchNetwork: false);
      await App.markSetupDone();
      await App.setLang(lang);
      await App.saveProfile(
          schoolName: 'Govt. Model High School, Lahore',
          district: 'Lahore',
          tehsil: '',
          teacherName: 'Teacher');
      student = await App.students.add(name: 'Ayesha Khan', rollNo: '7', grade: 9);
      await App.students.add(name: 'Ali Raza', rollNo: '8', grade: 9);
      await App.setPref('last_grade', '9');
    });
  }

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 30)));
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Widget wrap(Widget w, String lang) => MaterialApp(
      key: UniqueKey(),
      debugShowCheckedModeBanner: false,
      theme: buildTheme(lang),
      builder: (c, child) => Directionality(
          textDirection: lang == 'ur' ? TextDirection.rtl : TextDirection.ltr,
          child: child!),
      home: w);

  Future<void> shot(WidgetTester tester, String name) async {
    await expectLater(find.byType(MaterialApp).first, matchesGoldenFile('goldens/$name.png'));
  }

  Future<SubjectPlan> physicsPlan() async {
    late SubjectPlan plan;
    await tester0!.runAsync(() async {
      final b = (await App.library.bestBook(9, 'Physics'))!;
      final chapters = await App.library.chaptersWithTopics(b.id);
      plan = SubjectPlan(b.subject, b, chapters, {})..enabled = true;
      plan.selection.chapterIds.add(chapters.first.chapter.id);
      final pool = await App.library.pool(b.id, plan.selection, type: 'mcq');
      final byId = {for (final c in chapters) c.chapter.id: c};
      plan.questions = [
        for (final q in pool.take(3))
          App.engine.present(q,
              chapter: byId[q.chapterId]!.chapter,
              topic: byId[q.chapterId]!.topics.where((t) => t.id == q.topicId).firstOrNull,
              shuffle: false)
      ];
    });
    return plan;
  }

  for (final lang in ['en', 'ur']) {
    testWidgets('screens $lang', (tester) async {
      tester0 = tester;
      await boot(tester, lang: lang);
      await tester.pumpWidget(const SchoolAssessApp());
      await settle(tester);
      await shot(tester, '${lang}_1_home');

      await tester.pumpWidget(wrap(const LibraryScreen(), lang));
      await settle(tester);
      await shot(tester, '${lang}_2_library');

      late String bookId;
      await tester.runAsync(
          () async => bookId = (await App.library.bestBook(9, 'Physics'))!.id);
      await tester.pumpWidget(wrap(BookScreen(bookId: bookId), lang));
      await settle(tester);
      await tester.drag(find.byType(ListView).first, const Offset(0, -600));
      await settle(tester);
      await shot(tester, '${lang}_3_book');

      await tester.pumpWidget(wrap(AssessSetupScreen(student: student), lang));
      await settle(tester);
      final phy = find.text(subjectLabel('Physics'), skipOffstage: false).first;
      await tester.ensureVisible(phy);
      await settle(tester);
      await tester.tap(phy);
      await settle(tester);
      await shot(tester, '${lang}_4_setup');

      final plan = await physicsPlan();
      await tester.pumpWidget(wrap(
          AssessRunScreen(
              student: student, plans: [plan], feedbackMode: 'immediate', practice: false),
          lang));
      await settle(tester);
      final q = plan.questions.first;
      await tester.tap(find.text(q.options[(q.correctIndex + 1) % 4]).first);
      await settle(tester);
      await shot(tester, '${lang}_5_feedback');

      // Finish the remaining questions and show the result.
      for (var i = 0; i < 3; i++) {
        final cur = plan.questions[i];
        if (i > 0) {
          await tester.tap(find.text(cur.options[cur.correctIndex]).first);
          await settle(tester);
        }
        await tester.tap(find.text(i == 2 ? tr('Finish', 'مکمل کریں') : tr('Next', 'اگلا')).last);
        await settle(tester);
      }
      await shot(tester, '${lang}_6_result');

      await tester.pumpWidget(wrap(ProgressScreen(student: student), lang));
      await settle(tester);
      await shot(tester, '${lang}_7_progress');
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await settle(tester);
    });
  }
}

WidgetTester? tester0;

// Silence unused-import warnings for screens referenced only by type.
// ignore: unused_element
final _keep = [ResultScreen];
