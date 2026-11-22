import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/core.dart';
import '../data/db/database.dart';
import '../services/app.dart';
import '../services/textbook_import.dart';
import 'book_screen.dart';
import 'common.dart';
import 'reader_screen.dart';
import 'theme.dart';
import '../services/content_service.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _grade = 5;

  @override
  void initState() {
    super.initState();
    App.getPref('last_grade', '5').then((v) {
      if (mounted) setState(() => _grade = int.tryParse(v) ?? 5);
    });
  }

  Future<void> _open(Textbook b) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (_) => BookScreen(bookId: b.id)));
    if (mounted) setState(() {});
  }

  Future<Map<String, int>> _counts(List<Textbook> books) async {
    final out = <String, int>{};
    for (final b in books) {
      out[b.id] = (await App.library.questions(b.id, type: 'mcq')).length;
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(tr('Textbooks', 'درسی کتب')),
          actions: const [OnlineChip()]),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final b = await Navigator.push<Textbook>(context,
                MaterialPageRoute(builder: (_) => AddBookScreen(grade: _grade)));
            if (b != null) _open(b);
          },
          icon: const Icon(Icons.add),
          label: Text(tr('Add book', 'کتاب شامل کریں'))),
      body: Body(
          child: Column(children: [
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: GradeChips(
                value: _grade,
                onChanged: (g) {
                  setState(() => _grade = g!);
                  App.setPref('last_grade', '$g');
                })),
        Expanded(
            child: StreamBuilder<List<Textbook>>(
                stream: App.library.watchBooks(grade: _grade),
                builder: (_, snap) {
                  final books = snap.data ?? const <Textbook>[];
                  if (snap.hasData && books.isEmpty) {
                    return EmptyHint(
                        icon: Icons.menu_book,
                        text: tr(
                            'No textbook for ${gradeLabel(_grade)} yet.\n'
                                'Tap "Add book" to upload the official PDF.',
                            '${gradeLabel(_grade)} کے لیے ابھی کوئی کتاب نہیں۔\n'
                                'سرکاری PDF اپ لوڈ کرنے کے لیے "کتاب شامل کریں" دبائیں۔'));
                  }
                  return FutureBuilder<Map<String, int>>(
                      future: _counts(books),
                      builder: (_, cs) => ValueListenableBuilder<Set<String>>(
                          valueListenable: App.bookUpdates,
                          builder: (_, updates, __) => ListView(
                                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 88),
                                  children: [
                                    for (final b in books)
                                      BookCard(
                                          book: b,
                                          questions: cs.data?[b.id],
                                          updateAvailable: updates.contains(b.id),
                                          onTap: () => _open(b),
                                          onChanged: () => setState(() {})),
                                  ])));
                })),
      ])),
    );
  }
}

/// Add a book: upload a PDF, download from an official link, or register
/// the book without a file. Also used to add a new version of [previous].
class AddBookScreen extends StatefulWidget {
  final int grade;
  final Textbook? previous;
  const AddBookScreen({super.key, required this.grade, this.previous});
  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  late int _grade = widget.previous?.grade ?? widget.grade;
  late String _subject =
      widget.previous?.subject ?? defaultSubjectsFor(_grade).first;
  late String _lang = widget.previous?.language ?? 'en';
  late final _title = TextEditingController(text: widget.previous?.title ?? '');
  final _customSubject = TextEditingController();
  final _year = TextEditingController();
  final _edition = TextEditingController();
  late final _publisher =
      TextEditingController(text: widget.previous?.publisher ?? '');
  final _url = TextEditingController();
  StoredFile? _file;
  String _sourceType = 'no_file';
  bool _busy = false;
  String _progress = '';

  Future<void> _run(Future<void> Function() f) async {
    setState(() => _busy = true);
    try {
      await f();
    } on ImportProblem catch (e) {
      if (mounted) {
        await showDialog(
            context: context,
            builder: (d) => AlertDialog(
                    title: Text(tr('Could not add the file', 'فائل شامل نہ ہو سکی')),
                    content: Text(e.message),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(d),
                          child: const Text('OK'))
                    ]));
      }
    } catch (e) {
      if (mounted) snack(context, '$e');
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _progress = '';
        });
      }
    }
  }

  Future<void> _upload() => _run(() async {
        final f = await App.importer.pickPdf();
        if (f != null) {
          _file = f;
          _sourceType = 'manual_upload';
        }
      });

  Future<void> _download() => _run(() async {
        final f = await App.importer.downloadOfficial(_url.text,
            onProgress: (got, total) {
          if (mounted) {
            setState(() => _progress = total == null
                ? '${(got / 1048576).toStringAsFixed(1)} MB'
                : '${(got * 100 / total).round()}%');
          }
        });
        _file = f;
        _sourceType = 'official_download';
      });

  Future<void> _save() async {
    final subject = _subject == '_other' ? _customSubject.text.trim() : _subject;
    if (_title.text.trim().isEmpty || subject.isEmpty) {
      snack(context,
          tr('Enter the book title and subject.', 'کتاب کا عنوان اور مضمون درج کریں۔'));
      return;
    }
    if (_file != null) {
      final same = await App.importer.findSameFile(_file!.sha256);
      if (same != null && mounted) {
        final go = await confirm(
            context,
            tr('Same file already in library', 'یہی فائل پہلے سے موجود ہے'),
            tr('This exact PDF is already stored as "${same.title}" (v${same.version}). Add it again anyway?',
                'یہی PDF "${same.title}" (v${same.version}) کے طور پر موجود ہے۔ پھر بھی شامل کریں؟'));
        if (!go) return;
      }
    }
    final b = await App.library.addBook(
        grade: _grade,
        subject: subject,
        title: _title.text,
        academicYear: _year.text,
        edition: _edition.text,
        publisher: _publisher.text,
        language: _lang,
        sourceType: _sourceType,
        sourceUrl: _sourceType == 'official_download' ? _url.text : '',
        filePath: _file?.path,
        fileSha256: _file?.sha256,
        fileSize: _file?.size,
        previousVersionOf: widget.previous);
    if (mounted) Navigator.pop(context, b);
  }

  @override
  Widget build(BuildContext context) {
    final subjects = defaultSubjectsFor(_grade);
    final subjectItems = {...subjects, if (_subject != '_other') _subject};
    final isNewVersion = widget.previous != null;
    return Scaffold(
      appBar: AppBar(
          title: Text(isNewVersion
              ? tr('Add new version', 'نیا ورژن شامل کریں')
              : tr('Add book', 'کتاب شامل کریں'))),
      body: Body(
          child: ListView(padding: const EdgeInsets.all(16), children: [
        if (isNewVersion)
          Card(
              child: ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(tr('Earlier versions are kept',
                      'پرانے ورژن محفوظ رہتے ہیں')),
                  subtitle: Text(tr(
                      'The current version stays in the library. Its chapters and topics are copied to the new version.',
                      'موجودہ ورژن لائبریری میں رہے گا۔ اس کے ابواب نئے ورژن میں نقل ہو جائیں گے۔')))),
        if (!isNewVersion) ...[
          Row(children: [
            Expanded(
                child: DropdownButtonFormField<int>(
                    initialValue: _grade,
                    decoration:
                        InputDecoration(labelText: tr('Class', 'جماعت')),
                    items: [
                      for (final g in kGrades)
                        DropdownMenuItem(value: g, child: Text(gradeLabel(g)))
                    ],
                    onChanged: (g) => setState(() {
                          _grade = g!;
                          _subject = defaultSubjectsFor(_grade).first;
                        }))),
            const SizedBox(width: 10),
            Expanded(
                child: DropdownButtonFormField<String>(
                    key: ValueKey('$_grade$_subject'),
                    initialValue: _subject,
                    isExpanded: true,
                    decoration:
                        InputDecoration(labelText: tr('Subject', 'مضمون')),
                    items: [
                      for (final s in subjectItems)
                        DropdownMenuItem(value: s, child: Text(subjectLabel(s))),
                      DropdownMenuItem(
                          value: '_other',
                          child: Text(tr('Other…', 'دیگر…'))),
                    ],
                    onChanged: (s) => setState(() => _subject = s!))),
          ]),
          if (_subject == '_other')
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                    controller: _customSubject,
                    decoration: InputDecoration(
                        labelText: tr('Subject name', 'مضمون کا نام')))),
          const SizedBox(height: 10),
        ],
        TextField(
            controller: _title,
            decoration: InputDecoration(
                labelText: '${tr('Book title', 'کتاب کا عنوان')} *')),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
              child: TextField(
                  controller: _year,
                  decoration: InputDecoration(
                      labelText: tr('Academic year', 'تعلیمی سال'),
                      hintText: '2026-27'))),
          const SizedBox(width: 10),
          Expanded(
              child: TextField(
                  controller: _edition,
                  decoration:
                      InputDecoration(labelText: tr('Edition', 'ایڈیشن')))),
        ]),
        const SizedBox(height: 10),
        TextField(
            controller: _publisher,
            decoration: InputDecoration(
                labelText: tr('Publisher / board', 'ناشر / بورڈ'))),
        const SizedBox(height: 10),
        SegmentedButton<String>(
            segments: [
              ButtonSegment(
                  value: 'en', label: Text(tr('English book', 'انگریزی کتاب'))),
              ButtonSegment(
                  value: 'ur', label: Text(tr('Urdu book', 'اردو کتاب'))),
            ],
            selected: {_lang},
            onSelectionChanged: (s) => setState(() => _lang = s.first)),
        SectionTitle(tr('Book file (PDF)', 'کتاب کی فائل (PDF)')),
        if (_file != null)
          Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: ListTile(
                  leading: const Icon(Icons.check_circle, color: kGood),
                  title: Text(tr('PDF ready', 'PDF تیار ہے')),
                  subtitle: Text(
                      '${(_file!.size / 1048576).toStringAsFixed(1)} MB  •  ${_sourceType == 'official_download' ? tr('official download', 'سرکاری ڈاؤن لوڈ') : tr('uploaded from device', 'موبائل سے اپ لوڈ')}'),
                  trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() {
                            _file = null;
                            _sourceType = 'no_file';
                          })))),
        if (_file == null) ...[
          OutlinedButton.icon(
              onPressed: _busy ? null : _upload,
              icon: const Icon(Icons.upload_file),
              label: Text(tr('Upload PDF from this device',
                  'اس موبائل سے PDF اپ لوڈ کریں'))),
          const SizedBox(height: 12),
          Text(tr(
              'Or download from an official website (needs internet). Open the site, find the book, copy the link of its PDF and paste it below.',
              'یا سرکاری ویب سائٹ سے ڈاؤن لوڈ کریں (انٹرنیٹ درکار)۔ ویب سائٹ کھولیں، کتاب تلاش کریں، اس کی PDF کا لنک نقل کر کے نیچے چسپاں کریں۔')),
          Wrap(spacing: 8, children: [
            for (final e in kOfficialSites.entries)
              ActionChip(
                  avatar: const Icon(Icons.open_in_new, size: 16),
                  label: Text(e.key),
                  onPressed: () => launchUrl(Uri.parse(e.value),
                      mode: LaunchMode.externalApplication)),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            Expanded(
                child: TextField(
                    controller: _url,
                    keyboardType: TextInputType.url,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                        labelText:
                            tr('Official PDF link', 'سرکاری PDF لنک')))),
            const SizedBox(width: 8),
            FilledButton.tonal(
                onPressed: _busy ? null : _download,
                child: Text(_progress.isEmpty
                    ? tr('Download', 'ڈاؤن لوڈ')
                    : _progress)),
          ]),
          const SizedBox(height: 6),
          Text(
              tr('You can also save the book without a file and add chapters and questions by hand.',
                  'آپ فائل کے بغیر بھی کتاب محفوظ کر کے ابواب اور سوالات خود شامل کر سکتے ہیں۔'),
              style: Theme.of(context).textTheme.bodySmall),
        ],
        const SizedBox(height: 20),
        FilledButton.icon(
            onPressed: _busy ? null : _save,
            icon: const Icon(Icons.save),
            label: Text(tr('Save book', 'کتاب محفوظ کریں'))),
      ])),
    );
  }
}

/// Edit book details that may be filled in later.
Future<void> showBookMetaDialog(BuildContext context, Textbook b) async {
  final title = TextEditingController(text: b.title);
  final year = TextEditingController(text: b.academicYear);
  final edition = TextEditingController(text: b.edition);
  final publisher = TextEditingController(text: b.publisher);
  final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
              title: Text(tr('Book details', 'کتاب کی تفصیل')),
              content: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                for (final f in [
                  (title, tr('Book title', 'کتاب کا عنوان')),
                  (year, tr('Academic year', 'تعلیمی سال')),
                  (edition, tr('Edition', 'ایڈیشن')),
                  (publisher, tr('Publisher / board', 'ناشر / بورڈ')),
                ])
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextField(
                          controller: f.$1,
                          decoration: InputDecoration(labelText: f.$2))),
              ])),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(d, false),
                    child: Text(tr('Cancel', 'منسوخ'))),
                FilledButton(
                    onPressed: () => Navigator.pop(d, true),
                    child: Text(tr('Save', 'محفوظ کریں'))),
              ]));
  if (ok == true && title.text.trim().isNotEmpty) {
    await App.library.updateBookMeta(
        b.id,
        TextbooksCompanion(
            title: Value(title.text.trim()),
            academicYear: Value(year.text.trim()),
            edition: Value(edition.text.trim()),
            publisher: Value(publisher.text.trim())));
  }
}


/// One book in the library: subject colour, question count and the state of
/// its PDF (not downloaded / downloaded), with a one-tap download.
class BookCard extends StatelessWidget {
  final Textbook book;
  final int? questions;
  final bool updateAvailable;
  final VoidCallback onTap;
  final VoidCallback onChanged;
  const BookCard(
      {super.key,
      required this.book,
      required this.questions,
      required this.updateAvailable,
      required this.onTap,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final st = subjectStyle(book.subject);
    final hasFile = book.filePath != null;
    final canDownload = !hasFile && book.remoteFile != null;
    return Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: onTap,
            child: IntrinsicHeight(
                child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Container(width: 6, color: st.color),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                      child: Row(children: [
                        GradientIcon(st.icon, st.gradient, size: 50),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(subjectLabel(book.subject),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: st.color)),
                              Text(book.title,
                                  textDirection: dirOf(book.title),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 6),
                              Wrap(spacing: 6, runSpacing: 4, children: [
                                if (questions != null)
                                  Pill('$questions ${tr('MCQs', 'سوالات')}', st.color,
                                      icon: Icons.quiz_rounded),
                                if (hasFile)
                                  Pill(tr('On phone', 'موبائل میں'), kGood,
                                      icon: Icons.check_circle_rounded),
                                if (book.isApplicable)
                                  Pill(tr('Applicable syllabus', 'نافذ نصاب'), kBrand),
                                if (!book.isCurrent)
                                  Pill(tr('Older version', 'پرانا ورژن'), kMuted),
                                if (updateAvailable)
                                  Pill(tr('Update available', 'نیا ورژن'), kWarn),
                              ]),
                            ])),
                        if (canDownload)
                          IconButton.filledTonal(
                              tooltip: tr('Download book', 'کتاب ڈاؤن لوڈ کریں'),
                              icon: const Icon(Icons.download_rounded),
                              onPressed: () async {
                                if (await downloadBookDialog(context, book)) onChanged();
                              })
                        else if (hasFile)
                          IconButton.filledTonal(
                              tooltip: tr('Read book', 'کتاب پڑھیں'),
                              icon: const Icon(Icons.chrome_reader_mode_rounded),
                              onPressed: () => openBook(context, book.id))
                        else
                          const Icon(Icons.chevron_right),
                      ]))),
            ]))));
  }
}

String bookSizeLabel(Textbook b) => fmtMb(b.remoteBytes ?? b.fileSize);
