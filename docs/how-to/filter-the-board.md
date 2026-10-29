# Filter the board

This is a how-to. It assumes the reader is logged in and the Board is open.

1. Type in the search box. The board filters on title, type, and payload text.

2. Choose a type from the select (Tasks, Emails, Projects, or All).

3. The columns update. Counts appear in the column headers.

When `MEILISEARCH_ENDPOINT` is set, filtering uses Meilisearch. Otherwise it falls back to a local query.

See the [CLI reference](../reference/cli.md) for the same filter from the command line.
