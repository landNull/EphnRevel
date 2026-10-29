# CLI

This is a reference. It states the contract for `mix revelctl`.

## Commands

| Command | Effect |
|---|---|
| `mix revelctl create TYPE TITLE [--set key=value]` | Insert a node |
| `mix revelctl list` | Print every node |
| `mix revelctl board` | Print nodes grouped by column |
| `mix revelctl query ID` | Print one node |
| `mix revelctl mail status` | Print IMAP/SMTP configuration |
| `mix revelctl mail fetch` | Create email nodes from the inbox (stub) |
| `mix revelctl mail send TO SUBJECT BODY` | Create a sent email node |

The CLI and the web UI call the same Graph context. Side effects (database, HTTP to Meilisearch, SMTP) live in the shell around the pure functions.

See [Graph](graph.md).
