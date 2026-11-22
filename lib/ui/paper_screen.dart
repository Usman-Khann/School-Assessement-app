import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../core/core.dart';
import '../data/db/database.dart';
import '../data/repos/library_repo.dart';
import '../services/app.dart';
import '../services/paper_generator.dart';
import '../services/pdf_builder.dart';
import 'common.dart';

class PaperListScreen extends StatelessWidget {
  const PaperListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('Exam Papers', 'امتحانی پرچے'))),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const PaperSetupScreen())),
          icon: const Icon(Icons.add),
          label: Text(tr('New paper', 'نیا پرچہ'))),
      body: Body(
          child: StreamBuilder<List<Paper>>(
              stream: App.watchPapers(),
              builder: (_, snap) {
                final list = snap.data ?? const <Paper>[];
                if (snap.hasData && list.isEmpty) {
                  return EmptyHint(
                      icon: Icons.description,
                      text: tr('No saved papers yet. Tap "New paper".',
                          'ابھی کوئی پرچہ محفوظ نہیں۔ "نیا پرچہ" دبائیں۔'));
                }
                return ListView(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
                    children: [
                      for (final p in list)
                        Card(
                            child: ListTile(
                                leading: const Icon(Icons.description),
                                title: Text(p.title, textDirection: dirOf(p.title)),
                                subtitle: Text(
                                    '${gradeLabel(p.grade)}  •  ${subjectLabel(p.subject)}  •  ${fmtDate(p.createdAt)}'),
                                trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () async {
                                      if (await confirm(
                                          context,
                                          tr('Delete paper?', 'پرچہ حذف کریں؟'),
                                          p.title)) {
                                        App.deletePaper(p.id);
                                      }
                                    }),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => PaperPreviewScreen(
                                            paper: GeneratedPaper.fromStored(
                                                p.configJson, p.contentJson),
                                            saved: true)))))
                    ]);
              })),
    );
  }
}

class PaperSetupScreen extends StatefulWidget {
  const PaperSetupScreen({super.key});
  @override
  State<PaperSetupScreen> createState() => _PaperSetupScreenState();
}

class _PaperSetupScreenState extends State<PaperSetupScreen> {
  int? _grade;
  List<String> _subjects = [];
  String? _subject;
  Textbook? _book;
  List<ChapterWithTopics> _chapters = [];
  Map<String, int> _counts = {};
  final _sel = ContentSelection();
  final _title = TextEditingController(text: 'Examination Paper');
  final _duration = TextEditingController(text: '60');
  final _count = {
    for (final t in kPaperOrder)
      t: TextEditingController(text: t == 'mcq' ? '10' : '0')
  };
  final _marks = {
    for (final t in kPaperOrder)
      t: TextEditingController(
          text: t == 'long' ? '5' : (t == 'short' ? '2' : '1'))
  };
  int _difficulty = 0;
  String _lang = 'en';

  Future<void> _setGrade(int g) async {
    final subs = await App.library.subjectsWithBooks(g);
    setState(() {
      _grade = g;
      _subjects = subs;
      _subject = null;
      _book = null;
      _chapters = [];
    });
  }

  Future<void> _setSubject(String s) async {
    final b = await App.library.bestBook(_grade!, s);
    final ch = b == null
        ? <ChapterWithTopics>[]
        : await App.library.chaptersWithTopics(b.id);
    final counts =
        b == null ? <String, int>{} : await App.library.countsByChapter(b.id);
    setState(() {
      _subject = s;
      _book = b;
      _chapters = ch;
      _counts = counts;
      _sel.chapterIds.clear();
      _sel.topicIds.clear();
      if (b != null) _lang = b.language;
    });
  }

  int get _totalMarks => kPaperOrder.fold(
      0,
      (s, t) =>
          s + (parseInt(_count[t]!.text) ?? 0) * (parseInt(_marks[t]!.text) ?? 0));

  Future<void> _generate() async {
    final b = _book;
    if (b == null) {
      return snack(
          context, tr('Choose a class and subject with a textbook.', 'کتاب والا مضمون منتخب کریں۔'));
    }
    if (_sel.isEmpty) {
      return snack(context,
          tr('Tick the chapters or topics to include.', 'ابواب یا موضوعات منتخب کریں۔'));
    }
    final school = await App.school();
    final cfg = PaperConfig(
        title: _title.text.trim().isEmpty ? 'Examination Paper' : _title.text.trim(),
        schoolName: school.name,
        grade: b.grade,
        subject: b.subject,
        bookId: b.id,
        chapterIds: {..._sel.chapterIds},
        topicIds: {..._sel.topicIds},
        counts: {for (final t in kPaperOrder) t: parseInt(_count[t]!.text) ?? 0},
        marksEach: {for (final t in kPaperOrder) t: parseInt(_marks[t]!.text) ?? 1},
        difficulty: _difficulty,
        durationMin: parseInt(_duration.text) ?? 60,
        language: _lang);
    final paper = await App.papers.generate(cfg);
    if (!mounted) return;
    if (paper.totalQuestions == 0) {
      return snack(
          context,
          tr('The question bank has no matching questions in the selected chapters.',
              'منتخب ابواب میں مطلوبہ سوالات سوال بینک میں موجود نہیں۔'));
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => PaperPreviewScreen(paper: paper)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('New exam paper', 'نیا امتحانی پرچہ'))),
      bottomNavigationBar: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(12),
              child: FilledButton.icon(
                  onPressed: _generate,
                  icon: const Icon(Icons.auto_awesome),
                  label: Text(tr('Generate paper ($_totalMarks marks)',
                      'پرچہ بنائیں ($_totalMarks نمبر)'))))),
      body: Body(
          child: ListView(padding: const EdgeInsets.all(12), children: [
        SectionTitle(tr('Class', 'جماعت')),
        GradeChips(value: _grade, onChanged: (g) => _setGrade(g!)),
        if (_grade != null) ...[
          SectionTitle(tr('Subject', 'مضمون')),
          Wrap(spacing: 6, children: [
            for (final s in _subjects)
              ChoiceChip(
                  label: Text(subjectLabel(s)),
                  selected: _subject == s,
                  onSelected: (_) => _setSubject(s))
          ]),
        ],
        if (_subject != null && _book == null)
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                  tr('No textbook added for this subject yet.',
                      'اس مضمون کی کتاب ابھی شامل نہیں۔'),
                  style: const TextStyle(color: kBad))),
        if (_book != null) ...[
          SectionTitle(
              '${tr('Chapters and topics', 'ابواب اور موضوعات')}  •  ${_book!.title}'),
          Card(
              child: ContentPicker(
                  chapters: _chapters,
                  selection: _sel,
                  counts: _counts,
                  onChanged: () => setState(() {}))),
          SectionTitle(tr('Questions and marks', 'سوالات اور نمبر')),
          for (final t in kPaperOrder)
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(children: [
                  Expanded(flex: 3, child: Text(typeLabel(t))),
                  Expanded(
                      flex: 2,
                      child: TextField(
                          controller: _count[t],
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                              labelText: tr('How many', 'تعداد')))),
                  const SizedBox(width: 8),
                  Expanded(
                      flex: 2,
                      child: TextField(
                          controller: _marks[t],
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                              labelText: tr('Marks each', 'فی سوال نمبر')))),
                ])),
          Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('${tr('Total marks', 'کل نمبر')}: $_totalMarks',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          SectionTitle(tr('Paper details', 'پرچے کی تفصیل')),
          TextField(
              controller: _title,
              decoration:
                  InputDecoration(labelText: tr('Paper title', 'پرچے کا عنوان'))),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
                child: TextField(
                    controller: _duration,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: tr('Time (minutes)', 'وقت (منٹ)')))),
            const SizedBox(width: 10),
            Expanded(
                child: DropdownButtonFormField<int>(
                    initialValue: _difficulty,
                    decoration: InputDecoration(
                        labelText: tr('Difficulty', 'مشکل کی سطح')),
                    items: [
                      DropdownMenuItem(
                          value: 0, child: Text(tr('Mixed', 'ملی جلی'))),
                      for (final d in [1, 2, 3])
                        DropdownMenuItem(
                            value: d, child: Text(difficultyLabel(d)))
                    ],
                    onChanged: (v) => setState(() => _difficulty = v!))),
          ]),
          const SizedBox(height: 10),
          SegmentedButton<String>(
              segments: [
                ButtonSegment(
                    value: 'en',
                    label: Text(tr('English headings', 'انگریزی عنوانات'))),
                ButtonSegment(
                    value: 'ur',
                    label: Text(tr('Urdu headings', 'اردو عنوانات'))),
              ],
              selected: {_lang},
              onSelectionChanged: (s) => setState(() => _lang = s.first)),
        ],
        const SizedBox(height: 24),
      ])),
    );
  }
}

class PaperPreviewScreen extends StatefulWidget {
  final GeneratedPaper paper;
  final bool saved;
  const PaperPreviewScreen({super.key, required this.paper, this.saved = false});
  @override
  State<PaperPreviewScreen> createState() => _PaperPreviewScreenState();
}

class _PaperPreviewScreenState extends State<PaperPreviewScreen> {
  late bool _saved = widget.saved;
  bool _busy = false;

  GeneratedPaper get p => widget.paper;

  Future<void> _pdf({required bool key, required bool print}) async {
    setState(() => _busy = true);
    try {
      final bytes =
          key ? await PdfBuilder.answerKey(p) : await PdfBuilder.paper(p);
      final name =
          '${p.config.title.replaceAll(RegExp(r'[^\w]+'), '_')}${key ? '_answer_key' : ''}.pdf';
      if (print) {
        await Printing.layoutPdf(onLayout: (_) async => bytes, name: name);
      } else {
        await Printing.sharePdf(bytes: bytes, filename: name);
      }
    } catch (e) {
      if (mounted) snack(context, '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = p.config;
    return Scaffold(
      appBar: AppBar(title: Text(c.title), actions: [
        if (!_saved)
          TextButton.icon(
              onPressed: () async {
                await App.savePaper(p);
                setState(() => _saved = true);
                if (context.mounted) snack(context, tr('Paper saved', 'پرچہ محفوظ ہو گیا'));
              },
              icon: const Icon(Icons.save),
              label: Text(tr('Save', 'محفوظ کریں')))
      ]),
      body: Body(
          child: ListView(padding: const EdgeInsets.all(12), children: [
        if (p.shortfalls.isNotEmpty)
          Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: ListTile(
                  leading: const Icon(Icons.warning_amber),
                  title: Text(tr('Not enough questions in the selected chapters',
                      'منتخب ابواب میں سوالات کم ہیں')),
                  subtitle: Text([
                    for (final e in p.shortfalls.entries)
                      '${typeLabel(e.key)}: ${e.value} ${tr('missing', 'کم')}',
                    tr('Nothing was taken from chapters you did not select. Add questions to the bank or reduce the numbers.',
                        'غیر منتخب ابواب سے کچھ نہیں لیا گیا۔ سوال بینک میں سوالات شامل کریں یا تعداد کم کریں۔'),
                  ].join('\n')))),
        Card(
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${gradeLabel(c.grade)}  •  ${subjectLabel(c.subject)}',
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(
                          '${tr('Total marks', 'کل نمبر')}: ${p.totalMarks}   •   ${tr('Time', 'وقت')}: ${c.durationMin} ${tr('min', 'منٹ')}   •   ${p.totalQuestions} ${tr('questions', 'سوالات')}'),
                      const SizedBox(height: 10),
                      if (_busy) const LinearProgressIndicator(),
                      Wrap(spacing: 8, runSpacing: 6, children: [
                        FilledButton.icon(
                            onPressed: _busy
                                ? null
                                : () => _pdf(key: false, print: true),
                            icon: const Icon(Icons.print),
                            label: Text(tr('Print paper', 'پرچہ پرنٹ کریں'))),
                        FilledButton.tonalIcon(
                            onPressed: _busy
                                ? null
                                : () => _pdf(key: false, print: false),
                            icon: const Icon(Icons.share),
                            label: Text(tr('Share paper PDF', 'پرچہ PDF شیئر کریں'))),
                        OutlinedButton.icon(
                            onPressed: _busy
                                ? null
                                : () => _pdf(key: true, print: true),
                            icon: const Icon(Icons.key),
                            label: Text(tr('Print answer key', 'جوابات پرنٹ کریں'))),
                        OutlinedButton.icon(
                            onPressed: _busy
                                ? null
                                : () => _pdf(key: true, print: false),
                            icon: const Icon(Icons.share),
                            label: Text(tr('Share answer key', 'جوابات شیئر کریں'))),
                      ]),
                    ]))),
        for (final type in kPaperOrder)
          if (p.sections[type] != null) ...[
            SectionTitle(
                '${typeLabel(type)}  (${p.sections[type]!.length} × ${p.sections[type]!.first.marks})'),
            for (var i = 0; i < p.sections[type]!.length; i++)
              _question(i + 1, p.sections[type]![i]),
          ],
        const SizedBox(height: 24),
      ])),
    );
  }

  Widget _question(int n, PaperQuestion q) => Card(
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ContentText('$n. ${q.text}'),
            for (var i = 0; i < (q.type == 'mcq' ? q.options.length : 0); i++)
              ContentText('   (${String.fromCharCode(65 + i)}) ${q.options[i]}'),
            const SizedBox(height: 4),
            ContentText('${tr('Answer', 'جواب')}: ${q.keyAnswer.isEmpty ? '—' : q.keyAnswer}',
                style: const TextStyle(color: kGood, fontSize: 13)),
          ])));
}
