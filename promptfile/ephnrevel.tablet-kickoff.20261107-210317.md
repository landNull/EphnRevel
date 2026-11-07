# ephnrevel: tablet-kickoff

- app: ephnrevel (project root: `~/Apps/EphnRevel` on the Termux side = `/root/Apps/EphnRevel` inside the vibe container)
- created: 2026-11-07
- status: act

## Current state

**The mission.** EphnRevel (https://github.com/landNull/EphnRevel, AGPL-3.0) is Landy's Elixir/Phoenix port of Revel: a project manager where every element is a task node in a graph store. It is becoming the office data center (three-persona admin, Drupal 7 migration, public websites built by staff with zero code). Development of the main feature series happens later, inside the poki VM on knarr. THIS session runs on the a11 tablet, inside the vibe container, and its only job is: **assess the current state of the EphnRevel code, verify the toolchain can build it, set up the project management files, stage the promptfile series, and leave the repo ready to clone into poki.** Do not implement any feature from the series here.

**Repo facts (verified on GitHub main, commit 24149ea, 2026-11-07 — re-verify on disk and record any drift):**

- Stack (mix.exs, version 0.1.0): Elixir ~1.16, Phoenix ~1.7.14, phoenix_live_view ~1.0, phoenix_ecto + ecto_sql ~3.11 with ecto_sqlite3 ~0.17 (dev store), Bandit ~1.5, bcrypt_elixir ~3.0, jason, req, finch; esbuild + tailwind as dev-only asset deps.
- `lib/ephnrevel/`: `graph.ex` (pure functional core), `graph/node.ex`, `graph/link.ex`, `cli.ex`, `mail.ex`, `search.ex`, `accounts.ex` + `accounts/`, `repo.ex`, `application.ex`. `lib/mix/tasks/revelctl.ex` = the `mix revelctl` CLI (create, list, board, query, plus mail status/fetch/send). `lib/ephnrevel_web/`: `router.ex`, `user_auth.ex`, `live/dashboard_live.ex`, `live/board_live.ex`, `live/node_live/`, `live/user_login_live.ex`, `components/core_components.ex`.
- Graph model: two tables, `nodes` and `links`. Node = `{id, type, title, payload (free-form JSON), external_id}`; Link = `{kind, source_id, target_id}`. Project-to-task links use kind `contains`. The kanban Board reads `payload["column"]` — that is the only convention. 17 node types: task, project, milestone, file, email, event, lead, opportunity, account, contact, ticket, campaign, content, inventory_item, knowledge_article, user, group.
- `docs/` is a Diátaxis tree with `docs/outline.md` as the master index.
- `revel.settings.json` at the repo root is the canonical project brief (schema 1.1.0): when anything conflicts with it, the JSON wins. It contains no secrets. Read it first.

**Known gaps (all pre-identified, each owned by a series promptfile — record them, do not fix them):**

1. No `test/` directory at all, so `mix test` cannot be green. Owner: the dlitfunc-docs promptfile (M9).
2. The `revel.settings.json` repository block says project name "eph-revel" with the wrong URL; the real repo is EphnRevel. Owner: dlitfunc-docs (M9). Do NOT touch `revel.settings.json` in this session.
3. No help/trail/back/bookmark/course revelctl verbs. Owner: dlitfunc-docs (M9).
4. No `AGENTS.md`, no `planning/`, no `promptfile/`. THIS session creates them.
5. No personas, definitions, Theme Machine, ArcadeDB integration, D7 migration, or public websites — the whole feature series. Owners: the series files below.

**The promptfile series (all eight files; this one runs FIRST and on the tablet, the rest run later in poki):**

1. `ephnrevel.admin-personas.20261107-192743.md` — M1-M4
2. `ephnrevel.theme-machine-shell.20261107-195209.md` — M5
3. `ephnrevel.arcadedb-index.20261107-195400.md` — M6
4. `ephnrevel.d7-migration.20261107-195500.md` — M7
5. `ephnrevel.public-websites.20261107-195600.md` — M8
6. `ephnrevel.dlitfunc-docs.20261107-195700.md` — M9
7. `ephnrevel.store-and-devel-branch.20261107-195800.md` — M10
8. `ephnrevel.tablet-kickoff.20261107-210317.md` — this file (project-level, no milestone)

**Supersession (important):** this file runs before `ephnrevel.admin-personas.20261107-192743.md` and supersedes only Task 1, items 1-3 of that file (create `promptfile/`, create `AGENTS.md`, create `planning/projects.json`). When admin-personas runs later in poki, it must treat those three items as verify-and-extend: the files already exist; reconcile its Task 1 ledger list against the existing ledger, keep existing node ids, add only what is missing, never duplicate nodes. Everything else in that file is unchanged and authoritative.

**Tablet environment facts (verified on this tablet):**

- The vibe container is Debian 13 (proot). The toolchain lives there: Elixir 1.18.3 on Erlang/OTP 27 (satisfies mix.exs ~1.16), git, build-essential, rebar3. Termux `~/Apps` is bind-mounted at container `/root/Apps` — one repo, visible from both sides.
- Container commands must run with a clean environment, e.g. `proot-distro login vibe -- env -i HOME=/root TERM=xterm-256color PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin bash -c '<command>'`. Termux PATH/env leaks cause build failures.
- proot has no systemd; mix, Ecto, and Bandit run fine. Compiles are slow under proot — `mix compile` taking several minutes is normal, not a failure.
- The first `mix deps.get` downloads Hex and rebar — normal, not a proot failure.
- gh (GitHub CLI) is installed and authenticated on the TERMUX side, not necessarily in the container. Git operations work from either side (same bind); if a push from the container fails on credentials, run it from the Termux side in `~/Apps/EphnRevel`.
- For long outputs use tmux capture (prefix + P) instead of screen text selection.
- Promptfile protocol (from `/root/.vibe/AGENTS.md`): the app prefix must match the project's declared name; files in `promptfile/` are immutable records — never rename, edit, or delete them.

## What to do

Run this whole session inside the vibe container. Start the vibe session in the project directory once it exists.

**Task 1 — Toolchain check.** `elixir --version` and `git --version` inside the container. Record exact versions. If Elixir is missing, stop and report instead of installing anything.

**Task 2 — Clone.** If `/root/Apps/EphnRevel` does not exist: `git clone https://github.com/landNull/EphnRevel /root/Apps/EphnRevel`. Record the HEAD commit of main (`git rev-parse --short HEAD` and `git log -1 --format='%h %ad %s'`). Note drift if it is not 24149ea.

**Task 3 — Project identity.** Create `AGENTS.md` at the repo root (this supersedes admin-personas Task 1 item 2; that file will extend it later):

- First line: `project name: ephnrevel`
- Then, briefly: read `revel.settings.json` first; the JSON wins over prose and chat memory; it contains no secrets.
- Build and verify commands: `mix deps.get`, `mix ecto.setup`, `mix test`, `mix phx.server`.
- Ledger roll-in rules: before acting on a promptfile, set its ledger node column to `doing`; mark `done` + `payload.done_on` only after that file's verification passes on disk; if no node exists, create one (next free id, type `task`, payload kind `promptfile`, `contains` link to the right milestone).
- Files in `promptfile/` are immutable records; only the ledger is mutable.
- Agents commit on `agent/<name>/<task>` branches, never main; commit messages carry a `Signed-off-by:` trailer with the operator's identity; the operator merges.

**Task 4 — Stage the promptfiles.** Create `promptfile/` in the repo root if missing. The operator downloads the eight series files into it. Verify all eight filenames from the list above are present; list any missing ones and stop-and-report if any are absent (do not proceed to the commit without them; do not create or reconstruct any of them yourself).

**Task 5 — The ledger.** Create `planning/projects.json` (supersedes admin-personas Task 1 item 3; every later series file reconciles against it instead of recreating it). Use EphnRevel's own node/link shapes exactly — this file must be importable into EphnRevel as-is later:

- `nodes`: `{id, type, title, payload, external_id}`. `links`: `{kind: "contains", source, target}`.
- Node 1: type `project`, title "EphnRevel", payload `{"column": "active", "kind": "project"}`.
- Milestone nodes, type `milestone`, payload `{"column": "todo"}`, each with a `contains` link FROM node 1: M1 "Definitions and persona foundation", M2 "Backdrop persona", M3 "WordPress persona", M4 "Revel-native best-of-both persona, docs, release", M5 "Theme Machine shell", M6 "ArcadeDB index", M7 "D7 migration", M8 "Public websites", M9 "d-LitFunc docs and test harness", M10 "Production readiness" (parking milestone).
- Eight promptfile task nodes, type `task`, payload `{"column": "todo", "kind": "promptfile"}`, `external_id` = the exact filename, each with a `contains` link from its milestone: admin-personas → M1, theme-machine-shell → M5, arcadedb-index → M6, d7-migration → M7, public-websites → M8, dlitfunc-docs → M9, store-and-devel-branch → M10. The eighth node is THIS file, linked from node 1, payload `{"column": "doing", "kind": "promptfile"}` — it goes `done` with `payload.done_on` only after this session's verification passes.
- Seeding rule: all seven series promptfile nodes stay `todo` — their work has not happened, no matter what any file or chat log claims. Never mark anything done from assumption.
- Later files must link to these milestone nodes, never duplicate them.

**Task 6 — Build and smoke assessment (record everything; diagnostics before any change; fix nothing outside this file's scope).**

1. `mix deps.get` — record dependency resolution and any version warnings.
2. `mix compile` — record success/warnings and wall time. If it fails, capture the full error, stop-and-report.
3. `mix ecto.setup` — creates the SQLite dev database (the exqlite NIF compiles C code; slow under proot is normal). If it fails, capture the error, record it as a finding, and skip the DB-dependent smoke steps (do not attempt fixes).
4. `mix test` — expected to fail or report no tests to run: the repo has NO `test/` directory (gap 1, owned by dlitfunc-docs). Record the exact output as the finding. Do not create any tests.
5. Server smoke (only if ecto.setup succeeded): run `mix phx.server` in a separate tmux window, wait for the Bandit listener line, then `curl -s -o /dev/null -w '%{http_code}\n' http://localhost:4000` — expect 200 or a 302 to the login page. Stop the server afterwards.
6. CLI smoke (only if ecto.setup succeeded): `mix revelctl create task "Kickoff smoke node" --set column=todo`, then `mix revelctl list`, `mix revelctl board`, `mix revelctl query`. All four must work. There is no delete verb; the smoke node stays in the dev database — that is fine, note it. Do NOT log in to the web UI or change any account data.

**Task 7 — Assessment report.** Write `planning/state-assessment.md` (plain English, complete file):

- Confirmed-on-disk facts: HEAD commit, stack versions from mix.exs, toolchain versions, which smoke steps passed with actual outputs summarized.
- Drift: anything that differs from the Current state section above.
- Gaps table: each known gap, its owner promptfile, and its current status.
- Readiness verdict: is the repo ready for the poki series to start at admin-personas, yes or no, with exact reasons.
- Tablet notes: anything the poki session should know (compile times, gotchas hit).

**Task 8 — Git.** On a branch named `agent/vibe-cli/tablet-kickoff`:

- `git checkout -b agent/vibe-cli/tablet-kickoff`
- Commit the new files only (AGENTS.md, planning/projects.json, planning/state-assessment.md, promptfile/ contents). Do not modify any pre-existing repo file; `git status` must show no modified tracked files.
- Commit message: "tablet-kickoff: state assessment, ledger, AGENTS.md, promptfile staging", ending with a `Signed-off-by:` trailer carrying the operator's git identity.
- Push: `git push -u origin agent/vibe-cli/tablet-kickoff` (from the container; on auth failure, run it from the Termux side in `~/Apps/EphnRevel` where gh is authenticated).
- Never merge. Stop and report once pushed; the operator merges the branch into main so the later poki clone picks everything up.

**Task 9 — Ledger close.** After the verification steps pass (or a failure is recorded as a finding without blocking), set this file's ledger node to `done` with `payload.done_on` = today's date, print the full ledger table (all nodes with columns), and reconcile it with what is true on disk.

## Build + verify

Verification for this session, all on disk:

1. `/root/Apps/EphnRevel` exists; HEAD commit recorded; `promptfile/` contains the eight expected filenames.
2. `AGENTS.md` first line is `project name: ephnrevel`.
3. `planning/projects.json` parses (`jq . planning/projects.json`): project + 10 milestone nodes + 8 promptfile nodes, valid `contains` links, nothing marked done except this session's node after its checks pass.
4. `mix compile` result recorded (green, or captured failure); same for ecto.setup, mix test, server smoke, revelctl smoke.
5. `planning/state-assessment.md` exists and names every gap with its owner.
6. `git status` clean; branch pushed; no modifications to pre-existing files.
7. Ledger table printed and truthful.

Rules for this work: plain English; complete files, never partial diffs; when something fails, run a diagnostic and read the actual output before doing anything; never suggest alternative setups; if any spec in this file conflicts with the real repo, stop and report the conflict instead of improvising.