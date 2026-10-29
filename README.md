# Eph-Revel

Elixir + Phoenix reimplementation of Revel.

**Thesis:** a project manager that treats every element as a task node.

CLI-first control plane. Phoenix LiveView admin with Bootstrap 5, sessions, user management. Graph store (Ecto + SQLite). Meilisearch (MIT) for typo-tolerant search and faceted filtering. Zoho IMAP/SMTP email stack (emails are task nodes on the kanban).

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
# Run Meilisearch (single binary, open source)
# https://www.meilisearch.com/docs/learn/getting_started/installation
export MEILISEARCH_ENDPOINT=http://127.0.0.1:7700
export MEILISEARCH_API_KEY=your-master-key   # optional for local
```

Board search/filter uses Meilisearch when the endpoint is reachable; otherwise falls back to local Ecto query.

## Zoho email (IMAP + SMTP)

Emails become `type: "email"` task nodes and appear on the kanban (column from payload, default `inbox`).

```sh
export EPH_MAIL_USER=you@zoho.com          # or you@yourdomain.com
export EPH_MAIL_PASSWORD=app-password      # Zoho app password if 2FA
export EPH_IMAP_HOST=imap.zoho.com         # or imappro.zoho.com for paid custom domain
export EPH_IMAP_PORT=993
export EPH_SMTP_HOST=smtp.zoho.com         # or smtppro.zoho.com
export EPH_SMTP_PORT=465                   # SSL; or 587 TLS
```

CLI:

```sh
mix revelctl mail status
mix revelctl mail fetch
mix revelctl mail send to@example.com "Subject" "Body"
```

## CLI

```sh
mix revelctl create task "Write docs" --set column=todo
mix revelctl list
mix revelctl board
mix revelctl query <id>
```

## Architecture notes

- Graph: Node + Link (Ecto). Emails are just nodes with type `email`.
- Search: Meilisearch (MIT Community Edition) — chosen over Typesense (GPL-3) for more permissive commercial use and excellent typo-tolerant + faceted filtering.
- Email: EspoCRM-style personal account pattern; IMAP fetch and SMTP send create/update nodes so everything lands on the same board.
- Distro-agnostic. Tested pattern for Devuan / sysvinit hosts.
