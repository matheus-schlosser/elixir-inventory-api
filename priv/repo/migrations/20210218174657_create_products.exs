defmodule AdminApi.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :category_id, references(:categories)
      add :name, :string
      add :image, :string
      add :price, :string

      timestamps()
    end

  end
end
