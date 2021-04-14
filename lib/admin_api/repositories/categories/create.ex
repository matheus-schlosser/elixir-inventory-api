defmodule AdminApi.Repositories.Categories.Create do
  alias AdminApi.Repo
  alias AdminApi.Schemas.Category

  def create_category(params) do
    %Category{}
    |> Category.changeset(params)
    |> Repo.insert()
  end
end
