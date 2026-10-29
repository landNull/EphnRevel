defmodule EphRevelWeb.DashboardLive do
  use EphRevelWeb, :live_view

  alias EphRevel.Graph

  def mount(_params, _session, socket) do
    stats = Graph.dashboard()
    {:ok, assign(socket, page_title: "Dashboard", stats: stats)}
  end

  def render(assigns) do
    ~H"""
    <h1 class="h2 mb-4">Dashboard</h1>
    <div class="row">
      <div class="col-md-4">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">Nodes</h5>
            <p class="display-4"><%= @stats.nodes %></p>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">Emails</h5>
            <p class="display-4"><%= @stats.emails %></p>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">Links</h5>
            <p class="display-4"><%= @stats.links %></p>
          </div>
        </div>
      </div>
    </div>
    <div class="mt-4">
      <.link navigate={~p"/board"} class="btn btn-primary">Open Board</.link>
      <.link navigate={~p"/nodes"} class="btn btn-outline-primary ms-2">All Nodes</.link>
    </div>
    """
  end
end
