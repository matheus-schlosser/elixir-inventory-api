defmodule AdminApi.Repositories.Clients.Delete do
  alias AdminApi.Repo
  alias AdminApi.Schemas.Client
  alias Ecto.Multi


  def delete_client(id) do
    Multi.new()
    |> Multi.run(:client, fn repo, _changes -> get_client(repo, id) end)
    |> Multi.run(:delete_client, fn repo, %{client: client} ->
      delete(repo, client)
    end)
    |> run_transaction()
  end

  defp get_client(repo, id) do
    case repo.get(Client, id) do
      nil -> {:error, "Client Not Found!"}
      client -> {:ok, client}
    end
  end

  defp delete({:error, _reason} = error, _repo), do: error

  defp delete(repo, client) do
    client
    |> repo.delete()
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{delete_client: client}} -> {:ok, client}
    end
  end
end
