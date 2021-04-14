# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :admin_api, AdminApi.Accounts.Auth.Guardian,
  issuer: "admin_api",
  # secret_key: System.get_env("GUARDIAN_SECRET")
  secret_key: "Qf9xjlYrE4xUABHeXDQFUBm8IYqqL3antKiGizZAIlSZZpr67tk7EOTv84uabuv1"

config :admin_api,
  ecto_repos: [AdminApi.Repo]

# Configures the endpoint
config :admin_api, AdminApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bcY9B2FpItDPRI7a59Rhetsve0dOYRFp5uvi5JwQKj7HeO5isQ70JmBUOBaKuCsb",
  render_errors: [view: AdminApiWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: AdminApi.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
