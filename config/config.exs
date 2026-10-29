import Config

config :ephnrevel,
  ecto_repos: [EphnRevel.Repo],
  meilisearch_endpoint: System.get_env("MEILISEARCH_ENDPOINT", "http://127.0.0.1:7700"),
  meilisearch_api_key: System.get_env("MEILISEARCH_API_KEY")

config :ephnrevel, EphnRevelWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: EphnRevelWeb.ErrorHTML, json: EphnRevelWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: EphnRevel.PubSub,
  live_view: [signing_salt: "ephnrevelsalt"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
