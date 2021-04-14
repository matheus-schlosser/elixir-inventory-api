defmodule AdminApiWeb.ProductsControllerTest do
  use AdminApiWeb.ConnCase, async: true

  alias AdminApi.Accounts.Auth.Guardian
  alias AdminApi.Repositories.Categories.Create, as: CategoryCreate
  alias AdminApi.Repositories.Products.Create, as: ProductCreate
  alias AdminApi.Repositories.Users.Create, as: UserCreate
  alias AdminApi.Schemas.{Category, Product}

  describe "Products Tests" do

    @invalid_params %{category_id: nil, name: nil, image: nil, price: nil}

    setup %{conn: conn} do
      {:ok, user} = UserCreate.create_user(%{name: "user", email: "user@test.com", password: "123456"})
      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      conn = conn
      |> put_req_header("authorization", "Bearer " <> token)

      {:ok, conn: conn}
    end

    test "create product when data is valid", %{conn: conn} do
      category_params = %{name: "Category Name", image: "Some image"}
      {:ok, %Category{id: category_id}} = CategoryCreate.create_category(category_params)

      product_params = %{category_id: category_id, name: "Product Name", image: "Some Image", price: "5.99"}

      response =
        conn
          |> post(Routes.products_path(conn, :create, product_params))
          |> json_response(:created)

      expected_response = %{"message" => "Product Created Successfully"}

      assert response == expected_response
    end

    test "render erro when data is invalid to create product", %{conn: conn} do
      response =
        conn
          |> post(Routes.products_path(conn, :create, @invalid_params))
          |> json_response(:bad_request)

      expected_response = %{"message" => %{"category_id" => ["can't be blank"], "image" => ["can't be blank"], "name" => ["can't be blank"], "price" => ["can't be blank"]}}

      assert response == expected_response
    end

    test "lists all products on index", %{conn: conn} do
      response =
        conn
          |> get(Routes.products_path(conn, :index))
          |> json_response(:ok)

      expected_response = %{"data" => []}

      assert response == expected_response
    end

    test "lists the product chosen", %{conn: conn} do
      category_params = %{name: "Category Name", image: "Some image"}
      {:ok, %Category{id: category_id}} = CategoryCreate.create_category(category_params)

      product_params = %{category_id: category_id, name: "Product Name", image: "Some Image", price: "5.99"}
      {:ok, %Product{id: id}} = ProductCreate.create_product(product_params)

      response =
        conn
          |> get(Routes.products_path(conn, :show, id))
          |> json_response(:ok)

      expected_response = %{"data" => %{"id" => id, "name" => "Product Name", "category_id" => category_id, "image" => "Some Image", "price" => "5.99"}}

      assert response == expected_response
    end

    test "update product when data is valid", %{conn: conn} do
      category_params = %{name: "Category Name", image: "Some image"}
      {:ok, %Category{id: category_id}} = CategoryCreate.create_category(category_params)

      product_params = %{category_id: category_id, name: "Product Name", image: "Some Image", price: "5.99"}
      {:ok, %Product{} = product} = ProductCreate.create_product(product_params)

      product_update_params = %{category_id: category_id, name: "Product Name Updated", image: "Some Image Updated", price: "15.99"}

      response =
        conn
          |> put(Routes.products_path(conn, :update, product, product_update_params))
          |> json_response(:ok)

      expected_response = %{"message" => "Product Updated Successfully"}

      assert response == expected_response
    end

    test "delete_post/1 deletes product", %{conn: conn} do
      category_params = %{name: "Category Name", image: "Some image"}
      {:ok, %Category{id: category_id}} = CategoryCreate.create_category(category_params)

      product_params = %{category_id: category_id, name: "Product Name", image: "Some Image", price: "5.99"}
      {:ok, %Product{id: id}} = ProductCreate.create_product(product_params)

      response =
        conn
          |> delete(Routes.products_path(conn, :delete, id))
          |> json_response(:ok)

      expected_response = %{"message" => "Product Deleted Successfully"}

      assert response == expected_response
    end

  end
end
