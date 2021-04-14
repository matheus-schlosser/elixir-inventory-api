defmodule AdminApiWeb.UsersController do
  use AdminApiWeb, :controller
  alias AdminApi.Accounts.Auth.Guardian
  alias AdminApi.Schemas.User

  alias AdminApi.Repositories.Users.Create, as: UserCreate

  action_fallback AdminApiWeb.FallbackController

  def signup(conn, params) do
    with {:ok, %User{}} <- UserCreate.create_user(params) do
      conn
      |> put_status(:created)
      |> render("success.json", message: "User Created Successfully")
    end
  end

  def signin(conn, %{"email" => email, "password" => password}) do
    with {:ok, _user, token} <- Guardian.authenticate(email, password) do
      conn
      |> put_status(:ok)
      |> render("user_auth.json", %{auth: true, token: token})
    end
  end
end
