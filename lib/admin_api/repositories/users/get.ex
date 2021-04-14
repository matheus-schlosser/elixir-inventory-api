defmodule AdminApi.Repositories.Users.Get do

  alias AdminApi.Repo
  alias AdminApi.Schemas.User

  def get_users, do: Repo.all(User)
  def get_user(id), do: Repo.get(User, id)

end
