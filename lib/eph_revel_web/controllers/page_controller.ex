defmodule EphRevelWeb.PageController do
  use EphRevelWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
