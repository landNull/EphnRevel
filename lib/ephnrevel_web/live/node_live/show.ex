defmodule EphnRevelWeb.NodeLive.Show do
  use EphnRevelWeb, :live_view

  alias EphnRevel.Graph

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok, assign(socket, node: Graph.get_node!(id))}
  end

  @impl true
  def handle_event("delete", _params, socket) do
    {:ok, _} = Graph.delete_node(socket.assigns.node)

    {:noreply,
     socket
     |> put_flash(:info, "Node deleted")
     |> push_navigate(to: ~p"/nodes")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="d-flex justify-content-between align-items-start mb-3">
      <h1 class="h2"><%= @node.title %></h1>
      <div>
        <.link patch={~p"/nodes/#{@node}/edit"} class="btn btn-outline-secondary me-2">Edit</.link>
        <.link phx-click="delete" data-confirm="Delete this node?" class="btn btn-outline-danger">Delete</.link>
      </div>
    </div>

    <dl class="row">
      <dt class="col-sm-2">Type</dt>
      <dd class="col-sm-10"><span class="badge bg-secondary"><%= @node.type %></span></dd>

      <dt class="col-sm-2">External ID</dt>
      <dd class="col-sm-10"><%= @node.external_id || "—" %></dd>

      <dt class="col-sm-2">Payload</dt>
      <dd class="col-sm-10">
        <pre class="bg-light p-3 rounded"><%= Jason.encode!(@node.payload || %{}, pretty: true) %></pre>
      </dd>
    </dl>

    <.link navigate={~p"/nodes"} class="btn btn-secondary">Back to Nodes</.link>
    """
  end
end
