defmodule EventstoreShowcase.Users do
  alias EventstoreShowcase.{
    Repo,
    User,
    UserCreated,
    UserModified
  }

  def create_user(params) do
    params
    |> User.create_user()
    |> Repo.insert()
    |> generate_event(:user_created)
    |> append_to_stream
  end

  def modify_user(user, params) do
    user
    |> User.modify_user(params)
    |> Repo.update()
    |> generate_event(:user_modified)
    |> append_to_stream
  end

  def generate_event({:ok, user}, :user_created),
    do: %UserCreated{
      id: user.id,
      name: user.name
    }

  def generate_event({:ok, user}, :user_modified),
    do: %UserModified{
      id: user.id,
      name: user.name
    }

  def generate_event({:error, changeset}, _) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  def append_to_stream(%UserCreated{id: user_id} = event) do
    # A new stream will be created when the expected version is zero.
    expected_version = 0

    events = [
      %EventStore.EventData{
        event_type: Atom.to_string(event.__struct__),
        data: event,
        metadata: "user_event"
      }
    ]

    EventStore.append_to_stream(user_id, expected_version, events)
  end

  def append_to_stream(%UserModified{id: user_id} = event) do
    stream_version =
      user_id
      |> EventStore.stream_forward()
      |> Enum.to_list()
      |> length

    events = [
      %EventStore.EventData{
        event_type: Atom.to_string(event.__struct__),
        data: event
      }
    ]

    EventStore.append_to_stream(user_id, stream_version, events)
  end
end
