defmodule AdminApi.Repositories.Orders.Get do
  alias AdminApi.Repo
  alias AdminApi.Schemas.Order

  def get_orders, do: Repo.all(Order)
  def get_order(id), do: Repo.get(Order, id)

end
