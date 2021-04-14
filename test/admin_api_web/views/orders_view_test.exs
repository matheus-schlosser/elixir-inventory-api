defmodule AdminApiWeb.OrdersViewTest do
  use AdminApiWeb.ConnCase, async: true

  import Phoenix.View

  alias AdminApi.Repositories.Categories.Create, as: CategoryCreate
  alias AdminApi.Repositories.Clients.Create, as: ClientCreate
  alias AdminApi.Repositories.Orders.Create, as: OrderCreate
  alias AdminApi.Repositories.Products.Create, as: ProductCreate

  alias AdminApi.Schemas.{Category, Client, Order, Product}
  alias AdminApiWeb.OrdersView

  test "renders create.json" do
    client_params = %{name: "company test", responsible: "responsible test", phone: "99999999", active: true}
    {:ok, %Client{id: client_id}} = ClientCreate.create_client(client_params)

    category_params = %{name: "Category Name", image: "Some image"}
    {:ok, %Category{id: category_id}} = CategoryCreate.create_category(category_params)

    product_params = %{category_id: category_id, name: "Product Name", image: "Some Image", price: "5.99"}
    {:ok, %Product{id: product_id}} = ProductCreate.create_product(product_params)

    %{client_id: client_id, category_id: category_id, product_id: product_id}

    orders_params = %{
      client_id: client_id,
      product_id: product_id,
      description: "Some Description",
      quantity: "1",
      status: true
    }

    {:ok, %Order{}} = OrderCreate.create_order(orders_params)

    response = render(OrdersView, "success.json", %{message: "Order Created Successfully"})

    expected_response = %{message: "Order Created Successfully"}

    assert expected_response == response
  end
end
