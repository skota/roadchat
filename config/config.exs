# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :roadchat,
  ecto_repos: [Roadchat.Repo]

# geo config
config :geo_postgis,
  json_library: Jason # If you want to set your JSON module

# Configures the endpoint
config :roadchat, RoadchatWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: RoadchatWeb.ErrorHTML, json: RoadchatWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Roadchat.PubSub,
  live_view: [signing_salt: "8TJVk74c"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :roadchat, Roadchat.Mailer, adapter: Swoosh.Adapters.Local

config :swoosh, :api_client, Swoosh.ApiClient.Hackney

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
# config :logger, :console,
#   format: "$time $metadata[$level] $message\n",
#   metadata: [:request_id]
# tell logger to load a LoggerFileBackend processes
config :logger,
  backends: [:console, {LoggerFileBackend, :error_log},
             {LoggerFileBackend, :info_log}],
  format: "$time $metadata[$level] $message\n"

# configuration for the {LoggerFileBackend, :error_log} backend
config :logger, :error_log,
  path: "logs/error.log",
  level: :error

# configuration for the {LoggerFileBackend, :error_log} backend
config :logger, :info_log,
  path: "logs/info.log",
  level: :info


# guardian stuff
config :roadchat, Roadchat.Guardian,
  issuer: "roadchat",
  secret_key: "BY8grm00++tVtByLhHG15he/3GlUG0rOSLmP2/2cbIRwdR4xJk1RHvqGHPFuNcF8",
  ttl: {30, :days}

config :roadchat, Roadchat.AuthAccessPipeline,
  module: Roadchat.Guardian,
  error_handler: Roadchat.AuthErrorHandler



# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
