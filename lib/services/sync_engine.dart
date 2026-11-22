import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../data/db/database.dart';

/// Cloud side of synchronisation. The real implementation (Supabase) is a
/// later phase; see docs/SYNC_DESIGN.md and docs/supabase_schema.sql.
///
/// IMPORTANT: implementations must talk to the backend using the signed-in
/// user's session (Supabase anon key + Row Level Security). No service-role
/// or AI provider secret may ever be shipped inside the app.
abstract class CloudBackend {
  bool get isConfigured;

  /// Idempotent upsert/delete keyed by the row's UUID, so retrying after a
  /// lost connection can never create duplicates.
  Future<void> push(
      String entity, String id, String op, Map<String, dynamic>? payload);
}

class NotConfiguredBackend implements CloudBackend {
  @override
  bool get isConfigured => false;
  @override
  Future<void> push(String e, String id, String op, Map<String, dynamic>? p) =>
      throw StateError('Cloud backend not configured');
}

class SyncStatus {
  final int pending;
  final int failed;
  final bool running;
  final DateTime? lastRun;
  const SyncStatus(
      {this.pending = 0, this.failed = 0, this.running = false, this.lastRun});
}

class SyncEngine {
  final AppDatabase db;
  CloudBackend backend;
  final ValueNotifier<SyncStatus> status = ValueNotifier(const SyncStatus());
  bool _running = false;
  DateTime? _lastRun;

  SyncEngine(this.db, [CloudBackend? backend])
      : backend = backend ?? NotConfiguredBackend();

  Future<void> refreshStatus() async {
    final rows = await db.select(db.syncQueue).get();
    status.value = SyncStatus(
        pending: rows.where((r) => r.status == 'pending').length,
        failed: rows.where((r) => r.status == 'failed').length,
        running: _running,
        lastRun: _lastRun);
  }

  Future<Map<String, dynamic>?> _payload(SyncItem it) async {
    switch (it.entity) {
      case 'students':
        return (await (db.select(db.students)
                  ..where((t) => t.id.equals(it.entityId)))
                .getSingleOrNull())
            ?.toJson();
      case 'schools':
        return (await (db.select(db.schools)
                  ..where((t) => t.id.equals(it.entityId)))
                .getSingleOrNull())
            ?.toJson();
      case 'teachers':
        return (await (db.select(db.teachers)
                  ..where((t) => t.id.equals(it.entityId)))
                .getSingleOrNull())
            ?.toJson();
      case 'attempts':
        final a = await (db.select(db.attempts)
              ..where((t) => t.id.equals(it.entityId)))
            .getSingleOrNull();
        if (a == null) return null;
        final ans = await (db.select(db.attemptAnswers)
              ..where((t) => t.attemptId.equals(a.id)))
            .get();
        return {...a.toJson(), 'answers': ans.map((e) => e.toJson()).toList()};
    }
    return null;
  }

  /// Pushes the outbox. Safe to call any time; does nothing while the cloud
  /// is not configured. Local rows are never deleted, whatever happens.
  Future<void> run() async {
    if (_running) return;
    if (!backend.isConfigured) return refreshStatus();
    _running = true;
    await refreshStatus();
    try {
      final items = await (db.select(db.syncQueue)
            ..where((t) => t.status.isNotValue('done'))
            ..orderBy([(t) => OrderingTerm(expression: t.id)]))
          .get();
      for (final it in items) {
        try {
          await backend.push(it.entity, it.entityId, it.op, await _payload(it));
          await (db.update(db.syncQueue)..where((t) => t.id.equals(it.id)))
              .write(const SyncQueueCompanion(
                  status: Value('done'), lastError: Value('')));
        } catch (e) {
          await (db.update(db.syncQueue)..where((t) => t.id.equals(it.id)))
              .write(SyncQueueCompanion(
                  status: const Value('failed'),
                  tries: Value(it.tries + 1),
                  lastError: Value('$e')));
        }
      }
    } finally {
      _running = false;
      _lastRun = DateTime.now();
      await refreshStatus();
    }
  }
}
