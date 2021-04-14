defmodule AdminApiWeb.ClientsViewTest do
  use AdminApiWeb.ConnCase, async: true

  import Phoenix.View

  alias AdminApi.Repositories.Clients.Create, as: ClientCreate
  alias AdminApi.Repositories.Clients.Delete, as: ClientDelete
  alias AdminApi.Repositories.Clients.Edit, as: ClientUpdate

  alias AdminApi.Schemas.Client
  alias AdminApiWeb.ClientsView

  test "renders success.json on create" do
    params = %{
      "name" => "Company 1",
      "responsible" => "James",
      "phone" => "999999",
      "active" => true
    }

    {:ok, %Client{}} = ClientCreate.create_client(params)

    response = render(ClientsView, "success.json", %{message: "Client Created Successfully"})

    expected_response = %{message: "Client Created Successfully"}

    assert expected_response == response
  end

  test "renders success.json on update" do
    params = %{
      "name" => "Company 1 Update",
      "responsible" => "James",
      "phone" => "999999",
      "active" => true
    }

    {:ok, %Client{id: id}} = ClientCreate.create_client(params)

    params_to_update = %{
      "id" => id,
      "name" => "Company Updated",
      "responsible" => "James",
      "phone" => "999999",
      "active" => true
    }

    {:ok, %Client{}} = ClientUpdate.update_client(params_to_update)

    response = render(ClientsView, "success.json", %{message: "Client Updated Successfully"})

    expected_response = %{message: "Client Updated Successfully"}

    assert expected_response == response
  end

  test "renders success.json on delete" do
    params = %{
      "name" => "Company Test",
      "responsible" => "James",
      "phone" => "999999",
      "active" => true
    }

    {:ok, %Client{id: id}} = ClientCreate.create_client(params)

    {:ok, %Client{}} = ClientDelete.delete_client(id)

    response = render(ClientsView, "success.json", %{message: "Client Deleted Successfully"})

    expected_response = %{message: "Client Deleted Successfully"}

    assert expected_response == response
  end
end
