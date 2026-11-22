import 'package:drift/drift.dart';

/// All primary keys are client-generated UUID strings so that rows created
/// offline on different devices can later be merged in the cloud without
/// collisions. `schoolId` scopes tenant data (multi-school ready).

class Schools extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get district => text().withDefault(const Constant(''))();
  TextColumn get tehsil => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class Teachers extends Table {
  TextColumn get id => text()();
  TextColumn get schoolId => text()();
  TextColumn get name => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class Students extends Table {
  TextColumn get id => text()();
  TextColumn get schoolId => text()();

  /// Short human-readable internal ID, e.g. STU-4F9A2C.
  TextColumn get code => text()();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get rollNo => text().withDefault(const Constant(''))();
  IntColumn get grade => integer()();
  TextColumn get section => text().withDefault(const Constant(''))();
  TextColumn get academicYear => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class Textbooks extends Table {
  TextColumn get id => text()();

  /// Groups successive versions/editions of the same book.
  TextColumn get seriesId => text()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  /// True for the most recently imported version in its series.
  BoolColumn get isCurrent => boolean().withDefault(const Constant(true))();

  /// True when the teacher/admin has marked this version as the officially
  /// applicable syllabus book for [academicYear]. Independent of [isCurrent].
  BoolColumn get isApplicable => boolean().withDefault(const Constant(false))();
  IntColumn get grade => integer()();
  TextColumn get subject => text()();
  TextColumn get title => text()();
  TextColumn get academicYear => text().withDefault(const Constant(''))();
  TextColumn get edition => text().withDefault(const Constant(''))();
  TextColumn get publisher => text().withDefault(const Constant(''))();
  TextColumn get language => text().withDefault(const Constant('en'))();

  /// official_download | manual_upload | no_file | demo
  TextColumn get sourceType => text()();
  TextColumn get sourceUrl => text().withDefault(const Constant(''))();
  TextColumn get filePath => text().nullable()();
  TextColumn get fileSha256 => text().nullable()();
  IntColumn get fileSize => integer().nullable()();
  DateTimeColumn get importedAt => dateTime()();
  TextColumn get notes => text().withDefault(const Constant(''))();

  /// For books from the online content catalog: path of the PDF inside the
  /// content repository (e.g. books/g9_math.pdf) and its size in bytes.
  /// The PDF itself is only downloaded when the teacher asks for it.
  TextColumn get remoteFile => text().nullable()();
  IntColumn get remoteBytes => integer().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class Chapters extends Table {
  TextColumn get id => text()();
  TextColumn get textbookId => text()();
  IntColumn get number => integer()();
  TextColumn get title => text()();
  IntColumn get pageStart => integer().nullable()();
  IntColumn get pageEnd => integer().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class Topics extends Table {
  TextColumn get id => text()();
  TextColumn get chapterId => text()();
  IntColumn get orderNo => integer().withDefault(const Constant(0))();
  TextColumn get title => text()();
  IntColumn get pageStart => integer().nullable()();
  IntColumn get pageEnd => integer().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class Questions extends Table {
  TextColumn get id => text()();
  TextColumn get textbookId => text()();
  TextColumn get chapterId => text()();
  TextColumn get topicId => text().nullable()();
  IntColumn get grade => integer()();
  TextColumn get subject => text()();

  /// mcq | short | long | fill | tf
  TextColumn get type => text()();
  TextColumn get body => text()();

  /// JSON array of option strings (mcq: 4, tf: 2, others: empty).
  TextColumn get optionsJson => text().withDefault(const Constant('[]'))();
  IntColumn get correctIndex => integer().nullable()();

  /// Model answer / marking points for non-MCQ types.
  TextColumn get answer => text().withDefault(const Constant(''))();
  TextColumn get shortExplanation => text().withDefault(const Constant(''))();
  TextColumn get conceptExplanation => text().withDefault(const Constant(''))();

  /// Only set when verified against the textbook. Never guessed.
  IntColumn get pageRef => integer().nullable()();

  /// 1 easy, 2 medium, 3 hard
  IntColumn get difficulty => integer().withDefault(const Constant(2))();

  /// manual | import | ai | demo | elearn
  TextColumn get source => text().withDefault(const Constant('manual'))();

  /// Teacher-facing note when the original question was corrected.
  TextColumn get reviewNote => text().withDefault(const Constant(''))();
  BoolColumn get verified => boolean().withDefault(const Constant(false))();
  TextColumn get language => text().withDefault(const Constant('en'))();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

/// One row per student per subject per sitting. Never updated after saving.
class Attempts extends Table {
  TextColumn get id => text()();
  TextColumn get schoolId => text()();

  /// Groups the subjects assessed together in one sitting.
  TextColumn get sessionId => text()();
  TextColumn get studentId => text()();
  IntColumn get grade => integer()();
  TextColumn get subject => text()();
  TextColumn get textbookId => text()();
  TextColumn get textbookTitle => text().withDefault(const Constant(''))();

  /// immediate | end
  TextColumn get feedbackMode => text()();
  BoolColumn get practice => boolean().withDefault(const Constant(false))();
  TextColumn get chapterIdsJson => text().withDefault(const Constant('[]'))();
  TextColumn get topicIdsJson => text().withDefault(const Constant('[]'))();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime()();
  IntColumn get total => integer()();
  IntColumn get correct => integer()();
  RealColumn get percentage => real()();
  IntColumn get timeTakenSec => integer()();
  TextColumn get feedback => text().withDefault(const Constant(''))();
  @override
  Set<Column> get primaryKey => {id};
}

class AttemptAnswers extends Table {
  TextColumn get id => text()();
  TextColumn get attemptId => text()();
  TextColumn get studentId => text()();
  TextColumn get questionId => text()();
  TextColumn get chapterId => text()();
  TextColumn get topicId => text().nullable()();
  IntColumn get orderNo => integer()();

  /// Full copy of the question as shown (text, options in shown order,
  /// explanations, chapter/topic titles, page) so history stays readable
  /// even if the question bank or book is edited later.
  TextColumn get snapshotJson => text()();

  /// Index the student chose (in shown order); null = skipped.
  IntColumn get selectedIndex => integer().nullable()();
  IntColumn get correctIndex => integer()();
  BoolColumn get isCorrect => boolean()();
  IntColumn get timeSec => integer().withDefault(const Constant(0))();
  @override
  Set<Column> get primaryKey => {id};
}

class Papers extends Table {
  TextColumn get id => text()();
  TextColumn get schoolId => text()();
  TextColumn get title => text()();
  IntColumn get grade => integer()();
  TextColumn get subject => text()();
  TextColumn get textbookId => text()();
  TextColumn get configJson => text()();
  TextColumn get contentJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

/// Outbox of local changes waiting to be pushed to the cloud.
@DataClassName('SyncItem')
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entity => text()();
  TextColumn get entityId => text()();

  /// upsert | delete
  TextColumn get op => text()();
  DateTimeColumn get createdAt => dateTime()();

  /// pending | failed | done
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get tries => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().withDefault(const Constant(''))();
}

@DataClassName('AppSetting')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  @override
  Set<Column> get primaryKey => {key};
}
