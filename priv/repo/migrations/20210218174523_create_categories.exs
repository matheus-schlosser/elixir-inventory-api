defmodule AdminApi.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :image, :string

      timestamps()
    end

    create unique_index(:categories, [:name])
  end
end
