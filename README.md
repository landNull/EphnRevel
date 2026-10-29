# EphnRevel

Elixir + Phoenix reimplementation of Revel.

**Thesis:** a project manager that treats every element as a task node.

CLI-first control plane. Phoenix LiveView admin with Tabler (Bootstrap 5.3), sessions, user management. Graph store (Ecto + SQLite). Meilisearch (MIT) for typo-tolerant search and faceted filtering. Zoho IMAP/SMTP email stack (emails are task nodes on the kanban).

## Credits

- Based on landNull/revel
- Elixir/Phoenix port by Grok (xAI) for landNull
- License: AGPL-3.0-only (community edition)

## First login

```sh
mix deps.get
mix ecto.setup
mix phx.server
```

http://localhost:4000 — `admin@example.com` / `password123456`

## Meilisearch (recommended, MIT, free commercial)

```sh
export MEILISEARCH_ENDPOINT=http://127.0.0.1:7700
export MEILISEARCH_API_KEY=your-master-key   # optional for local
```

## Zoho email (IMAP + SMTP)

Emails become `type: "email"` task nodes and appear on the kanban.

```sh
export EPH_MAIL_USER=you@zoho.com
export EPH_MAIL_PASSWORD=app-password
export EPH_IMAP_HOST=imap.zoho.com
export EPH_SMTP_HOST=smtp.zoho.com
```

## Architecture notes

- Graph: Node + Link (Ecto + SQLite). Emails are nodes with type `email`.
- Search: Meilisearch (MIT).
- UI: Tabler (includes Bootstrap 5.3).
- Distro-agnostic. Tested pattern for Devuan / sysvinit hosts.
