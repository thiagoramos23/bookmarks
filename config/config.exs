# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bookmarks,
  ecto_repos: [Bookmarks.Repo]

# Configures the endpoint
config :bookmarks, BookmarksWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "CTXyV867gXmGY0UwH/hpZVNg8a4QNM8J57+PSfoGoNTdzyRnLMbJidKpuT5J/pYx",
  render_errors: [view: BookmarksWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Bookmarks.PubSub,
  live_view: [signing_salt: "kQEf+IrA"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
