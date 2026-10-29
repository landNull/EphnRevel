import Config

config :eph_revel,
  ecto_repos: [EphRevel.Repo]

config :eph_revel, EphRevelWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: EphRevelWeb.ErrorHTML, json: EphRevelWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: EphRevel.PubSub,
  live_view: [signing_salt: "ephrevelsalt"]

config :eph_revel, EphRevel.Mailer, adapter: Swoosh.Adapters.Local

config :swoosh, :api_client, false

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
