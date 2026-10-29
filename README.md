# Eph-Revel

Elixir + Phoenix reimplementation of Revel.

**Thesis:** a project manager that treats every element as a task node.

CLI-first control plane (`revelctl` / Mix tasks). Phoenix LiveView admin with Bootstrap 5, sessions, and user management. Graph store (Ecto + SQLite for local usability; Postgres-ready).

## Credits

- Based on landNull/revel (Python community edition)
- Elixir/Phoenix port by Grok (xAI) for landNull
- License: AGPL-3.0-only (community edition)

## First login (usable immediately)

```sh
mix deps.get
mix ecto.setup          # creates DB, migrates, seeds
mix phx.server
```

Open http://localhost:4000

**Seeded admin:** `admin@example.com` / `password123456`

After login you get a dashboard, kanban board, and node CRUD. Demo nodes are already loaded.

## CLI (control plane)

```sh
mix revelctl create task "Write docs" --set column=todo
mix revelctl list
mix revelctl board
mix revelctl query <id>
```

Same domain as the web UI.

## Architecture

- Graph: Node + Link (Ecto schemas)
- Projections: kanban (column in payload), dashboard counts, list
- Auth: sessions + user management (phx.gen.auth style)
- UI: Bootstrap 5 (CDN) + LiveView
- Store: SQLite (dev) so it runs without external services; swap to Postgres for scale

See `revel.settings.json` for the contract carried forward from the original Revel brief.

## Development

```sh
mix test
mix format
```

Distro-agnostic. Tested on Devuan-class hosts and standard Elixir/OTP.
