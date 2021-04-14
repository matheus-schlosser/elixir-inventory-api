defmodule AdminApiWeb.CategoriesControllerTest do
  use AdminApiWeb.ConnCase, async: true

  alias AdminApi.Accounts.Auth.Guardian
  alias AdminApi.Repositories.Categories.Create, as: CategoryCreate
  alias AdminApi.Repositories.Users.Create, as: UserCreate
  alias AdminApi.Schemas.Category

  describe "Categories Tests" do
    @create_params %{name: "some content", image: "some image"}
    @update_params %{name: "some updated content", image: "some updated image"}
    @invalid_params %{name: nil, image: nil}

    setup %{conn: conn} do
      {:ok, user} = UserCreate.create_user(%{name: "user", email: "user@test.com", password: "123456"})
      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      conn = conn
      |> put_req_header("authorization", "Bearer " <> token)

      {:ok, conn: conn}
    end

    test "create category when data is valid", %{conn: conn} do
      response =
        conn
          |> post(Routes.categories_path(conn, :create, @create_params))
          |> json_response(:created)

      expected_response = %{"message" => "Category Created Successfully"}

      assert response == expected_response
    end

    test "render erro when data is invalid to create category", %{conn: conn} do
      response =
        conn
          |> post(Routes.categories_path(conn, :create, @invalid_params))
          |> json_response(:bad_request)

      expected_response = %{"message" => %{"name" => ["can't be blank"], "image" => ["can't be blank"]}}

      assert response == expected_response
    end

    test "lists all categories on index", %{conn: conn} do
      response =
        conn
          |> get(Routes.categories_path(conn, :index))
          |> json_response(:ok)

      expected_response = %{"data" => []}

      assert response == expected_response
    end

    test "lists the category chosen", %{conn: conn} do
      {:ok, %Category{id: id}} = CategoryCreate.create_category(@create_params)

      response =
        conn
          |> get(Routes.categories_path(conn, :show, id))
          |> json_response(:ok)

      expected_response = %{"data" => %{"id" => id, "image" => "some image", "name" => "some content", "products" => []}}

      assert response == expected_response
    end

    test "update category when data is valid", %{conn: conn} do
      {:ok, %Category{} = category} = CategoryCreate.create_category(@create_params)

      response =
        conn
          |> put(Routes.categories_path(conn, :update, category, @update_params))
          |> json_response(:ok)

      expected_response = %{"message" => "Category Updated Successfully"}

      assert response == expected_response
    end

    test "renders errors when data is invalid to update category", %{conn: conn} do
      {:ok, %Category{} = category} = CategoryCreate.create_category(@create_params)

      response =
        conn
          |> put(Routes.categories_path(conn, :update, category, @invalid_params))
          |> json_response(:bad_request)

          expected_response = %{"message" => %{"name" => ["can't be blank"], "image" => ["can't be blank"]}}

      assert response == expected_response
    end


    test "delete_post/1 deletes category", %{conn: conn} do
      {:ok, %Category{id: id}} = CategoryCreate.create_category(@create_params)

      response =
        conn
          |> delete(Routes.categories_path(conn, :delete, id))
          |> json_response(:ok)

      expected_response = %{"message" => "Category Deleted Successfully"}

      assert response == expected_response
    end

    test "delete_post/1 show erro when delete category with wrong id", %{conn: conn} do
      response =
        conn
          |> delete(Routes.categories_path(conn, :delete, 999))
          |> json_response(:bad_request)

      expected_response = %{"message" => "Category Not Found!"}

      assert response == expected_response
    end

  end
end
