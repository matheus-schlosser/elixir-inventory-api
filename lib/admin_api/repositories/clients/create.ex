defmodule AdminApi.Repositories.Clients.Create do
  alias AdminApi.Repo
  alias AdminApi.Schemas.Client

  def create_client(params) do
    %Client{}
    |> Client.changeset(params)
    |> Repo.insert()
  end
end
