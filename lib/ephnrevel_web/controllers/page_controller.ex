defmodule EphnRevelWeb.PageController do
  use EphnRevelWeb, :controller

  def home(conn, _params) do
    if conn.assigns[:current_user] do
      redirect(conn, to: ~p"/dashboard")
    else
      redirect(conn, to: ~p"/users/log_in")
    end
  end
end
