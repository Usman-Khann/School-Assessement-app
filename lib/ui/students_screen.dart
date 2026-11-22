import 'package:flutter/material.dart';

import '../core/core.dart';
import '../data/db/database.dart';
import '../data/repos/student_repo.dart';
import '../services/app.dart';
import 'common.dart';
import 'progress_screen.dart';

/// Student list with class filter and search. When [pickMode] is true,
/// tapping a student returns it to the caller instead of opening progress.
class StudentsScreen extends StatefulWidget {
  final bool pickMode;
  final int? initialGrade;
  const StudentsScreen({super.key, this.pickMode = false, this.initialGrade});
  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  late int? _grade = widget.initialGrade;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.pickMode
              ? tr('Choose student', 'طالب علم منتخب کریں')
              : tr('Students', 'طلبہ'))),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final s = await showStudentForm(context, grade: _grade);
            if (s != null && widget.pickMode && context.mounted) {
              Navigator.pop(context, s);
            }
          },
          icon: const Icon(Icons.person_add),
          label: Text(tr('Add student', 'نیا طالب علم'))),
      body: Body(
          child: Column(children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: tr('Search by name, roll number or ID',
                        'نام، رول نمبر یا آئی ڈی سے تلاش کریں')),
                onChanged: (v) => setState(() => _query = v))),
        if (!widget.pickMode || widget.initialGrade == null)
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GradeChips(
                  value: _grade,
                  allowAll: true,
                  onChanged: (g) => setState(() => _grade = g))),
        Expanded(
            child: StreamBuilder<List<Student>>(
                stream: App.students.watch(grade: _grade, query: _query),
                builder: (_, snap) {
                  final list = snap.data ?? const <Student>[];
                  if (snap.hasData && list.isEmpty) {
                    return EmptyHint(
                        icon: Icons.groups,
                        text: tr('No students here yet. Tap "Add student".',
                            'ابھی کوئی طالب علم نہیں۔ "نیا طالب علم" دبائیں۔'));
                  }
                  return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 88),
                      itemCount: list.length,
                      itemBuilder: (_, i) => _row(list[i]));
                })),
      ])),
    );
  }

  Widget _row(Student s) {
    final name = studentDisplayName(s);
    final bits = [
      gradeLabel(s.grade),
      if (s.section.isNotEmpty) '${tr('Section', 'سیکشن')} ${s.section}',
      if (s.rollNo.isNotEmpty) '${tr('Roll', 'رول')} ${s.rollNo}',
      s.code,
    ];
    return Card(
        child: ListTile(
            leading: CircleAvatar(child: Text(name.characters.first.toUpperCase())),
            title: Text(name, textDirection: dirOf(name)),
            subtitle: Text(bits.join('  •  ')),
            trailing: IconButton(
                icon: const Icon(Icons.edit),
                tooltip: tr('Edit', 'ترمیم'),
                onPressed: () => showStudentForm(context, existing: s)),
            onTap: () {
              if (widget.pickMode) {
                Navigator.pop(context, s);
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ProgressScreen(student: s)));
              }
            }));
  }
}

/// Add / edit dialog. Only the class is required. Returns the saved student
/// (or the already-existing one when a duplicate was detected and chosen).
Future<Student?> showStudentForm(BuildContext context,
    {Student? existing, int? grade}) {
  return showDialog<Student>(
      context: context,
      builder: (_) => _StudentForm(existing: existing, grade: grade));
}

class _StudentForm extends StatefulWidget {
  final Student? existing;
  final int? grade;
  const _StudentForm({this.existing, this.grade});
  @override
  State<_StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<_StudentForm> {
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late final _roll = TextEditingController(text: widget.existing?.rollNo ?? '');
  late final _section =
      TextEditingController(text: widget.existing?.section ?? '');
  late final _year =
      TextEditingController(text: widget.existing?.academicYear ?? '');
  late int? _grade = widget.existing?.grade ?? widget.grade;
  String? _error;

  Future<void> _save() async {
    if (_grade == null) {
      setState(() => _error = tr('Please choose a class.', 'جماعت منتخب کریں۔'));
      return;
    }
    try {
      Student? saved;
      final e = widget.existing;
      if (e == null) {
        saved = await App.students.add(
            name: _name.text,
            rollNo: _roll.text,
            grade: _grade!,
            section: _section.text,
            academicYear: _year.text);
      } else {
        await App.students.edit(e.id,
            name: _name.text,
            rollNo: _roll.text,
            grade: _grade!,
            section: _section.text,
            academicYear: _year.text);
        saved = await App.students.get(e.id);
      }
      await App.sync.refreshStatus();
      if (mounted) Navigator.pop(context, saved);
    } on DuplicateStudent catch (d) {
      if (!mounted) return;
      final use = await confirm(
          context,
          tr('Student already exists', 'طالب علم پہلے سے موجود ہے'),
          tr(
              '${studentDisplayName(d.existing)} (${d.existing.code}) is already registered in this class. '
                  'No second record was created. Use the existing record?',
              '${studentDisplayName(d.existing)} (${d.existing.code}) اس جماعت میں پہلے سے درج ہے۔ '
                  'نیا ریکارڈ نہیں بنایا گیا۔ موجودہ ریکارڈ استعمال کریں؟'));
      if (use && mounted && widget.existing == null) {
        Navigator.pop(context, d.existing);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final opt = tr('(optional)', '(اختیاری)');
    Widget field(TextEditingController c, String label) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextField(
            controller: c, decoration: InputDecoration(labelText: '$label $opt')));
    return AlertDialog(
      title: Text(widget.existing == null
          ? tr('Add student', 'نیا طالب علم')
          : tr('Edit student', 'طالب علم میں ترمیم')),
      content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonFormField<int>(
                initialValue: _grade,
                decoration: InputDecoration(
                    labelText: '${tr('Class', 'جماعت')} *', errorText: _error),
                items: [
                  for (final g in kGrades)
                    DropdownMenuItem(value: g, child: Text(gradeLabel(g)))
                ],
                onChanged: (g) => setState(() {
                      _grade = g;
                      _error = null;
                    })),
            const SizedBox(height: 10),
            field(_name, tr('Student name', 'طالب علم کا نام')),
            field(_roll, tr('Roll number', 'رول نمبر')),
            field(_section, tr('Section', 'سیکشن')),
            field(_year, tr('Academic year', 'تعلیمی سال')),
            if (widget.existing != null)
              Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('ID: ${widget.existing!.code}',
                      style: Theme.of(context).textTheme.bodySmall)),
          ]))),
      actions: [
        if (widget.existing != null)
          TextButton(
              onPressed: () async {
                final ok = await confirm(
                    context,
                    tr('Remove student?', 'طالب علم ہٹائیں؟'),
                    tr('The student is hidden from lists. Saved assessment history is kept.',
                        'طالب علم فہرست سے ہٹ جائے گا۔ محفوظ شدہ نتائج برقرار رہیں گے۔'));
                if (!ok) return;
                await App.students.remove(widget.existing!.id);
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(tr('Remove', 'ہٹائیں'),
                  style: const TextStyle(color: kBad))),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr('Cancel', 'منسوخ'))),
        FilledButton(onPressed: _save, child: Text(tr('Save', 'محفوظ کریں'))),
      ],
    );
  }
}
