defmodule AdminApi.Repositories.Users.Create do
  alias AdminApi.Repo
  alias AdminApi.Schemas.User

  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end
end
