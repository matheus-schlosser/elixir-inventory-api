defmodule AdminApi.Repositories.Products.Delete do
  alias AdminApi.Repo
  alias AdminApi.Schemas.Product
  alias Ecto.Multi

  def delete_product(id) do
    Multi.new()
    |> Multi.run(:product, fn repo, _changes -> get_product(repo, id) end)
    |> Multi.run(:delete_product, fn repo, %{product: product} ->
      delete(repo, product)
    end)
    |> run_transaction()
  end

  defp get_product(repo, id) do
    case repo.get(Product, id) do
      nil -> {:error, "Product Not Found!"}
      product -> {:ok, product}
    end
  end

  defp delete({:error, _reason} = error, _repo), do: error

  defp delete(repo, product) do
    product
    |> repo.delete()
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{delete_product: product}} -> {:ok, product}
    end
  end
end
