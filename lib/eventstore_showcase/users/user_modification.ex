defmodule EventstoreShowcase.UserModification do
  defmodule Cmd do
    use Ecto.Schema
    import Ecto.Changeset
    alias EventstoreShowcase.Repo
    alias EventstoreShowcase.User

    @required ~w(user_id name)a
    embedded_schema do
      field :user_id, :binary
      field :name, :string
    end

    def build(params) do
      changeset =
        %__MODULE__{}
        |> cast(params, @required)
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
          {:ok, user}
      end
    end

    def new(params) do
      with {:ok, command} <- build(params),
           {:ok, user} <- check_user(command) do
        {:ok, %{command: command, user: user}}
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
