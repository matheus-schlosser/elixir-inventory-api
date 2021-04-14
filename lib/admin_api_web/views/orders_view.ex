defmodule AdminApiWeb.OrdersView do
  use AdminApiWeb, :view

  def render("order.json", %{order: order}) do
    %{
      client_id: order.client_id,
      product_id: order.product_id,
      quantity: order.quantity,
      description: order.description
    }
  end

  def render("index.json", %{orders: orders}) do
    %{
      data: render_many(orders, __MODULE__, "order.json", as: :order)
    }
  end

  def render("show.json", %{order: order}) do
    render_one(order, __MODULE__, "order.json", as: :order)
  end

  def render("success.json", %{message: message}) do
    %{message: message}
  end

end
