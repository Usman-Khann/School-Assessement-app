import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Schools,
  Teachers,
  Students,
  Textbooks,
  Chapters,
  Topics,
  Questions,
  Attempts,
  AttemptAnswers,
  Papers,
  SyncQueue,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'school_assess'));
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(textbooks, textbooks.remoteFile);
            await m.addColumn(textbooks, textbooks.remoteBytes);
            await m.addColumn(questions, questions.reviewNote);
          }
        },
      );

  /// Adds a change to the sync outbox. A still-pending entry for the same
  /// row is reused so repeated edits don't create duplicate uploads.
  Future<void> enqueueSync(String entity, String entityId,
      {String op = 'upsert'}) async {
    final existing = await (select(syncQueue)
          ..where((t) =>
              t.entity.equals(entity) &
              t.entityId.equals(entityId) &
              t.status.isNotValue('done')))
        .get();
    if (existing.isNotEmpty) {
      await (update(syncQueue)..where((t) => t.id.equals(existing.first.id)))
          .write(SyncQueueCompanion(
              op: Value(op),
              status: const Value('pending'),
              createdAt: Value(DateTime.now())));
      return;
    }
    await into(syncQueue).insert(SyncQueueCompanion.insert(
        entity: entity, entityId: entityId, op: op, createdAt: DateTime.now()));
  }

  Future<String?> getSetting(String key) async {
    final r = await (select(appSettings)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return r?.value;
  }

  Future<void> setSetting(String key, String value) => into(appSettings)
      .insertOnConflictUpdate(AppSettingsCompanion.insert(key: key, value: value));
}
