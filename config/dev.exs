import Config

config :ephnrevel, EphnRevel.Repo,
  database: Path.expand("../ephnrevel_dev.db", Path.dirname(__ENV__.file)),
  pool_size: 5,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true

config :ephnrevel, EphnRevelWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "kV94NyCVF9IaSxd7pKaU9iKjDl1pjvPgilZWPwlr8gxbZhhfGFTqpjDCYXxLqABNjCFrQ9gQCdY8q5_9lDXs8Q",
  watchers: []

config :ephnrevel, EphnRevelWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/ephnrevel_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
