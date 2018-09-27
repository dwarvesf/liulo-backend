# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :liulo,
  ecto_repos: [Liulo.Repo]

# Configures the endpoint
config :liulo, LiuloWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FhmUmF4qs1GBDmxJHk4RLmYaf9qlhTsggLmIuJoajznZn07vLePlnoLFuuIVAwZK",
  render_errors: [view: LiuloWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Liulo.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :liulo, Liulo.AuthAccessPipeline,
  module: Liulo.Guardian,
  error_handler: Liulo.AuthErrorHandler

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
