# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :thread_watcher,
  ecto_repos: [ThreadWatcher.Repo],
  image_domain: "https://thrdwchr.ga",
  api_domain: "https://api.thread-watcher.ga"

# Configures the endpoint
config :thread_watcher, ThreadWatcherWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sBEY0tdcs9Jk0PB/LTKBd8oKkDAeW4U/OWRR+N8Hc6R+mLFwBZ7du4IXvsWBM7HG",
  render_errors: [view: ThreadWatcherWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ThreadWatcher.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
