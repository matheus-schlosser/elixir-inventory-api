defmodule AdminApi.OrdersTest do
  use AdminApi.DataCase, async: true

  alias AdminApi.Repositories.Categories.Create, as: CategoryCreate
  alias AdminApi.Repositories.Clients.Create, as: ClientCreate
  alias AdminApi.Repositories.Orders.Create, as: OrderCreate
  alias AdminApi.Repositories.Orders.Get, as: OrderGet
  alias AdminApi.Repositories.Products.Create, as: ProductCreate
  alias AdminApi.Schemas.{Category, Client, Order, Product}

  describe "Orders" do

    defp fixture() do
      client_params = %{name: "company test", responsible: "responsible test", phone: "99999999", active: true}
      {:ok, %Client{id: client_id}} = ClientCreate.create_client(client_params)

      category_params = %{name: "Category Name", image: "Some image"}
      {:ok, %Category{id: category_id}} = CategoryCreate.create_category(category_params)

      product_params = %{category_id: category_id, name: "Product Name", image: "Some Image", price: "5.99"}
      {:ok, %Product{id: product_id}} = ProductCreate.create_product(product_params)

      %{client_id: client_id, category_id: category_id, product_id: product_id}
    end

    @invalid_params %{client_id: nil, product_id: nil, quantity: nil, description: nil, status: nil}

    test "lists all orders on index" do
      data = fixture()
      orders_params = %{
        client_id: data.client_id,
        product_id: data.product_id,
        description: "Some Description",
        quantity: 1,
        status: true
      }

      {:ok, %Order{} = orders} = OrderCreate.create_order(orders_params)

      assert OrderGet.get_orders() == [orders]
    end


    test "get_order!/1 returns the order with given id" do
      data = fixture()
      orders_params = %{
        client_id: data.client_id,
        product_id: data.product_id,
        description: "Some Description",
        quantity: 1,
        status: true
      }

      {:ok, %Order{} = order} = OrderCreate.create_order(orders_params)

      assert OrderGet.get_order(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      data = fixture()
      orders_params = %{
        client_id: data.client_id,
        product_id: data.product_id,
        description: "Some Description",
        quantity: 1,
        status: true
      }

      assert {:ok, %Order{} = order} = OrderCreate.create_order(orders_params)
      assert order.client_id == data.client_id
      assert order.product_id == data.product_id
      assert order.description == "Some Description"
      assert order.quantity == 1
      assert order.status == true
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OrderCreate.create_order(@invalid_params)
    end

  end
end
