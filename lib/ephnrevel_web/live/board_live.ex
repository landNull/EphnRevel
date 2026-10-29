defmodule EphnRevelWeb.BoardLive do
  use EphnRevelWeb, :live_view

  alias EphnRevel.Graph

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "Board", query: "", type_filter: nil, columns: Graph.board())}
  end

  def handle_event("filter", %{"query" => q, "type" => type}, socket) do
    type = if type == "", do: nil, else: type
    filters = if type, do: ["type = #{type}"], else: []
    columns = Graph.board(type, q, filters)
    {:noreply, assign(socket, query: q, type_filter: type, columns: columns)}
  end

  def render(assigns) do
    ~H"""
    <h1 class="h2 mb-3">Kanban Board</h1>
    <form phx-change="filter" class="row g-2 mb-4">
      <div class="col-md-6">
        <input type="search" name="query" value={@query} class="form-control" placeholder="Search tasks, emails, titles…" />
      </div>
      <div class="col-md-3">
        <select name="type" class="form-select">
          <option value="">All types</option>
          <option value="task" selected={@type_filter == "task"}>Tasks</option>
          <option value="email" selected={@type_filter == "email"}>Emails</option>
          <option value="project" selected={@type_filter == "project"}>Projects</option>
        </select>
      </div>
    </form>
    <div class="row">
      <%= for {col, nodes} <- @columns do %>
        <div class="col-md-3">
          <div class="card mb-3">
            <div class="card-header"><%= col %> <span class="badge bg-secondary"><%= length(nodes) %></span></div>
            <div class="card-body">
              <%= for node <- nodes do %>
                <div class={"card mb-2 border-start border-4 #{if node.type == "email", do: "border-info", else: "border-primary"}"}>
                  <div class="card-body p-2">
                    <strong><%= node.title %></strong><br>
                    <small class="text-muted"><%= node.type %></small>
                    <%= if node.type == "email" do %>
                      <div class="small text-muted"><%= get_in(node.payload, ["from"]) %></div>
                    <% end %>
                  </div>
                </div>
              <% end %>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    <p class="text-muted small mt-3">Filtering uses Meilisearch when configured (MEILISEARCH_ENDPOINT). Otherwise falls back to local query.</p>
    """
  end
end
