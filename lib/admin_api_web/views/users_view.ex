defmodule AdminApiWeb.UsersView do
  use AdminApiWeb, :view


  def render("success.json", %{message: message}) do
    %{message: message}
  end

  def render("user_auth.json", %{auth: auth, token: token}) do
    %{
      auth: auth,
      token: token
    }
  end
end
