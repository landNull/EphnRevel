# EphnRevel state assessment — tablet kickoff, 2026-11-07

Written by the tablet-kickoff session (`promptfile/ephnrevel.tablet-kickoff.20261107-210317.md`), run inside the vibe container on the a11 tablet at `/root/Apps/EphnRevel`.

## Confirmed on disk

- **Repo**: `/root/Apps/EphnRevel` exists, branch `main`, HEAD `24149ea` ("Fix JS.hide call to use keyword opts", Wed Oct 28 23:59:48 2026 -0600). Matches the expected commit — **no drift**.
- **Toolchain**: Elixir 1.18.3 on Erlang/OTP 27 (erts-15.2.7), git 2.47.3. Satisfies `mix.exs` `elixir: ~> 1.16`.
- **Stack (mix.exs, version 0.1.0)**: Phoenix ~> 1.7.14 (locked 1.7.24), phoenix_live_view ~> 1.0 (locked 1.2.13), phoenix_ecto 4.7.0, ecto_sql ~> 3.11 (locked ecto 3.14.2), ecto_sqlite3 ~> 0.17 (locked 0.26.0 — allowed by the two-segment requirement), Bandit ~> 1.5 (ran 1.14.1), bcrypt_elixir ~> 3.0, jason, req 0.7.5, finch 0.24.0; esbuild + tailwind dev-only.
- **Smoke results**:
  - `mix deps.get` — pass, 19.0s wall. Security advisories from Hex: ecto 3.14.2 CVE-2026-118391 (HIGH), phoenix_html 4.3.0 CVE-2026-117645 (MEDIUM). Recorded, not fixed (out of scope).
  - `mix compile` — pass, exit 0, 1m42.5s wall, 27 app files, "Generated ephnrevel app", no warnings observed.
  - `mix ecto.setup` — pass, exit 0, 8.1s wall. SQLite dev DB created, both migrations ran (users; nodes+links), seeds ran ("Seeded admin@example.com … and demo graph").
  - `mix test` — **fail, exit 1**, 1m43.7s wall. Test-env compile succeeded, then the `test` alias step `ecto.create --quiet` crashed: `config/test.exs` configures app `:eph_revel` (wrong name; the app is `:ephnrevel`), so the Repo got no database path — `** (ArgumentError) No SQLite database path specified` from `ecto_sqlite3 0.26.0` `storage_up/1`. There is also no `test/` directory. Recorded as a finding, not fixed.
  - Server smoke — pass. `mix phx.server` booted: "Running EphnRevelWeb.Endpoint with Bandit 1.14.1 at 0.0.0.0:4000". `curl http://localhost:4000` → `302` redirect to `http://localhost:4000/users/log_in` (expected auth redirect). Server stopped afterwards.
  - CLI smoke — pass, all four verbs exit 0: `mix revelctl create task "Kickoff smoke node" --set column=todo` (created node id 5), `mix revelctl list` (5 nodes listed), `mix revelctl board` (columns active/doing/done/todo rendered), `mix revelctl query` (usage, exit 0) and `mix revelctl query 5` (returned the smoke node). The smoke node stays in the dev DB — expected, there is no delete verb.
- **Project management files**: `AGENTS.md` (first line `project name: ephnrevel` plus the required rules), `promptfile/` with all eight series files, `planning/projects.json` (19 nodes, 18 links, jq-valid) all verified on disk.

## Drift vs. the kickoff brief

- HEAD is exactly `24149ea` — no drift.
- `mix.lock` resolves `ecto_sqlite3` to 0.26.0 (brief said ~0.17; the `~> 0.17` requirement allows it). Noted, not an error.
- `mix.lock` committed at HEAD is incomplete: it lacks entries for `finch`, `mint`, `nimble_options`, `nimble_pool`, and `req`, all required by `mix.exs`. `mix deps.get` adds them (5 insertions). Restored the file unmodified for this commit per the "no modified tracked files" rule; poki's `deps.get` will regenerate them. Owner for a permanent fix: dlitfunc-docs (M9).
- New finding beyond the brief's gap list: `config/test.exs` uses the wrong application name `:eph_revel`, so the `mix test` alias fails at `ecto.create` before any test would run. Owner: dlitfunc-docs (M9), same as gap 1.
- The brief's expected `mix test` behavior was "fails or no tests" — actual failure is the config app-name bug above plus the missing `test/` directory.

## Gaps table

| # | Gap | Owner promptfile | Status |
|---|-----|------------------|--------|
| 1 | No `test/` directory; `mix test` cannot be green (now also fails earlier on the `:eph_revel` config name in `config/test.exs`) | dlitfunc-docs (M9) | Open, recorded |
| 2 | `revel.settings.json` repository block says name "eph-revel" with the wrong URL; real repo is EphnRevel | dlitfunc-docs (M9) | Open, untouched per instructions |
| 3 | No help/trail/back/bookmark/course revelctl verbs | dlitfunc-docs (M9) | Open, recorded |
| 4 | No `AGENTS.md`, `planning/`, `promptfile/` | this file (tablet-kickoff) | **Closed this session** — all three created/verified on disk |
| 5 | No personas, definitions, Theme Machine, ArcadeDB, D7 migration, public websites | admin-personas, theme-machine-shell, arcadedb-index, d7-migration, public-websites | Open — staged in `promptfile/`, work happens in poki |

## Readiness verdict

**Yes — the repo is ready for the poki series to start at admin-personas.** Reasons: the toolchain builds the project cleanly (`deps.get` + `compile` + `ecto.setup` all green), the web server serves the auth redirect, all four `revelctl` verbs work against the SQLite dev store, HEAD matches the expected commit, and the project management files (`AGENTS.md`, `promptfile/` with all eight series files, `planning/projects.json` ledger) are in place on a pushed branch. The only red check is `mix test`, which is a pre-identified gap owned by dlitfunc-docs (M9), not a blocker for M1.

## Tablet notes for the poki session

- Compiles under proot are slow but fine: dev `mix compile` 1m42s, test-env compile ~1m44s, `mix deps.get` 19s, `mix ecto.setup` 8s. exqlite used a precompiled NIF download (no C compile); bcrypt_elixir compiled its NIF with `cc` fine.
- `inotify-tools` is missing in the container: every `mix` run prints a red `[error]` plus warnings about `file_system`/live-reload, and esbuild/tailwind print "version is not configured" warnings. All dev-only and harmless; ignore them.
- Each `mix` invocation boots the app (~10–20s under proot); batch CLI checks in one shell line.
- `mix test` fails at the `ecto.create --quiet` alias step due to the `:eph_revel` vs `:ephnrevel` config-name mismatch in `config/test.exs` — do not "fix" it outside the owning promptfile.
- gh is authenticated on the Termux side, not necessarily in the container; if a push from the container fails on credentials, push from `~/Apps/EphnRevel` on the Termux side.
