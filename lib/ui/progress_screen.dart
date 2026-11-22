import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../core/core.dart';
import '../data/db/database.dart';
import '../data/repos/student_repo.dart';
import '../services/app.dart';
import '../services/pdf_builder.dart';
import '../services/progress_engine.dart';
import 'assess_setup_screen.dart';
import 'common.dart';
import 'result_screen.dart';
import 'theme.dart';

class ProgressScreen extends StatefulWidget {
  final Student student;
  const ProgressScreen({super.key, required this.student});
  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<SubjectProgress>? _data;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final d = await App.attempts.progress(widget.student.id);
    if (mounted) setState(() => _data = d);
  }

  Future<void> _report() async {
    final school = await App.school();
    final teacher = await App.teacher();
    final bytes = await PdfBuilder.progressReport(
        student: widget.student,
        schoolName: school.name,
        teacherName: teacher.name,
        progress: _data ?? const []);
    await Printing.sharePdf(
        bytes: bytes, filename: 'progress_${widget.student.code}.pdf');
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.student;
    final data = _data;
    return Scaffold(
      appBar: AppBar(title: Text(studentDisplayName(s)), actions: [
        IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: tr('Progress report (PDF)', 'کارکردگی رپورٹ (PDF)'),
            onPressed: data == null ? null : _report),
      ]),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (_) => AssessSetupScreen(student: s)));
            _load();
          },
          icon: const Icon(Icons.quiz),
          label: Text(tr('Assess', 'جائزہ لیں'))),
      body: data == null
          ? const Center(child: CircularProgressIndicator())
          : Body(
              child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
                  children: [
                  Text(
                      [
                        gradeLabel(s.grade),
                        if (s.section.isNotEmpty)
                          '${tr('Section', 'سیکشن')} ${s.section}',
                        if (s.rollNo.isNotEmpty)
                          '${tr('Roll', 'رول')} ${s.rollNo}',
                        'ID ${s.code}',
                      ].join('  •  '),
                      style: Theme.of(context).textTheme.bodyMedium),
                  if (data.isEmpty)
                    EmptyHint(
                        icon: Icons.insights,
                        text: tr(
                            'No assessments yet. Tap "Assess" to test this student.',
                            'ابھی کوئی جائزہ نہیں۔ "جائزہ لیں" دبائیں۔')),
                  for (final p in data) _subject(context, p),
                ])),
    );
  }

  Widget _subject(BuildContext context, SubjectProgress p) {
    final latest = p.latest!;
    final prev = p.previous;
    final d = p.delta;
    String pts(double v) =>
        v.abs().toStringAsFixed(v == v.roundToDouble() ? 0 : 1);
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                GradientIcon(subjectStyle(p.subject).icon,
                    subjectStyle(p.subject).gradient, size: 40),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(subjectLabel(p.subject),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: subjectStyle(p.subject).color))),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                if (prev != null)
                  _stat(tr('Previous', 'پچھلا'), fmtPct(prev.percentage),
                      pctColor(prev.percentage)),
                _stat(tr('Latest', 'تازہ ترین'), fmtPct(latest.percentage),
                    pctColor(latest.percentage)),
                _stat(tr('Average', 'اوسط'), fmtPct(p.average), null),
                _stat(tr('Tests', 'ٹیسٹ'), '${p.attempts.length}', null),
              ]),
              if (d != null)
                Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(children: [
                      Icon(
                          d > 0
                              ? Icons.trending_up
                              : d < 0
                                  ? Icons.trending_down
                                  : Icons.trending_flat,
                          color: d > 0 ? kGood : (d < 0 ? kBad : Colors.grey)),
                      const SizedBox(width: 6),
                      Expanded(
                          child: Text(
                              d > 0
                                  ? tr('Improvement: ${pts(d)} percentage points',
                                      'بہتری: ${pts(d)} فیصد پوائنٹس')
                                  : d < 0
                                      ? tr('Decline: ${pts(d)} percentage points',
                                          'کمی: ${pts(d)} فیصد پوائنٹس')
                                      : tr('No change since the previous test',
                                          'پچھلے ٹیسٹ سے کوئی تبدیلی نہیں'),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: d > 0 ? kGood : (d < 0 ? kBad : null)))),
                    ])),
              if (p.attempts.length >= 2) ...[
                const SizedBox(height: 10),
                SizedBox(
                    height: 140,
                    width: double.infinity,
                    child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: CustomPaint(
                            painter: _TrendPainter(
                                [for (final a in p.attempts) a.percentage],
                                subjectStyle(p.subject).color)))),
              ],
              if (p.weakAreas.isNotEmpty) ...[
                SectionTitle(tr('Needs more practice', 'مزید مشق درکار')),
                for (final b in p.weakAreas)
                  PctBar(label: b.title, correct: b.correct, total: b.total),
              ],
              if (p.chapters.isNotEmpty)
                ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text(tr('Chapter-wise performance', 'باب وار کارکردگی')),
                    children: [
                      for (final b in p.chapters)
                        PctBar(label: b.title, correct: b.correct, total: b.total)
                    ]),
              if (p.topics.isNotEmpty)
                ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text(tr('Topic-wise performance', 'موضوع وار کارکردگی')),
                    children: [
                      for (final b in p.topics)
                        PctBar(label: b.title, correct: b.correct, total: b.total)
                    ]),
              if (p.repeated.isNotEmpty)
                ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text(
                        '${tr('Repeated mistakes', 'بار بار کی غلطیاں')} (${p.repeated.length})'),
                    children: [
                      for (final r in p.repeated)
                        ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.replay, color: kBad),
                            title: ContentText(r.question.text),
                            subtitle: Text(
                                '${tr('Wrong', 'غلط')} ${r.timesWrong}/${r.timesSeen}  •  ${tr('Answer', 'جواب')}: ${r.question.options[r.question.correctIndex]}'))
                    ]),
              ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(tr('All assessments', 'تمام جائزے')),
                  children: [
                    for (final a in p.attempts.reversed)
                      ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                              '${fmtDate(a.finishedAt)}${a.practice ? '  (${tr('practice', 'مشق')})' : ''}'),
                          subtitle: Text('${a.correct}/${a.total}'),
                          trailing: Text(fmtPct(a.percentage),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: pctColor(a.percentage))),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ResultScreen(
                                      student: widget.student,
                                      attemptIds: [a.id],
                                      fromHistory: true))))
                  ]),
            ])));
  }

  Widget _stat(String label, String value, Color? color) => Expanded(
      child: Column(children: [
        Text(value,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ]));
}

/// Minimal score-over-time line chart (0-100%), oldest attempt on the left.
class _TrendPainter extends CustomPainter {
  final List<double> values;
  final Color color;
  _TrendPainter(this.values, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    const left = 30.0, bottom = 6.0, top = 8.0, right = 10.0;
    final w = size.width - left - right;
    final h = size.height - top - bottom;
    final grid = Paint()
      ..color = Colors.grey.withValues(alpha: 0.35)
      ..strokeWidth = 1;
    for (final g in [0, 50, 100]) {
      final y = top + h * (1 - g / 100);
      canvas.drawLine(Offset(left, y), Offset(left + w, y), grid);
      final tp = TextPainter(
          text: TextSpan(
              text: '$g', style: const TextStyle(fontSize: 10, color: Colors.grey)),
          textDirection: TextDirection.ltr)
        ..layout();
      tp.paint(canvas, Offset(left - tp.width - 4, y - tp.height / 2));
    }
    Offset pt(int i) => Offset(
        left + (values.length == 1 ? w / 2 : w * i / (values.length - 1)),
        top + h * (1 - values[i].clamp(0, 100) / 100));
    final line = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final path = Path()..moveTo(pt(0).dx, pt(0).dy);
    for (var i = 1; i < values.length; i++) {
      path.lineTo(pt(i).dx, pt(i).dy);
    }
    canvas.drawPath(path, line);
    for (var i = 0; i < values.length; i++) {
      canvas.drawCircle(pt(i), 4, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_TrendPainter old) => old.values != values;
}
