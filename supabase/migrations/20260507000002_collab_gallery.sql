-- v3.1 — Collaborative Gallery
-- Voegt share-token + bulk-run-tracking + awaiting_photo-flag toe aan designs_v3.

alter table public.designs_v3 add column if not exists share_token text;
alter table public.designs_v3 add column if not exists share_expires_at timestamptz;
alter table public.designs_v3 add column if not exists awaiting_photo boolean default false;
alter table public.designs_v3 add column if not exists bulk_run_id text;
alter table public.designs_v3 add column if not exists bulk_run_label text;

create unique index if not exists idx_designs_v3_share_token
    on public.designs_v3(share_token)
    where share_token is not null;

create index if not exists idx_designs_v3_bulk_run
    on public.designs_v3(bulk_run_id);
