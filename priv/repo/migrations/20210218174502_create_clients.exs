defmodule AdminApi.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :name, :string
      add :responsible, :string
      add :phone, :string
      add :active, :boolean

      timestamps()
    end

    create unique_index(:clients, [:name])
  end
end
