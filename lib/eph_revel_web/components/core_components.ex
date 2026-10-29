defmodule EphRevelWeb.CoreComponents do
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  attr :flash, :map, default: %{}, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group"

  def flash_group(assigns) do
    ~H"""
    <div id={@id}>
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />
    </div>
    """
  end

  attr :id, :string, doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"

  def flash(assigns) do
    ~H"""
    <div
      :if={msg = Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      class={["alert", @kind == :info && "alert-info", @kind == :error && "alert-danger"]}
      role="alert"
    >
      <%= msg %>
    </div>
    """
  end

  attr :for, :any, required: true
  attr :as, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="mb-3">
        <%= render_slot(@inner_block, f) %>
      </div>
      <div :for={action <- @actions} class="mt-3">
        <%= render_slot(action) %>
      </div>
    </.form>
    """
  end

  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  slot :inner_block, required: true

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="modal fade"
      tabindex="-1"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-body">
            <%= render_slot(@inner_block) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.add_class("show", to: "##{id}")
    |> JS.add_class("modal-open", to: "body")
    |> JS.set_attribute({"aria-hidden", "false"}, to: "##{id}")
    |> JS.set_attribute({"style", "display: block;"}, to: "##{id}")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(to: "##{id}")
    |> JS.remove_class("show", to: "##{id}")
    |> JS.remove_class("modal-open", to: "body")
    |> JS.set_attribute({"aria-hidden", "true"}, to: "##{id}")
    |> JS.remove_attribute("style", to: "##{id}")
  end

  attr :field, Phoenix.HTML.FormField
  attr :type, :string, default: "text"
  attr :label, :string
  attr :class, :string, default: "form-control"
  attr :rest, :global

  def input(assigns) do
    ~H"""
    <div class="mb-3">
      <label class="form-label"><%= @label %></label>
      <input type={@type} name={@field.name} id={@field.id} value={@field.value} class={@class} {@rest} />
    </div>
    """
  end

  attr :class, :string, default: "btn btn-primary"
  attr :rest, :global
  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button class={@class} {@rest}>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end
end
