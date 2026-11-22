import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../core/core.dart';
import '../data/db/database.dart';
import '../data/repos/library_repo.dart';
import '../services/app.dart';
import 'common.dart';
import 'library_screen.dart';
import 'questions_screen.dart';
import 'reader_screen.dart';
import 'theme.dart';
import '../services/content_service.dart';

class BookScreen extends StatefulWidget {
  final String bookId;
  const BookScreen({super.key, required this.bookId});
  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  Textbook? _book;
  List<ChapterWithTopics> _chapters = [];
  Map<String, int> _counts = {};
  List<Textbook> _versions = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final b = await App.library.book(widget.bookId);
    if (b == null) return;
    final ch = await App.library.chaptersWithTopics(b.id);
    final counts = await App.library.countsByChapter(b.id);
    final vs = await App.library.versions(b.seriesId);
    if (mounted) {
      setState(() {
        _book = b;
        _chapters = ch;
        _counts = counts;
        _versions = vs;
      });
    }
  }

  Future<void> _importPack() async {
    final r = await FilePicker.pickFiles(
        type: FileType.custom, allowedExtensions: ['json']);
    final path = r.isEmpty ? null : r.first.path;
    if (path == null) return;
    try {
      final rep =
          await App.library.importPack(_book!, await File(path).readAsString());
      await _load();
      if (!mounted) return;
      await showDialog(
          context: context,
          builder: (d) => AlertDialog(
                  title: Text(tr('Import finished', 'امپورٹ مکمل')),
                  content: SingleChildScrollView(
                      child: Text([
                    tr('${rep.questions} question(s) added, ${rep.chapters} new chapter(s), ${rep.topics} new topic(s).',
                        '${rep.questions} سوالات، ${rep.chapters} نئے ابواب، ${rep.topics} نئے موضوعات شامل ہوئے۔'),
                    if (rep.skipped.isNotEmpty)
                      '\n${tr('Skipped', 'چھوڑے گئے')} (${rep.skipped.length}):\n${rep.skipped.join('\n')}',
                  ].join())),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(d),
                        child: const Text('OK'))
                  ]));
    } catch (e) {
      if (mounted) {
        snack(context,
            '${tr('This file is not a valid question pack.', 'یہ فائل درست سوالات کا پیک نہیں۔')} ($e)');
      }
    }
  }

  Future<void> _chapterDialog({Chapter? c}) async {
    final num = TextEditingController(
        text: '${c?.number ?? (_chapters.isEmpty ? 1 : _chapters.last.chapter.number + 1)}');
    final title = TextEditingController(text: c?.title ?? '');
    final from = TextEditingController(text: c?.pageStart?.toString() ?? '');
    final to = TextEditingController(text: c?.pageEnd?.toString() ?? '');
    final res = await _structDialog(
        c == null ? tr('Add chapter', 'باب شامل کریں') : tr('Edit chapter', 'باب میں ترمیم'),
        title, from, to,
        number: num, canDelete: c != null);
    if (res == 'save' && title.text.trim().isNotEmpty) {
      if (c == null) {
        await App.library.addChapter(_book!.id,
            number: parseInt(num.text) ?? 1,
            title: title.text,
            pageStart: parseInt(from.text),
            pageEnd: parseInt(to.text));
      } else {
        await App.library.updateChapter(c.id,
            number: parseInt(num.text) ?? c.number,
            title: title.text,
            pageStart: parseInt(from.text),
            pageEnd: parseInt(to.text));
      }
    } else if (res == 'delete') {
      await App.library.deleteChapter(c!.id);
    }
    await _load();
  }

  Future<void> _topicDialog(Chapter ch, {Topic? t}) async {
    final title = TextEditingController(text: t?.title ?? '');
    final from = TextEditingController(text: t?.pageStart?.toString() ?? '');
    final to = TextEditingController(text: t?.pageEnd?.toString() ?? '');
    final res = await _structDialog(
        t == null ? tr('Add topic', 'موضوع شامل کریں') : tr('Edit topic', 'موضوع میں ترمیم'),
        title, from, to,
        canDelete: t != null);
    if (res == 'save' && title.text.trim().isNotEmpty) {
      if (t == null) {
        await App.library.addTopic(ch.id,
            title: title.text,
            pageStart: parseInt(from.text),
            pageEnd: parseInt(to.text));
      } else {
        await App.library.updateTopic(t.id,
            title: title.text,
            pageStart: parseInt(from.text),
            pageEnd: parseInt(to.text));
      }
    } else if (res == 'delete') {
      await App.library.deleteTopic(t!.id);
    }
    await _load();
  }

  Future<String?> _structDialog(String heading, TextEditingController title,
      TextEditingController from, TextEditingController to,
      {TextEditingController? number, bool canDelete = false}) {
    return showDialog<String>(
        context: context,
        builder: (d) => AlertDialog(
                title: Text(heading),
                content: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                  if (number != null)
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextField(
                            controller: number,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: tr('Chapter number', 'باب نمبر')))),
                  TextField(
                      controller: title,
                      autofocus: true,
                      decoration:
                          InputDecoration(labelText: tr('Title', 'عنوان'))),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                        child: TextField(
                            controller: from,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: tr('From page', 'صفحہ از')))),
                    const SizedBox(width: 10),
                    Expanded(
                        child: TextField(
                            controller: to,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: tr('To page', 'صفحہ تا')))),
                  ]),
                  const SizedBox(height: 6),
                  Text(
                      tr('Page numbers are optional. Enter them only as printed in the book.',
                          'صفحہ نمبر اختیاری ہیں۔ صرف وہی لکھیں جو کتاب میں درج ہیں۔'),
                      style: Theme.of(context).textTheme.bodySmall),
                ])),
                actions: [
                  if (canDelete)
                    TextButton(
                        onPressed: () async {
                          if (await confirm(
                              d,
                              tr('Delete?', 'حذف کریں؟'),
                              tr('Its questions are removed from the question bank. Saved student results are not affected.',
                                  'اس کے سوالات سوال بینک سے ہٹ جائیں گے۔ طلبہ کے محفوظ نتائج متاثر نہیں ہوں گے۔'))) {
                            if (d.mounted) Navigator.pop(d, 'delete');
                          }
                        },
                        child: Text(tr('Delete', 'حذف'),
                            style: const TextStyle(color: kBad))),
                  TextButton(
                      onPressed: () => Navigator.pop(d),
                      child: Text(tr('Cancel', 'منسوخ'))),
                  FilledButton(
                      onPressed: () => Navigator.pop(d, 'save'),
                      child: Text(tr('Save', 'محفوظ کریں'))),
                ]));
  }

  String _sourceLabel(Textbook b) {
    switch (b.sourceType) {
      case 'official_download':
        return b.remoteFile != null
            ? tr('Official PCTB textbook (eLearn Punjab web version)',
                'سرکاری PCTB درسی کتاب (ای لرن پنجاب ویب ورژن)')
            : tr('Downloaded from official website', 'سرکاری ویب سائٹ سے ڈاؤن لوڈ');
      case 'manual_upload':
        return tr('Uploaded manually', 'خود اپ لوڈ کی گئی');
      case 'demo':
        return tr('SAMPLE - not an official textbook', 'نمونہ - سرکاری کتاب نہیں');
    }
    return tr('No file attached', 'فائل منسلک نہیں');
  }

  @override
  Widget build(BuildContext context) {
    final b = _book;
    if (b == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final total = _counts.values.fold(0, (a, c) => a + c);
    return Scaffold(
      appBar: AppBar(title: Text(b.title), actions: [
        IconButton(
            icon: const Icon(Icons.edit),
            tooltip: tr('Edit details', 'تفصیل میں ترمیم'),
            onPressed: () async {
              await showBookMetaDialog(context, b);
              _load();
            })
      ]),
      body: Body(
          child: ListView(padding: const EdgeInsets.all(12), children: [
        Card(
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${gradeLabel(b.grade)}  •  ${subjectLabel(b.subject)}',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text([
                        '${tr('Version', 'ورژن')} ${b.version}${b.isCurrent ? ' (${tr('latest', 'تازہ ترین')})' : ''}',
                        if (b.academicYear.isNotEmpty)
                          '${tr('Academic year', 'تعلیمی سال')}: ${b.academicYear}',
                        if (b.edition.isNotEmpty)
                          '${tr('Edition', 'ایڈیشن')}: ${b.edition}',
                        if (b.publisher.isNotEmpty)
                          '${tr('Publisher', 'ناشر')}: ${b.publisher}',
                        _sourceLabel(b),
                        if (b.sourceUrl.isNotEmpty) b.sourceUrl,
                        '${tr('Added', 'شامل کی گئی')}: ${fmtDate(b.importedAt)}',
                      ].join('\n')),
                      SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(tr('Officially applicable syllabus',
                              'سرکاری طور پر نافذ نصاب')),
                          subtitle: Text(tr(
                              'Turn on for the book your school must follow this academic year. Tests use this book by default, even if a newer version is in the library.',
                              'اس کتاب کے لیے آن کریں جو اس تعلیمی سال میں نافذ ہے۔ ٹیسٹ اسی کتاب سے بنیں گے، چاہے نیا ورژن موجود ہو۔')),
                          value: b.isApplicable,
                          onChanged: (v) async {
                            await App.library.setApplicable(b, v);
                            _load();
                          }),
                      Wrap(spacing: 8, runSpacing: 4, children: [
                        if (b.filePath != null)
                          FilledButton.icon(
                              onPressed: () => openBook(context, b.id),
                              icon: const Icon(Icons.chrome_reader_mode_rounded),
                              label: Text(tr('Read book', 'کتاب پڑھیں')))
                        else if (b.remoteFile != null)
                          FilledButton.icon(
                              onPressed: () async {
                                if (await downloadBookDialog(context, b)) _load();
                              },
                              icon: const Icon(Icons.download_rounded),
                              label: Text(
                                  '${tr('Download book', 'کتاب ڈاؤن لوڈ کریں')} (${fmtMb(b.remoteBytes)})')),
                        if (b.filePath != null && b.remoteFile != null)
                          TextButton.icon(
                              onPressed: () async {
                                if (await confirm(
                                    context,
                                    tr('Remove the downloaded file?', 'ڈاؤن لوڈ فائل ہٹائیں؟'),
                                    tr('This frees ${fmtMb(b.fileSize)} on the phone. Chapters and MCQs stay; the book can be downloaded again.',
                                        'اس سے موبائل میں ${fmtMb(b.fileSize)} جگہ خالی ہوگی۔ ابواب اور سوالات برقرار رہیں گے۔'))) {
                                  await App.content.removeBookFile(b);
                                  _load();
                                }
                              },
                              icon: const Icon(Icons.delete_outline),
                              label: Text(tr('Free space', 'جگہ خالی کریں'))),
                        OutlinedButton.icon(
                            onPressed: () async {
                              final nb = await Navigator.push<Textbook>(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AddBookScreen(
                                          grade: b.grade, previous: b)));
                              if (nb != null && context.mounted) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            BookScreen(bookId: nb.id)));
                              }
                            },
                            icon: const Icon(Icons.update),
                            label: Text(tr('Add new version', 'نیا ورژن'))),
                      ]),
                    ]))),
        if (_versions.length > 1) ...[
          SectionTitle(tr('Version history', 'ورژن کی تاریخ')),
          for (final v in _versions)
            ListTile(
                dense: true,
                leading: Icon(v.id == b.id ? Icons.radio_button_checked : Icons.history),
                title: Text('v${v.version}  •  ${v.title}'),
                subtitle: Text([
                  fmtDate(v.importedAt),
                  if (v.academicYear.isNotEmpty) v.academicYear,
                  if (v.isApplicable) tr('Applicable syllabus', 'نافذ نصاب'),
                ].join('  •  ')),
                onTap: v.id == b.id
                    ? null
                    : () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BookScreen(bookId: v.id)))),
        ],
        SectionTitle(
            '${tr('Question bank', 'سوال بینک')}: $total ${tr('questions', 'سوالات')}'),
        Wrap(spacing: 8, runSpacing: 4, children: [
          FilledButton.icon(
              onPressed: _chapters.isEmpty
                  ? null
                  : () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => QuestionsScreen(book: b)));
                      _load();
                    },
              icon: const Icon(Icons.list_alt),
              label: Text(tr('View / add questions', 'سوالات دیکھیں / شامل کریں'))),
          OutlinedButton.icon(
              onPressed: _importPack,
              icon: const Icon(Icons.file_open),
              label: Text(tr('Import question pack', 'سوالات کا پیک امپورٹ'))),
        ]),
        SectionTitle(tr('Chapters and topics', 'ابواب اور موضوعات')),
        if (_chapters.isEmpty)
          Text(tr(
              'No chapters yet. Add the chapters exactly as listed in the book\'s table of contents.',
              'ابھی کوئی باب نہیں۔ کتاب کی فہرست کے مطابق ابواب شامل کریں۔')),
        for (final c in _chapters)
          Card(
              child: ExpansionTile(
                  leading: CircleAvatar(
                      backgroundColor: subjectStyle(b.subject).color,
                      foregroundColor: Colors.white,
                      child: Text('${c.chapter.number}',
                          style: const TextStyle(fontWeight: FontWeight.w800))),
                  title: Text(c.chapter.title,
                      textDirection: dirOf(c.chapter.title),
                      style: Theme.of(context).textTheme.titleSmall),
                  subtitle: Text([
                    if (c.chapter.pageStart != null)
                      '${tr('pp.', 'صفحات')} ${c.chapter.pageStart}${c.chapter.pageEnd == null ? '' : '-${c.chapter.pageEnd}'}',
                    '${c.topics.length} ${tr('topics', 'موضوعات')}',
                    '${_counts[c.chapter.id] ?? 0} ${tr('questions', 'سوالات')}',
                  ].join('  •  ')),
                  children: [
                    for (final t in c.topics)
                      ListTile(
                          dense: true,
                          leading: const Icon(Icons.label_outline),
                          title: Text(t.title, textDirection: dirOf(t.title)),
                          subtitle: t.pageStart == null
                              ? null
                              : Text(
                                  '${tr('pp.', 'صفحات')} ${t.pageStart}${t.pageEnd == null ? '' : '-${t.pageEnd}'}'),
                          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                            if (t.pageStart != null &&
                                (b.filePath != null || b.remoteFile != null))
                              IconButton(
                                  tooltip: tr('Open at this page', 'اس صفحے پر کھولیں'),
                                  icon: const Icon(Icons.menu_book_rounded, color: kBrand),
                                  onPressed: () => openBook(context, b.id,
                                      page: t.pageStart!, heading: t.title)),
                            IconButton(
                                tooltip: tr('Edit', 'ترمیم'),
                                icon: const Icon(Icons.edit, size: 18),
                                onPressed: () => _topicDialog(c.chapter, t: t)),
                          ]),
                          onTap: t.pageStart != null &&
                                  (b.filePath != null || b.remoteFile != null)
                              ? () => openBook(context, b.id,
                                  page: t.pageStart!, heading: t.title)
                              : () => _topicDialog(c.chapter, t: t)),
                    OverflowBar(children: [
                      if (c.chapter.pageStart != null &&
                          (b.filePath != null || b.remoteFile != null))
                        TextButton.icon(
                            onPressed: () => openBook(context, b.id,
                                page: c.chapter.pageStart!, heading: c.chapter.title),
                            icon: const Icon(Icons.menu_book_rounded),
                            label: Text(tr('Read chapter', 'باب پڑھیں'))),
                      TextButton.icon(
                          onPressed: () => _topicDialog(c.chapter),
                          icon: const Icon(Icons.add),
                          label: Text(tr('Add topic', 'موضوع شامل کریں'))),
                      TextButton.icon(
                          onPressed: () => _chapterDialog(c: c.chapter),
                          icon: const Icon(Icons.edit),
                          label: Text(tr('Edit chapter', 'باب میں ترمیم'))),
                    ]),
                  ])),
        const SizedBox(height: 8),
        OutlinedButton.icon(
            onPressed: () => _chapterDialog(),
            icon: const Icon(Icons.add),
            label: Text(tr('Add chapter', 'باب شامل کریں'))),
        const SizedBox(height: 40),
      ])),
    );
  }
}
