-- v3.1.1 — Run-level share
-- Eén share-link voor een hele bulk-run, zodat de collega in één keer foto's
-- kan uploaden voor alle mockups in dezelfde campagne.
-- Token wordt op alle rows van de run gezet (handmatig synchroon gehouden vanuit
-- de Edge Function), zodat we geen extra tabel nodig hebben.

alter table public.designs_v3 add column if not exists run_share_token text;
alter table public.designs_v3 add column if not exists run_share_expires_at timestamptz;

create index if not exists idx_designs_v3_run_share_token
    on public.designs_v3(run_share_token)
    where run_share_token is not null;
