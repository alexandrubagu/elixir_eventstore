defmodule EventstoreShowcase.Users do
  alias Ecto.Multi

  alias EventstoreShowcase.{
    UserCreation,
    UserModification
  }

  alias EventstoreShowcase.{
    Repo,
    User
  }

  def create_user(params) do
    Multi.new()
    |> build_command(:create, params)
    |> authorize()
    |> handle_command()
    |> run_projections()
    |> audit_event()
    |> execute()
    |> emit_event()
    |> return(:user)
  end

  def modify_user(params) do
    Multi.new()
    |> build_command(:modify, params)
    |> authorize()
    |> handle_command()
    |> run_projections()
    |> audit_event()
    |> execute()
    |> emit_event()
    |> return(:user)
  end

  def build_command(multi, :create, params) do
    Multi.run(multi, :command, fn _, _ ->
      UserCreation.Cmd.new(params)
    end)
  end

  def build_command(multi, :modify, params) do
    Multi.run(multi, :command, fn _, _ ->
      UserModification.Cmd.new(params)
    end)
  end

  def authorize(multi), do: multi
  def audit_event(multi), do: multi
  def emit_event(multi), do: multi

  def handle_command(multi) do
    Multi.run(multi, :event, fn
      _, %{command: %UserCreation.Cmd{} = cmd} ->
        cmd
        |> UserCreation.Event.from_command()
        |> append_to_stream

      _, %{command: %UserModification.Cmd{} = cmd} ->
        cmd
        |> UserModification.Event.from_command()
        |> append_to_stream()
    end)
  end

  def append_to_stream(event) do
    events = [
      %EventStore.EventData{
        event_type: Atom.to_string(event.__struct__),
        data: event,
        metadata: "user_event"
      }
    ]

    with :ok <- EventStore.append_to_stream(event.id, event.version, events) do
      {:ok, event}
    end
  end

  def run_projections(multi) do
    Multi.insert(multi, :user, fn %{event: event} ->
      User.create_user(event)
    end)
  end

  def return({:ok, result}, key), do: Map.get(result, key)
  def return(any, _key), do: any

  def execute(multi), do: Repo.transaction(multi)
end
