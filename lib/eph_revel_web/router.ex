defmodule EphRevelWeb.Router do
  use EphRevelWeb, :router

  import EphRevelWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {EphRevelWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EphRevelWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/", EphRevelWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live "/users/log_in", UserLoginLive, :new
    post "/users/log_in", UserSessionController, :create
  end

  scope "/", EphRevelWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/dashboard", DashboardLive, :index
    live "/board", BoardLive, :index
    live "/nodes", NodeLive.Index, :index
    live "/nodes/new", NodeLive.Index, :new
    live "/nodes/:id", NodeLive.Show, :show
    live "/nodes/:id/edit", NodeLive.Index, :edit

    delete "/users/log_out", UserSessionController, :delete
  end

  if Application.compile_env(:eph_revel, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: EphRevelWeb.Telemetry
    end
  end
end
