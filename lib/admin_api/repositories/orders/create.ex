defmodule AdminApi.Repositories.Orders.Create do
  alias AdminApi.Repo
  alias AdminApi.Schemas.Order

  def create_order(params) do
    %Order{}
    |> Order.changeset(params)
    |> Repo.insert()
  end



end
