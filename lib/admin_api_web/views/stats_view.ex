defmodule AdminApiWeb.StatsView do
  use AdminApiWeb, :view

  def render("stats.json", %{data: data}) do
    %{
      clients: data.clients,
      products: data.products,
      orders: data.orders
    }
  end
end
