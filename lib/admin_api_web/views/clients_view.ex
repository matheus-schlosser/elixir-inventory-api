defmodule AdminApiWeb.ClientsView do
  use AdminApiWeb, :view

  def render("client.json", %{client: client}) do
    %{
      id: client.id,
      name: client.name,
      responsible: client.responsible,
      phone: client.phone,
      active: client.active
    }
  end

  def render("index.json", %{clients: clients}) do
    %{
      data: render_many(clients, __MODULE__, "client.json", as: :client)
    }
  end

  def render("show.json", %{client: client}) do
    %{
      data: render_one(client, __MODULE__, "client.json", as: :client)
    }
  end

  def render("success.json", %{message: message}) do
    %{message: message}
  end

end
