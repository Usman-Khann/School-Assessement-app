import 'package:drift/drift.dart';

import '../../core/core.dart';
import '../db/database.dart';

class DuplicateStudent implements Exception {
  final Student existing;
  DuplicateStudent(this.existing);
}

class StudentRepo {
  final AppDatabase db;
  final String Function() schoolId;
  StudentRepo(this.db, this.schoolId);

  static String _norm(String s) =>
      s.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  Stream<List<Student>> watch({int? grade, String query = ''}) {
    final q = db.select(db.students)
      ..where((t) => t.deleted.equals(false) & t.schoolId.equals(schoolId()));
    if (grade != null) q.where((t) => t.grade.equals(grade));
    q.orderBy([
      (t) => OrderingTerm(expression: t.grade),
      (t) => OrderingTerm(expression: t.section),
      (t) => OrderingTerm(expression: t.name),
    ]);
    final n = _norm(query);
    return q.watch().map((rows) => n.isEmpty
        ? rows
        : rows
            .where((s) =>
                _norm(s.name).contains(n) ||
                _norm(s.rollNo).contains(n) ||
                s.code.toLowerCase().contains(n))
            .toList());
  }

  Future<List<Student>> list({int? grade}) => watch(grade: grade).first;

  Future<Student?> get(String id) =>
      (db.select(db.students)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// A student is a duplicate when the same class + section already holds a
  /// record with the same roll number, or (if no roll number) the same name.
  /// Fully anonymous students (no name, no roll) are never duplicates.
  Future<Student?> findDuplicate({
    required String name,
    required String rollNo,
    required int grade,
    required String section,
    String? excludeId,
  }) async {
    final n = _norm(name), r = _norm(rollNo), sec = _norm(section);
    if (n.isEmpty && r.isEmpty) return null;
    final all = await list(grade: grade);
    for (final s in all) {
      if (s.id == excludeId) continue;
      if (_norm(s.section) != sec) continue;
      final sr = _norm(s.rollNo), sn = _norm(s.name);
      if (r.isNotEmpty && sr.isNotEmpty) {
        if (r == sr && (n.isEmpty || sn.isEmpty || n == sn)) return s;
      } else if (n.isNotEmpty && n == sn) {
        return s;
      }
    }
    return null;
  }

  /// Throws [DuplicateStudent] instead of creating a second record.
  Future<Student> add({
    String name = '',
    String rollNo = '',
    required int grade,
    String section = '',
    String academicYear = '',
  }) async {
    final dup = await findDuplicate(
        name: name, rollNo: rollNo, grade: grade, section: section);
    if (dup != null) throw DuplicateStudent(dup);
    final id = newId();
    final now = DateTime.now();
    await db.into(db.students).insert(StudentsCompanion.insert(
          id: id,
          schoolId: schoolId(),
          code: studentCodeFromId(id),
          name: Value(name.trim()),
          rollNo: Value(rollNo.trim()),
          grade: grade,
          section: Value(section.trim()),
          academicYear: Value(academicYear.trim()),
          createdAt: now,
          updatedAt: now,
        ));
    await db.enqueueSync('students', id);
    return (await get(id))!;
  }

  Future<void> edit(
    String id, {
    required String name,
    required String rollNo,
    required int grade,
    required String section,
    required String academicYear,
  }) async {
    final dup = await findDuplicate(
        name: name,
        rollNo: rollNo,
        grade: grade,
        section: section,
        excludeId: id);
    if (dup != null) throw DuplicateStudent(dup);
    await (db.update(db.students)..where((t) => t.id.equals(id)))
        .write(StudentsCompanion(
      name: Value(name.trim()),
      rollNo: Value(rollNo.trim()),
      grade: Value(grade),
      section: Value(section.trim()),
      academicYear: Value(academicYear.trim()),
      updatedAt: Value(DateTime.now()),
    ));
    await db.enqueueSync('students', id);
  }

  /// Soft delete: the row and all assessment history stay in the database.
  Future<void> remove(String id) async {
    await (db.update(db.students)..where((t) => t.id.equals(id))).write(
        StudentsCompanion(
            deleted: const Value(true), updatedAt: Value(DateTime.now())));
    await db.enqueueSync('students', id, op: 'delete');
  }
}

String studentDisplayName(Student s) {
  if (s.name.isNotEmpty) return s.name;
  if (s.rollNo.isNotEmpty) return '${tr('Roll No.', 'رول نمبر')} ${s.rollNo}';
  return s.code;
}
