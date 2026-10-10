-- Jalankan sekali di Supabase: SQL Editor → New query → tempel → Run

-- 1) Tabel riwayat undian (2 baris: tahap1 dan tahap2)
create table if not exists public.undian_live (
  id         text primary key check (id in ('tahap1','tahap2')),
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

insert into public.undian_live (id, data) values
  ('tahap1', '{"drawn": []}'),
  ('tahap2', '{"items": []}')
on conflict (id) do nothing;

-- 2) Keamanan: semua orang boleh membaca, hanya admin yang login boleh menulis
alter table public.undian_live enable row level security;

drop policy if exists "baca publik" on public.undian_live;
create policy "baca publik" on public.undian_live
  for select to anon, authenticated using (true);

drop policy if exists "admin menulis" on public.undian_live;
create policy "admin menulis" on public.undian_live
  for insert to authenticated with check (true);

drop policy if exists "admin mengubah" on public.undian_live;
create policy "admin mengubah" on public.undian_live
  for update to authenticated using (true) with check (true);

-- 3) Aktifkan realtime agar /riwayat langsung berubah
do $$ begin
  alter publication supabase_realtime add table public.undian_live;
exception when duplicate_object then null; end $$;
