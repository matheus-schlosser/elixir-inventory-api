defmodule AdminApi.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset

  @required_params [:name, :email, :password]

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_format(:email, ~r/^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/, message: "Invalid e-mail!")
    |> update_change(:email, &String.downcase(&1))
    |> validate_length(:password,
      min: 6,
      max: 20,
      message: "Password must be between 6 to 20 digits!"
    )
    |> unique_constraint(:email, message: "User with email already exists")
    |> put_password_hash()
  end

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Pbkdf2.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
