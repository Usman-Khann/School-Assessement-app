import 'dart:convert';
import 'dart:math';

import '../data/repos/library_repo.dart';

class PaperConfig {
  String title;
  String schoolName;
  int grade;
  String subject;
  String bookId;
  Set<String> chapterIds;
  Set<String> topicIds;

  /// Number of questions per type (mcq, fill, tf, short, long).
  Map<String, int> counts;

  /// Marks for each question of a type.
  Map<String, int> marksEach;

  /// 0 = any, otherwise 1 easy / 2 medium / 3 hard.
  int difficulty;
  int durationMin;

  /// 'en' or 'ur' - language of headings and instructions.
  String language;

  PaperConfig({
    this.title = 'Examination Paper',
    this.schoolName = '',
    required this.grade,
    required this.subject,
    required this.bookId,
    Set<String>? chapterIds,
    Set<String>? topicIds,
    Map<String, int>? counts,
    Map<String, int>? marksEach,
    this.difficulty = 0,
    this.durationMin = 60,
    this.language = 'en',
  })  : chapterIds = chapterIds ?? {},
        topicIds = topicIds ?? {},
        counts = counts ??
            {'mcq': 10, 'fill': 0, 'tf': 0, 'short': 5, 'long': 2},
        marksEach = marksEach ??
            {'mcq': 1, 'fill': 1, 'tf': 1, 'short': 2, 'long': 5};

  ContentSelection get selection =>
      ContentSelection(chapterIds: chapterIds, topicIds: topicIds);

  Map<String, dynamic> toJson() => {
        'title': title,
        'schoolName': schoolName,
        'grade': grade,
        'subject': subject,
        'bookId': bookId,
        'chapterIds': chapterIds.toList(),
        'topicIds': topicIds.toList(),
        'counts': counts,
        'marksEach': marksEach,
        'difficulty': difficulty,
        'durationMin': durationMin,
        'language': language,
      };

  factory PaperConfig.fromJson(Map<String, dynamic> j) => PaperConfig(
        title: j['title'] as String,
        schoolName: (j['schoolName'] ?? '') as String,
        grade: j['grade'] as int,
        subject: j['subject'] as String,
        bookId: j['bookId'] as String,
        chapterIds: (j['chapterIds'] as List).cast<String>().toSet(),
        topicIds: (j['topicIds'] as List).cast<String>().toSet(),
        counts: (j['counts'] as Map).map((k, v) => MapEntry('$k', v as int)),
        marksEach:
            (j['marksEach'] as Map).map((k, v) => MapEntry('$k', v as int)),
        difficulty: (j['difficulty'] ?? 0) as int,
        durationMin: (j['durationMin'] ?? 60) as int,
        language: (j['language'] ?? 'en') as String,
      );
}

class PaperQuestion {
  final String type;
  final String text;
  final List<String> options;
  final int? correctIndex;
  final String answer;
  final String explanation;
  final String chapterTitle;
  final int? page;
  final int marks;
  PaperQuestion({
    required this.type,
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.answer,
    required this.explanation,
    required this.chapterTitle,
    required this.page,
    required this.marks,
  });

  /// Answer text for the key.
  String get keyAnswer {
    if (type == 'mcq' && correctIndex != null) {
      return '(${String.fromCharCode(65 + correctIndex!)}) ${options[correctIndex!]}';
    }
    if (type == 'tf' && correctIndex != null) {
      return correctIndex == 0 ? 'True' : 'False';
    }
    return answer;
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'text': text,
        'options': options,
        'correctIndex': correctIndex,
        'answer': answer,
        'explanation': explanation,
        'chapterTitle': chapterTitle,
        'page': page,
        'marks': marks,
      };

  factory PaperQuestion.fromJson(Map<String, dynamic> j) => PaperQuestion(
        type: j['type'] as String,
        text: j['text'] as String,
        options: (j['options'] as List).cast<String>(),
        correctIndex: j['correctIndex'] as int?,
        answer: (j['answer'] ?? '') as String,
        explanation: (j['explanation'] ?? '') as String,
        chapterTitle: (j['chapterTitle'] ?? '') as String,
        page: j['page'] as int?,
        marks: j['marks'] as int,
      );
}

class GeneratedPaper {
  final PaperConfig config;

  /// In printing order: mcq, fill, tf, short, long.
  final Map<String, List<PaperQuestion>> sections;

  /// type -> how many requested questions could NOT be supplied from the
  /// selected chapters/topics. Shown to the teacher; never silently filled.
  final Map<String, int> shortfalls;
  GeneratedPaper(this.config, this.sections, this.shortfalls);

  int get totalMarks => sections.values
      .expand((e) => e)
      .fold(0, (sum, q) => sum + q.marks);
  int get totalQuestions => sections.values.fold(0, (s, l) => s + l.length);

  String contentJson() => jsonEncode({
        for (final e in sections.entries)
          e.key: e.value.map((q) => q.toJson()).toList()
      });

  factory GeneratedPaper.fromStored(String configJson, String contentJson) {
    final c = PaperConfig.fromJson(jsonDecode(configJson) as Map<String, dynamic>);
    final raw = jsonDecode(contentJson) as Map<String, dynamic>;
    return GeneratedPaper(
        c,
        {
          for (final e in raw.entries)
            e.key: (e.value as List)
                .map((q) => PaperQuestion.fromJson(q as Map<String, dynamic>))
                .toList()
        },
        {});
  }
}

const kPaperOrder = ['mcq', 'fill', 'tf', 'short', 'long'];

class PaperGenerator {
  final LibraryRepo lib;
  final Random rnd;
  PaperGenerator(this.lib, [Random? rnd]) : rnd = rnd ?? Random();

  Future<GeneratedPaper> generate(PaperConfig c) async {
    final chapters = {for (final ch in await lib.chapters(c.bookId)) ch.id: ch};
    final sections = <String, List<PaperQuestion>>{};
    final short = <String, int>{};
    for (final type in kPaperOrder) {
      final want = c.counts[type] ?? 0;
      if (want <= 0) continue;
      var pool = await lib.pool(c.bookId, c.selection, type: type);
      if (c.difficulty != 0) {
        pool = pool.where((q) => q.difficulty == c.difficulty).toList();
      }
      pool.shuffle(rnd);
      final picked = pool.take(want).toList();
      if (picked.length < want) short[type] = want - picked.length;
      if (picked.isEmpty) continue;
      sections[type] = [
        for (final q in picked)
          PaperQuestion(
            type: type,
            text: q.body,
            options: optionsOf(q),
            correctIndex: q.correctIndex,
            answer: q.answer,
            explanation: q.shortExplanation,
            chapterTitle: chapters[q.chapterId]?.title ?? '',
            page: q.pageRef,
            marks: c.marksEach[type] ?? 1,
          )
      ];
    }
    return GeneratedPaper(c, sections, short);
  }
}
