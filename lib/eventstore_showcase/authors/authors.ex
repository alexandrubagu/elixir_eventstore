defmodule EventstoreShowcase.Authors do
  alias EventstoreShowcase.{
    Repo,
    Author,
    AuthorCreated,
    AuthorModified
  }

  def create_author(event) do
    %{name: event.name}
    |> Author.create_author()
    |> Repo.insert()
    |> generate_event(:author_created)
    |> append_to_stream
  end

  def generate_event({:ok, author}, :author_created),
    do: %AuthorCreated{
      id: author.id,
      name: author.name
    }

  def generate_event({:error, changeset}, _) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  def append_to_stream(%AuthorCreated{id: author_id} = event) do
    # A new stream will be created when the expected version is zero.
    expected_version = 0

    events = [
      %EventStore.EventData{
        event_type: Atom.to_string(event.__struct__),
        data: event
      }
    ]

    EventStore.append_to_stream(author_id, expected_version, events)
  end
end
