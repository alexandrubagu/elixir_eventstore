defmodule EventstoreShowcase.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      EventstoreShowcase.AuthorSubscriber,
      EventstoreShowcase.Repo,
      EventstoreShowcaseWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: EventstoreShowcase.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    EventstoreShowcaseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
