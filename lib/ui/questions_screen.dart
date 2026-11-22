import 'package:flutter/material.dart';

import '../core/core.dart';
import '../data/db/database.dart';
import '../data/repos/library_repo.dart';
import '../services/app.dart';
import 'common.dart';

/// Question bank of one book, filtered by chapter and type.
class QuestionsScreen extends StatefulWidget {
  final Textbook book;
  const QuestionsScreen({super.key, required this.book});
  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  List<ChapterWithTopics> _chapters = [];
  String? _chapterId;
  String _type = 'mcq';
  List<Question> _qs = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _chapters = await App.library.chaptersWithTopics(widget.book.id);
    _chapterId = _chapters.isEmpty ? null : _chapters.first.chapter.id;
    await _load();
  }

  Future<void> _load() async {
    final qs = _chapterId == null
        ? <Question>[]
        : await App.library
            .questions(widget.book.id, chapterId: _chapterId, type: _type);
    if (mounted) setState(() => _qs = qs);
  }

  ChapterWithTopics? get _chapter =>
      _chapters.where((c) => c.chapter.id == _chapterId).firstOrNull;

  Future<void> _edit([Question? q]) async {
    final ch = _chapter;
    if (ch == null) return;
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => QuestionEditor(
                book: widget.book, chapter: ch, type: q?.type ?? _type, existing: q)));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('Question bank', 'سوال بینک'))),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _edit(),
          icon: const Icon(Icons.add),
          label: Text(tr('Add question', 'سوال شامل کریں'))),
      body: Body(
          child: Column(children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: DropdownButtonFormField<String>(
                key: ValueKey(_chapterId),
                initialValue: _chapterId,
                isExpanded: true,
                decoration: InputDecoration(labelText: tr('Chapter', 'باب')),
                items: [
                  for (final c in _chapters)
                    DropdownMenuItem(
                        value: c.chapter.id,
                        child: Text('${c.chapter.number}. ${c.chapter.title}',
                            overflow: TextOverflow.ellipsis))
                ],
                onChanged: (v) {
                  _chapterId = v;
                  _load();
                })),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(spacing: 6, children: [
              for (final t in kQuestionTypes)
                ChoiceChip(
                    label: Text(typeLabel(t)),
                    selected: _type == t,
                    onSelected: (_) {
                      _type = t;
                      _load();
                    })
            ])),
        Expanded(
            child: _qs.isEmpty
                ? EmptyHint(
                    icon: Icons.help_outline,
                    text: tr('No questions of this type in this chapter yet.',
                        'اس باب میں اس قسم کے سوالات ابھی نہیں ہیں۔'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 88),
                    itemCount: _qs.length,
                    itemBuilder: (_, i) {
                      final q = _qs[i];
                      final topic = _chapter?.topics
                          .where((t) => t.id == q.topicId)
                          .firstOrNull;
                      return Card(
                          child: ListTile(
                              title: ContentText(q.body),
                              subtitle: Text([
                                if (topic != null) topic.title,
                                difficultyLabel(q.difficulty),
                                if (q.pageRef != null)
                                  '${tr('p.', 'ص')} ${q.pageRef}',
                                if (!q.verified)
                                  tr('not verified', 'غیر تصدیق شدہ'),
                              ].join('  •  ')),
                              trailing: const Icon(Icons.edit, size: 18),
                              onTap: () => _edit(q)));
                    })),
      ])),
    );
  }
}

class QuestionEditor extends StatefulWidget {
  final Textbook book;
  final ChapterWithTopics chapter;
  final String type;
  final Question? existing;
  const QuestionEditor(
      {super.key,
      required this.book,
      required this.chapter,
      required this.type,
      this.existing});
  @override
  State<QuestionEditor> createState() => _QuestionEditorState();
}

class _QuestionEditorState extends State<QuestionEditor> {
  late final Question? q = widget.existing;
  late final _body = TextEditingController(text: q?.body ?? '');
  late final List<TextEditingController> _opts;
  late int? _correct = q?.correctIndex;
  late final _answer = TextEditingController(text: q?.answer ?? '');
  late final _short = TextEditingController(text: q?.shortExplanation ?? '');
  late final _concept = TextEditingController(text: q?.conceptExplanation ?? '');
  late final _page = TextEditingController(text: q?.pageRef?.toString() ?? '');
  late String? _topicId = q?.topicId;
  late int _difficulty = q?.difficulty ?? 2;
  late bool _verified = q?.verified ?? true;

  String get type => widget.type;

  @override
  void initState() {
    super.initState();
    final old = q == null ? const <String>[] : optionsOf(q!);
    _opts = List.generate(
        4, (i) => TextEditingController(text: i < old.length ? old[i] : ''));
  }

  Future<void> _save() async {
    String? err;
    final opts = _opts.map((e) => e.text.trim()).toList();
    if (_body.text.trim().isEmpty) {
      err = tr('Write the question.', 'سوال لکھیں۔');
    } else if (type == 'mcq') {
      if (opts.any((o) => o.isEmpty)) {
        err = tr('Fill in all four options.', 'چاروں آپشن لکھیں۔');
      } else if (opts.map((e) => e.toLowerCase()).toSet().length != 4) {
        err = tr('Two options are the same.', 'دو آپشن ایک جیسے ہیں۔');
      } else if (_correct == null) {
        err = tr('Mark the correct option.', 'درست آپشن منتخب کریں۔');
      }
    } else if (type == 'tf' && _correct == null) {
      err = tr('Choose True or False.', 'درست یا غلط منتخب کریں۔');
    } else if (type == 'fill' && _answer.text.trim().isEmpty) {
      err = tr('Write the answer.', 'جواب لکھیں۔');
    }
    if (err != null) return snack(context, err);
    await App.library.saveQuestion(
        id: q?.id,
        book: widget.book,
        chapterId: widget.chapter.chapter.id,
        topicId: _topicId,
        type: type,
        body: _body.text,
        options: type == 'mcq'
            ? opts
            : type == 'tf'
                ? const ['True', 'False']
                : const [],
        correctIndex: (type == 'mcq' || type == 'tf') ? _correct : null,
        answer: _answer.text,
        shortExplanation: _short.text,
        conceptExplanation: _concept.text,
        pageRef: parseInt(_page.text),
        difficulty: _difficulty,
        source: q?.source ?? 'manual',
        verified: _verified);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 10);
    return Scaffold(
      appBar: AppBar(title: Text(typeLabel(type)), actions: [
        if (q != null)
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                if (await confirm(
                    context,
                    tr('Delete question?', 'سوال حذف کریں؟'),
                    tr('Saved student results are not affected.',
                        'طلبہ کے محفوظ نتائج متاثر نہیں ہوں گے۔'))) {
                  await App.library.deleteQuestion(q!.id);
                  if (context.mounted) Navigator.pop(context);
                }
              })
      ]),
      body: Body(
          child: ListView(padding: const EdgeInsets.all(16), children: [
        Text('${widget.chapter.chapter.number}. ${widget.chapter.chapter.title}',
            style: Theme.of(context).textTheme.titleSmall),
        gap,
        if (widget.chapter.topics.isNotEmpty) ...[
          DropdownButtonFormField<String?>(
              initialValue: _topicId,
              isExpanded: true,
              decoration: InputDecoration(labelText: tr('Topic', 'موضوع')),
              items: [
                DropdownMenuItem(
                    value: null,
                    child: Text(tr('Whole chapter (no topic)',
                        'پورا باب (کوئی موضوع نہیں)'))),
                for (final t in widget.chapter.topics)
                  DropdownMenuItem(
                      value: t.id,
                      child: Text(t.title, overflow: TextOverflow.ellipsis))
              ],
              onChanged: (v) => setState(() => _topicId = v)),
          gap,
        ],
        TextField(
            controller: _body,
            minLines: 2,
            maxLines: 6,
            decoration: InputDecoration(
                labelText: tr('Question', 'سوال'),
                hintText: type == 'fill' ? 'The capital of Punjab is ____.' : null)),
        gap,
        if (type == 'mcq') ...[
          Text(tr('Options (tick the correct one)', 'آپشن (درست پر نشان لگائیں)')),
          RadioGroup<int>(
              groupValue: _correct,
              onChanged: (v) => setState(() => _correct = v),
              child: Column(children: [
                for (var i = 0; i < 4; i++)
                  Row(children: [
                    Radio<int>(value: i),
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: TextField(
                                controller: _opts[i],
                                decoration: InputDecoration(
                                    labelText:
                                        '${tr('Option', 'آپشن')} ${String.fromCharCode(65 + i)}')))),
                  ])
              ])),
        ],
        if (type == 'tf')
          SegmentedButton<int>(
              emptySelectionAllowed: true,
              segments: [
                ButtonSegment(value: 0, label: Text(tr('True', 'درست'))),
                ButtonSegment(value: 1, label: Text(tr('False', 'غلط'))),
              ],
              selected: {if (_correct != null) _correct!},
              onSelectionChanged: (s) =>
                  setState(() => _correct = s.isEmpty ? null : s.first)),
        if (type != 'mcq' && type != 'tf')
          TextField(
              controller: _answer,
              minLines: type == 'fill' ? 1 : 3,
              maxLines: 10,
              decoration: InputDecoration(
                  labelText: type == 'fill'
                      ? tr('Correct answer', 'درست جواب')
                      : tr('Model answer / marking points',
                          'مثالی جواب / نمبروں کی تقسیم'))),
        gap,
        TextField(
            controller: _short,
            minLines: 1,
            maxLines: 4,
            decoration: InputDecoration(
                labelText: tr('Short explanation', 'مختصر وضاحت'))),
        gap,
        TextField(
            controller: _concept,
            minLines: 2,
            maxLines: 8,
            decoration: InputDecoration(
                labelText: tr('Concept explanation (simple words)',
                    'تصور کی آسان وضاحت'))),
        gap,
        Row(children: [
          Expanded(
              child: DropdownButtonFormField<int>(
                  initialValue: _difficulty,
                  decoration:
                      InputDecoration(labelText: tr('Difficulty', 'مشکل کی سطح')),
                  items: [
                    for (final d in [1, 2, 3])
                      DropdownMenuItem(value: d, child: Text(difficultyLabel(d)))
                  ],
                  onChanged: (v) => setState(() => _difficulty = v!))),
          const SizedBox(width: 10),
          Expanded(
              child: TextField(
                  controller: _page,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: tr('Textbook page', 'کتاب کا صفحہ'),
                      helperText: tr('only if checked', 'صرف تصدیق شدہ')))),
        ]),
        CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _verified,
            onChanged: (v) => setState(() => _verified = v!),
            title: Text(tr('I have checked this question and answer against the textbook',
                'میں نے یہ سوال اور جواب کتاب سے ملا کر دیکھ لیا ہے'))),
        gap,
        FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: Text(tr('Save question', 'سوال محفوظ کریں'))),
      ])),
    );
  }
}
