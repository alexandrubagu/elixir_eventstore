defmodule EventstoreShowcase.Author do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "authors" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def create_author(attrs) do
    changeset(%__MODULE__{}, attrs)
  end

  def modify_author(author, attrs) do
    changeset(%__MODULE__{id: author.id}, attrs)
  end
end
