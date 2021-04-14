defmodule AdminApi.Repositories.Categories.Edit do
  alias AdminApi.Repo
  alias AdminApi.Schemas.Category
  alias Ecto.Multi

  def update_category(params) do
    id = params["id"] || params.id

    Multi.new()
    |> Multi.run(:category, fn repo, _changes -> get_category(repo, id) end)
    |> Multi.run(:update_category, fn repo, %{category: category} ->
      update(repo, category, params)
    end)
    |> run_transaction()
  end

  defp get_category(repo, id) do
    case repo.get(Category, id) do
      nil -> {:error, "Category Not Found!"}
      category -> {:ok, category}
    end
  end

  defp update({:error, _reason} = error, _repo, _category), do: error

  defp update(repo, category, params) do
    category
    |> Category.changeset(params)
    |> repo.update()
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{update_category: category}} -> {:ok, category}
    end
  end
end
