defmodule AdminApiWeb.OrdersControllerTest do
  use AdminApiWeb.ConnCase, async: true

  alias AdminApi.Accounts.Auth.Guardian
  alias AdminApi.Repositories.Categories.Create, as: CategoryCreate
  alias AdminApi.Repositories.Clients.Create, as: ClientCreate
  alias AdminApi.Repositories.Orders.Create, as: OrderCreate
  alias AdminApi.Repositories.Products.Create, as: ProductCreate
  alias AdminApi.Repositories.Users.Create, as: UserCreate
  alias AdminApi.Schemas.{Category, Client, Order, Product}

  describe "Orders Tests" do

    @invalid_params %{client_id: nil, product_id: nil, description: nil, quantity: nil, status: nil}

    defp fixture() do
      client_params = %{name: "company test", responsible: "responsible test", phone: "99999999", active: true}
      {:ok, %Client{id: client_id}} = ClientCreate.create_client(client_params)

      category_params = %{name: "Category Name", image: "Some image"}
      {:ok, %Category{id: category_id}} = CategoryCreate.create_category(category_params)

      product_params = %{category_id: category_id, name: "Product Name", image: "Some Image", price: "5.99"}
      {:ok, %Product{id: product_id}} = ProductCreate.create_product(product_params)

      %{client_id: client_id, category_id: category_id, product_id: product_id}
    end

    setup %{conn: conn} do
      {:ok, user} = UserCreate.create_user(%{name: "user", email: "user@test.com", password: "123456"})
      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      conn = conn
      |> put_req_header("authorization", "Bearer " <> token)

      {:ok, conn: conn}
    end

    test "create order when data is valid", %{conn: conn} do
      data = fixture()

      orders_params = %{
        client_id: data.client_id,
        product_id: data.product_id,
        description: "Some Description",
        quantity: 1,
        status: true
      }

      response =
        conn
          |> post(Routes.orders_path(conn, :create, orders_params))
          |> json_response(:created)

      expected_response = %{"message" => "Order Created Successfully"}

      assert response == expected_response
    end

    test "render erro when data is invalid to create order", %{conn: conn} do
      response =
        conn
          |> post(Routes.orders_path(conn, :create, @invalid_params))
          |> json_response(:bad_request)

      expected_response = %{"message" => %{"client_id" => ["can't be blank"], "description" => ["can't be blank"], "product_id" => ["can't be blank"], "quantity" => ["can't be blank"], "status" => ["can't be blank"]}}

      assert response == expected_response
    end

    test "lists all orders on index", %{conn: conn} do
      response =
        conn
          |> get(Routes.orders_path(conn, :index))
          |> json_response(:ok)

      expected_response = %{"data" => []}

      assert response == expected_response
    end

    test "lists the order chosen", %{conn: conn} do
      data = fixture()

      orders_params = %{
        client_id: data.client_id,
        product_id: data.product_id,
        description: "Some Description",
        quantity: 1,
        status: true
      }

      {:ok, %Order{id: id}} = OrderCreate.create_order(orders_params)

      response =
        conn
          |> get(Routes.orders_path(conn, :show, id))
          |> json_response(:ok)

      expected_response = %{"client_id" => data.client_id, "description" => "Some Description", "product_id" => data.product_id, "quantity" => 1}

      assert response == expected_response
    end

    test "update order when data is valid", %{conn: conn} do
      data = fixture()

      orders_params = %{
        client_id: data.client_id,
        product_id: data.product_id,
        description: "Some Description",
        quantity: 1,
        status: true
      }

      orders_updated_params = %{
        client_id: data.client_id,
        product_id: data.product_id,
        description: "Some Description Updated",
        quantity: 5,
        status: true
      }

      {:ok, %Order{} = order} = OrderCreate.create_order(orders_params)

      response =
        conn
          |> put(Routes.orders_path(conn, :update, order, orders_updated_params))
          |> json_response(:ok)

      expected_response = %{"message" => "Order Updated Successfully"}

      assert response == expected_response
    end

    test "delete_post/1 deletes order", %{conn: conn} do
      data = fixture()

      orders_params = %{
        client_id: data.client_id,
        product_id: data.product_id,
        description: "Some Description",
        quantity: 1,
        status: true
      }

      {:ok, %Order{id: id}} = OrderCreate.create_order(orders_params)

      response =
        conn
          |> delete(Routes.orders_path(conn, :delete, id))
          |> json_response(:ok)

      expected_response = %{"message" => "Order Deleted Successfully"}

      assert response == expected_response
    end

    test "delete_post/1 show erro when delete order with wrong id", %{conn: conn} do
      response =
        conn
          |> delete(Routes.orders_path(conn, :delete, 999))
          |> json_response(:bad_request)

      expected_response = %{"message" => "Order Not Found!"}

      assert response == expected_response
    end

  end
end
