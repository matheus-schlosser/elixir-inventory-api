defmodule AdminApiWeb.OrdersController do
  use AdminApiWeb, :controller
  alias AdminApi.Schemas.Order

  alias AdminApi.Repositories.Orders.Create, as: OrderCreate
  alias AdminApi.Repositories.Orders.Delete, as: OrderDelete
  alias AdminApi.Repositories.Orders.Edit, as: OrderUpdate
  alias AdminApi.Repositories.Orders.Get, as: OrderGet

  action_fallback AdminApiWeb.FallbackController

  def index(conn, _) do
    orders = OrderGet.get_orders()

    conn
    |> render("index.json", orders: orders)
  end

  def show(conn, %{"id" => id}) do
    case OrderGet.get_order(id) do
      %Order{} = order ->
        conn
        |> put_status(:ok)
        |> render("show.json", order: order)

      nil ->
        conn
        |>render("success.json", message: "Order Not Found")
    end
  end

  def create(conn, params) do
    with {:ok, %Order{}} <- OrderCreate.create_order(params) do
      conn
      |> put_status(:created)
      |> render("success.json", %{message: "Order Created Successfully"})
    end
  end

  def update(conn, params) do
    with {:ok, %Order{}} <- OrderUpdate.update_order(params) do
      conn
      |> put_status(:ok)
      |> render("success.json", %{message: "Order Updated Successfully"})
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok,  %Order{}} <- OrderDelete.delete_order(id) do
      conn
      |> put_status(:ok)
      |> render("success.json", %{message: "Order Deleted Successfully"})
    end
  end
end
