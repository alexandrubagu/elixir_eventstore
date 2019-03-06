defmodule EventstoreShowcase.User do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "users" do
    field :name, :string
    field :version, :integer

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def create_user(event) do
    %__MODULE__{
      id: event.id,
      name: event.name,
      version: 0
    }
  end

  def modify_user(event, version) do
    %__MODULE__{
      id: event.user_id,
      name: event.name,
      version: version
    }
  end
end
