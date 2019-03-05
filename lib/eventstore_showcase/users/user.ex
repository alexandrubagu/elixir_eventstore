defmodule EventstoreShowcase.User do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "users" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def create_user(attrs) do
    changeset(%__MODULE__{}, attrs)
  end

  def modify_user(user, attrs) do
    changeset(%__MODULE__{id: user.id}, attrs)
  end
end
