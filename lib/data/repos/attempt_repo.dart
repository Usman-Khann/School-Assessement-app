import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/core.dart';
import '../../services/assessment_engine.dart';
import '../../services/progress_engine.dart';
import '../db/database.dart';
import 'library_repo.dart';

class AttemptRepo {
  final AppDatabase db;
  final String Function() schoolId;
  AttemptRepo(this.db, this.schoolId);

  /// Saves one finished subject attempt. Always inserts new rows; earlier
  /// results are never modified.
  Future<Attempt> save({
    required Student student,
    required Textbook book,
    required ContentSelection selection,
    required List<ShownQuestion> questions,
    required DateTime startedAt,
    required DateTime finishedAt,
    required String sessionId,
    required String feedbackMode,
    bool practice = false,
  }) async {
    final id = newId();
    final correct = questions.where((q) => q.isCorrect).length;
    final total = questions.length;
    await db.transaction(() async {
      await db.into(db.attempts).insert(AttemptsCompanion.insert(
            id: id,
            schoolId: schoolId(),
            sessionId: sessionId,
            studentId: student.id,
            grade: book.grade,
            subject: book.subject,
            textbookId: book.id,
            textbookTitle: Value(book.title),
            feedbackMode: feedbackMode,
            practice: Value(practice),
            chapterIdsJson: Value(jsonEncode(selection.chapterIds.toList())),
            topicIdsJson: Value(jsonEncode(selection.topicIds.toList())),
            startedAt: startedAt,
            finishedAt: finishedAt,
            total: total,
            correct: correct,
            percentage: total == 0 ? 0 : correct * 100.0 / total,
            timeTakenSec: finishedAt.difference(startedAt).inSeconds,
            feedback: Value(ProgressEngine.feedbackFor(questions)),
          ));
      for (var i = 0; i < questions.length; i++) {
        final q = questions[i];
        await db.into(db.attemptAnswers).insert(AttemptAnswersCompanion.insert(
              id: newId(),
              attemptId: id,
              studentId: student.id,
              questionId: q.questionId,
              chapterId: q.chapterId,
              topicId: Value(q.topicId),
              orderNo: i,
              snapshotJson: jsonEncode(q.toJson()),
              selectedIndex: Value(q.selected),
              correctIndex: q.correctIndex,
              isCorrect: q.isCorrect,
              timeSec: Value(q.timeSec),
            ));
      }
      await db.enqueueSync('attempts', id);
    });
    return (await (db.select(db.attempts)..where((t) => t.id.equals(id)))
        .getSingle());
  }

  Future<List<Attempt>> forStudent(String studentId, {String? subject}) {
    final q = db.select(db.attempts)
      ..where((t) => t.studentId.equals(studentId));
    if (subject != null) q.where((t) => t.subject.equals(subject));
    q.orderBy([(t) => OrderingTerm(expression: t.finishedAt)]);
    return q.get();
  }

  Stream<List<Attempt>> watchForStudent(String studentId) =>
      (db.select(db.attempts)
            ..where((t) => t.studentId.equals(studentId))
            ..orderBy([(t) => OrderingTerm(expression: t.finishedAt)]))
          .watch();

  Future<List<AttemptAnswer>> answers(String attemptId) =>
      (db.select(db.attemptAnswers)
            ..where((t) => t.attemptId.equals(attemptId))
            ..orderBy([(t) => OrderingTerm(expression: t.orderNo)]))
          .get();

  Future<List<AttemptAnswer>> answersForStudent(String studentId) =>
      (db.select(db.attemptAnswers)
            ..where((t) => t.studentId.equals(studentId)))
          .get();

  /// How many times this student has already been shown each question.
  Future<Map<String, int>> seenCounts(String studentId) async {
    final m = <String, int>{};
    for (final a in await answersForStudent(studentId)) {
      m[a.questionId] = (m[a.questionId] ?? 0) + 1;
    }
    return m;
  }

  Future<List<SubjectProgress>> progress(String studentId) async =>
      ProgressEngine.compute(
          await forStudent(studentId), await answersForStudent(studentId));

  Future<int> totalAttempts() async =>
      (await db.select(db.attempts).get()).length;
}
