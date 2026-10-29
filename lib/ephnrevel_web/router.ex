defmodule EphnRevelWeb.Router do
  use EphnRevelWeb, :router

  import EphnRevelWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {EphnRevelWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EphnRevelWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/", EphnRevelWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live "/users/log_in", UserLoginLive, :new
    post "/users/log_in", UserSessionController, :create
  end

  scope "/", EphnRevelWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/dashboard", DashboardLive, :index
    live "/board", BoardLive, :index
    live "/nodes", NodeLive.Index, :index
    live "/nodes/new", NodeLive.Index, :new
    live "/nodes/:id", NodeLive.Show, :show
    live "/nodes/:id/edit", NodeLive.Index, :edit

    delete "/users/log_out", UserSessionController, :delete
  end

  if Application.compile_env(:ephnrevel, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: EphnRevelWeb.Telemetry
    end
  end
end
