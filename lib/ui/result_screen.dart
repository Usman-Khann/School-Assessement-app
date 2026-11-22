import 'package:flutter/material.dart';

import '../core/core.dart';
import '../data/db/database.dart';
import '../data/repos/student_repo.dart';
import '../services/app.dart';
import '../services/assessment_engine.dart';
import 'assess_run_screen.dart';
import 'common.dart';
import 'progress_screen.dart';

class _Loaded {
  final Attempt attempt;
  final Attempt? previous;
  final List<ShownQuestion> questions;
  _Loaded(this.attempt, this.previous, this.questions);
}

/// Shows one or more saved attempts read back from the database: score,
/// comparison with the previous attempt in that subject, and every question
/// with the student's original answer and the explanation. Used both right
/// after an assessment and when opening an old result from history.
class ResultScreen extends StatefulWidget {
  final Student student;
  final List<String> attemptIds;
  final bool fromHistory;
  const ResultScreen(
      {super.key,
      required this.student,
      required this.attemptIds,
      this.fromHistory = false});
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<_Loaded>? _data;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final all = await App.attempts.forStudent(widget.student.id);
    final out = <_Loaded>[];
    for (final id in widget.attemptIds) {
      final a = all.where((e) => e.id == id).firstOrNull;
      if (a == null) continue;
      final earlier = all
          .where((e) =>
              e.subject == a.subject && e.finishedAt.isBefore(a.finishedAt))
          .toList();
      out.add(_Loaded(
          a,
          earlier.isEmpty ? null : earlier.last,
          (await App.attempts.answers(id))
              .map(ShownQuestion.fromAnswer)
              .toList()));
    }
    if (mounted) setState(() => _data = out);
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    return Scaffold(
      appBar: AppBar(
          title: Text(
              '${tr('Result', 'نتیجہ')}  •  ${studentDisplayName(widget.student)}')),
      bottomNavigationBar: widget.fromHistory
          ? null
          : SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(children: [
                    Expanded(
                        child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(tr('Done', 'ٹھیک ہے')))),
                    const SizedBox(width: 10),
                    Expanded(
                        child: FilledButton.icon(
                            onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ProgressScreen(
                                        student: widget.student))),
                            icon: const Icon(Icons.show_chart),
                            label: Text(tr('Progress', 'کارکردگی')))),
                  ]))),
      body: data == null
          ? const Center(child: CircularProgressIndicator())
          : Body(
              child: ListView(padding: const EdgeInsets.all(12), children: [
              for (final d in data) ..._attempt(context, d),
            ])),
    );
  }

  List<Widget> _attempt(BuildContext context, _Loaded d) {
    final a = d.attempt;
    final prev = d.previous;
    final delta = prev == null ? null : a.percentage - prev.percentage;
    return [
      Card(
          child: Padding(
              padding: const EdgeInsets.all(14),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(
                      child: Text(subjectLabel(a.subject),
                          style: Theme.of(context).textTheme.titleLarge)),
                  if (a.practice) Chip(label: Text(tr('Practice', 'مشق'))),
                ]),
                Text(fmtDate(a.finishedAt),
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                Row(children: [
                  ScoreRing(percent: a.percentage, size: 96),
                  const SizedBox(width: 16),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('${a.correct} / ${a.total} ${tr('correct', 'درست')}',
                            style: Theme.of(context).textTheme.titleLarge),
                        Text('${(a.timeTakenSec / 60).toStringAsFixed(1)} ${tr('min', 'منٹ')}',
                            style: Theme.of(context).textTheme.bodySmall),
                      ])),
                ]),
                const SizedBox(height: 8),
                if (prev != null)
                  Text(
                      '${tr('Previous', 'پچھلا')}: ${fmtPct(prev.percentage)}   →   ${tr('Now', 'اب')}: ${fmtPct(a.percentage)}   '
                      '(${delta! > 0 ? tr('improved by', 'بہتری') : delta < 0 ? tr('dropped by', 'کمی') : tr('no change', 'کوئی تبدیلی نہیں')}'
                      '${delta == 0 ? '' : ' ${delta.abs().toStringAsFixed(delta == delta.roundToDouble() ? 0 : 1)} ${tr('percentage points', 'فیصد پوائنٹس')}'})',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: delta > 0
                              ? kGood
                              : delta < 0
                                  ? kBad
                                  : null))
                else
                  Text(tr('First assessment in this subject.',
                      'اس مضمون میں پہلا جائزہ۔')),
                if (a.feedback.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ContentText(a.feedback),
                ],
              ]))),
      for (var i = 0; i < d.questions.length; i++)
        _ReviewTile(number: i + 1, q: d.questions[i]),
      const SizedBox(height: 16),
    ];
  }
}

class _ReviewTile extends StatelessWidget {
  final int number;
  final ShownQuestion q;
  const _ReviewTile({required this.number, required this.q});
  @override
  Widget build(BuildContext context) {
    final ok = q.isCorrect;
    return Card(
        child: ExpansionTile(
            leading: Icon(ok ? Icons.check_circle : Icons.cancel,
                color: ok ? kGood : kBad),
            title: ContentText('$number. ${q.text}'),
            childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            children: [
          for (var i = 0; i < q.options.length; i++)
            OptionTile(
                index: i,
                text: q.options[i],
                selected: q.selected == i,
                correct: i == q.correctIndex),
          FeedbackCard(q: q),
        ]));
  }
}
