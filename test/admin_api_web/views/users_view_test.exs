defmodule AdminApiWeb.UsersViewTest do
  use AdminApiWeb.ConnCase, async: true

  import Phoenix.View

  alias AdminApi.Accounts.Auth.Guardian
  alias AdminApi.Repositories.Users.Create, as: UserCreate
  alias AdminApi.Schemas.User
  alias AdminApiWeb.UsersView

  test "renders signup.json" do
    params = %{
      "name" => "Matheus",
      "email" => "matheus@gmail.com",
      "password" => "123456",
    }

    {:ok, %User{}} = UserCreate.create_user(params)

    response = render(UsersView, "success.json", %{message: "User Created Successfully"})

    expected_response = %{message: "User Created Successfully"}

    assert expected_response == response
  end

  test "renders user_auth.json" do
    params = %{
      "name" => "Matheus",
      "email" => "matheus@gmail.com",
      "password" => "123456"
    }

    {:ok, %User{}} = UserCreate.create_user(params)

    email = params["email"]
    password = params["password"]

    {:ok, _user, token} = Guardian.authenticate(email, password)

    response = render(UsersView, "user_auth.json", %{auth: true, token: token})

    expected_response = %{
      auth: true,
      token: token
    }

    assert expected_response == response
  end


end
