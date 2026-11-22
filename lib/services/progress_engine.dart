import '../core/core.dart';
import '../data/db/database.dart';
import 'assessment_engine.dart';

class Bucket {
  final String id;
  final String title;
  int correct = 0;
  int total = 0;
  Bucket(this.id, this.title);
  double get pct => total == 0 ? 0 : correct * 100.0 / total;
}

class RepeatedMistake {
  final ShownQuestion question;
  int timesWrong = 0;
  int timesSeen = 0;
  RepeatedMistake(this.question);
}

class SubjectProgress {
  final String subject;

  /// Oldest first.
  final List<Attempt> attempts;
  final List<Bucket> chapters;
  final List<Bucket> topics;
  final List<RepeatedMistake> repeated;
  SubjectProgress(
      this.subject, this.attempts, this.chapters, this.topics, this.repeated);

  Attempt? get latest => attempts.isEmpty ? null : attempts.last;
  Attempt? get previous =>
      attempts.length < 2 ? null : attempts[attempts.length - 2];

  /// Change in percentage points between the previous and latest attempt.
  double? get delta =>
      previous == null ? null : latest!.percentage - previous!.percentage;

  double get average => attempts.isEmpty
      ? 0
      : attempts.map((a) => a.percentage).reduce((a, b) => a + b) /
          attempts.length;

  /// Topics (or chapters when a question has no topic) answered at least
  /// twice with under 60% accuracy, weakest first.
  List<Bucket> get weakAreas {
    final all = [...topics, ...chapters.where((c) => !_hasTopicIn(c))];
    final w = all.where((b) => b.total >= 2 && b.pct < 60).toList()
      ..sort((a, b) => a.pct.compareTo(b.pct));
    return w;
  }

  bool _hasTopicIn(Bucket chapter) =>
      topics.any((t) => t.id.startsWith('${chapter.id}|'));
}

class ProgressEngine {
  /// Pure function: builds per-subject progress from saved history.
  static List<SubjectProgress> compute(
      List<Attempt> attempts, List<AttemptAnswer> answers) {
    final bySubject = <String, List<Attempt>>{};
    for (final a in attempts) {
      bySubject.putIfAbsent(a.subject, () => []).add(a);
    }
    final ansByAttempt = <String, List<AttemptAnswer>>{};
    for (final a in answers) {
      ansByAttempt.putIfAbsent(a.attemptId, () => []).add(a);
    }
    final out = <SubjectProgress>[];
    for (final e in bySubject.entries) {
      final list = e.value..sort((a, b) => a.finishedAt.compareTo(b.finishedAt));
      final chapters = <String, Bucket>{};
      final topics = <String, Bucket>{};
      final rep = <String, RepeatedMistake>{};
      for (final att in list) {
        for (final ans in ansByAttempt[att.id] ?? const <AttemptAnswer>[]) {
          final q = ShownQuestion.fromAnswer(ans);
          final cTitle = q.chapterNumber > 0
              ? '${q.chapterNumber}. ${q.chapterTitle}'
              : q.chapterTitle;
          final cb =
              chapters.putIfAbsent(q.chapterId, () => Bucket(q.chapterId, cTitle));
          cb.total++;
          if (ans.isCorrect) cb.correct++;
          if (q.topicId != null) {
            final key = '${q.chapterId}|${q.topicId}';
            final tb = topics.putIfAbsent(key, () => Bucket(key, q.topicTitle));
            tb.total++;
            if (ans.isCorrect) tb.correct++;
          }
          final r = rep.putIfAbsent(q.questionId, () => RepeatedMistake(q));
          r.timesSeen++;
          if (!ans.isCorrect) r.timesWrong++;
        }
      }
      final repeated = rep.values.where((r) => r.timesWrong >= 2).toList()
        ..sort((a, b) => b.timesWrong.compareTo(a.timesWrong));
      out.add(SubjectProgress(e.key, list, chapters.values.toList(),
          topics.values.toList(), repeated));
    }
    out.sort((a, b) => a.subject.compareTo(b.subject));
    return out;
  }

  /// Plain-language feedback stored with each attempt.
  static String feedbackFor(List<ShownQuestion> qs) {
    if (qs.isEmpty) return '';
    final correct = qs.where((q) => q.isCorrect).length;
    final pct = correct * 100.0 / qs.length;
    final weak = <String, int>{};
    for (final q in qs.where((q) => !q.isCorrect)) {
      final name = q.topicTitle.isNotEmpty ? q.topicTitle : q.chapterTitle;
      weak[name] = (weak[name] ?? 0) + 1;
    }
    final names = (weak.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(3)
        .map((e) => e.key)
        .join(', ');
    final level = pct >= 80
        ? tr('Very good understanding.', 'بہت اچھی سمجھ۔')
        : pct >= 60
            ? tr('Good, with some gaps.', 'اچھا، مگر کچھ کمی ہے۔')
            : pct >= 40
                ? tr('Needs more practice.', 'مزید مشق کی ضرورت ہے۔')
                : tr('Needs re-teaching of the basics.',
                    'بنیادی تصورات دوبارہ پڑھانے کی ضرورت ہے۔');
    final head = tr('Scored $correct out of ${qs.length} (${fmtPct(pct)}).',
        '${qs.length} میں سے $correct درست (${fmtPct(pct)})۔');
    final tail = names.isEmpty
        ? ''
        : ' ${tr('Practise again:', 'دوبارہ مشق کریں:')} $names.';
    return '$head $level$tail';
  }
}
