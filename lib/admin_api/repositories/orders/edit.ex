defmodule AdminApi.Repositories.Orders.Edit do
  alias AdminApi.Repo
  alias AdminApi.Schemas.Order
  alias Ecto.Multi

  def update_order(params) do
    id = params["id"] || params.id

    Multi.new()
    |> Multi.run(:order, fn repo, _changes -> get_order(repo, id) end)
    |> Multi.run(:update_order, fn repo, %{order: order} ->
      update(repo, order, params)
    end)
    |> run_transaction()
  end

  defp get_order(repo, id) do
    case repo.get(Order, id) do
      nil -> {:error, "Order Not Found!"}
      order -> {:ok, order}
    end
  end

  defp update({:error, _reason} = error, _repo, _account), do: error

  defp update(repo, order, params) do
    order
    |> Order.changeset(params)
    |> repo.update()
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{update_order: order}} -> {:ok, order}
    end
  end
end
