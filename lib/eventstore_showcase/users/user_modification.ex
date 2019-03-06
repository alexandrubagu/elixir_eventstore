defmodule EventstoreShowcase.UserModification do
  defmodule Cmd do
    use Ecto.Schema
    import Ecto.Changeset
    alias EventstoreShowcase.Repo
    alias EventstoreShowcase.User

    @required ~w(user_id name)a
    @optional ~w(version)a
    embedded_schema do
      field :user_id, :binary
      field :name, :string
      field :version, :integer, default: 0
    end

    def build(params) do
      changeset =
        %__MODULE__{}
        |> cast(params, @required ++ @optional)
        |> validate_required(@required)

      case changeset.valid? do
        true -> {:ok, apply_changes(changeset)}
        false -> {:error, changeset}
      end
    end

    def check_user(command) do
      case Repo.get_by(User, id: command.user_id) do
        nil ->
          {:error, :not_found}

        user ->
          {:ok, %{command | version: user.version}}
      end
    end

    def new(params) do
      with {:ok, command} <- build(params) do
        check_user(command)
      end
    end
  end

  defmodule Event do
    defstruct [:id, :name, :version]

    def from_command(command) do
      %__MODULE__{
        id: command.id,
        name: command.name,
        version: command.version
      }
    end
  end
end
