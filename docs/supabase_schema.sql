-- DRAFT cloud schema mirroring the local Drift tables. Not yet applied or tested.

create table schools (
  id uuid primary key,
  name text not null default '',
  district text not null default '',
  tehsil text not null default '',
  updated_at timestamptz not null default now()
);

-- Which signed-in users belong to which school, and in what role.
create table school_members (
  school_id uuid not null references schools(id),
  user_id uuid not null references auth.users(id),
  role text not null check (role in ('teacher','principal','admin')),
  primary key (school_id, user_id)
);

create table teachers (
  id uuid primary key,
  school_id uuid not null references schools(id),
  name text not null default '',
  updated_at timestamptz not null default now()
);

create table students (
  id uuid primary key,
  school_id uuid not null references schools(id),
  code text not null,
  name text not null default '',
  roll_no text not null default '',
  grade int not null check (grade between 3 and 10),
  section text not null default '',
  academic_year text not null default '',
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted boolean not null default false
);

create table attempts (
  id uuid primary key,
  school_id uuid not null references schools(id),
  session_id uuid not null,
  student_id uuid not null references students(id),
  grade int not null,
  subject text not null,
  textbook_id uuid not null,
  textbook_title text not null default '',
  feedback_mode text not null,
  practice boolean not null default false,
  chapter_ids jsonb not null default '[]',
  topic_ids jsonb not null default '[]',
  started_at timestamptz not null,
  finished_at timestamptz not null,
  total int not null,
  correct int not null,
  percentage real not null,
  time_taken_sec int not null,
  feedback text not null default ''
);

create table attempt_answers (
  id uuid primary key,
  attempt_id uuid not null references attempts(id),
  student_id uuid not null references students(id),
  question_id uuid not null,
  chapter_id uuid not null,
  topic_id uuid,
  order_no int not null,
  snapshot jsonb not null,
  selected_index int,
  correct_index int not null,
  is_correct boolean not null,
  time_sec int not null default 0
);

-- Tenant isolation: members see only their own school's rows.
alter table schools enable row level security;
alter table school_members enable row level security;
alter table teachers enable row level security;
alter table students enable row level security;
alter table attempts enable row level security;
alter table attempt_answers enable row level security;

create function is_member(sid uuid) returns boolean language sql security definer stable as
$$ select exists (select 1 from school_members m where m.school_id = sid and m.user_id = auth.uid()) $$;

create policy members_self on school_members for select using (user_id = auth.uid());
create policy school_rw on schools for all using (is_member(id)) with check (is_member(id));
create policy teachers_rw on teachers for all using (is_member(school_id)) with check (is_member(school_id));
create policy students_rw on students for all using (is_member(school_id)) with check (is_member(school_id));
-- History is insert-only: no update/delete policies.
create policy attempts_read on attempts for select using (is_member(school_id));
create policy attempts_insert on attempts for insert with check (is_member(school_id));
create policy answers_read on attempt_answers for select
  using (exists (select 1 from attempts a where a.id = attempt_id and is_member(a.school_id)));
create policy answers_insert on attempt_answers for insert
  with check (exists (select 1 from attempts a where a.id = attempt_id and is_member(a.school_id)));
