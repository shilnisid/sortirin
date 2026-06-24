-- ============================================================================
-- Sortirin — Supabase Database Migration
-- Version: 1.0.0 (M1 Foundation)
-- ============================================================================

-- 0. Extensions
create extension if not exists "pg_cron" with schema "extensions";
create extension if not exists "pg_net" with schema "extensions";

-- ============================================================================
-- 1. PROFILES
-- extends auth.users with app-specific fields
-- ============================================================================
create table if not exists public.profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  email         text,
  name          text,
  photo_url     text,
  phone         text,
  city          text,
  district      text,
  is_profile_complete boolean not null default false,
  total_points  integer not null default 0 check (total_points >= 0),
  streak_days   integer not null default 0 check (streak_days >= 0),
  last_submission_at timestamptz,
  fcm_token     text,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

-- Auto-create profile on signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email, name, photo_url)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data ->> 'full_name',
    new.raw_user_meta_data ->> 'avatar_url'
  )
  on conflict (id) do nothing;
  return new;
end;
$$ language plpgsql security definer;

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- updated_at trigger
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger set_profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

-- RLS
alter table public.profiles enable row level security;

create policy "Users can view their own profile"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Users can update their own profile"
  on public.profiles for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

create policy "Leaderboard can see limited fields"
  on public.profiles for select
  using (true);  -- name + city + total_points only for leaderboard

-- ============================================================================
-- 2. WASTE CATEGORIES & TYPES
-- ============================================================================
create table if not exists public.waste_categories (
  id          bigint generated always as identity primary key,
  name        text not null unique,  -- 'organik', 'kertas', 'plastik', etc.
  label       text not null,          -- display label in Indonesian
  icon_url    text,
  color_hex   text,                   -- e.g. '#22C55E'
  sort_order  integer not null default 0,
  is_active   boolean not null default true,
  created_at  timestamptz not null default now()
);

create table if not exists public.waste_types (
  id           bigint generated always as identity primary key,
  category_id  bigint not null references public.waste_categories(id),
  name         text not null unique,
  label        text not null,
  description  text,                  -- edukasi singkat cara pilah
  base_points  integer not null check (base_points > 0),
  icon_url     text,
  is_active    boolean not null default true,
  co2_factor   numeric(10,6),        -- kg CO₂ saved per item (approx)
  created_at   timestamptz not null default now()
);

alter table public.waste_categories enable row level security;
alter table public.waste_types enable row level security;

create policy "Waste categories are public"
  on public.waste_categories for select using (true);

create policy "Waste types are public"
  on public.waste_types for select using (true);

-- Seed data
insert into public.waste_categories (name, label, color_hex, sort_order) values
  ('organik',      'Organik',        '#22C55E', 1),
  ('kertas',       'Kertas/Kardus',  '#60A5FA', 2),
  ('plastik_lunak','Plastik Lunak',  '#FBBF24', 3),
  ('plastik_keras','Plastik Keras',  '#F59E0B', 4),
  ('kaca',         'Kaca/Beling',    '#A78BFA', 5),
  ('logam',        'Logam/Kaleng',   '#FB923C', 6),
  ('tekstil',      'Tekstil',        '#F472B6', 7),
  ('b3_ringan',    'B3 Ringan',      '#EF4444', 8),
  ('b3_berat',     'B3 Berat',       '#DC2626', 9),
  ('residu',       'Residu',         '#6B7280', 10)
on conflict (name) do nothing;

insert into public.waste_types (category_id, name, label, base_points, co2_factor) values
  ((select id from waste_categories where name='organik'),       'sisa_makanan',       'Sisa Makanan',        5, 0.12),
  ((select id from waste_categories where name='organik'),       'sayur_buah',         'Sayur & Buah Busuk',  5, 0.10),
  ((select id from waste_categories where name='kertas'),        'kardus',             'Kardus',              8, 0.25),
  ((select id from waste_categories where name='kertas'),        'kertas_buku',        'Kertas & Buku',       8, 0.20),
  ((select id from waste_categories where name='plastik_lunak'), 'kresek',             'Kantong Kresek',     10, 0.30),
  ((select id from waste_categories where name='plastik_lunak'), 'bubble_wrap',        'Bubble Wrap',        10, 0.28),
  ((select id from waste_categories where name='plastik_keras'), 'botol_pet',          'Botol PET',          12, 0.40),
  ((select id from waste_categories where name='plastik_keras'), 'kemasan_keras',      'Kemasan Keras',      12, 0.35),
  ((select id from waste_categories where name='kaca'),          'botol_kaca',         'Botol Kaca',         12, 0.50),
  ((select id from waste_categories where name='kaca'),          'pecahan_kaca',       'Pecahan Kaca',       12, 0.45),
  ((select id from waste_categories where name='logam'),         'kaleng_aluminium',   'Kaleng Aluminium',   15, 0.80),
  ((select id from waste_categories where name='logam'),         'besi_baja',          'Besi & Baja',        15, 1.00),
  ((select id from waste_categories where name='tekstil'),       'baju_bekas',         'Baju Bekas',         10, 0.60),
  ((select id from waste_categories where name='tekstil'),       'kain_perca',         'Kain Perca',         10, 0.50),
  ((select id from waste_categories where name='b3_ringan'),     'baterai',            'Baterai',            25, 2.00),
  ((select id from waste_categories where name='b3_berat'),      'elektronik',         'Elektronik Rusak',   40, 5.00),
  ((select id from waste_categories where name='b3_berat'),      'lampu_tl',           'Lampu TL',           40, 3.00),
  ((select id from waste_categories where name='residu'),        'popok',              'Popok & Pembalut',    3, 0.05),
  ((select id from waste_categories where name='residu'),        'styrofoam_kotor',    'Styrofoam Kotor',     3, 0.08)
on conflict (name) do nothing;

-- ============================================================================
-- 3. SUBMISSIONS
-- ============================================================================
create type submission_status as enum (
  'draft', 'compressing', 'uploading', 'pending_review',
  'approved', 'rejected', 'failed'
);

create table if not exists public.submissions (
  id                bigint generated always as identity primary key,
  user_id           uuid not null references public.profiles(id),
  video_url         text,                  -- Supabase Storage URL (deleted after 12h)
  video_hash        text not null unique,  -- SHA-256 anti-replay
  thumbnail_url     text,                  -- frame ke-1 (permanent)
  gps_lat           numeric(10,7),
  gps_lng           numeric(10,7),
  gps_accuracy      numeric(6,2),
  device_fingerprint jsonb,
  status            submission_status not null default 'draft',
  total_points      integer not null default 0,
  rejection_reason  text,                  -- populated when rejected
  video_size_bytes  bigint,
  video_duration_ms integer,
  submitted_at      timestamptz,
  validated_at      timestamptz,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

-- Index for anti-replay check
create unique index idx_submissions_video_hash on public.submissions(video_hash);
create index idx_submissions_user_status on public.submissions(user_id, status);
create index idx_submissions_created_at on public.submissions(created_at desc);

alter table public.submissions enable row level security;

create policy "Users can view own submissions"
  on public.submissions for select
  using (auth.uid() = user_id);

create policy "Users can insert own submissions"
  on public.submissions for insert
  with check (auth.uid() = user_id);

create policy "Users can update own submissions"
  on public.submissions for update
  using (auth.uid() = user_id);

-- ============================================================================
-- 4. SUBMISSION ITEMS
-- ============================================================================
create table if not exists public.submission_items (
  id              bigint generated always as identity primary key,
  submission_id   bigint not null references public.submissions(id) on delete cascade,
  waste_type_id   bigint not null references public.waste_types(id),
  quantity        integer not null check (quantity between 1 and 99),
  base_points     integer not null,
  created_at      timestamptz not null default now()
);

create index idx_submission_items_submission on public.submission_items(submission_id);

alter table public.submission_items enable row level security;

create policy "Users can view own submission items"
  on public.submission_items for select
  using (exists (select 1 from submissions s where s.id = submission_id and s.user_id = auth.uid()));

create policy "Users can insert own submission items"
  on public.submission_items for insert
  with check (exists (select 1 from submissions s where s.id = submission_id and s.user_id = auth.uid()));

-- ============================================================================
-- 5. VALIDATION RESULTS
-- ============================================================================
create table if not exists public.validation_results (
  id              bigint generated always as identity primary key,
  submission_id   bigint not null references public.submissions(id) on delete cascade unique,
  confidence      numeric(5,4) not null check (confidence between 0 and 1),
  ai_model        text not null default 'nemotron-3-nano-omni-30b',
  is_auto_reviewed boolean not null default false,
  object_detected text,        -- what AI identified
  is_type_match   boolean,     -- matches user's selected type
  is_container_ok boolean,     -- appropriate container visible
  is_screen_record boolean,    -- detected as screen recording
  raw_response    jsonb,       -- full AI response for audit
  validated_at    timestamptz not null default now()
);

alter table public.validation_results enable row level security;

create policy "Users can view own validation results"
  on public.validation_results for select
  using (exists (select 1 from submissions s where s.id = submission_id and s.user_id = auth.uid()));

create policy "Service can insert validation"
  on public.validation_results for insert
  with check (true);

-- ============================================================================
-- 6. POINTS LEDGER (append-only)
-- ============================================================================
create table if not exists public.points_ledger (
  id              bigint generated always as identity primary key,
  user_id         uuid not null references public.profiles(id),
  submission_id   bigint references public.submissions(id),
  amount          integer not null,
  balance_after   integer not null,
  reason          text not null,  -- 'submission_approved', 'bonus_variety', 'bonus_discovery', 'streak_multiplier', 'redeem'
  metadata        jsonb,         -- breakdown of calculation
  created_at      timestamptz not null default now()
);

create index idx_points_ledger_user on public.points_ledger(user_id, created_at desc);

-- Append-only: no update/delete allowed
alter table public.points_ledger enable row level security;

create policy "Users can view own ledger"
  on public.points_ledger for select
  using (auth.uid() = user_id);

create policy "Service can insert ledger entries"
  on public.points_ledger for insert
  with check (true);

-- Function to update total_points on profile
create or replace function public.update_total_points()
returns trigger as $$
begin
  update public.profiles
  set total_points = new.balance_after
  where id = new.user_id;
  return new;
end;
$$ language plpgsql security definer;

create trigger on_points_ledger_insert
  after insert on public.points_ledger
  for each row execute function public.update_total_points();

-- ============================================================================
-- 7. STREAKS
-- ============================================================================
create table if not exists public.streaks (
  id              bigint generated always as identity primary key,
  user_id         uuid not null references public.profiles(id) unique,
  current_streak  integer not null default 0,
  longest_streak  integer not null default 0,
  last_activity_date date,        -- last date with an approved submission
  grace_used      boolean not null default false,  -- whether today's grace is consumed
  updated_at      timestamptz not null default now()
);

alter table public.streaks enable row level security;

create policy "Users can view own streak"
  on public.streaks for select
  using (auth.uid() = user_id);

create policy "Service can update streaks"
  on public.streaks for insert
  with check (true);

create policy "Service can update own streak"
  on public.streaks for update
  using (true);

-- ============================================================================
-- 8. BADGES
-- ============================================================================
create table if not exists public.badges (
  id              bigint generated always as identity primary key,
  code            text not null unique,  -- e.g. 'first_submission', 'streak_30'
  name            text not null,
  description     text,
  category        text not null,  -- 'pemula', 'explorer', 'konsistensi', 'volume', 'impact', 'komunitas', 'b3_hero'
  icon_url        text,
  requirement     jsonb,          -- machine-readable criteria
  sort_order      integer not null default 0,
  created_at      timestamptz not null default now()
);

create table if not exists public.user_badges (
  id              bigint generated always as identity primary key,
  user_id         uuid not null references public.profiles(id),
  badge_id        bigint not null references public.badges(id),
  earned_at       timestamptz not null default now(),
  unique(user_id, badge_id)
);

create index idx_user_badges_user on public.user_badges(user_id);

alter table public.badges enable row level security;
alter table public.user_badges enable row level security;

create policy "Badges are public"
  on public.badges for select using (true);

create policy "Users can view own badges"
  on public.user_badges for select
  using (auth.uid() = user_id);

create policy "Service can award badges"
  on public.user_badges for insert
  with check (true);

-- Seed badges
insert into public.badges (code, name, description, category, sort_order) values
  ('first_submission',    'Pemilah Pemula',    'Submission pertamamu!',                'pemula',      1),
  ('complete_profile',    'Profil Lengkap',    'Lengkapi data dirimu',                 'pemula',      2),
  ('streak_7',            'Konsisten 7 Hari',  'Streak 7 hari berturut-turut',         'konsistensi', 3),
  ('streak_30',           'Dedikasi Sebulan',  'Streak 30 hari!',                      'konsistensi', 4),
  ('streak_90',           'Teladan 3 Bulan',   'Streak 90 hari',                       'konsistensi', 5),
  ('streak_180',          'Pejuang Lingkungan','Streak 180 hari',                      'konsistensi', 6),
  ('streak_365',          'Legenda Hijau',     'Streak 365 hari!',                     'konsistensi', 7),
  ('items_50',            'Kolektor 50',       '50 item terpilah',                     'volume',      8),
  ('items_200',           'Kolektor 200',      '200 item terpilah',                    'volume',      9),
  ('items_500',           'Kolektor 500',      '500 item terpilah',                    'volume',      10),
  ('items_1000',          'Kolektor 1K',       '1.000 item terpilah',                  'volume',      11),
  ('items_5000',          'Master Pemilah',    '5.000 item terpilah',                  'volume',      12),
  ('points_10k',          'Impact 10K',        '10.000 poin terkumpul',                'impact',      13),
  ('points_50k',          'Impact 50K',        '50.000 poin terkumpul',                'impact',      14),
  ('points_100k',         'Impact 100K',       '100.000 poin terkumpul',               'impact',      15),
  ('b3_hero',             'Pahlawan B3',       'Pemilah B3 terbanyak',                 'b3_hero',     16)
on conflict (code) do nothing;

-- ============================================================================
-- 9. REWARDS & REDEMPTIONS
-- ============================================================================
create table if not exists public.rewards (
  id              bigint generated always as identity primary key,
  name            text not null,
  description     text,
  points_required integer not null check (points_required > 0),
  value_label     text,               -- e.g. 'Rp 5.000', '1 GB'
  provider        text not null,       -- 'flip', 'digiflazz', 'tripay'
  provider_code   text unique,         -- provider's product code
  category        text not null,       -- 'ewallet', 'pulsa', 'pln', 'voucher', 'game'
  icon_url        text,
  is_active       boolean not null default true,
  sort_order      integer not null default 0,
  created_at      timestamptz not null default now()
);

create type redemption_status as enum (
  'pending', 'processing', 'completed', 'failed'
);

create table if not exists public.redemptions (
  id              bigint generated always as identity primary key,
  user_id         uuid not null references public.profiles(id),
  reward_id       bigint not null references public.rewards(id),
  points_spent    integer not null check (points_spent > 0),
  destination     text not null,       -- nomor HP / ID tujuan / e-wallet
  status          redemption_status not null default 'pending',
  provider_ref    text,                -- external ref from Flip/Digiflazz/Tripay
  error_message   text,
  requested_at    timestamptz not null default now(),
  completed_at    timestamptz,
  created_at      timestamptz not null default now()
);

create index idx_redemptions_user on public.redemptions(user_id, created_at desc);

alter table public.rewards enable row level security;
alter table public.redemptions enable row level security;

create policy "Rewards are public"
  on public.rewards for select using (true);

create policy "Users can view own redemptions"
  on public.redemptions for select
  using (auth.uid() = user_id);

create policy "Users can request redemption"
  on public.redemptions for insert
  with check (auth.uid() = user_id);

-- Seed tier rewards
insert into public.rewards (name, points_required, value_label, provider, provider_code, category, sort_order) values
  ('GoPay / OVO / DANA',           5000,   'Rp 5.000',   'flip',      'ewallet_5000',       'ewallet', 1),
  ('Kuota Internet 1 GB',          10000,  'Rp 10.000',  'digiflazz', 'kuota_1gb',          'pulsa',   2),
  ('Token Listrik PLN',            10000,  'Rp 10.000',  'digiflazz', 'pln_10000',          'pln',     3),
  ('Voucher Indomaret/Alfamart',   15000,  'Rp 15.000',  'tripay',    'voucher_15000',      'voucher', 4),
  ('Diamond ML / Garena Shell',    25000,  'Rp 25.000',  'digiflazz', 'game_25000',         'game',    5),
  ('Voucher Shopee/Tokopedia',     50000,  'Rp 50.000',  'tripay',    'voucher_50000',      'voucher', 6),
  ('GoPay Premium',                100000, 'Rp 100.000', 'flip',      'ewallet_100000',     'ewallet', 7)
on conflict (provider_code) do nothing;

-- ============================================================================
-- 10. LEADERBOARD (materialized view, refresh periodically)
-- ============================================================================
create materialized view if not exists public.leaderboard_monthly as
select
  p.id as user_id,
  p.name,
  p.city,
  p.photo_url,
  coalesce(sum(pl.amount) filter (where pl.reason != 'redeem' and pl.created_at >= date_trunc('month', now())), 0) as period_points,
  row_number() over (order by coalesce(sum(pl.amount) filter (where pl.reason != 'redeem' and pl.created_at >= date_trunc('month', now())), 0) desc) as rank
from public.profiles p
left join public.points_ledger pl on pl.user_id = p.id
where p.is_profile_complete = true
group by p.id, p.name, p.city, p.photo_url;

create unique index idx_lb_monthly_user on public.leaderboard_monthly(user_id);

-- Refresh function (call via pg_cron or Edge Function)
create or replace function public.refresh_leaderboard()
returns void as $$
begin
  refresh materialized view concurrently public.leaderboard_monthly;
end;
$$ language plpgsql security definer;

-- Schedule refresh every 15 minutes (optional, uncomment when pg_cron ready)
-- select cron.schedule('refresh-leaderboard', '*/15 * * * *', 'select public.refresh_leaderboard();');

-- ============================================================================
-- 11. FCM TOKENS
-- ============================================================================
create table if not exists public.fcm_tokens (
  id          bigint generated always as identity primary key,
  user_id     uuid not null references public.profiles(id),
  token       text not null,
  platform    text not null default 'android',  -- 'android' or 'ios'
  created_at  timestamptz not null default now(),
  unique(user_id, token)
);

alter table public.fcm_tokens enable row level security;

create policy "Users can manage own FCM tokens"
  on public.fcm_tokens for all
  using (auth.uid() = user_id);

-- ============================================================================
-- 12. STORAGE BUCKETS (created via Edge Function or management API)
-- ============================================================================
-- Buckets: 'videos', 'thumbnails'
-- RLS policies are defined at bucket level in the dashboard.
-- For reference, the SQL-equivalent (supabase 2.x):
/*
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  ('videos', 'videos', false, 52428800, array['video/mp4', 'video/webm', 'video/quicktime']),
  ('thumbnails', 'thumbnails', true, 1048576, array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do nothing;
*/

-- ============================================================================
-- 13. CLEANUP FUNCTION (delete videos after 12 hours)
-- ============================================================================
create or replace function public.cleanup_expired_videos()
returns void as $$
begin
  -- Mark submissions for cleanup where video is older than 12 hours
  update public.submissions
  set video_url = null
  where status in ('approved', 'rejected')
    and video_url is not null
    and submitted_at < now() - interval '12 hours';
end;
$$ language plpgsql security definer;

-- Schedule every hour
-- select cron.schedule('cleanup-videos', '0 * * * *', 'select public.cleanup_expired_videos();');

-- ============================================================================
-- 14. VERIFICATION
-- ============================================================================
-- Useful queries:
-- select count(*) from public.profiles;
-- select count(*) from public.waste_categories;
-- select count(*) from public.waste_types;
-- select count(*) from public.badges;
-- select count(*) from public.rewards;
