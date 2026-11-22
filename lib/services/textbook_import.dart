import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../core/core.dart';
import '../data/db/database.dart';
import '../data/repos/library_repo.dart';

/// Official Punjab Government sources. Downloads are only accepted from
/// these hosts (or their sub-domains); anything else must be uploaded
/// manually by the teacher/administrator.
const kOfficialHosts = [
  'pectaa.edu.pk',
  'elearn.gov.pk',
  'punjab.gov.pk',
  'ptb.gop.pk',
  'pctb.punjab.gov.pk',
];

const kOfficialSites = {
  'PECTAA': 'https://pectaa.edu.pk/',
  'eLearn Punjab': 'https://www.elearn.gov.pk/',
};

bool isOfficialUrl(String url) {
  final u = Uri.tryParse(url.trim());
  if (u == null || u.scheme != 'https' && u.scheme != 'http') return false;
  final h = u.host.toLowerCase();
  return kOfficialHosts.any((o) => h == o || h.endsWith('.$o'));
}

class StoredFile {
  final String path;
  final String sha256;
  final int size;
  StoredFile(this.path, this.sha256, this.size);
}

class ImportProblem implements Exception {
  final String message;
  ImportProblem(this.message);
  @override
  String toString() => message;
}

class TextbookImporter {
  final LibraryRepo lib;
  TextbookImporter(this.lib);

  Future<Directory> _dir() async {
    final base = await getApplicationDocumentsDirectory();
    final d = Directory(p.join(base.path, 'textbooks'));
    if (!d.existsSync()) d.createSync(recursive: true);
    return d;
  }

  static Future<bool> _looksLikePdf(File f) async {
    final raf = await f.open();
    try {
      final head = await raf.read(5);
      return String.fromCharCodes(head) == '%PDF-';
    } finally {
      await raf.close();
    }
  }

  static Future<String> _sha(File f) async =>
      (await sha256.bind(f.openRead()).first).toString();

  /// Lets the teacher choose a PDF from the device and copies it into the
  /// app's private storage. Returns null if the picker was cancelled.
  Future<StoredFile?> pickPdf() async {
    final r = await FilePicker.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf']);
    final src = r.isEmpty ? null : r.first.path;
    if (src == null) return null;
    final f = File(src);
    if (!await _looksLikePdf(f)) {
      throw ImportProblem(
          tr('This file is not a valid PDF.', 'یہ فائل درست PDF نہیں ہے۔'));
    }
    final dest = File(p.join((await _dir()).path, '${newId()}.pdf'));
    await f.copy(dest.path);
    return StoredFile(dest.path, await _sha(dest), await dest.length());
  }

  /// Downloads a PDF from an official Punjab Government URL.
  Future<StoredFile> downloadOfficial(String url,
      {void Function(int received, int? total)? onProgress}) async {
    if (!isOfficialUrl(url)) {
      throw ImportProblem(tr(
          'Only links from official Punjab Government websites are accepted. '
              'Use "Upload PDF" for other files.',
          'صرف حکومتِ پنجاب کی سرکاری ویب سائٹس کے لنک قبول کیے جاتے ہیں۔'));
    }
    final dest = File(p.join((await _dir()).path, '${newId()}.pdf'));
    final client = http.Client();
    try {
      final resp = await client
          .send(http.Request('GET', Uri.parse(url.trim())))
          .timeout(const Duration(seconds: 30));
      if (resp.statusCode != 200) {
        throw ImportProblem(tr(
            'The official website did not return the file (HTTP ${resp.statusCode}). '
                'Please try later or upload the PDF manually.',
            'سرکاری ویب سائٹ سے فائل نہیں ملی (HTTP ${resp.statusCode})۔'));
      }
      final sink = dest.openWrite();
      var got = 0;
      await for (final chunk in resp.stream) {
        sink.add(chunk);
        got += chunk.length;
        onProgress?.call(got, resp.contentLength);
      }
      await sink.close();
      if (!await _looksLikePdf(dest)) {
        await dest.delete();
        throw ImportProblem(tr(
            'That link is a web page, not a PDF file. Open the official site, '
                'copy the direct link of the book PDF, and try again.',
            'یہ لنک PDF فائل کا نہیں ہے۔ کتاب کی PDF کا براہِ راست لنک استعمال کریں۔'));
      }
      return StoredFile(dest.path, await _sha(dest), await dest.length());
    } on ImportProblem {
      rethrow;
    } catch (e) {
      if (dest.existsSync()) await dest.delete();
      throw ImportProblem(tr(
          'Could not reach the official website. Check the internet '
              'connection, or upload the PDF manually. ($e)',
          'سرکاری ویب سائٹ تک رسائی نہیں ہو سکی۔ انٹرنیٹ چیک کریں یا PDF خود اپ لوڈ کریں۔'));
    } finally {
      client.close();
    }
  }

  /// For books downloaded from an official URL: asks the server for the
  /// current file size and reports books whose remote file now differs.
  /// The local copy is never replaced; the teacher decides to import the
  /// new file as a new version.
  Future<Set<String>> checkForUpdates() async {
    final changed = <String>{};
    final books = await lib.watchBooks().first;
    for (final b in books) {
      if (b.sourceType != 'official_download' ||
          !b.isCurrent ||
          b.fileSize == null ||
          !isOfficialUrl(b.sourceUrl)) {
        continue;
      }
      try {
        final r = await http
            .head(Uri.parse(b.sourceUrl))
            .timeout(const Duration(seconds: 15));
        final len = int.tryParse(r.headers['content-length'] ?? '');
        if (r.statusCode == 200 && len != null && len != b.fileSize) {
          changed.add(b.id);
        }
      } catch (_) {
        // Offline or site unreachable: simply try again next time.
      }
    }
    return changed;
  }

  Future<Textbook?> findSameFile(String sha) async {
    final books = await lib.watchBooks().first;
    return books.where((b) => b.fileSha256 == sha).firstOrNull;
  }
}
