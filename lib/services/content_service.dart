import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../core/core.dart';
import '../data/db/database.dart';

/// The public GitHub repository that holds the content catalog, question
/// packs and textbook PDFs (folder `content/`).
const kContentRepo = 'Usman-Khann/School-Assessement-app';
const kContentBranch = 'main';

String contentUrl(String path) =>
    'https://raw.githubusercontent.com/$kContentRepo/$kContentBranch/content/'
    '${path.split('/').map(Uri.encodeComponent).join('/')}';

class ContentProblem implements Exception {
  final String message;
  ContentProblem(this.message);
  @override
  String toString() => message;
}

/// Keeps the local library in step with the content catalog.
///
/// * A copy of the catalog and all question packs is bundled inside the app,
///   so every book's chapters, topics and MCQs work offline from the first
///   launch.
/// * When online, a newer catalog is fetched from the repository and imported
///   (only books whose content changed are touched).
/// * Textbook PDFs are large, so each one is downloaded only when the teacher
///   asks for it, then kept on the phone for offline reading.
///
/// Imports are idempotent: every row has a stable id from the catalog, so a
/// re-import updates rows instead of duplicating them, and the teacher's own
/// settings (downloaded file, "applicable syllabus" flag) are preserved.
class ContentService {
  final AppDatabase db;
  final ValueNotifier<bool> busy = ValueNotifier(false);
  final ValueNotifier<String> message = ValueNotifier('');
  ContentService(this.db);

  Future<String> installedVersion() async =>
      await db.getSetting('content_version') ?? '';

  /// Imports the catalog shipped in the app if it is newer than the
  /// installed one. Returns the number of books imported.
  Future<int> ensureBundled() async {
    final raw = await rootBundle.loadString('assets/content/catalog.json');
    final cat = jsonDecode(raw) as Map<String, dynamic>;
    if ((cat['version'] as String).compareTo(await installedVersion()) <= 0) {
      return 0;
    }
    return importCatalog(
        cat, (path) => rootBundle.loadString('assets/content/$path'));
  }

  /// Checks the repository for a newer catalog. Returns a short message for
  /// the teacher. Never throws for network problems.
  Future<String> checkOnline() async {
    if (busy.value) return message.value;
    busy.value = true;
    try {
      final r = await http
          .get(Uri.parse(contentUrl('catalog.json')))
          .timeout(const Duration(seconds: 30));
      if (r.statusCode != 200) {
        return message.value = tr(
            'Could not reach the content server (HTTP ${r.statusCode}).',
            'مواد کے سرور تک رسائی نہیں ہو سکی (HTTP ${r.statusCode})۔');
      }
      final cat = jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>;
      final have = await installedVersion();
      if ((cat['version'] as String).compareTo(have) <= 0) {
        return message.value =
            tr('Textbook content is up to date.', 'درسی مواد تازہ ترین ہے۔');
      }
      final n = await importCatalog(cat, (path) async {
        final pr = await http
            .get(Uri.parse(contentUrl(path)))
            .timeout(const Duration(seconds: 60));
        if (pr.statusCode != 200) {
          throw ContentProblem('HTTP ${pr.statusCode} for $path');
        }
        return utf8.decode(pr.bodyBytes);
      });
      return message.value = tr('Updated content for $n books.',
          '$n کتابوں کا مواد اپ ڈیٹ ہو گیا۔');
    } catch (e) {
      return message.value = tr(
          'Could not check for new content. Your saved content still works offline.',
          'نیا مواد چیک نہیں ہو سکا۔ محفوظ مواد آف لائن کام کرتا رہے گا۔');
    } finally {
      busy.value = false;
    }
  }

  /// Imports a catalog. [load] returns the text of a pack given its path.
  Future<int> importCatalog(Map<String, dynamic> cat,
      Future<String> Function(String path) load) async {
    final books = (cat['books'] as List).cast<Map<String, dynamic>>();
    final now = DateTime.now();
    final note = (cat['note'] ?? '').toString();
    var count = 0;
    for (final b in books) {
      final packText = await load(b['pack'] as String);
      final pack = jsonDecode(packText) as Map<String, dynamic>;
      final bid = b['id'] as String;
      final grade = (b['grade'] as num).toInt();
      final subject = b['subject'] as String;
      await db.transaction(() async {
        final meta = TextbooksCompanion(
          grade: Value(grade),
          subject: Value(subject),
          title: Value(b['title'] as String),
          edition: const Value('eLearn Punjab web version'),
          publisher: Value((b['publisher'] ?? '').toString()),
          language: Value((b['language'] ?? 'en').toString()),
          sourceUrl: Value((b['sourceUrl'] ?? '').toString()),
          notes: Value(note),
          remoteFile: Value(b['pdf'] as String?),
          remoteBytes: Value((b['pdfBytes'] as num?)?.toInt()),
        );
        await db.into(db.textbooks).insert(
            meta.copyWith(
              id: Value(bid),
              seriesId: Value('cat-${b['key']}'),
              sourceType: const Value('official_download'),
              importedAt: Value(now),
            ),
            onConflict: DoUpdate((_) => meta));

        final chapters = (b['chapters'] as List).cast<Map<String, dynamic>>();
        await db.batch((bt) {
          for (final c in chapters) {
            bt.insert(
                db.chapters,
                ChaptersCompanion.insert(
                  id: c['id'] as String,
                  textbookId: bid,
                  number: (c['number'] as num).toInt(),
                  title: c['title'] as String,
                  pageStart: Value((c['pageStart'] as num?)?.toInt()),
                  pageEnd: Value((c['pageEnd'] as num?)?.toInt()),
                ),
                mode: InsertMode.insertOrReplace);
            final topics = (c['topics'] as List).cast<Map<String, dynamic>>();
            for (var i = 0; i < topics.length; i++) {
              final t = topics[i];
              bt.insert(
                  db.topics,
                  TopicsCompanion.insert(
                    id: t['id'] as String,
                    chapterId: c['id'] as String,
                    orderNo: Value(i),
                    title: t['title'] as String,
                    pageStart: Value((t['page'] as num?)?.toInt()),
                  ),
                  mode: InsertMode.insertOrReplace);
            }
          }
        });

        final qs = (pack['questions'] as List).cast<Map<String, dynamic>>();
        final ids = <String>[];
        await db.batch((bt) {
          for (final q in qs) {
            final body = q['text'] as String;
            ids.add(q['id'] as String);
            bt.insert(
                db.questions,
                QuestionsCompanion.insert(
                  id: q['id'] as String,
                  textbookId: bid,
                  chapterId: q['chapterId'] as String,
                  topicId: Value(q['topicId'] as String?),
                  grade: grade,
                  subject: subject,
                  type: (q['type'] ?? 'mcq') as String,
                  body: body,
                  optionsJson: Value(jsonEncode(q['options'] ?? const [])),
                  correctIndex: Value((q['correctIndex'] as num?)?.toInt()),
                  answer: Value((q['answer'] ?? '').toString()),
                  shortExplanation: Value((q['explanation'] ?? '').toString()),
                  conceptExplanation: Value((q['concept'] ?? '').toString()),
                  pageRef: Value((q['page'] as num?)?.toInt()),
                  difficulty: Value((q['difficulty'] as num?)?.toInt() ?? 2),
                  source: Value((q['source'] ?? 'elearn').toString()),
                  verified: const Value(false),
                  language: Value(isRtlText(body) ? 'ur' : 'en'),
                  createdAt: now,
                  deleted: const Value(false),
                  reviewNote: Value((q['reviewNote'] ?? '').toString()),
                ),
                mode: InsertMode.insertOrReplace);
          }
        });
        // Questions removed from the catalog are hidden, never hard-deleted,
        // so saved assessment history keeps pointing at something.
        await (db.update(db.questions)
              ..where((t) =>
                  t.textbookId.equals(bid) &
                  t.source.equals('elearn') &
                  t.id.isNotIn(ids)))
            .write(const QuestionsCompanion(deleted: Value(true)));
      });
      count++;
    }
    await db.setSetting('content_version', cat['version'] as String);
    return count;
  }

  Future<Directory> _bookDir() async {
    final base = await getApplicationDocumentsDirectory();
    final d = Directory(p.join(base.path, 'textbooks'));
    if (!d.existsSync()) d.createSync(recursive: true);
    return d;
  }

  /// Downloads the PDF of a catalog book from the content repository and
  /// remembers where it is stored.
  Future<void> downloadBook(Textbook b,
      {void Function(int received, int? total)? onProgress}) async {
    final remote = b.remoteFile;
    if (remote == null) {
      throw ContentProblem(tr('This book has no file to download.',
          'اس کتاب کی کوئی فائل ڈاؤن لوڈ کے لیے موجود نہیں۔'));
    }
    final dest = File(p.join((await _bookDir()).path, '${b.id}.pdf'));
    final tmp = File('${dest.path}.part');
    final client = http.Client();
    try {
      final resp = await client
          .send(http.Request('GET', Uri.parse(contentUrl(remote))))
          .timeout(const Duration(seconds: 40));
      if (resp.statusCode != 200) {
        throw ContentProblem(tr(
            'The book could not be downloaded (HTTP ${resp.statusCode}). Please try again later.',
            'کتاب ڈاؤن لوڈ نہیں ہو سکی (HTTP ${resp.statusCode})۔ بعد میں دوبارہ کوشش کریں۔'));
      }
      final total = resp.contentLength ?? b.remoteBytes;
      final sink = tmp.openWrite();
      var got = 0;
      await for (final chunk in resp.stream) {
        sink.add(chunk);
        got += chunk.length;
        onProgress?.call(got, total);
      }
      await sink.close();
      final head = await tmp.openRead(0, 5).first;
      if (String.fromCharCodes(head) != '%PDF-') {
        await tmp.delete();
        throw ContentProblem(tr('The downloaded file is not a PDF.',
            'ڈاؤن لوڈ کی گئی فائل PDF نہیں ہے۔'));
      }
      if (dest.existsSync()) await dest.delete();
      await tmp.rename(dest.path);
      final sha = (await sha256.bind(dest.openRead()).first).toString();
      await (db.update(db.textbooks)..where((t) => t.id.equals(b.id))).write(
          TextbooksCompanion(
              filePath: Value(dest.path),
              fileSha256: Value(sha),
              fileSize: Value(await dest.length())));
    } on ContentProblem {
      rethrow;
    } catch (e) {
      if (tmp.existsSync()) await tmp.delete();
      throw ContentProblem(tr(
          'Download failed. Check the internet connection and try again.',
          'ڈاؤن لوڈ ناکام۔ انٹرنیٹ چیک کر کے دوبارہ کوشش کریں۔'));
    } finally {
      client.close();
    }
  }

  /// Frees space by removing a downloaded book file (the book, chapters and
  /// questions stay; the PDF can be downloaded again).
  Future<void> removeBookFile(Textbook b) async {
    final f = b.filePath == null ? null : File(b.filePath!);
    if (f != null && f.existsSync()) await f.delete();
    await (db.update(db.textbooks)..where((t) => t.id.equals(b.id))).write(
        const TextbooksCompanion(
            filePath: Value(null), fileSha256: Value(null), fileSize: Value(null)));
  }
}

String fmtMb(int? bytes) =>
    bytes == null ? '' : '${(bytes / 1048576).toStringAsFixed(bytes < 10485760 ? 1 : 0)} MB';
