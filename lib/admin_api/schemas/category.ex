defmodule AdminApi.Schemas.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdminApi.Schemas.Product

  @required_params [:name, :image]

  schema "categories" do
    field :name, :string
    field :image, :string

    has_many :product, Product
    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> unique_constraint(:categories, [:name])
  end

end
