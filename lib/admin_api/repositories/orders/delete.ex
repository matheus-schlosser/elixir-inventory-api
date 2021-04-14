defmodule AdminApi.Repositories.Orders.Delete do
  alias AdminApi.Repo
  alias AdminApi.Schemas.Order
  alias Ecto.Multi

  def delete_order(id) do
    Multi.new()
    |> Multi.run(:order, fn repo, _changes -> get_order(repo, id) end)
    |> Multi.run(:delete_order, fn repo, %{order: order} ->
      delete(repo, order)
    end)
    |> run_transaction()
  end

  defp get_order(repo, id) do
    case repo.get(Order, id) do
      nil -> {:error, "Order Not Found!"}
      order -> {:ok, order}
    end
  end

  defp delete({:error, _reason} = error, _repo), do: error
  defp delete(repo, order) do
    order
    |> repo.delete()
  end


  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{delete_order: order}} -> {:ok, order}
    end
  end
end
