# Graph

This is a reference. It states the contract for nodes and links.

## Node

| Field | Type | Required |
|---|---|---|
| id | integer | yes |
| type | string | yes |
| title | string | yes |
| payload | map | no (default `{}`) |
| external_id | string | no |
| inserted_at / updated_at | utc_datetime | yes |

`payload` is free-form JSON. The Board reads `payload["column"]`. Email nodes store `from`, `to`, `subject`, `body`, `message_id` inside `payload`.

## Link

| Field | Type | Required |
|---|---|---|
| id | integer | yes |
| kind | string | yes |
| source_id | integer | yes |
| target_id | integer | yes |
| payload | map | no |

A link connects two nodes. The demo seed uses `kind: "contains"` from a project to its tasks.

The store is Ecto + SQLite. It is not a native graph database. Queries are relational.

See [Why a graph of task nodes](../explanation/why-a-graph-of-task-nodes.md).
