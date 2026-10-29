defmodule EphRevelWeb.BoardLive do
  use EphRevelWeb, :live_view

  alias EphRevel.Graph

  def mount(_params, _session, socket) do
    columns = Graph.board()
    {:ok, assign(socket, page_title: "Board", columns: columns)}
  end

  def render(assigns) do
    ~H"""
    <h1 class="h2 mb-4">Kanban Board</h1>
    <div class="row">
      <%= for {col, nodes} <- @columns do %>
        <div class="col-md-3">
          <div class="card mb-3">
            <div class="card-header"><%= col %></div>
            <div class="card-body">
              <%= for node <- nodes do %>
                <div class="card mb-2">
                  <div class="card-body p-2">
                    <strong><%= node.title %></strong><br>
                    <small class="text-muted"><%= node.type %></small>
                  </div>
                </div>
              <% end %>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
