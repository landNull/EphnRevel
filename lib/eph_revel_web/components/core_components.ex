defmodule EphRevelWeb.CoreComponents do
  use Phoenix.Component

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
  attr :action, :string, default: nil
  attr :method, :string, default: nil
  attr :as, :atom, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def form(assigns) do
    ~H"""
    <form action={@action} method={@method} {@rest}>
      <%= render_slot(@inner_block) %>
    </form>
    """
  end

  attr :field, Phoenix.HTML.FormField
  attr :type, :string, default: "text"
  attr :label, :string
  attr :class, :string, default: ""
  attr :rest, :global

  def input(assigns) do
    ~H"""
    <div>
      <label class="form-label"><%= @label %></label>
      <input type={@type} name={@field.name} value={@field.value} class={@class} {@rest} />
    </div>
    """
  end

  attr :class, :string, default: ""
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
