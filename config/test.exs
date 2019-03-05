use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :eventstore_showcase, EventstoreShowcaseWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :eventstore_showcase, EventstoreShowcase.Repo,
  username: "postgres",
  password: "postgres",
  database: "eventstore_showcase_test",
  hostname: "localhost",
  pool_size: 1

config :eventstore, EventStore.Storage,
  serializer: EventStore.TermSerializer,
  username: "postgres",
  password: "postgres",
  database: "eventstore_dev",
  hostname: "localhost",
  pool_size: 1
