defmodule AdminApiWeb.ClientsController do
  use AdminApiWeb, :controller
  alias AdminApi.Schemas.Client

  alias AdminApi.Repositories.Clients.Create, as: ClientCreate
  alias AdminApi.Repositories.Clients.Delete, as: ClientDelete
  alias AdminApi.Repositories.Clients.Edit, as: ClientUpdate
  alias AdminApi.Repositories.Clients.Get, as: ClientGet

  action_fallback AdminApiWeb.FallbackController

  def index(conn, _) do
    clients = ClientGet.get_clients()

    conn
    |> render("index.json", clients: clients)
  end

  def show(conn, %{"id" => id}) do
    case ClientGet.get_client(id) do
      %Client{} = client ->
        conn
        |> put_status(:ok)
        |> render("show.json", client: client)

      nil ->
        conn
        |>render("success.json", message: "Client Not Found!")
    end
  end

  def create(conn, params) do
    with {:ok, %Client{}} <- ClientCreate.create_client(params) do
      conn
      |> put_status(:created)
      |>render("success.json", message: "Client Created Successfully")
    end
  end

  def update(conn, params) do
    with {:ok, %Client{}} <- ClientUpdate.update_client(params) do
      conn
      |> put_status(:ok)
      |>render("success.json", message: "Client Updated Successfully")
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok,  %Client{}} <- ClientDelete.delete_client(id) do
      conn
      |> put_status(:ok)
      |> render("success.json", message: "Client Deleted Successfully")
    end
  end
end
