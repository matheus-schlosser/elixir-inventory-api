defmodule AdminApi.Schemas.Client do
  use Ecto.Schema
  import Ecto.Changeset
  alias AdminApi.Schemas.Order

  @required_params [:name, :responsible, :phone, :active]

  schema "clients" do
    field :name, :string
    field :responsible, :string
    field :phone, :string
    field :active, :boolean

    has_many :order, Order
    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> unique_constraint(:clients, [:name])
    # |> unique_constraint(:name, message: "Client already exists")
  end

end
