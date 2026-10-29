defmodule EphRevelWeb.NodeLive.FormComponent do
  use EphRevelWeb, :live_component

  alias EphRevel.Graph

  @impl true
  def update(%{node: node} = assigns, socket) do
    changeset = Graph.change_node(node)

    payload_json =
      case node.payload do
        %{} = p when map_size(p) > 0 -> Jason.encode!(p, pretty: true)
        _ -> "{}"
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:payload_json, payload_json)}
  end

  @impl true
  def handle_event("validate", %{"node" => params}, socket) do
    changeset =
      socket.assigns.node
      |> Graph.change_node(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"node" => params}, socket) do
    save_node(socket, socket.assigns.action, params)
  end

  defp save_node(socket, :edit, params) do
    case Graph.update_node(socket.assigns.node, params) do
      {:ok, node} ->
        notify_parent({:saved, node})

        {:noreply,
         socket
         |> put_flash(:info, "Node updated")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_node(socket, :new, params) do
    case Graph.create_node(params) do
      {:ok, node} ->
        notify_parent({:saved, node})

        {:noreply,
         socket
         |> put_flash(:info, "Node created")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h2 class="h4 mb-3"><%= @title %></h2>

      <.simple_form
        for={@changeset}
        id="node-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@changeset[:type]} type="text" label="Type" required />
        <.input field={@changeset[:title]} type="text" label="Title" required />
        <.input field={@changeset[:external_id]} type="text" label="External ID" />

        <div class="mb-3">
          <label class="form-label">Payload (JSON)</label>
          <textarea
            name="node[payload_json]"
            class="form-control font-monospace"
            rows="8"
            phx-debounce="blur"
          ><%= @payload_json %></textarea>
          <div class="form-text">Object stored as the node payload (e.g. column, subject, from).</div>
        </div>

        <:actions>
          <.button phx-disable-with="Saving...">Save Node</.button>
          <.link patch={@patch} class="btn btn-outline-secondary ms-2">Cancel</.link>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
