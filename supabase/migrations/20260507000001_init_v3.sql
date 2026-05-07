-- SocialFrame v3 — eigen designs-tabel
-- Brand kits zijn gedeeld met v2 (zelfde brand_kits-tabel).
-- Designs zijn versie-specifiek zodat v2's library niet besmet wordt.

create table if not exists public.designs_v3 (
  id text primary key,
  platform_id text,
  format_id text,
  content jsonb,
  style jsonb,
  date text,
  created_at timestamptz default now()
);

alter table public.designs_v3 enable row level security;
-- Geen policies = geen direct anon-toegang. Alleen via Edge Function (service-role).
