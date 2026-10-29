defmodule EphRevelWeb.NodeLive.Index do
  use EphRevelWeb, :live_view

  alias EphRevel.Graph
  alias EphRevel.Graph.Node

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :nodes, Graph.list_nodes())}
  end

  @impl true
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

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    node = Graph.get_node!(id)
    {:ok, _} = Graph.delete_node(node)

    {:noreply, stream_delete(socket, :nodes, node)}
  end

  @impl true
  def handle_info({EphRevelWeb.NodeLive.FormComponent, {:saved, node}}, socket) do
    {:noreply, stream_insert(socket, :nodes, node)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h1 class="h2">Nodes</h1>
      <.link patch={~p"/nodes/new"} class="btn btn-primary">New Node</.link>
    </div>

    <div class="table-responsive">
      <table class="table table-striped align-middle">
        <thead>
          <tr>
            <th>Type</th>
            <th>Title</th>
            <th>Column</th>
            <th class="text-end">Actions</th>
          </tr>
        </thead>
        <tbody id="nodes" phx-update="stream">
          <tr :for={{id, node} <- @streams.nodes} id={id}>
            <td><span class="badge bg-secondary"><%= node.type %></span></td>
            <td><%= node.title %></td>
            <td><%= get_in(node.payload || %{}, ["column"]) || "—" %></td>
            <td class="text-end">
              <.link navigate={~p"/nodes/#{node}"} class="btn btn-sm btn-outline-primary me-1">Show</.link>
              <.link patch={~p"/nodes/#{node}/edit"} class="btn btn-sm btn-outline-secondary me-1">Edit</.link>
              <.link phx-click={JS.push("delete", value: %{id: node.id}) |> hide("#" <> id)}
                     data-confirm="Delete this node?"
                     class="btn btn-sm btn-outline-danger">Delete</.link>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <.modal :if={@live_action in [:new, :edit]} id="node-modal" show on_cancel={JS.patch(~p"/nodes")}>
      <.live_component
        module={EphRevelWeb.NodeLive.FormComponent}
        id={@node.id || :new}
        title={@page_title}
        action={@live_action}
        node={@node}
        patch={~p"/nodes"}
      />
    </.modal>
    """
  end
end
