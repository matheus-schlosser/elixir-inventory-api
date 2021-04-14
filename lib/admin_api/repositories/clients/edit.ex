defmodule AdminApi.Repositories.Clients.Edit do
  alias AdminApi.Repo
  alias AdminApi.Schemas.Client
  alias Ecto.Multi

  def update_client(params) do
    id = params["id"] || params.id

    Multi.new()
    |> Multi.run(:client, fn repo, _changes -> get_client(repo, id) end)
    |> Multi.run(:update_client, fn repo, %{client: client} ->
      update(repo, client, params)
    end)
    |> run_transaction()
  end

  defp get_client(repo, id) do
    case repo.get(Client, id) do
      nil -> {:error, "Client Not Found!"}
      client -> {:ok, client}
    end
  end

  defp update({:error, _reason} = error, _repo, _client), do: error

  defp update(repo, client, params) do
    client
    |> Client.changeset(params)
    |> repo.update()
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{update_client: client}} -> {:ok, client}
    end
  end
end
