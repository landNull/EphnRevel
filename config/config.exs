import Config

config :eph_revel,
  ecto_repos: [EphRevel.Repo],
  meilisearch_endpoint: System.get_env("MEILISEARCH_ENDPOINT", "http://127.0.0.1:7700"),
  meilisearch_api_key: System.get_env("MEILISEARCH_API_KEY")

config :eph_revel, EphRevelWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: EphRevelWeb.ErrorHTML, json: EphRevelWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: EphRevel.PubSub,
  live_view: [signing_salt: "ephrevelsalt"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
