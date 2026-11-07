# ephnrevel: arcadedb-index

- app: ephnrevel (project root: the EphnRevel checkout, default `~/Apps/EphnRevel` on Termux = `/root/Apps/EphnRevel` in the container; the repo is github.com/landNull/EphnRevel)
- created: 2026-11-07
- status: act

## Current state

File 2 of 4 in the EphnRevel data-center series. Run only after `ephnrevel.theme-machine-shell.20261107-195209.md` verifies green. Series order: theme-machine-shell → arcadedb-index → d7-migration → public-websites.

Verified repo facts (re-verify on disk before acting; stop-and-report on conflict): Elixir ~1.16, Phoenix ~1.7.14, LiveView ~1.0, Ecto + ecto_sqlite3 (dev) / Postgres (prod), Bandit, Jason, Req (HTTP client, already a dependency). Graph store: `nodes` `{id, type, title, payload, external_id}` + `links` `{kind, source_id, target_id}`. `lib/ephnrevel/graph.ex` is the pure core; `mix revelctl` exists. `revel.settings.json` is the canonical brief (no secrets; JSON wins; decisions update it first, then the ledger). Ledger: `planning/projects.json`, columns todo/doing/done/parked, roll-in rules in AGENTS.md. After M5: Theme Machine shell present, version 0.3.0, feature docs 016-019.

**Why this milestone exists (the decision):** ArcadeDB is in the architecture from the start, so nothing is refactored later. The pattern (family rule) still holds: ArcadeDB is a DERIVED, REBUILDABLE graph index. The source of truth stays the nodes/links tables (SQLite dev / Postgres prod). "From the start" means: the single domain write path is index-aware from its first commit and the Cypher query layer exists from day one, while the app fully boots and runs with the index absent (graceful degradation; tablet dev with SQLite only loses nothing).

**ArcadeDB facts:** Apache 2.0, OSFCU-clean. Java server (runs on knarr; NOT on the tablet - do not install Java in Termux for this). Serves HTTP/JSON API, binary, and Postgres wire protocols. EphnRevel talks to it over HTTP/JSON using Req (the dependency already present; no new deps required). Endpoint and credentials come from env vars only (`ARCADEDB_ENDPOINT`, `ARCADEDB_USER`, `ARCADEDB_PASSWORD`): never from `revel.settings.json` and never committed.

## What to do

Work milestone M6. Set nodes `doing` before acting; `done` + `payload.done_on` only after verification passes. Add M6 ("ArcadeDB derived index") milestone node, task nodes, and this file as a task node with external_id = this exact filename, payload.kind `promptfile`.

1. **Client module `EphnRevel.Graph.Index`:** HTTP/JSON client over Req; functions for upsert node, upsert link (vertices + edges), delete, count, and raw Cypher query. Endpoint/credentials from env; absent env = index disabled by configuration, not an error.
2. **Index-aware write path:** every node/link write in the domain layer also enqueues an index update (Erlang queue + GenServer drainer; non-blocking; an index failure is logged and marks the index stale, it NEVER fails the domain write). This is the no-refactor guarantee: all future features (including the D7 migration, next file) flow through this path automatically.
3. **Sync state:** in-memory + persisted sync state (last-ok, stale flag, last error) shown in the Revel-native persona admin and queryable via CLI.
4. **Rebuild and status verbs:** `mix revelctl index status` (endpoint, counts, stale flag) and `mix revelctl index rebuild` (wipe the EphnRevel database in ArcadeDB and re-index every node/link from the source of truth). Derived-and-rebuildable proven by test.
5. **Query surface:** `mix revelctl query cypher "<cypher>"` and `EphnRevel.Graph.query_cypher/2` for mindmap-style traversals (contains chains, reference neighborhoods). Plain-English error when the index is absent: name what is disabled and how to enable it.
6. **Graceful degradation test:** with no endpoint configured, `mix test` fully green and the app boots; with the endpoint configured but the server down, domain writes succeed, stale flag set, rebuild recovers.
7. **Ops docs:** `docs/how-to/arcadedb.md`: knarr deployment (Java, SysVinit service like Perseus's pattern, LAN-only), env vars, rebuild procedure. Add the decision to `revel.settings.json` first (ArcadeDB as derived rebuildable index, HTTP/JSON via Req, env-only credentials, graceful degradation), mirror in the ledger. Feature doc `docs/features/020-arcadedb-index.md`, linked from outline.md. Version stays 0.3.0 unless M6 ships separately from M5 (then 0.3.1).

## Build + verify

Baseline `mix test` green before starting; after each task; red suite stops the milestone.

1. No env vars set: app boots, all tests green, CLI prints the plain-English disabled notice.
2. Against a live ArcadeDB (knarr): `mix revelctl create task "index probe"` → `mix revelctl index status` shows the node indexed (count matches).
3. Stop ArcadeDB: create/edit nodes succeed (domain writes unaffected), stale flag set; restart + `mix revelctl index rebuild` → counts match the DB exactly (rebuildable proof).
4. `mix revelctl query cypher "MATCH (n)-[:contains]->(m) RETURN n.title, m.title LIMIT 5"` returns linked pairs.
5. Ledger M6 truthful; final table printed. Agent branch commit, never main, Signed-off-by.

Rules: plain English; complete files, never partial diffs; diagnostics before fixes, read actual output; never suggest alternative setups; stop-and-report on conflicts with real code. If knarr's ArcadeDB server does not exist yet, still complete all code and tests against the degradation path, deploy the service per the ops doc, and run live checks 2-4 when it is up.