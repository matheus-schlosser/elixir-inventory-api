defmodule AdminApi.Repositories.Categories.Delete do
  alias AdminApi.Repo
  alias AdminApi.Schemas.Category
  alias Ecto.Multi


  def delete_category(id) do
    Multi.new()
    |> Multi.run(:category, fn repo, _changes -> get_category(repo, id) end)
    |> Multi.run(:delete_category, fn repo, %{category: category} ->
      delete(repo, category)
    end)
    |> run_transaction()
  end

  defp get_category(repo, id) do
    case repo.get(Category, id) do
      nil -> {:error, "Category Not Found!"}
      category -> {:ok, category}
    end
  end

  defp delete({:error, _reason} = error, _repo), do: error

  defp delete(repo, category) do
    category
    |> repo.delete()
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{delete_category: category}} -> {:ok, category}
    end
  end
end
