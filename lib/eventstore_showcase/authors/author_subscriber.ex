defmodule EventstoreShowcase.AuthorSubscriber do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    selector = fn %EventStore.RecordedEvent{metadata: metadata} ->
      metadata == "user_event"
    end

    {:ok, subscription} =
      EventStore.subscribe_to_all_streams(Ecto.UUID.generate(), self(), selector: selector)

    {:ok, %{subscription: subscription}}
  end

  # Successfully subscribed to all streams
  def handle_info({:subscribed, subscription}, %{subscription: subscription} = state) do
    {:noreply, state}
  end

  # Event notification
  def handle_info({:events, events}, %{subscription: subscription} = state) do
    # confirm receipt of received events
    EventStore.ack(subscription, events)
    Enum.each(events, &EventstoreShowcase.Authors.create_author(&1.data))

    {:noreply, state}
  end
end
