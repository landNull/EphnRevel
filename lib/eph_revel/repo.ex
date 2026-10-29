defmodule EphRevel.Repo do
  use Ecto.Repo,
    otp_app: :eph_revel,
    adapter: Ecto.Adapters.SQLite3
end
