defmodule EphnRevelWeb.UserLoginLive do
  use EphnRevelWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="row justify-content-center">
      <div class="col-md-4">
        <div class="card">
          <div class="card-body">
            <h2 class="h4 mb-3">Log in</h2>
            <.form for={@form} id="login_form" action={~p"/users/log_in"} method="post">
              <div class="mb-3">
                <.input field={@form[:email]} type="email" label="Email" class="form-control" required />
              </div>
              <div class="mb-3">
                <.input field={@form[:password]} type="password" label="Password" class="form-control" required />
              </div>
              <div class="mb-3 form-check">
                <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" class="form-check-input" />
              </div>
              <.button class="btn btn-primary w-100" phx-disable-with="Logging in...">Log in</.button>
            </.form>
            <p class="mt-3 text-muted small">Seeded: admin@example.com / password123456</p>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
