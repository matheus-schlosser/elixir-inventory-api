defmodule AdminApiWeb.StatsController do
  use AdminApiWeb, :controller

  alias AdminApi.Repositories.Clients.Get, as: ClientGet
  alias AdminApi.Repositories.Orders.Get, as: OrderGet
  alias AdminApi.Repositories.Products.Get, as: ProductGet

  action_fallback AdminApiWeb.FallbackController

  def index(conn, _) do
    clients = ClientGet.get_clients()
    products = ProductGet.get_products()
    orders = OrderGet.get_orders()

    clients_size = Enum.count(clients)
    products_size = Enum.count(products)
    orders_size = Enum.count(orders)

    data = %{clients: clients_size, products: products_size, orders: orders_size}

    conn
    |> render("stats.json", data: data)
  end
end
