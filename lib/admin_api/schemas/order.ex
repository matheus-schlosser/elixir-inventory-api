defmodule AdminApi.Schemas.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdminApi.Schemas.{Client}

  @required_params [:client_id, :product_id, :quantity, :description, :status]

  schema "orders" do
    field :product_id, :integer
    field :quantity, :integer
    field :description, :string
    field :status, :boolean

    belongs_to :client, Client

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_params)
    |> foreign_key_constraint(:client_id, message: "Verify client_id before execute")
    |> foreign_key_constraint(:product_id, message: "Verify product_id before execute")
    |> validate_required(@required_params)
  end

end
