defmodule AdminApi.Accounts.Auth.Session do
  import Ecto.Query

  alias AdminApi.Repo
  alias AdminApi.Schemas.User

  def authenticate(email, password) do
    query = from user in User, where: user.email == ^email

    case Repo.one(query) do
      nil ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}

      user ->
        if Pbkdf2.verify_pass(password, user.password_hash) do
          {:ok, user}
        else
          {:error, :unauthorized}
        end
    end
  end
end
