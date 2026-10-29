defmodule EphRevelWeb.NodeLive.FormComponent do
  use EphRevelWeb, :live_component

  alias EphRevel.Graph

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h2 class="h4 mb-3"><%= @title %></h2>

      <.simple_form
        for={@form}
        id="node-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:type]} type="text" label="Type" placeholder="task, email, project…" />
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:external_id]} type="text" label="External ID" />

        <div class="mb-3">
          <label class="form-label">Payload (JSON)</label>
          <textarea name="node[payload_json]" class="form-control" rows="6"><%= @payload_json %></textarea>
          <div class="form-text">Object stored as the node payload (e.g. column, subject, from, body).</div>
        </div>

        <:actions>
          <.button phx-disable-with="Saving…" class="btn btn-primary">Save Node</.button>
          <.link patch={@patch} class="btn btn-secondary ms-2">Cancel</.link>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{node: node} = assigns, socket) do
    payload_json = Jason.encode!(node.payload || %{}, pretty: true)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:payload_json, payload_json)
     |> assign_new(:form, fn ->
       to_form(Graph.change_node(node))
     end)}
  end

  @impl true
  def handle_event("validate", %{"node" => node_params}, socket) do
    changeset =
      socket.assigns.node
      |> Graph.change_node(node_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"node" => node_params}, socket) do
    save_node(socket, socket.assigns.action, node_params)
  end

  defp save_node(socket, :edit, node_params) do
    case Graph.update_node(socket.assigns.node, node_params) do
      {:ok, node} ->
        notify_parent({:saved, node})

        {:noreply,
         socket
         |> put_flash(:info, "Node updated")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_node(socket, :new, node_params) do
    case Graph.create_node(node_params) do
      {:ok, node} ->
        notify_parent({:saved, node})

        {:noreply,
         socket
         |> put_flash(:info, "Node created")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
