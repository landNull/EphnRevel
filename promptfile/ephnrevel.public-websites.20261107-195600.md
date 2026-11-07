# ephnrevel: public-websites

- app: ephnrevel (project root: the EphnRevel checkout, default `~/Apps/EphnRevel` on Termux = `/root/Apps/EphnRevel` in the container; the repo is github.com/landNull/EphnRevel)
- created: 2026-11-07
- status: act

## Current state

File 4 of 4 in the EphnRevel data-center series. Run only after the first three verify green AND the admin-personas promptfile (`ephnrevel.admin-personas.20261107-192743.md`) verified green (Landy's locked order: websites build after the admin personas). Series order: theme-machine-shell → arcadedb-index → d7-migration → public-websites.

Verified repo facts (re-verify on disk; stop-and-report on conflict): Elixir ~1.16, Phoenix ~1.7.14, LiveView ~1.0, Ecto + ecto_sqlite3/Postgres, Bandit, Jason, Req, Tabler/Bootstrap 5.3 chrome. Graph store: `nodes` {id, type, title, payload, external_id} + `links` {kind, source_id, target_id}; 17 node types; Board reads `payload["column"]`. `revel.settings.json` = canonical brief, no secrets, decisions file-first then ledger. Ledger `planning/projects.json`. After M1-M7, these exist and are green: three personas; definitions-as-nodes in `priv/definitions/{content_types,views,layouts}/` mirrored as definition nodes; layout definition nodes (regions + displays + path pattern + conditions persona/role/node type - feature doc 017); view definition nodes; quick edit + bulk substrate; draft/published/scheduled status flow with `publish_at`; audit event nodes; Theme Machine shell (per-persona DTCG catalogs → `:root[data-theme]` stylesheets in `priv/static/themes/`); ArcadeDB derived index + `query cypher`; D7 data imported as nodes with `d7/...` external_ids; feature docs 016-021; version 0.3.x.

**What this milestone adds (the decision):** public-facing websites are first-class EphnRevel deliverables. Office design staff (accomplished Drupal 7 builders) create websites entirely through the admin interface - content types, views, layouts, theme - with zero code. A website is a project-node subgraph: content nodes + definition nodes + a theme catalog, rendered by Phoenix. Multi-site = multiple project nodes with host/path conditions; one app, one database, one index. The legal-copying principle is unchanged: structure and behavior as shapes/data, never code.

## What to do

Work milestone M8. Nodes `doing` before acting; `done` + `payload.done_on` only after verification. Add M8 ("Public-facing websites") milestone node, task nodes, and this file as a task node with external_id = this exact filename, payload.kind `promptfile`.

1. **Site context:** a website = a project node with payload `{host, path_prefix}` conditions. A `EphnRevel.Site` module resolves the current site context from host + path (single-site default when no conditions match; plain-English resolution report for debugging).
2. **Public rendering pipeline:** a public plug/router that matches a layout definition's path pattern within the resolved site, then composes: layout → regions → displays. Each display is a view definition (base node type, filters, sort, pager, display format: list/grid/table/cards, fields to show) evaluated as a graph query by the existing core; single-node displays render one node. Output renders through HEEx view-mode templates keyed by content type + display mode (the framework owns templates; definitions own everything else). Public pages show ONLY `status: published` content; drafts and scheduled are excluded everywhere public.
3. **Staff building flow (all through the Backdrop persona, no code anywhere):** create a content type → fields appear on content forms automatically; build a view → filters/sorts/fields/display + preview; build a page → layout with regions, drop views/blocks/single nodes into regions, set path pattern + conditions; write content → draft → publish; theme the site → Theme Machine tab (a site theme = a catalog + per-site token values; generated stylesheet scoped `:root[data-site="<slug>"]` alongside the persona stylesheets).
4. **Revel-native persona integration:** site management screen (list sites, site resolution report, per-site theme status); `mix revelctl site list|show` for parity.
5. **Menus and paths:** menu links render as public navigation from `contains`/`menu` links; `payload.path` aliases resolve before 404.
6. **Docs + settings:** decision to `revel.settings.json` first (public websites: site = project node subgraph, layout/view/definition composition, published-only visibility, per-site theme catalogs; staff build with zero code), mirror in the ledger; feature doc `docs/features/022-public-websites.md`; a staff tutorial `docs/tutorials/build-a-website.md` written for a Drupal 7 builder (plain English: map each familiar D7 step to its EphnRevel screen); link both from outline.md. Bump version to 0.4.0 when green.

## Build + verify

Baseline `mix test` green; after each task; red suite stops the milestone.

1. **Zero-code site build (the acceptance that matters):** using ONLY the admin interface, build a 3-page site: one content type with 3 fields, one view listing it as cards, one layout with a navigation region and a content region, three published nodes. Visit the public path: pages render themed; the view lists published nodes only.
2. Draft a fourth node: it is invisible publicly, visible in the admin Board; publish it: it appears publicly.
3. Second site: second project node with a different path prefix; its pages render under its prefix with its own theme values; the first site is unaffected.
4. If D7 data is imported: one migrated D7 node displays publicly through a view built for its type (title + path alias correct).
5. If ArcadeDB is configured: a contains-chain (menu) renders correctly from the index query path used by the site module, and the site still renders fully with the index down (degradation).
6. Ledger M8 truthful; final ledger table for the whole series printed. Agent branch commit, never main, Signed-off-by.

Rules: plain English in all docs and UI text; complete files, never partial diffs; diagnostics before fixes, read actual output; never suggest alternative setups; stop-and-report on any conflict with real code. The staff tutorial must be testable by walking it literally - if any step cannot be done from the admin interface alone, that step is a bug in this milestone, not a documentation note.