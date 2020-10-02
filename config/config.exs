# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :dailyutils,
  namespace: DailyUtils,
  ecto_repos: [DailyUtils.Repo]

# Configures the endpoint
config :dailyutils, DailyUtilsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bOwFJYokZojxx45rLFeEeD9HJzBVqbxgY9GnrF0czGVqBsdyWc739GKeuPnvG7BQ",
  render_errors: [view: DailyUtilsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: DailyUtils.PubSub,
  live_view: [signing_salt: "vR4Bx66a"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :dailyutils, :pow,
  user: DailyUtils.Users.User,
  repo: DailyUtils.Repo,
  web_module: DailyUtilsWeb,
  extensions: [PowResetPassword, PowPersistentSession],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  mailer_backend: DailyUtils.PowMailer,
  cache_store_backend: Pow.Store.Backend.MnesiaCache

# routes_backend: DailyUtilsWeb.PowRouter

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
