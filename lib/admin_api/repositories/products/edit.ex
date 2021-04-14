defmodule AdminApi.Repositories.Products.Edit do
  alias AdminApi.Repo
  alias AdminApi.Schemas.Product
  alias Ecto.Multi

  def update_product(params) do
    id = params["id"] || params.id

    Multi.new()
    |> Multi.run(:product, fn repo, _changes -> get_product(repo, id) end)
    |> Multi.run(:update_product, fn repo, %{product: product} ->
      update(repo, product, params)
    end)
    |> run_transaction()
  end

  defp get_product(repo, id) do
    case repo.get(Product, id) do
      nil -> {:error, "Product Not Found!"}
      product -> {:ok, product}
    end
  end

  defp update({:error, _reason} = error, _repo, _account), do: error

  defp update(repo, product, params) do
    product
    |> Product.changeset(params)
    |> repo.update()
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{update_product: product}} -> {:ok, product}
    end
  end
end
