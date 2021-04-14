defmodule AdminApi.Schemas.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias AdminApi.Schemas.Category

  @required_params [:category_id, :name, :image, :price]

  schema "products" do
    field :name, :string
    field :image, :string
    field :price, :string

    belongs_to :category, Category
    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_params)
    |> foreign_key_constraint(:category_id, message: "Verify category_id before execute")
    |> validate_required(@required_params)
  end

end
