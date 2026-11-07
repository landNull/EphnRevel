# ephnrevel: d7-migration

- app: ephnrevel (project root: the EphnRevel checkout, default `~/Apps/EphnRevel` on Termux = `/root/Apps/EphnRevel` in the container; the repo is github.com/landNull/EphnRevel)
- created: 2026-11-07
- status: act

## Current state

File 3 of 4 in the EphnRevel data-center series. Run only after `ephnrevel.arcadedb-index.20261107-195400.md` verifies green (the migration MUST flow through the index-aware write path, so nothing is refactored later). Series order: theme-machine-shell → arcadedb-index → d7-migration → public-websites.

Verified repo facts (re-verify on disk; stop-and-report on conflict): Elixir ~1.16, Phoenix ~1.7.14, Ecto + ecto_sqlite3 (dev), Bandit, Jason, Req. Graph store: `nodes` {id, type, title, payload, external_id} + `links` {kind, source_id, target_id}; `external_id` is the idempotency key for this migration. `lib/ephnrevel/graph.ex` pure core; `mix revelctl` exists (create/list/board/query). `revel.settings.json` = canonical brief, no secrets, decisions update it first then the ledger. Ledger `planning/projects.json`, columns todo/doing/done/parked. After M5/M6: Theme Machine shell + ArcadeDB derived index live, feature docs 016-020.

**Why direct, not via Backdrop:** the D7 → Backdrop path is an in-place CMS upgrade for people staying on a CMS. EphnRevel replaces the CMS, so the intermediate hop would only add a format conversion plus a second custom exporter. The D7 MySQL database becomes a source EphnRevel points at: one ETL into a generic node graph, rerunnable.

**Key dependency:** MyXQL, the MySQL 5.5+ driver for Elixir from the elixir-ecto organization, Apache 2.0, OSFCU-clean, works as an Ecto adapter. It is added ONLY as a read-only second Repo; the D7 database is never written.

**No secrets rule:** the D7 connection settings come exclusively from env vars (`D7_DB_HOST`, `D7_DB_PORT`, `D7_DB_NAME`, `D7_DB_USER`, `D7_DB_PASSWORD`). Nothing about the D7 database goes into `revel.settings.json` or any committed file.

## What to do

Work milestone M7. Nodes `doing` before acting; `done` + `payload.done_on` only after verification. Add M7 ("Drupal 7 data migration") milestone node, task nodes, and this file as a task node with external_id = this exact filename, payload.kind `promptfile`.

1. **Read-only D7 Repo:** add myxql to mix.exs (dev/test envs are enough); `EphnRevel.D7Repo` configured from env vars only; read-only by convention (the ETL never issues writes against it).
2. **Type mapping definition:** `priv/definitions/migrations/d7.json`: per-D7-content-type → EphnRevel node type (default: unrecognized types → `content`), field-machine-name → payload-key rules, and the reference-field list that become links. This file is data, reviewable as a diff, editable later without code changes.
3. **ETL verb:** `mix revelctl migrate drupal7` with `--dry-run` (report only, zero writes) and full mode. Extraction from standard D7 tables: `node` + `node_revision` (title, created/changed as ISO-8601, status, promote), `field_data_*` per the mapping (raw values into payload JSON; text formats recorded, not executed), `users` (→ user nodes, external_id `d7/user/<uid>`), `taxonomy_term_data` + `taxonomy_vocabulary` (terms → nodes; term references → links kind `references`; vocabularies recorded in payload), `file_managed` (→ file nodes, external_id `d7/file/<fid>`; payload records the URI and filename - files are NOT copied in this milestone), `menu_links` + `book` (→ links kind `contains` and `menu`), `url_alias` (→ payload.path). Content nodes get external_id `d7/node/<nid>` and payload.status mapped to the existing draft/published flow (D7 status 1 → `published`, 0 → `draft`).
4. **Idempotency:** upsert keyed on external_id. Rerunning never duplicates; unchanged rows are skipped; changed rows update payload and report as updated.
5. **Reconciliation report:** per-entity-type counts (D7 side vs imported side), created/updated/skipped totals, unmapped-field warnings with machine names named. Any count mismatch = hard failure naming the type and both counts.
6. **Settings + docs:** decision to `revel.settings.json` first (direct D7 → Revel ETL, MyXQL read-only second Repo, external_id idempotence, env-only credentials; Backdrop hop removed), mirror in the ledger; feature doc `docs/features/021-d7-migration.md` + `docs/how-to/migrate-drupal7.md`, linked from outline.md.

## Build + verify

Baseline `mix test` green. All verifications use a copy or snapshot of the D7 database, never production.

1. `--dry-run` against the real D7 database: report prints, zero writes (node count unchanged - prove it).
2. Full run: reconciliation report shows matching counts per type; spot-check three nodes of different types in the Board (title, fields, status, path alias all correct).
3. Rerun: 0 created, 0 unexpected updates; idempotency proven.
4. If ArcadeDB is configured: after the run, `mix revelctl index status` counts match the DB (the migration flowed through the index-aware path with no index-specific code in the ETL).
5. `mix revelctl query cypher` returns a D7 menu chain (contains links) end to end.
6. No D7 credentials anywhere in the repo (`grep -r "D7_DB" --exclude-dir=priv/static` clean except docs naming the env vars). Ledger M7 truthful; final table printed. Agent branch commit, never main, Signed-off-by.

Rules: plain English; complete files, never partial diffs; diagnostics before fixes, read actual output; never suggest alternative setups; stop-and-report on conflicts. If the D7 database is not reachable yet, complete all code + tests against a small synthetic D7 fixture DB (create it in test/support), and run live checks when the real database is available.