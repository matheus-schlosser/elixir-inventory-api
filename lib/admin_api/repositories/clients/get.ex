defmodule AdminApi.Repositories.Clients.Get do
  alias AdminApi.Repo
  alias AdminApi.Schemas.Client

  def get_clients, do: Repo.all(Client)
  def get_client(id), do: Repo.get(Client, id)

end
