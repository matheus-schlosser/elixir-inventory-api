defmodule AdminApi.Repositories.Products.Create do
  alias AdminApi.Repo
  alias AdminApi.Schemas.Product

  def create_product(params) do
    %Product{}
    |> Product.changeset(params)
    |> Repo.insert()
  end
end
