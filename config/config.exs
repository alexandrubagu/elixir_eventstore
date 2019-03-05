# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :eventstore_showcase,
  ecto_repos: [EventstoreShowcase.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :eventstore_showcase, EventstoreShowcaseWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iNfUPKX3UuSIGIO+yNn/xj2IUkA+TpoQ9xEmzQ2VSjaXoeKHu0iNyB66wGwilTRF",
  render_errors: [view: EventstoreShowcaseWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: EventstoreShowcase.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :eventstore, column_data_type: "jsonb"

config :eventstore, EventStore.Storage,
  serializer: EventStore.JsonbSerializer,
  types: EventStore.PostgresTypes

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
