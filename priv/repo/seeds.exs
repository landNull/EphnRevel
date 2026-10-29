alias EphRevel.Accounts
alias EphRevel.Graph

# Admin user for first login
{:ok, _user} =
  Accounts.register_user(%{
    email: "admin@example.com",
    password: "password123456"
  })

# Demo graph (Northwind-style nodes)
{:ok, project} = Graph.create_node(%{type: "project", title: "Northwind Demo", payload: %{column: "active"}})
{:ok, task1} = Graph.create_node(%{type: "task", title: "Design schema", payload: %{column: "todo"}})
{:ok, task2} = Graph.create_node(%{type: "task", title: "Implement LiveView board", payload: %{column: "doing"}})
{:ok, task3} = Graph.create_node(%{type: "task", title: "Ship first login", payload: %{column: "done"}})

Graph.create_link(%{source_id: project.id, target_id: task1.id, kind: "contains"})
Graph.create_link(%{source_id: project.id, target_id: task2.id, kind: "contains"})
Graph.create_link(%{source_id: project.id, target_id: task3.id, kind: "contains"})

IO.puts("Seeded admin@example.com / password123456 and demo graph")
