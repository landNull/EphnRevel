defmodule EphnRevelWeb.PageController do
  use EphnRevelWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
