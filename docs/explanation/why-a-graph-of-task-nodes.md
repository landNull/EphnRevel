# Why a graph of task nodes

This is an explanation. It says why every element is a node.

Revel's thesis is that a project manager should treat every element as a task node. A project, a task, an email, a note — each is a node. Relationships are links.

EphnRevel keeps that thesis. The store is two tables (`nodes`, `links`) because SQLite + Ecto is already in the stack and the prototype ran. A native graph database was not adopted because the prototype already worked and the queries needed so far are simple.

Projections (Board, Dashboard, future Calendar/Gantt) read the same nodes. They do not own separate data.

The core functions in `EphnRevel.Graph` take values and return values. The LiveViews and the CLI perform the side effects.

See the [Graph reference](../reference/graph.md).
