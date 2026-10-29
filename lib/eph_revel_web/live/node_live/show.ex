defmodule EphRevelWeb.NodeLive.Show do
  use EphRevelWeb, :live_view

  alias EphRevel.Graph

  def mount(%{"id" => id}, _session, socket) do
    {:ok, assign(socket, node: Graph.get_node!(id))}
  end

  def render(assigns) do
    ~H"""
    <h1 class="h2"><%= @node.title %></h1>
    <p><strong>Type:</strong> <%= @node.type %></p>
    <p><strong>Payload:</strong> <code><%= inspect(@node.payload) %></code></p>
    <.link navigate={~p"/nodes"} class="btn btn-secondary">Back</.link>
    """
  end
end
