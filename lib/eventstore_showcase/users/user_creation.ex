defmodule EventstoreShowcase.UserCreation do
  defmodule Cmd do
    use Ecto.Schema
    import Ecto.Changeset
    alias EventstoreShowcase.Repo
    alias EventstoreShowcase.User

    @required ~w(name)a
    @optional ~w(id)a

    @primary_key {:id, :binary_id, autogenerate: true}
    embedded_schema do
      field :name, :string
    end

    def build(params) do
      changeset =
        %__MODULE__{}
        |> cast(params, @required ++ @optional)
        |> put_uuid
        |> validate_required(@required)

      case changeset.valid? do
        true -> {:ok, apply_changes(changeset)}
        false -> {:error, changeset}
      end
    end

    def put_uuid(changeset) do
      case get_field(changeset, :id) do
        nil -> put_change(changeset, :id, Ecto.UUID.generate())
        _ -> changeset
      end
    end

    def check_user_uniqueness(command) do
      case Repo.get_by(User, name: command.name) do
        nil ->
          :ok

        _ ->
          {:error, :already_used}
      end
    end

    def new(params) do
      with {:ok, command} <- build(params),
           :ok <- check_user_uniqueness(command) do
        {:ok, command}
      end
    end
  end

  defmodule Event do
    defstruct [:id, :name]

    def from_command(command) do
      %__MODULE__{
        id: command.id,
        name: command.name
      }
    end
  end
end
