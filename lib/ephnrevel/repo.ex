defmodule EphnRevel.Repo do
  use Ecto.Repo,
    otp_app: :ephnrevel,
    adapter: Ecto.Adapters.SQLite3
end
