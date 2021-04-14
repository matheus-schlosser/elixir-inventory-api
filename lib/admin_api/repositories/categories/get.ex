defmodule AdminApi.Repositories.Categories.Get do
  alias AdminApi.Repo
  alias AdminApi.Schemas.Category


  def get_categories() do
    categories_data = Repo.all(Category)
    categories = Repo.preload(categories_data, :product)

    categories
  end

  def get_category(id) do
    category =
      Category
      |> Repo.get(id)
      |> Repo.preload(:product)

    category
  end
end
