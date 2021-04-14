defmodule AdminApi.UsersTest do
  use AdminApi.DataCase, async: true

  alias AdminApi.Repositories.Users.Create, as: UserCreate
  alias AdminApi.Schemas.User

  describe "singUp/1" do
    test "when all params are valid, returns an user" do
      params = %{
        name: "Matheus",
        email: "matheus@gmail.com",
        password: "123456",
      }

      {:ok, %User{id: user_id}} = UserCreate.create_user(params)
      user = Repo.get(User, user_id)

      hashed_password = Pbkdf2.add_hash(params.password)

      assert user.name == "Matheus"
      assert user.email == "matheus@gmail.com"
      assert Pbkdf2.verify_pass("123456", hashed_password.password_hash) == true
    end

  end
end
