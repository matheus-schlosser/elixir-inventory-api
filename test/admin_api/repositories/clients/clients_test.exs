defmodule AdminApi.ClientsTest do
  use AdminApi.DataCase, async: true

  alias AdminApi.Repositories.Clients.Create, as: ClientCreate
  alias AdminApi.Repositories.Clients.Delete, as: ClientDelete
  alias AdminApi.Repositories.Clients.Edit, as: ClientUpdate
  alias AdminApi.Repositories.Clients.Get, as: ClientGet
  alias AdminApi.Schemas.Client

  describe "Clients" do

    @create_params %{name: "Company test", responsible: "Responsible", phone: "99999999", active: true}
    @update_params %{name: "Updated name", responsible: "Updated responsible", phone: "99999999", active: true}
    @invalid_params %{name: nil, responsible: nil, phone: nil, active: nil}

    test "lists all clients on index" do
      {:ok, %Client{} = clients} = ClientCreate.create_client(@create_params)

      assert ClientGet.get_clients() == [clients]
    end


    test "get_client!/1 returns the client with given id" do
      {:ok, %Client{} = client} = ClientCreate.create_client(@create_params)

      assert ClientGet.get_client(client.id) == client
    end

    test "create_client/1 with valid data creates a client" do
      assert {:ok, %Client{} = client} = ClientCreate.create_client(@create_params)
      assert client.name == "Company test"
      assert client.responsible == "Responsible"
      assert client.phone == "99999999"
      assert client.active == true
    end

    test "create_client/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ClientCreate.create_client(@invalid_params)
    end

    test "update_client/2 with valid data updates the client" do
      {:ok, %Client{id: id}} = ClientCreate.create_client(@create_params)

      params = Map.put(@update_params, :id, id)

      assert {:ok, %Client{} = client} = ClientUpdate.update_client(params)
      assert client.name == "Updated name"
      assert client.responsible == "Updated responsible"
      assert client.phone == "99999999"
      assert client.active == true
    end

    test "update_client/2 with invalid data returns error changeset" do
      {:ok, %Client{id: id}} = ClientCreate.create_client(@create_params)

      params = Map.put(@invalid_params, :id, id)

      assert {:error, %Ecto.Changeset{}} = ClientUpdate.update_client(params)
    end

    test "delete_client/1 deletes the client" do
      {:ok, %Client{id: id}} = ClientCreate.create_client(@create_params)

      assert {:ok, %Client{}} = ClientDelete.delete_client(id)
    end

  end
end
