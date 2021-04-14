defmodule AdminApi.Accounts.Auth.Guardian do
  use Guardian, otp_app: :admin_api
  alias AdminApi.Accounts.Auth.Session
  alias AdminApi.Repositories.Users.Get, as: GetUser

  def authenticate(email, password) do
    case Session.authenticate(email, password) do
      {:ok, user} -> create_token(user)
      _ -> {:error, :unauthorized}
    end
  end

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    case GetUser.get_user(id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end

  def create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, user, token}
  end
end
