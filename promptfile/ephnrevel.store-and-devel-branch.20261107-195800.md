# ephnrevel: store-and-devel-branch

- app: ephnrevel (project root: the EphnRevel checkout; developed in poki at `~/Apps/EphnRevel`, Perseus origin on knarr)
- created: 2026-11-07
- status: act

## Current state

This file records two decisions made by the operator (2026-11-07) and puts them into the contracts. It runs any time after the admin-personas promptfile (`ephnrevel.admin-personas.20261107-192743.md`) verifies green (the ledger `planning/projects.json` and AGENTS.md must already exist). It does not gate milestones M5-M9; it must land before any production-deploy work.

Verified facts (re-verify on disk; stop-and-report on conflict): `revel.settings.json` is the canonical brief (schema 1.1.0; JSON wins over prose; no secrets; decisions update it FIRST, then the ledger mirrors). Its `core.store` currently reads `ecto_sqlite (dev) / ecto_postgres (prod)` — this changes. The repo currently has only the `main` branch. The ledger uses EphnRevel node/link shapes with columns todo/doing/done/parked; roll-in rules live in AGENTS.md. Development happens in the poki VM on knarr; the Perseus git server runs on knarr (SSH port 2222, agent branches `agent/<name>/<task>`, agents never touch protected refs; merging is the operator's act).

**Decision 1 (operator, 2026-11-07): the production store is MariaDB/Percona, not Postgres.** Rationale: ArcadeDB has no MySQL wire protocol and needs none (EphnRevel syncs to it over HTTP/JSON), and `Ecto.Adapters.MyXQL` is the official elixir-ecto adapter — the same driver the D7 migration (`ephnrevel.d7-migration.20261107-195500.md`) reads the source database with. Dev stays on ecto_sqlite3. The production host itself is deliberately undecided until the dev series runs; NO production adapter code is written in this file — the MyXQL prod adapter belongs to the future production-deploy milestone. This file only records the decision truthfully in the contracts.

**Decision 2 (operator, 2026-11-07): the branch workflow is feature branches in poki, merged to `devel` on knarr.** Convention: agents develop and push feature branches (`agent/<name>/<task>`) from poki; the operator merges feature branches into `devel` (the integration branch) on knarr; `main` is stable releases only, protected by Perseus exactly as today. Agents never merge; agents never touch `main` or `devel` directly.

## What to do

1. **Roll-in:** add milestone node M10 ("Production readiness", column todo, linked to the project node) as the parking milestone for production work; add this file as a task node with external_id = this exact filename, payload.kind `promptfile`, linked to M10; add two decision nodes (payload.kind `decision`, column done): "Prod store = MariaDB/Percona via Ecto.Adapters.MyXQL" and "Branch workflow: feature branches in poki, operator merges to devel on knarr".
2. **Settings first:** update `revel.settings.json`: `core.store` reads `ecto_sqlite (dev) / ecto_myxql MariaDB/Percona (prod)`. Add the two decisions as the next free Dxxx entries (highest existing id + 1, + 2) with short titles. The file must stay valid JSON and contain no secrets.
3. **Ledger second:** mirror both decisions exactly as the decision nodes from task 1.
4. **Create the `devel` branch:** from current `main`, create `devel`, push it to the origin (Perseus on knarr; if the remote is not yet configured, create the branch locally and note in the report that it pushes when the origin exists). Never force-push; never touch `main`.
5. **AGENTS.md:** append a "Branch workflow" section stating the convention from Decision 2 verbatim (agents push feature branches only; operator merges to `devel`; `main` is stable releases only) and one line noting the prod store decision with its Dxxx id.
6. **Docs:** write `docs/how-to/branch-workflow.md` (short, plain English, links to the AGENTS.md section and to the ledger) and link it from `docs/outline.md`.

## Build + verify

1. `python3 -m json.tool revel.settings.json` (or `jq . revel.settings.json`) parses clean; `core.store` names MariaDB/Percona; both Dxxx entries present with the next free ids.
2. `git branch --list` shows `devel` created from `main` (or pushed when origin exists); `main` untouched (`git log main` unchanged).
3. AGENTS.md contains the workflow section; `docs/how-to/branch-workflow.md` exists and is linked from outline.md.
4. Ledger: M10 + this file's task node done with `payload.done_on`; both decision nodes done; final ledger table printed.
5. Commit on an agent branch (`agent/<session>/store-and-devel-branch`), never main or devel, Signed-off-by trailer; the operator merges.

Rules: plain English; complete files, never partial diffs; diagnostics before fixes, read actual output; never suggest alternative setups; stop-and-report on conflicts with real code or contracts.