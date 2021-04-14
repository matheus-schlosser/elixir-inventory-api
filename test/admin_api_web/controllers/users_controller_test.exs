defmodule AdminApiWeb.UsersControllerTest do
  use AdminApiWeb.ConnCase, async: true

  alias AdminApi.Accounts.Auth.Guardian
  alias AdminApi.Repositories.Users.Create, as: UserCreate
  alias AdminApi.Schemas.User

  @create_params %{name: "Name", email: "name@email.com", password: "123456"}
  @invalid_params %{name: nil, email: nil, password: nil}

  setup %{conn: conn} do
    {:ok, user} = UserCreate.create_user(%{name: "Name", email: "user@business.com", password: "123456"})
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    conn = conn
    |> put_req_header("authorization", "Bearer " <> token)

    {:ok, conn: conn}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      response =
        conn
        |> post(Routes.users_path(conn, :signup, @create_params))
        |> json_response(:created)

      expected_response = %{"message" => "User Created Successfully"}
      assert response == expected_response
    end

    test "renders errors when data is invalid", %{conn: conn} do
      response =
        conn
        |> post(Routes.users_path(conn, :signup, @invalid_params))
        |> json_response(:bad_request)

      expected_response = %{"message" => %{"email" => ["can't be blank"], "name" => ["can't be blank"], "password" => ["can't be blank"]}}
      assert response == expected_response
    end
  end

  describe "singin/2" do
    test "when all params are valid, singin", %{conn: conn} do

      {:ok, %User{email: email, password: password}} = UserCreate.create_user(@create_params)

      params = %{
        "email" => email,
        "password" => password
      }

      response =
        conn
        |> post(Routes.users_path(conn, :signin, params))
        |> json_response(:ok)

      assert %{"auth" => true} = response
    end

    test "when there are invalid params, returns an error", %{conn: conn} do
      params = %{email: "user@business.com", password: ""}

      response =
        conn
        |> post(Routes.users_path(conn, :signin, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "unauthorized"}

      assert response == expected_response
    end
  end

end
