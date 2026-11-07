project name: ephnrevel

Read `revel.settings.json` first: when anything conflicts with it, the JSON wins over prose and chat memory. It contains no secrets.

Build and verify commands: `mix deps.get`, `mix ecto.setup`, `mix test`, `mix phx.server`.

Ledger roll-in rules (`planning/projects.json`):

- Before acting on a promptfile, set its ledger node column to `doing`.
- Mark `done` plus `payload.done_on` only after that file's verification passes on disk.
- If no node exists, create one: next free id, type `task`, payload kind `promptfile`, and a `contains` link to the right milestone.

Files in `promptfile/` are immutable records; only the ledger is mutable.

Agents commit on `agent/<name>/<task>` branches, never main. Commit messages carry a `Signed-off-by:` trailer with the operator's identity; the operator merges.
