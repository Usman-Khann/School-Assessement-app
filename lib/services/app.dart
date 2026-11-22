import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../core/core.dart';
import '../data/db/database.dart';
import '../data/demo_pack.dart';
import '../data/repos/attempt_repo.dart';
import '../data/repos/library_repo.dart';
import '../data/repos/student_repo.dart';
import 'assessment_engine.dart';
import 'content_service.dart';
import 'paper_generator.dart';
import 'sync_engine.dart';
import 'textbook_import.dart';

/// Simple service locator. Everything the UI needs hangs off [App].
class App {
  static late AppDatabase db;
  static late StudentRepo students;
  static late LibraryRepo library;
  static late AttemptRepo attempts;
  static late TextbookImporter importer;
  static late SyncEngine sync;
  static late PaperGenerator papers;
  static final AssessmentEngine engine = AssessmentEngine();

  /// Current tenant. In guest mode this is a device-local school created on
  /// first launch; every tenant-owned row carries it.
  static String schoolId = '';
  static String teacherId = '';
  static bool setupDone = false;

  static final ValueNotifier<bool> online = ValueNotifier(false);

  /// Ids of official books whose remote file seems to have changed.
  static final ValueNotifier<Set<String>> bookUpdates = ValueNotifier({});
  static StreamSubscription? _connSub;

  static late ContentService content;

  static Future<void> init(
      {AppDatabase? database,
      bool watchNetwork = true,
      bool importBundledContent = true}) async {
    db = database ?? AppDatabase();
    students = StudentRepo(db, () => schoolId);
    library = LibraryRepo(db);
    attempts = AttemptRepo(db, () => schoolId);
    importer = TextbookImporter(library);
    sync = SyncEngine(db);
    papers = PaperGenerator(library);
    content = ContentService(db);
    if (importBundledContent) {
      // Official chapters, topics and MCQs shipped inside the app.
      await content.ensureBundled();
    }

    final oldSid = await db.getSetting('school_id');
    final oldTid = await db.getSetting('teacher_id');
    final String sid = oldSid ?? newId();
    final String tid = oldTid ?? newId();
    if (oldSid == null || oldTid == null) {
      final now = DateTime.now();
      await db.transaction(() async {
        await db.into(db.schools).insert(
            SchoolsCompanion.insert(id: sid, updatedAt: now),
            mode: InsertMode.insertOrIgnore);
        await db.into(db.teachers).insert(
            TeachersCompanion.insert(id: tid, schoolId: sid, updatedAt: now),
            mode: InsertMode.insertOrIgnore);
        await db.setSetting('school_id', sid);
        await db.setSetting('teacher_id', tid);
      });
    }
    schoolId = sid;
    teacherId = tid;
    appLang.value = await db.getSetting('lang') ?? 'en';
    setupDone = (await db.getSetting('setup_done')) == '1';
    await sync.refreshStatus();

    if (watchNetwork) {
      try {
        final c = Connectivity();
        _setOnline(await c.checkConnectivity());
        _connSub = c.onConnectivityChanged.listen(_setOnline);
      } catch (_) {
        // Connectivity plugin unavailable (e.g. tests): stay "offline".
      }
    }
  }

  static void _setOnline(List<ConnectivityResult> r) {
    final now = r.any((e) => e != ConnectivityResult.none);
    final was = online.value;
    online.value = now;
    if (now && !was) {
      // Internet is back: push pending records, fetch newer textbook content
      // from the content repository and look for updated official books.
      sync.run();
      content.checkOnline();
      importer.checkForUpdates().then((s) => bookUpdates.value = s);
    }
  }

  static Future<void> dispose() async {
    await _connSub?.cancel();
    await db.close();
  }

  // ---------- School / teacher profile (all optional) ----------
  static Future<School> school() =>
      (db.select(db.schools)..where((t) => t.id.equals(schoolId))).getSingle();
  static Future<Teacher> teacher() =>
      (db.select(db.teachers)..where((t) => t.id.equals(teacherId)))
          .getSingle();

  static Future<void> saveProfile({
    required String schoolName,
    required String district,
    required String tehsil,
    required String teacherName,
  }) async {
    final now = DateTime.now();
    await (db.update(db.schools)..where((t) => t.id.equals(schoolId))).write(
        SchoolsCompanion(
            name: Value(schoolName.trim()),
            district: Value(district.trim()),
            tehsil: Value(tehsil.trim()),
            updatedAt: Value(now)));
    await (db.update(db.teachers)..where((t) => t.id.equals(teacherId))).write(
        TeachersCompanion(name: Value(teacherName.trim()), updatedAt: Value(now)));
    await db.enqueueSync('schools', schoolId);
    await db.enqueueSync('teachers', teacherId);
    await markSetupDone();
    await sync.refreshStatus();
  }

  static Future<void> markSetupDone() async {
    setupDone = true;
    await db.setSetting('setup_done', '1');
  }

  static Future<void> setLang(String l) async {
    appLang.value = l;
    await db.setSetting('lang', l);
  }

  static Future<String> getPref(String k, String fallback) async =>
      await db.getSetting(k) ?? fallback;
  static Future<void> setPref(String k, String v) => db.setSetting(k, v);

  /// Adds the clearly-labelled SAMPLE book for [grade] so the app can be
  /// tried immediately. Returns the existing one if already added.
  static Future<Textbook> loadDemo(int grade) async {
    final have = (await library.booksFor(grade, kMath))
        .where((b) => b.sourceType == 'demo')
        .firstOrNull;
    if (have != null) return have;
    final b = await library.addBook(
        grade: grade,
        subject: kMath,
        title: kDemoBookTitle,
        sourceType: 'demo',
        notes: 'Sample content for trying the app. Not from an official '
            'Punjab textbook. Delete or ignore once real books are added.');
    await library.importPack(b, jsonEncode(kDemoPack), source: 'demo');
    return b;
  }

  // ---------- Saved papers ----------
  static Future<String> savePaper(GeneratedPaper p) async {
    final id = newId();
    await db.into(db.papers).insert(PapersCompanion.insert(
        id: id,
        schoolId: schoolId,
        title: p.config.title,
        grade: p.config.grade,
        subject: p.config.subject,
        textbookId: p.config.bookId,
        configJson: jsonEncode(p.config.toJson()),
        contentJson: p.contentJson(),
        createdAt: DateTime.now()));
    return id;
  }

  static Stream<List<Paper>> watchPapers() => (db.select(db.papers)
        ..where((t) => t.schoolId.equals(schoolId))
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
        ]))
      .watch();

  static Future<void> deletePaper(String id) =>
      (db.delete(db.papers)..where((t) => t.id.equals(id))).go();
}
