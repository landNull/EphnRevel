# ephnrevel: dlitfunc-docs

- app: ephnrevel (project root: the EphnRevel checkout, default `~/Apps/EphnRevel` on Termux = `/root/Apps/EphnRevel` in the container; the repo is github.com/landNull/EphnRevel)
- created: 2026-11-07
- status: act

## Current state

File 5 of 5 in the EphnRevel data-center series. Run after `ephnrevel.public-websites.20261107-195600.md` verifies green. Series order: admin-personas → theme-machine-shell → arcadedb-index → d7-migration → public-websites → dlitfunc-docs.

Verified repo facts (main @ 24149ea, re-verify on disk; stop-and-report on conflict): Elixir ~1.16, Phoenix ~1.7.14, LiveView ~1.0, Ecto + ecto_sqlite3, Bandit, Jason, Req. Graph store: `nodes` {id, type, title, payload, external_id} + `links` {kind, source_id, target_id}. `lib/ephnrevel/graph.ex` pure core. `revel.settings.json` = canonical brief (JSON wins, no secrets, decisions file-first then ledger). Ledger `planning/projects.json`, columns todo/doing/done/parked. `mix.exs` version 0.4.0 expected after M8.

**Verified gaps this milestone closes (all found by parsing the repo on 2026-11-07):**
1. **The repo has NO `test/` directory** - mix.exs references `test/support` but no tests exist. Every "mix test green" gate in this series is currently meaningless. This milestone establishes the harness: ExUnit + doctests + a minimal suite for create/list/board/query and the Graph core. Doctests are d-LitFunc documentation that executes.
2. **`revelctl` has no help or navigation verbs** (only create/list/board/query/mail). The d-LitFunc standards REQUIRE them for any app with a docs satellite (requirements embedded below).
3. **`revel.settings.json` repository block is wrong**: it says name `Eph-Revel`, url `github.com/landNull/Eph-Revel`; the real repo is `EphnRevel`. The canonical brief currently points at a repo that does not exist.
4. **Docs today**: `docs/outline.md` master exists, Diátaxis shape, links to the d-LitFunc standards (never copies) - but only covers first-login/create-node/filter-board/email basics. Feature docs 016-022 land via earlier milestones. The staff port-model material does not exist yet.

**The d-LitFunc requirements (embedded so this file is self-contained; in EphnRevel docs, LINK to github.com/landNull/dlitfunc standards.md, never copy its text):**
- Documents: one of four kinds (tutorial, how-to, reference, explanation), never mixed; names literal, no metaphors; reader can read docs as a story; kinds interconnect; a deeper dive is a link whose destination returns the reader to where they left; docs live in the repo (master `docs/outline.md` links every page with relative paths; links resolve in any clone); RFC 2119 key words in reference docs; comments explain why or non-obvious contracts, with a link to the standard.
- Docs satellite: help reachable via `help`; topic resolution order `docs/reference/commands/<topic>.md` → `docs/how-to/<topic>.md` → `docs/explanation/<topic>.md` → `docs/reference/<topic>.md` → `docs/outline.md`; pager `show_help_pager` (prefers `sensible-pager`, then `less`, then `more`).
- Navigation and course (all MUSTs): per-app trail in XDG config home (`~/.config/ephnrevel/`, never in the repo), small plain-text file one position per line, persists across restarts; `back` verb pops to the exact position; `trail` verb lists the stack; `bookmark` verb with `save <name>` / `open <name>` / `list`, plain-text file in XDG home; course management: manifest in the docs satellite declaring tutorial order, progress file in XDG home, `continue` verb opens the first unfinished item, `done` verb records completion; badges MAY be awarded as a small plain file (id, name, criteria, earned date); no Open Badges/xAPI/SCORM machinery; navigation features MUST NOT require a running service.

**Port model (the staff material to document):** a D7 module is NOT ported as one node. Each declarative shape becomes its own definition node + JSON file: hook_node_info content types → content-type definitions; field definitions → field lists in type payload; views exports → view definition nodes; hook_menu → path patterns on layout definitions; hook_block → displays in layout regions; hook_permission → permission declarations; variables → settings/payload; custom DB tables → the graph store itself. The module container disappears. Hook code: mostly dissolves into shapes; the remainder becomes one small Elixir module against the functional core (the escape hatch). D7 approach = code is the container for capability; Revel approach = data is. D7 contrib (webform, commerce) does not port wholesale; per-case bake-or-adopt replaces it.

## What to do

Work milestone M9. Set nodes `doing` before acting; `done` + `payload.done_on` only after verification passes. Add M9 ("d-LitFunc documentation and port model") milestone node, task nodes, and this file as a task node with external_id = this exact filename, payload.kind `promptfile`.

1. **Settings fix first:** correct the `revel.settings.json` repository block to name `EphnRevel`, url `https://github.com/landNull/EphnRevel`; add the M9 decision there (d-LitFunc compliance + port model as staff docs); mirror both in the ledger.
2. **Test harness:** create `test/` with: ExUnit setup (DataCase), doctests for `EphnRevel.Graph` (every public function's @doc examples execute), a minimal suite for node/link create, list, board column reading, query. `mix test` must fail if a documented example is wrong (that is the point: documentation that executes).
3. **revelctl help + navigation verbs:** `help [topic]` with the exact topic resolution order and `show_help_pager` behavior; `trail`, `back`, `bookmark save|open|list`, `course list`, `continue`, `done` per the embedded MUSTs; XDG state under `~/.config/ephnrevel/` as small plain-text line files (trail lines `ts|page|heading`; course manifest `id|title|path|badge`); badge files id|name|criteria|earned-date. No service, no JSON machinery.
4. **Staff port-model documentation:** `docs/tutorials/port-a-drupal7-module.md` (walk one real D7 module shape by shape to definition nodes, zero code, written for an accomplished D7 site builder in plain English) and `docs/explanation/data-not-code.md` (the side-by-side: D7 module/code-container approach vs Revel node/data-container approach, honest about the escape-hatch boundary). Every deeper dive is a link with a return link. Link both from `docs/outline.md`.
5. **Docs completion pass:** for every feature doc 016-022, its matching docs-satellite pages exist (how-to or reference per kind) and interconnect; every implemented public function carries an explanatory comment or @doc with a link to the standard or its feature doc; reference pages use RFC 2119 words.
6. **Quest order:** arrange outline.md so the docs read as a story a D7 staff member can follow start to finish: first login → create a node → personas → build a website (M8 tutorial) → port a D7 module (M9 tutorial) → theme it (Theme Machine how-to) → reference/explanation as deeper dives.
7. **Feature doc + version:** `docs/features/023-dlitfunc-docs.md`, linked from outline.md. Bump version to 0.5.0 when green.

## Build + verify

Baseline `mix deps.get && mix ecto.setup && mix test` green before starting (the new harness itself is task 2, so at least one failing-then-fixed doctest is expected during setup); `mix test` after each task; red suite stops the milestone.

1. `mix test` runs the harness: Graph doctests + CRUD/list/board/query suite, all green.
2. `mix revelctl help create` opens the create reference page via the pager; `mix revelctl help nosuchtopic` falls through the resolution order to outline.md, never errors hard.
3. Trail: open a doc page, open a deeper page, restart the CLI, `back` returns to the exact position (trail persisted).
4. `bookmark save portmodel` / `bookmark open portmodel` / `bookmark list` all work; course manifest present, `continue` opens the first unfinished item, `done` records it, badge file written on course completion.
5. The port-model tutorial is walkable literally against the built system; every step either works or is a bug. Every deeper dive in both new docs has a working return link.
6. `grep -r "MUST NOT" docs/` shows RFC 2119 usage in reference docs; no d-LitFunc standards text is copied (links only).
7. `revel.settings.json` names EphnRevel correctly. Ledger M9 truthful; final table printed. Agent branch commit, never main, Signed-off-by trailer.

Rules: plain English; complete files, never partial diffs; diagnostics before fixes, read actual output; never suggest alternative setups; stop-and-report on conflicts with real code.