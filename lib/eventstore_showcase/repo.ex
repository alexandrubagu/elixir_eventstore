defmodule EventstoreShowcase.Repo do
  use Ecto.Repo,
    otp_app: :eventstore_showcase,
    adapter: Ecto.Adapters.Postgres
end
