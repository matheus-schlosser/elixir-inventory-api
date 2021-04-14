defmodule AdminApi.Repositories.Products.Get do
  alias AdminApi.Repo
  alias AdminApi.Schemas.Product

  def get_products, do: Repo.all(Product)
  def get_product(id), do: Repo.get(Product, id)

end
