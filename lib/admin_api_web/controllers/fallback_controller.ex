defmodule AdminApiWeb.FallbackController do
  use AdminApiWeb, :controller

  def call(conn, {:error, message}) do
    conn
    |> put_status(:bad_request)
    |> put_view(AdminApiWeb.ErrorView)
    |> render("error_message.json", message: message)
  end
end
