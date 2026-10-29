import Config

config :eph_revel, EphRevel.Repo,
  database: Path.expand("../eph_revel_test.db", Path.dirname(__ENV__.file)),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

config :eph_revel, EphRevelWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ephreveltestsecretkeybaseatleast64characterslongfortheendpoint",
  server: false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime
