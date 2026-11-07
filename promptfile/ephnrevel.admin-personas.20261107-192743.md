# ephnrevel: admin-personas

- app: ephnrevel (project root: the EphnRevel checkout; default `~/Apps/EphnRevel` on the Termux side = `/root/Apps/EphnRevel` inside the vibe container; if no checkout exists, clone https://github.com/landNull/EphnRevel there first)
- created: 2026-11-07
- status: act

## Current state

All facts below were verified by reading the GitHub repo landNull/EphnRevel (main branch, commit 24149ea, 2026-11-07). Re-verify anything that looks different on disk before acting, and stop-and-report if reality conflicts with this file.

**What EphnRevel is:** an Elixir/Phoenix reimplementation of Revel. Thesis: a project manager that treats every element as a task node. License AGPL-3.0-only. CLI-first control plane.

**Settings contract:** `revel.settings.json` at the repo root is the canonical project brief for humans and agents. Schema version 1.1.0; project name `eph-revel`; CLI name `revelctl`; decisions D001-D012 recorded. When prose docs or chat memory conflict with this file, the JSON wins. It contains no secrets. When a decision is made or changed, update this file first, then mirror it in the ledger.

**Stack (from mix.exs, version 0.1.0):** Elixir ~1.16, Phoenix ~1.7.14, phoenix_live_view ~1.0, phoenix_ecto + ecto_sql ~3.11 with ecto_sqlite3 ~0.17 (dev store), Bandit ~1.5, bcrypt_elixir ~3.0, jason, req, finch; esbuild + tailwind as dev-only asset deps.

**Code layout that exists today:**
- `lib/ephnrevel/`: `graph.ex` (functional core: pure functions, values in, values out), `graph/node.ex`, `graph/link.ex`, `cli.ex`, `mail.ex`, `search.ex`, `accounts.ex` + `accounts/`, `repo.ex`, `application.ex`.
- `lib/mix/tasks/revelctl.ex`: the `mix revelctl` CLI (create, list, board, query, plus mail status/fetch/send).
- `lib/ephnrevel_web/`: `router.ex`, `user_auth.ex`, `live/dashboard_live.ex`, `live/board_live.ex`, `live/node_live/`, `live/user_login_live.ex`, `components/core_components.ex`.
- `docs/`: Diátaxis tree (tutorials, how-to, reference, explanation) with `docs/outline.md` as the master index. d-LitFunc standards are linked, never copied.

**Graph model:** two tables, `nodes` and `links`. Node = `{id, type, title, payload (free-form JSON), external_id}`; Link = `{kind, source_id, target_id}`. Project-to-task links use kind `contains`. The kanban Board reads `payload["column"]`, and that is the only convention. 17 node types exist: task, project, milestone, file, email, event, lead, opportunity, account, contact, ticket, campaign, content, inventory_item, knowledge_article, user, group.

**Web admin today:** one generic LiveView UI (Dashboard with node/email/link counts, kanban Board, node pages). No personas, no definition files, no layout builder, no quick edit, no bulk actions, no config export/import exist yet.

**Not in the repo yet:** `AGENTS.md`, `planning/projects.json`, `promptfile/` folder, `docs/features/`. This promptfile establishes all of these.

**First run (baseline):** `mix deps.get`, `mix ecto.setup`, `mix phx.server`, then http://localhost:4000 with `admin@example.com` / `password123456`. Meilisearch and Zoho mail are optional env-driven extras; everything below works without them.

## What to do

Implement the three-persona admin system for EphnRevel. The admin UI becomes **personas**: interchangeable admin screens over the same underlying graph data. Legally, what is copied is structure and behavior, never pixels or code: WordPress muscle memory is portable behavior, not WordPress property (left sidebar, top admin bar with + New, list screens with filter links and hover row actions, draft to publish to schedule flow, Media Library grid); Backdrop's strengths are structural (layouts separate from styling, Views list builder in core, Field UI content types, configuration as exportable JSON), and its shapes are copied via config-style JSON definitions.

Work the milestones in `planning/projects.json` (task 1 creates it). Before starting any milestone or task, set its node column to `doing`. Mark it `done` with `payload.done_on` only after that task's verification in "Build + verify" passes. If no node exists for work you are doing, create one (next free id, type `task`, `contains` link to the right milestone). Promptfile files are immutable records; only the ledger is mutable. Keep columns truthful at all times; never mark done from assumption, only from a passing verification run on disk.

### Task 1 - Project management setup (M1)

1. Create `promptfile/` in the project root.
2. Create `AGENTS.md` at the repo root. Start the file with the line `project name: ephnrevel`, then keep/add: build and verify commands (`mix deps.get`, `mix ecto.setup`, `mix test`, `mix phx.server`), the rule that `revel.settings.json` wins over prose, the ledger roll-in rules from this file (doing before acting, done only after verification passes), and the note that files in `promptfile/` are immutable records.
3. Create `planning/projects.json`, the task-node ledger, using EphnRevel's own node and link shapes exactly (this is EphnRevel dogfooding its own model, and the file is importable into EphnRevel as-is later):
   - `nodes`: `{id, type, title, payload, external_id}`. `links`: `{kind: "contains", source, target}` (source/target hold node ids).
   - Node 1: type `project`, title "EphnRevel admin personas", payload `{"column": "active", "kind": "project"}`.
   - Milestone nodes, type `milestone`, payload `{"column": "todo"}`: M1 "Definitions and persona foundation", M2 "Backdrop persona", M3 "WordPress persona", M4 "Revel-native best-of-both persona, docs, release".
   - Task nodes, type `task`, payload `{"column": "todo", "kind": "task"}`, one per task 2-9 below, each linked `contains` from its milestone. Use `external_id` values: task 3 = `docs/features/016-quick-edit-and-bulk-actions.md`, task 5 = `docs/features/017-layout-builder.md`, task 8 = `docs/features/018-config-export-and-import.md`, task 9 = this file's exact filename (payload `kind: "promptfile"`).
   - One decision node, type `task`, payload `{"column": "done", "kind": "decision"}`, title "Three-persona admin: Backdrop, WordPress, Revel-native best-of-both", linked from node 1.
4. Add the decision to `revel.settings.json` first (next free Dxxx id after the highest existing one; title "Three-persona admin screens: Backdrop persona, WordPress persona, Revel-native best-of-both persona; shapes copied legally as structure/behavior via config-style JSON definitions"), then mirror it as the ledger decision node.

### Task 2 - Definitions-as-nodes foundation (M1)

Every admin construct becomes a node that stores a definition: a content type is a definition node, a view is a definition node, a layout is a definition node.

- Definition JSON files live in `priv/definitions/content_types/`, `priv/definitions/views/`, `priv/definitions/layouts/`, loaded at boot; instances stay in the database.
- Each definition file is mirrored as a graph node (its `external_id` = the definition filename) so definitions participate in the same graph as everything else.
- Add `revelctl` verbs: `mix revelctl definitions list` and `definitions show <name>`.
- Verify: create one content-type definition and one view definition; both appear in `revelctl definitions list`, and their nodes appear on the board.

### Task 3 - Persona architecture (M1)

- One LiveView component per persona (Backdrop, WordPress, Revel-native), each implementing the same edit projection over the same `EphnRevel.Graph` context. Every write from any persona goes through the same domain functions; no persona has private write paths.
- Audit visibility: one shared audit function records actor, action, node id, and before/after payload for every mutation, stored as `type: "event"` nodes; the Revel-native persona gets an audit screen (task 7).
- Persona is selectable: a per-user preference plus a session switcher; every persona renders the same data through its own idiom.
- LiveView pubsub: every graph write broadcasts, so all open personas update within one heartbeat.

### Task 4 - Backdrop persona (M2)

Backdrop admin view/screen: layouts with placement separate from styling, Views-style list builder, Field UI-style content types, config-as-JSON screens, and bulk operations with a confirmation step. The layout builder spec (this is feature doc 017): a layout is a definition of regions plus assigned displays (views, blocks, single nodes) with a path pattern and conditions (persona, role, node type); placement is separate from styling. Layout definition node plus JSON in `priv/definitions/layouts/`. Admin dashboards compose first; public-facing pages come later. Drag-and-drop uses SortableJS (MIT, vendored - download the single library file into the project, do not add a package manager). Rearranging is persona-local: the Backdrop persona's dashboard layout does not change the WordPress persona's layout, but the same underlying view appears in both.

### Task 5 - WordPress persona (M3)

WordPress admin view/screen, structure not pixels:
- Left sidebar navigation; top admin bar with a **+ New** quick-add (create any of the 17 node types).
- List screens with filter links (by type, column, status).
- Hover row actions on every row: Edit | Quick Edit | Trash | View.
- Quick Edit: inline edit of title and column without opening the editor (task 6 substrate).
- Bulk actions dropdown: change status/column, delete, assign on selected rows.
- Draft to publish to schedule flow: node payload gains `status` (`draft`, `published`, `scheduled`) and optional `publish_at`; scheduled nodes publish at `publish_at`; the board shows published nodes by default with a draft filter.
- Media Library-style grid view for file and email nodes.

### Task 6 - Quick edit and bulk actions substrate (M3)

One shared implementation (bake), used by all three personas; every action goes through the same domain functions and is audit-visible. Bulk operations always show a confirmation step in the Backdrop persona idiom. Feature doc 016. This is where the one-heartbeat acceptance check matters most.

### Task 7 - Revel-native persona (M4)

The third admin screen, specific to Revel itself: the well-rounded best-of-both option for Revel administration, and the default screen after login. Combine the strongest idioms of both familiar personas into the native Revel screen:
- From WordPress: + New quick-add, Quick Edit, hover row actions, list filters.
- From Backdrop: confirmation-protected bulk operations, layouts with placement separate from styling, config-as-JSON screens.
- Revel-native: the kanban Board as home, a task-node graph view (nodes with their `contains` links), the audit trail screen (task 3's event nodes), and the persona switcher. Every screen action name matches an existing `revelctl` verb so GUI and CLI stay one control plane.

### Task 8 - Config export and import (M4)

Feature doc 018: type, field, view, and layout definitions live as JSON files and can be exported, imported, and reviewed as diffs. This is mostly already true by design after task 2 (definitions in files, instances in the database); the feature is the export/import screens plus `revelctl` verbs (`mix revelctl definitions export <dir>` and `definitions import <dir>`), so definitions move between environments and land as reviewable diffs. Validate the whole file set before applying anything: no partial imports, and errors are plain-English and name the location.

### Task 9 - Docs, settings, ledger close-out (M4)

1. Write the feature docs with the standard shape used in the design conversation: `# NNN - Title`, then `Status: ... | Priority: ... | Added: 2026-11-07`, then sections "What it does", "WordPress idiom", "Backdrop idiom", "EphnRevel shape", "Acceptance", "Adopt or bake". Numbers: 016 quick-edit-and-bulk-actions, 017 layout-builder, 018 config-export-and-import (017 and 018 were numbered exactly this way in the conversation; 016 is quick edit's natural slot). Link all of them from `docs/outline.md` under a new "Features" section. Diátaxis and d-LitFunc rules apply: literal names, link the standards, never copy them.
2. Update `revel.settings.json`: the three-persona decision (already added in task 1) plus any new decisions you actually made (definition files location, SortableJS vendoring, status flow) - settings file first, ledger second.
3. Bump `mix.exs` version to 0.2.0.
4. Print the final ledger table (all nodes with columns) and reconcile it with reality before closing: every node's column must match what is actually true on disk.
5. Git: commit all work on a feature branch named `agent/vibe-cli/admin-personas` (or your session's agent branch convention). Never merge to main; the operator merges. Commit messages carry `Signed-off-by: <operator>`.

## Build + verify

Baseline before starting: `mix deps.get && mix ecto.setup && mix test` all green. Run `mix test` after each milestone; a red suite stops the milestone.

Per-feature acceptance (from the design conversation - each must pass before its node goes `done`):
1. Quick edit a title in one persona; the change appears in the other persona's list within one heartbeat (no manual refresh).
2. A bulk operation shows a confirmation step in the Backdrop persona before applying.
3. Rearrange the dashboard in the Backdrop persona; the WordPress persona's dashboard keeps its own layout; the same view appears in both.
4. Export definitions on one instance, import on another; the result lands as a reviewable diff and matches. An invalid definition set produces no partial import and a plain-English error naming the location.
5. `mix revelctl create|list|board|query` still work and share the same Graph context as all three personas (create via CLI, see it in every persona).

Final verification: full `mix test` green; `mix phx.server` boots; log in and walk each persona as `admin@example.com`; print the final ledger table; commit on the agent branch.

Rules for this work: plain English in all docs and UI text; produce complete files, never partial diffs; when troubleshooting, run a diagnostic and read the actual output before changing anything; never suggest alternative setups. If any spec in this file conflicts with the real code, stop and report the conflict instead of improvising.