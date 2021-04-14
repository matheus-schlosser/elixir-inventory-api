defmodule AdminApi.Accounts.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :admin_api,
    module: AdminApi.Accounts.Auth.Guardian,
    error_handler: AdminApi.Accounts.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
