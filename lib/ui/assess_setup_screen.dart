import 'package:flutter/material.dart';

import '../core/core.dart';
import '../data/db/database.dart';
import '../data/repos/library_repo.dart';
import '../data/repos/student_repo.dart';
import '../services/app.dart';
import '../services/assessment_engine.dart';
import 'assess_run_screen.dart';
import 'common.dart';
import 'students_screen.dart';
import 'theme.dart';

class SubjectPlan {
  final String subject;
  final Textbook? book;
  final List<ChapterWithTopics> chapters;
  final Map<String, int> counts;
  final ContentSelection selection = ContentSelection();
  bool enabled = false;
  int count = 20;
  List<ShownQuestion> questions = [];
  SubjectPlan(this.subject, this.book, this.chapters, this.counts);
}

class AssessSetupScreen extends StatefulWidget {
  final Student? student;
  const AssessSetupScreen({super.key, this.student});
  @override
  State<AssessSetupScreen> createState() => _AssessSetupScreenState();
}

class _AssessSetupScreenState extends State<AssessSetupScreen> {
  int? _grade;
  Student? _student;
  List<SubjectPlan> _plans = [];
  String _feedback = 'immediate';
  bool _practice = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _student = widget.student;
    if (_student != null) {
      _setGrade(_student!.grade);
    } else {
      App.getPref('last_grade', '').then((v) {
        final g = int.tryParse(v);
        if (g != null && mounted && _grade == null) _setGrade(g);
      });
    }
  }

  Future<void> _setGrade(int g) async {
    setState(() {
      _grade = g;
      _loading = true;
      if (_student?.grade != g) _student = null;
    });
    App.setPref('last_grade', '$g');
    final plans = <SubjectPlan>[];
    for (final s in await App.library.subjectsWithBooks(g)) {
      final b = await App.library.bestBook(g, s);
      plans.add(SubjectPlan(
          s,
          b,
          b == null ? [] : await App.library.chaptersWithTopics(b.id),
          b == null ? {} : await App.library.countsByChapter(b.id, type: 'mcq')));
    }
    if (mounted && _grade == g) {
      setState(() {
        _plans = plans;
        _loading = false;
      });
    }
  }

  Future<void> _start() async {
    final student = _student;
    final chosen = _plans.where((p) => p.enabled).toList();
    if (student == null) {
      return snack(context, tr('Choose a student.', 'طالب علم منتخب کریں۔'));
    }
    if (chosen.isEmpty) {
      return snack(
          context, tr('Tick at least one subject.', 'کم از کم ایک مضمون منتخب کریں۔'));
    }
    final seen = await App.attempts.seenCounts(student.id);
    final warnings = <String>[];
    for (final p in chosen) {
      if (p.selection.isEmpty) {
        if (!mounted) return;
        return snack(
            context,
            tr('${p.subject}: tick the chapters or topics to test.',
                '${subjectLabel(p.subject)}: ابواب یا موضوعات منتخب کریں۔'));
      }
      final pool = await App.library.pool(p.book!.id, p.selection, type: 'mcq');
      if (pool.isEmpty) {
        if (!mounted) return;
        return snack(
            context,
            tr('${p.subject}: the selected chapters have no MCQs in the question bank yet.',
                '${subjectLabel(p.subject)}: منتخب ابواب کے سوالات سوال بینک میں موجود نہیں۔'));
      }
      if (pool.length < p.count) {
        warnings.add(tr(
            '${p.subject}: only ${pool.length} of ${p.count} questions are available.',
            '${subjectLabel(p.subject)}: ${p.count} میں سے صرف ${pool.length} سوالات دستیاب ہیں۔'));
      }
      final chapters = {for (final c in p.chapters) c.chapter.id: c};
      p.questions = [
        for (final q in App.engine.pick(pool, p.count, seenCounts: seen))
          App.engine.present(q,
              chapter: chapters[q.chapterId]!.chapter,
              topic: chapters[q.chapterId]!
                  .topics
                  .where((t) => t.id == q.topicId)
                  .firstOrNull)
      ];
    }
    if (!mounted) return;
    if (warnings.isNotEmpty) {
      final go = await confirm(
          context,
          tr('Fewer questions available', 'کم سوالات دستیاب ہیں'),
          '${warnings.join('\n')}\n\n${tr('Questions are never taken from chapters you did not select. Continue with the available questions?', 'غیر منتخب ابواب سے سوالات کبھی نہیں لیے جاتے۔ دستیاب سوالات کے ساتھ جاری رکھیں؟')}');
      if (!go || !mounted) return;
    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => AssessRunScreen(
                student: student,
                plans: chosen,
                feedbackMode: _feedback,
                practice: _practice)));
  }

  @override
  Widget build(BuildContext context) {
    final total =
        _plans.where((p) => p.enabled).fold<int>(0, (s, p) => s + p.count);
    return Scaffold(
      appBar: AppBar(title: Text(tr('New assessment', 'نیا جائزہ'))),
      bottomNavigationBar: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(12),
              child: FilledButton.icon(
                  onPressed: _start,
                  icon: const Icon(Icons.play_arrow),
                  label: Text(total == 0
                      ? tr('Start', 'شروع کریں')
                      : tr('Start ($total MCQs)', 'شروع کریں ($total سوالات)'))))),
      body: Body(
          child: ListView(padding: const EdgeInsets.all(12), children: [
        SectionTitle('1. ${tr('Class', 'جماعت')}'),
        GradeChips(value: _grade, onChanged: (g) => _setGrade(g!)),
        if (_grade != null) ...[
          SectionTitle('2. ${tr('Student', 'طالب علم')}'),
          Card(
              child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(_student == null
                      ? tr('Tap to choose or add a student',
                          'طالب علم منتخب یا شامل کرنے کے لیے دبائیں')
                      : studentDisplayName(_student!)),
                  subtitle: _student == null ? null : Text(_student!.code),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final s = await Navigator.push<Student>(
                        context,
                        MaterialPageRoute(
                            builder: (_) => StudentsScreen(
                                pickMode: true, initialGrade: _grade)));
                    if (s != null) setState(() => _student = s);
                  })),
          SectionTitle('3. ${tr('Subjects, chapters and topics', 'مضامین، ابواب اور موضوعات')}'),
          if (_loading) const LinearProgressIndicator(),
          for (final p in _plans) _planCard(p),
          SectionTitle('4. ${tr('Explanations', 'وضاحتیں')}'),
          SegmentedButton<String>(
              segments: [
                ButtonSegment(
                    value: 'immediate',
                    label: Text(tr('After every question', 'ہر سوال کے بعد'))),
                ButtonSegment(
                    value: 'end',
                    label: Text(tr('At the end', 'آخر میں'))),
              ],
              selected: {_feedback},
              onSelectionChanged: (s) => setState(() => _feedback = s.first)),
          SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(tr('Practice mode', 'مشق موڈ')),
              subtitle: Text(tr(
                  'Saved in history and marked as practice.',
                  'ریکارڈ میں محفوظ ہوگا اور مشق کے طور پر نشان زد ہوگا۔')),
              value: _practice,
              onChanged: (v) => setState(() => _practice = v)),
        ],
        const SizedBox(height: 24),
      ])),
    );
  }

  Widget _planCard(SubjectPlan p) {
    final book = p.book;
    if (book == null) {
      return Card(
          child: ListTile(
              enabled: false,
              leading: const Icon(Icons.block),
              title: Text(subjectLabel(p.subject)),
              subtitle: Text(tr('No textbook added for this subject yet (Textbooks > Add book).',
                  'اس مضمون کی کتاب ابھی شامل نہیں (درسی کتب > کتاب شامل کریں)۔'))));
    }
    return Card(
        child: Column(children: [
      CheckboxListTile(
          value: p.enabled,
          activeColor: subjectStyle(p.subject).color,
          onChanged: (v) => setState(() => p.enabled = v!),
          secondary: GradientIcon(subjectStyle(p.subject).icon,
              subjectStyle(p.subject).gradient, size: 44),
          title: Text(subjectLabel(p.subject),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: subjectStyle(p.subject).color)),
          subtitle: Text(
              '${book.title}${book.isApplicable ? '  •  ${tr('Applicable syllabus', 'نافذ نصاب')}' : ''}',
              textDirection: dirOf(book.title))),
      if (p.enabled) ...[
        const Divider(height: 1),
        ContentPicker(
            chapters: p.chapters,
            selection: p.selection,
            counts: p.counts,
            onChanged: () => setState(() {})),
        Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: Row(children: [
              Text('${tr('MCQs', 'سوالات')}: '),
              Expanded(
                  child: Wrap(spacing: 6, children: [
                for (final n in [5, 10, 15, 20, 30])
                  ChoiceChip(
                      label: Text('$n'),
                      selected: p.count == n,
                      onSelected: (_) => setState(() => p.count = n)),
                ActionChip(
                    label: Text([5, 10, 15, 20, 30].contains(p.count)
                        ? tr('Other', 'دیگر')
                        : '${p.count}'),
                    onPressed: () async {
                      final c = TextEditingController(text: '${p.count}');
                      final n = await showDialog<int>(
                          context: context,
                          builder: (d) => AlertDialog(
                                  title: Text(tr('Number of MCQs', 'سوالات کی تعداد')),
                                  content: TextField(
                                      controller: c,
                                      autofocus: true,
                                      keyboardType: TextInputType.number),
                                  actions: [
                                    FilledButton(
                                        onPressed: () =>
                                            Navigator.pop(d, parseInt(c.text)),
                                        child: const Text('OK'))
                                  ]));
                      if (n != null && n > 0) setState(() => p.count = n);
                    }),
              ])),
            ])),
      ],
    ]));
  }
}
