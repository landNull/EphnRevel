defmodule EphRevelWeb.NodeLive.Index do
  use EphRevelWeb, :live_view

  alias EphRevel.Graph
  alias EphRevel.Graph.Node

  def mount(_params, _session, socket) do
    {:ok, stream(socket, :nodes, Graph.list_nodes())}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Node")
    |> assign(:node, Graph.get_node!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Node")
    |> assign(:node, %Node{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Nodes")
    |> assign(:node, nil)
  end

  def render(assigns) do
    ~H"""
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h1 class="h2">Nodes</h1>
      <.link patch={~p"/nodes/new"} class="btn btn-primary">New Node</.link>
    </div>
    <div class="table-responsive">
      <table class="table table-striped">
        <thead>
          <tr><th>Type</th><th>Title</th><th>Column</th><th></th></tr>
        </thead>
        <tbody id="nodes" phx-update="stream">
          <tr :for={{id, node} <- @streams.nodes} id={id}>
            <td><%= node.type %></td>
            <td><%= node.title %></td>
            <td><%= get_in(node.payload, ["column"]) %></td>
            <td>
              <.link navigate={~p"/nodes/#{node}"} class="btn btn-sm btn-outline-primary">Show</.link>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end
end
