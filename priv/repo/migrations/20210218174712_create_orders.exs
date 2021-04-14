defmodule AdminApi.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :client_id, references(:clients)
      add :product_id, references(:products)
      add :quantity, :integer
      add :status, :boolean
      add :description, :string

      timestamps()
    end
  end
end
