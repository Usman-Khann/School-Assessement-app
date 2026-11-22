# Offline-first sync design (prepared, cloud side NOT implemented)

## What exists in the app today
- Every tenant row has a client-generated UUID primary key and a `schoolId`.
- Every local write to students / school / teacher / attempts calls `AppDatabase.enqueueSync`,
  which adds one row to the `SyncQueue` outbox (one pending row per entity + id).
- `SyncEngine.run()` walks the outbox and calls `CloudBackend.push(entity, id, op, payload)`.
  It runs automatically when connectivity returns (`App._setOnline`).
- `CloudBackend` currently is `NotConfiguredBackend`, so nothing is uploaded and the outbox just grows.
- Local rows are never deleted by sync. A failed push marks the outbox row `failed` with the error and retries next time.

## What the next phase must add
1. `SupabaseBackend implements CloudBackend` using `supabase_flutter` with the project URL and the
   **anon** key (safe to ship). Never ship the service-role key or any AI provider key.
2. Optional sign-in (Supabase Auth). On first sign-in, attach the guest school to the account:
   insert the local `schools` row with `owner = auth.uid()` and then run the outbox.
3. Pull (download) of rows changed on other devices: keep `last_pulled_at` per table in `AppSettings`
   and fetch `updated_at > last_pulled_at`.

## Rules
- **Idempotent upserts** keyed by UUID (`on conflict (id) do update`) so retries never duplicate.
- **Attempts and answers are insert-only** (`on conflict do nothing`): history can never be overwritten.
- **Students / school / teacher: last-write-wins** on `updated_at`; a soft `deleted` flag instead of deletes.
- **Tenant isolation** by Row Level Security: a user can only read/write rows whose `school_id`
  belongs to a school they are a member of (see `supabase_schema.sql`).
- Textbook PDFs go to Supabase Storage; the question bank is shared content (read-only for teachers).

## AI question generation
`RemoteQuestionGenerator` posts chapter text to a server endpoint (e.g. a Supabase Edge Function)
that holds the AI key and returns a question pack (see QUESTION_PACK_FORMAT.md). The pack is imported
with `source: 'ai'`, `verified: false`, and should be reviewed by a teacher before use.
