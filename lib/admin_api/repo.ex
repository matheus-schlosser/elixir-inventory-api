defmodule AdminApi.Repo do
  use Ecto.Repo,
    otp_app: :admin_api,
    adapter: Ecto.Adapters.Postgres
end
