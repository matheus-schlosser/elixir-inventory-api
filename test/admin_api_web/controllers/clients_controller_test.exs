defmodule AdminApiWeb.ClientsControllerTest do
  use AdminApiWeb.ConnCase, async: true

  alias AdminApi.Accounts.Auth.Guardian
  alias AdminApi.Repositories.Clients.Create, as: ClientCreate
  alias AdminApi.Repositories.Users.Create, as: UserCreate
  alias AdminApi.Schemas.Client

  describe "Clients Tests" do
    @create_params %{name: "company test", responsible: "responsible test", phone: "99999999", active: true}
    @update_params %{name: "some updated body", responsible: "company name updated", phone: "99999999", active: true}
    @invalid_params %{name: nil, responsible: "responsible test", phone: "99999999", active: true}

    setup %{conn: conn} do
      {:ok, user} = UserCreate.create_user(%{name: "user", email: "user@test.com", password: "123456"})
      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      conn = conn
      |> put_req_header("authorization", "Bearer " <> token)

      {:ok, conn: conn}
    end

    test "create client when data is valid", %{conn: conn} do
      response =
        conn
          |> post(Routes.clients_path(conn, :create, @create_params))
          |> json_response(:created)

      expected_response = %{"message" => "Client Created Successfully"}

      assert response == expected_response
    end

    test "render erro when data is invalid to create client", %{conn: conn} do
      response =
        conn
          |> post(Routes.clients_path(conn, :create, @invalid_params))
          |> json_response(:bad_request)

      expected_response = %{"message" => %{"name" => ["can't be blank"]}}

      assert response == expected_response
    end

    test "lists all clients on index", %{conn: conn} do
      response =
        conn
          |> get(Routes.clients_path(conn, :index))
          |> json_response(:ok)

      expected_response = %{"data" => []}

      assert response == expected_response
    end

    test "lists the client chosen", %{conn: conn} do
      {:ok, %Client{id: id}} = ClientCreate.create_client(@create_params)

      response =
        conn
          |> get(Routes.clients_path(conn, :show, id))
          |> json_response(:ok)

      expected_response = %{"data" => %{"active" => true, "id" => id, "name" => "company test", "phone" => "99999999", "responsible" => "responsible test"}}

      assert response == expected_response
    end

    test "update client when data is valid", %{conn: conn} do
      {:ok, %Client{} = client} = ClientCreate.create_client(@create_params)

      response =
        conn
          |> put(Routes.clients_path(conn, :update, client, @update_params))
          |> json_response(:ok)

      expected_response = %{"message" => "Client Updated Successfully"}

      assert response == expected_response
    end

    test "renders errors when data is invalid to update client", %{conn: conn} do
      {:ok, %Client{} = client} = ClientCreate.create_client(@create_params)

      response =
        conn
          |> put(Routes.clients_path(conn, :update, client, @invalid_params))
          |> json_response(:bad_request)

      expected_response = %{"message" => %{"name" => ["can't be blank"]}}

      assert response == expected_response
    end


    test "delete_post/1 deletes client", %{conn: conn} do
      {:ok, %Client{id: id}} = ClientCreate.create_client(@create_params)

      response =
        conn
          |> delete(Routes.clients_path(conn, :delete, id))
          |> json_response(:ok)

      expected_response = %{"message" => "Client Deleted Successfully"}

      assert response == expected_response
    end

    test "delete_post/1 show error when delete client with wrong id", %{conn: conn} do
      response =
        conn
          |> delete(Routes.clients_path(conn, :delete, 999))
          |> json_response(:bad_request)

      expected_response = %{"message" => "Client Not Found!"}

      assert response == expected_response
    end

  end
end
