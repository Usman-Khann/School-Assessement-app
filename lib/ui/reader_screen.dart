import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import '../core/core.dart';
import '../data/db/database.dart';
import '../services/app.dart';
import '../services/content_service.dart';
import 'common.dart';

/// In-app textbook reader that opens directly at a page.
class ReaderScreen extends StatefulWidget {
  final Textbook book;
  final int page;
  final String? heading;
  const ReaderScreen({super.key, required this.book, this.page = 1, this.heading});
  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late final PdfControllerPinch _controller = PdfControllerPinch(
      document: PdfDocument.openFile(widget.book.filePath!),
      initialPage: widget.page < 1 ? 1 : widget.page);
  late int _page = widget.page;
  int _pages = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.heading ?? widget.book.title,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (_pages > 0)
            Center(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('$_page / $_pages',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w800)))),
        ],
      ),
      body: PdfViewPinch(
        controller: _controller,
        backgroundDecoration: const BoxDecoration(color: Color(0xFFE9EDF3)),
        onDocumentLoaded: (doc) => setState(() => _pages = doc.pagesCount),
        onPageChanged: (n) => setState(() => _page = n),
        onDocumentError: (_) => snack(context,
            tr('This book file could not be opened.', 'یہ کتاب نہیں کھل سکی۔')),
      ),
    );
  }
}

/// Opens [bookId] at [page]. If the PDF is not on the phone yet, offers to
/// download it (needs internet once).
Future<void> openBook(BuildContext context, String bookId,
    {int page = 1, String? heading}) async {
  var book = await App.library.book(bookId);
  if (book == null || !context.mounted) return;
  if (book.filePath != null && File(book.filePath!).existsSync()) {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                ReaderScreen(book: book!, page: page, heading: heading)));
    return;
  }
  if (book.remoteFile == null) {
    snack(context,
        tr('No file is attached to this book.', 'اس کتاب کے ساتھ کوئی فائل منسلک نہیں۔'));
    return;
  }
  final ok = await downloadBookDialog(context, book);
  if (!ok || !context.mounted) return;
  book = await App.library.book(bookId);
  if (book?.filePath != null && context.mounted) {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                ReaderScreen(book: book!, page: page, heading: heading)));
  }
}

/// Asks, then downloads a catalog book with a progress dialog.
/// Returns true when the file is now on the phone.
Future<bool> downloadBookDialog(BuildContext context, Textbook book) async {
  final go = await confirm(
      context,
      tr('Download this book?', 'یہ کتاب ڈاؤن لوڈ کریں؟'),
      tr('${book.title} (${fmtMb(book.remoteBytes)}). It is saved on this phone and opens without internet afterwards.',
          '${book.title} (${fmtMb(book.remoteBytes)})۔ یہ اسی موبائل میں محفوظ ہو جائے گی اور بعد میں انٹرنیٹ کے بغیر کھلے گی۔'));
  if (!go || !context.mounted) return false;
  final progress = ValueNotifier<double?>(null);
  String? error;
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (d) => AlertDialog(
            title: Text(tr('Downloading…', 'ڈاؤن لوڈ ہو رہی ہے…')),
            content: ValueListenableBuilder<double?>(
                valueListenable: progress,
                builder: (_, v, __) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LinearProgressIndicator(value: v, minHeight: 8),
                          const SizedBox(height: 10),
                          Text(v == null ? '' : '${(v * 100).round()}%'),
                        ])),
          ));
  try {
    await App.content.downloadBook(book, onProgress: (got, total) {
      if (total != null && total > 0) progress.value = got / total;
    });
  } on ContentProblem catch (e) {
    error = e.message;
  }
  if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
  if (error != null && context.mounted) {
    snack(context, error);
    return false;
  }
  return true;
}
