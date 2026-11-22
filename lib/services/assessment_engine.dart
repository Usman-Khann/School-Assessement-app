import 'dart:convert';
import 'dart:math';

import '../data/db/database.dart';
import '../data/repos/library_repo.dart';

/// A question exactly as presented to the student (options possibly
/// shuffled). Serialised into AttemptAnswers.snapshotJson.
class ShownQuestion {
  final String questionId;
  final String chapterId;
  final String? topicId;
  final String text;
  final List<String> options;
  final int correctIndex;
  final String shortExplanation;
  final String conceptExplanation;
  final int chapterNumber;
  final String chapterTitle;
  final String topicTitle;
  final int? page;
  final int difficulty;

  /// Textbook the question belongs to (for "read this in the book").
  final String? bookId;
  int? selected;
  int timeSec;

  ShownQuestion({
    required this.questionId,
    required this.chapterId,
    required this.topicId,
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.shortExplanation,
    required this.conceptExplanation,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.topicTitle,
    required this.page,
    required this.difficulty,
    this.bookId,
    this.selected,
    this.timeSec = 0,
  });

  bool get answered => selected != null;
  bool get isCorrect => selected == correctIndex;

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'chapterId': chapterId,
        'topicId': topicId,
        'text': text,
        'options': options,
        'correctIndex': correctIndex,
        'shortExplanation': shortExplanation,
        'conceptExplanation': conceptExplanation,
        'chapterNumber': chapterNumber,
        'chapterTitle': chapterTitle,
        'topicTitle': topicTitle,
        'page': page,
        'difficulty': difficulty,
        'bookId': bookId,
      };

  factory ShownQuestion.fromJson(Map<String, dynamic> j,
          {int? selected, int timeSec = 0}) =>
      ShownQuestion(
        questionId: j['questionId'] as String,
        chapterId: j['chapterId'] as String,
        topicId: j['topicId'] as String?,
        text: j['text'] as String,
        options: (j['options'] as List).map((e) => e.toString()).toList(),
        correctIndex: j['correctIndex'] as int,
        shortExplanation: (j['shortExplanation'] ?? '') as String,
        conceptExplanation: (j['conceptExplanation'] ?? '') as String,
        chapterNumber: (j['chapterNumber'] ?? 0) as int,
        chapterTitle: (j['chapterTitle'] ?? '') as String,
        topicTitle: (j['topicTitle'] ?? '') as String,
        page: j['page'] as int?,
        difficulty: (j['difficulty'] ?? 2) as int,
        bookId: j['bookId'] as String?,
        selected: selected,
        timeSec: timeSec,
      );

  factory ShownQuestion.fromAnswer(AttemptAnswer a) => ShownQuestion.fromJson(
      jsonDecode(a.snapshotJson) as Map<String, dynamic>,
      selected: a.selectedIndex,
      timeSec: a.timeSec);
}

class AssessmentEngine {
  final Random rnd;
  AssessmentEngine([Random? rnd]) : rnd = rnd ?? Random();

  /// Chooses up to [count] questions from [pool] (which must already be
  /// restricted to the teacher's selection). Questions the student has seen
  /// least often come first, and the picks are spread across chapters.
  List<Question> pick(List<Question> pool, int count,
      {Map<String, int> seenCounts = const {}}) {
    final list = [...pool]..shuffle(rnd);
    // Stable sort by times seen (List.sort is not stable, so decorate).
    final idx = {for (var i = 0; i < list.length; i++) list[i].id: i};
    list.sort((a, b) {
      final c = (seenCounts[a.id] ?? 0).compareTo(seenCounts[b.id] ?? 0);
      return c != 0 ? c : idx[a.id]!.compareTo(idx[b.id]!);
    });
    final byChapter = <String, List<Question>>{};
    for (final q in list) {
      byChapter.putIfAbsent(q.chapterId, () => []).add(q);
    }
    final queues = byChapter.values.toList()..shuffle(rnd);
    final out = <Question>[];
    while (out.length < count && queues.any((q) => q.isNotEmpty)) {
      for (final q in queues) {
        if (q.isEmpty) continue;
        out.add(q.removeAt(0));
        if (out.length >= count) break;
      }
    }
    out.shuffle(rnd);
    return out;
  }

  static final _positional = RegExp(
      r'(above|both|all of|none of|neither|\(a\)|\(b\)|اوپر|دونوں|تمام|کوئی نہیں)',
      caseSensitive: false);

  /// Builds the presented form. Options are shuffled unless any option
  /// refers to other options by position ("all of the above" etc.).
  ShownQuestion present(Question q,
      {required Chapter chapter, Topic? topic, bool shuffle = true}) {
    final opts = optionsOf(q);
    var order = List<int>.generate(opts.length, (i) => i);
    if (shuffle && !opts.any(_positional.hasMatch)) order.shuffle(rnd);
    return ShownQuestion(
      questionId: q.id,
      chapterId: q.chapterId,
      topicId: q.topicId,
      text: q.body,
      options: [for (final i in order) opts[i]],
      correctIndex: order.indexOf(q.correctIndex ?? 0),
      shortExplanation: q.shortExplanation,
      conceptExplanation: q.conceptExplanation,
      chapterNumber: chapter.number,
      chapterTitle: chapter.title,
      topicTitle: topic?.title ?? '',
      page: q.pageRef,
      difficulty: q.difficulty,
      bookId: q.textbookId,
    );
  }
}
