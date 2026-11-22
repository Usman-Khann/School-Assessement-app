import 'package:flutter/material.dart';

import '../core/core.dart';
import '../data/db/database.dart';
import '../data/repos/student_repo.dart';
import '../services/app.dart';
import '../services/assessment_engine.dart';
import 'assess_setup_screen.dart';
import 'common.dart';
import 'reader_screen.dart';
import 'result_screen.dart';
import 'theme.dart';

/// Runs the chosen subjects one after another. Each finished subject is
/// saved immediately as its own permanent attempt.
class AssessRunScreen extends StatefulWidget {
  final Student student;
  final List<SubjectPlan> plans;
  final String feedbackMode;
  final bool practice;
  const AssessRunScreen(
      {super.key,
      required this.student,
      required this.plans,
      required this.feedbackMode,
      required this.practice});
  @override
  State<AssessRunScreen> createState() => _AssessRunScreenState();
}

class _AssessRunScreenState extends State<AssessRunScreen> {
  final _sessionId = newId();
  final _saved = <String>[];
  int _p = 0;
  int _q = 0;
  bool _revealed = false;
  bool _saving = false;
  DateTime _subjectStart = DateTime.now();
  DateTime _questionStart = DateTime.now();

  SubjectPlan get plan => widget.plans[_p];
  ShownQuestion get q => plan.questions[_q];
  bool get immediate => widget.feedbackMode == 'immediate';

  void _choose(int i) {
    if (_revealed) return;
    setState(() {
      q.selected = i;
      if (immediate) {
        q.timeSec = DateTime.now().difference(_questionStart).inSeconds;
        _revealed = true;
      }
    });
  }

  Future<void> _next() async {
    if (!_revealed) {
      q.timeSec = DateTime.now().difference(_questionStart).inSeconds;
    }
    if (_q + 1 < plan.questions.length) {
      setState(() {
        _q++;
        _revealed = false;
        _questionStart = DateTime.now();
      });
      return;
    }
    setState(() => _saving = true);
    final a = await App.attempts.save(
        student: widget.student,
        book: plan.book!,
        selection: plan.selection,
        questions: plan.questions,
        startedAt: _subjectStart,
        finishedAt: DateTime.now(),
        sessionId: _sessionId,
        feedbackMode: widget.feedbackMode,
        practice: widget.practice);
    _saved.add(a.id);
    await App.sync.refreshStatus();
    if (!mounted) return;
    if (_p + 1 < widget.plans.length) {
      setState(() {
        _p++;
        _q = 0;
        _revealed = false;
        _saving = false;
        _subjectStart = DateTime.now();
        _questionStart = DateTime.now();
      });
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  ResultScreen(student: widget.student, attemptIds: _saved)));
    }
  }

  Future<void> _quit() async {
    final ok = await confirm(
        context,
        tr('Stop this assessment?', 'جائزہ روک دیں؟'),
        tr('Subjects already finished are saved. The subject in progress will not be saved.',
            'مکمل شدہ مضامین محفوظ ہیں۔ جاری مضمون محفوظ نہیں ہوگا۔'));
    if (!ok || !mounted) return;
    if (_saved.isEmpty) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  ResultScreen(student: widget.student, attemptIds: _saved)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final n = plan.questions.length;
    final last = _q + 1 == n;
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _quit();
        },
        child: Scaffold(
          appBar: AppBar(
              leading:
                  IconButton(icon: const Icon(Icons.close), onPressed: _quit),
              title: Text(
                  '${subjectLabel(plan.subject)}  •  ${studentDisplayName(widget.student)}'),
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(6),
                  child: LinearProgressIndicator(
                      value: (_q + (_revealed ? 1 : 0)) / n, minHeight: 6))),
          bottomNavigationBar: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(children: [
                    if (!_revealed && q.selected == null)
                      TextButton(
                          onPressed: _saving ? null : _next,
                          child: Text(tr('Skip', 'چھوڑیں'))),
                    const Spacer(),
                    FilledButton.icon(
                        onPressed: _saving ||
                                (immediate ? !_revealed : q.selected == null)
                            ? null
                            : _next,
                        icon: Icon(last ? Icons.check : Icons.arrow_forward),
                        label: Text(last
                            ? (_p + 1 < widget.plans.length
                                ? tr('Next subject', 'اگلا مضمون')
                                : tr('Finish', 'مکمل کریں'))
                            : tr('Next', 'اگلا'))),
                  ]))),
          body: Body(
              child: ListView(padding: const EdgeInsets.all(16), children: [
            Text(
                '${tr('Question', 'سوال')} ${_q + 1} / $n'
                '${widget.plans.length > 1 ? '   (${tr('Subject', 'مضمون')} ${_p + 1}/${widget.plans.length})' : ''}',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 10),
            ContentText(q.text,
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            for (var i = 0; i < q.options.length; i++)
              OptionTile(
                  index: i,
                  text: q.options[i],
                  selected: q.selected == i,
                  correct: _revealed ? i == q.correctIndex : null,
                  onTap: _revealed ? null : () => _choose(i)),
            if (_revealed) FeedbackCard(q: q),
          ])),
        ));
  }
}

/// One answer option. [correct] is null until the answer is revealed.
class OptionTile extends StatelessWidget {
  final int index;
  final String text;
  final bool selected;
  final bool? correct;
  final VoidCallback? onTap;
  const OptionTile(
      {super.key,
      required this.index,
      required this.text,
      required this.selected,
      required this.correct,
      this.onTap});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Color border = kLine;
    final letterColors = [const Color(0xFF3F51B5), const Color(0xFF00897B), const Color(0xFFE65100), const Color(0xFFAD1457)];
    Color badge = letterColors[index % 4];
    Color? fill;
    IconData? icon;
    if (correct == true) {
      badge = kGood;
      border = kGood;
      fill = kGood.withValues(alpha: 0.12);
      icon = Icons.check_circle;
    } else if (correct == false && selected) {
      badge = kBad;
      border = kBad;
      fill = kBad.withValues(alpha: 0.12);
      icon = Icons.cancel;
    } else if (correct == null && selected) {
      badge = cs.primary;
      border = cs.primary;
      fill = cs.primaryContainer;
    }
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Material(
            color: fill ?? cs.surface,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: border, width: 2)),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
                onTap: onTap,
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    child: Row(children: [
                      CircleAvatar(
                          radius: 16,
                          backgroundColor: badge,
                          child: Text(String.fromCharCode(65 + index),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13))),
                      const SizedBox(width: 12),
                      Expanded(
                          child: ContentText(text,
                              style: const TextStyle(fontSize: 17.5, fontWeight: FontWeight.w700))),
                      if (icon != null) Icon(icon, color: border),
                    ])))));
  }
}

/// Correct / incorrect banner with the right answer, short explanation,
/// concept explanation and the chapter / topic / page reference.
class FeedbackCard extends StatelessWidget {
  final ShownQuestion q;
  const FeedbackCard({super.key, required this.q});
  @override
  Widget build(BuildContext context) {
    final ok = q.isCorrect;
    final color = ok ? kGood : kBad;
    final ref = [
      '${tr('Chapter', 'باب')} ${q.chapterNumber}: ${q.chapterTitle}',
      if (q.topicTitle.isNotEmpty) '${tr('Topic', 'موضوع')}: ${q.topicTitle}',
      if (q.page != null) '${tr('Page', 'صفحہ')} ${q.page}',
    ].join('\n');
    return Card(
        margin: const EdgeInsets.only(top: 14),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color, width: 1.5)),
        child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(ok ? Icons.check_circle : Icons.cancel, color: color),
                const SizedBox(width: 8),
                Text(
                    ok
                        ? tr('Correct!', 'درست!')
                        : q.selected == null
                            ? tr('Not answered', 'جواب نہیں دیا')
                            : tr('Incorrect', 'غلط'),
                    style: TextStyle(
                        color: color, fontSize: 18, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 8),
              Text(tr('Correct answer', 'درست جواب'),
                  style: Theme.of(context).textTheme.labelMedium),
              ContentText(
                  '${String.fromCharCode(65 + q.correctIndex)}. ${q.options[q.correctIndex]}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              if (q.shortExplanation.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(tr('Why', 'وجہ'),
                    style: Theme.of(context).textTheme.labelMedium),
                ContentText(q.shortExplanation),
              ],
              if (q.conceptExplanation.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(tr('Understand the concept', 'تصور سمجھیں'),
                    style: Theme.of(context).textTheme.labelMedium),
                ContentText(q.conceptExplanation),
              ],
              const Divider(),
              ContentText(ref, style: Theme.of(context).textTheme.bodySmall),
              if (q.bookId != null && q.page != null)
                Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: OutlinedButton.icon(
                        onPressed: () => openBook(context, q.bookId!,
                            page: q.page!, heading: q.topicTitle.isNotEmpty ? q.topicTitle : q.chapterTitle),
                        icon: const Icon(Icons.menu_book_rounded),
                        label: Text(tr('Read this in the textbook (page ${q.page})',
                            'یہ کتاب میں پڑھیں (صفحہ ${q.page})')))),
            ])));
  }
}
