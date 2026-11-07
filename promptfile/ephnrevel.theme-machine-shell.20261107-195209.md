# ephnrevel: theme-machine-shell

- app: ephnrevel (project root: the EphnRevel checkout, default `~/Apps/EphnRevel` on Termux = `/root/Apps/EphnRevel` in the container; the repo is github.com/landNull/EphnRevel)
- created: 2026-11-07
- status: act

## Current state

This is file 1 of 4 in the EphnRevel data-center series. Run order: theme-machine-shell, then arcadedb-index, then d7-migration, then public-websites. All four run ONLY after the admin-personas promptfile (`ephnrevel.admin-personas.20261107-192743.md`) has verified green and its ledger milestones M1-M4 are done.

Verified repo facts (main @ 24149ea, re-verify on disk before acting; stop-and-report on conflict): Elixir ~1.16, Phoenix ~1.7.14, LiveView ~1.0, Ecto + ecto_sqlite3, Bandit, Jason, Req; version 0.1.0. Graph store: `nodes` `{id, type, title, payload (free-form JSON), external_id}` + `links` `{kind, source_id, target_id}` (kind `contains` for parent→child); Board reads `payload["column"]`. `lib/ephnrevel/graph.ex` is the pure functional core; side effects live in LiveViews/CLI. `mix revelctl` exists (create/list/board/query + mail). `revel.settings.json` is the canonical brief: prefer it over prose, JSON wins over chat history, no secrets; update it first when decisions change, then mirror in the ledger. Ledger: `planning/projects.json` with the same node/link shapes; columns todo/doing/done/parked; roll-in rules live in AGENTS.md.

After admin-personas runs green, these exist: three personas (Backdrop, WordPress, Revel-native) as LiveViews over the same Graph context; definitions-as-nodes (`priv/definitions/{content_types,views,layouts}/` JSON, mirrored as definition nodes); quick edit + bulk substrate; audit event nodes; feature docs 016-018 under `docs/features/`; version 0.2.0.

**The Theme Machine contract (what you are implementing natively, not porting):** the Backdrop PHP module `theme_machine` is the first shell; EphnRevel is the second shell. Do not port PHP. Implement the contract: (1) **DTCG 2025.10 design tokens** (W3C format: token groups with `$value`/`$type`) as the catalog token format, family-wide rule, no bespoke token JSON; (2) **per-theme catalog pattern → per-persona catalogs** in `priv/theme_machine/catalogs/<persona>/` (tokens plus icon/plugin/themeable catalogs as one DTCG-aligned convention); (3) **four verbs**: audit (pure: files + catalogs in → coverage report out), generate (pure: artifact contents from audit + selections), verify (pure: harness checks), guide (accordion UI over doc data); (4) **defaults policy**: powerful tools (raw template editing, widget regeneration) default OFF with doc beside each toggle; presentational settings default ON with sane defaults; (5) **write gate**: staged preview + explicit confirm for every generated write; (6) **guide/quest education**: accordion items with status + deeper-dive links that return (d-LitFunc return-link MUST). Color settings include pickers with hex/rgb/hsl + alpha; presets are quick-starts, never the ceiling.

**First catalog seed:** the backdrop-tabler catalog (landNull/backdrop-tabler targets the same Tabler `--tblr-*` variables EphnRevel's Tabler/Bootstrap 5.3 chrome already uses, including `data-bs-theme` color modes). Extract its token/catalog data as DTCG JSON (shapes/data transfer, no PHP). If the repo is unreachable, seed a minimal Tabler catalog by hand: palette, semantic, radius, typography groups with `--tblr-*` targets.

## What to do

Work milestone M5. Before each task set its ledger node to `doing`; `done` + `payload.done_on` only after its verification passes. Add M5 ("Theme Machine shell") as a milestone node linked to the project node, task nodes linked to M5, and this file as a task node with external_id = this exact filename, payload.kind `promptfile`.

1. **Catalogs:** `priv/theme_machine/catalogs/{backdrop,wordpress,revel}/tokens.json` in DTCG 2025.10 format. Token targets use the existing Tabler `--tblr-*` custom properties so generated stylesheets work with the current chrome unchanged.
2. **Functional core `EphnRevel.ThemeMachine`:** `audit(catalog_files)` → coverage report (tokens defined vs referenced vs orphaned, per persona); `generate(audit, selections)` → artifact contents: per-persona CSS custom-property stylesheet (`:root[data-theme="persona"] { --tblr-...: ...; }`); `verify(artifacts, catalog)` → checks list with pass/fail reasons. Pure functions, values in, values out; no file/network I/O in the core (the shell reads/writes).
3. **Token bridge in the shell:** write generated stylesheets to `priv/static/themes/<persona>.css`, linked from the root layout; persona switch (data-theme attribute) restyles every screen with no rebuild. Regeneration only ever replaces the whole file after staged preview + confirm.
4. **Themes tab in the Revel-native persona:** accordion guide (audit items with status + deeper-dive links with return links), token editing (color picker + hex/rgb/hsl + alpha; text/number for non-color tokens), presets as quick-starts, Save = draft config diff, Publish = staged preview + explicit confirm, verify verb runnable from the tab with results shown in-UI.
5. **CLI verbs:** `mix revelctl theme audit|generate|verify` (same core, same outputs; config lands as reviewable diffs).
6. **Settings + docs:** add the decision to `revel.settings.json` first (Theme Machine shell: contract implemented natively, DTCG 2025.10 catalogs, per-persona stylesheets, staged preview + confirm), mirror in the ledger; write `docs/features/019-theme-machine-shell.md` (standard shape: What it does / WordPress idiom / Backdrop idiom / EphnRevel shape / Acceptance / Adopt or bake) and link it from `docs/outline.md`. Bump version to 0.3.0 when green.

## Build + verify

Baseline `mix deps.get && mix ecto.setup && mix test` green before starting; `mix test` after each task; a red suite stops the milestone.

1. `mix revelctl theme audit` prints a per-persona coverage report; zero tokens orphaned after seeding fixes.
2. `mix revelctl theme generate` produces all three persona stylesheets; `mix revelctl theme verify` green.
3. In the app: switch persona; the Theme Machine tab's token edit → staged preview → confirm → stylesheet regenerated; the new colors appear in the switched persona without a rebuild.
4. A default-OFF toggle (raw template editing) is present, off, with its doc section beside it.
5. Ledger: M5 nodes truthful; final ledger table printed. Commit on the agent branch (`agent/vibe-cli/theme-machine-shell` or your session convention), never main, Signed-off-by trailer.

Rules: plain English; complete files, never partial diffs; diagnostics before fixes, read actual output; never suggest alternative setups; stop-and-report on any conflict with real code.