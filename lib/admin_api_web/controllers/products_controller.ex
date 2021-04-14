defmodule AdminApiWeb.ProductsController do
  use AdminApiWeb, :controller
  alias AdminApi.Schemas.Product

  alias AdminApi.Repositories.Products.Create, as: ProductCreate
  alias AdminApi.Repositories.Products.Delete, as: ProductDelete
  alias AdminApi.Repositories.Products.Edit, as: ProductUpdate
  alias AdminApi.Repositories.Products.Get, as: ProductGet

  action_fallback AdminApiWeb.FallbackController

  def index(conn, _) do
    products = ProductGet.get_products()
    conn
    |> render("index.json", products: products)
  end

  def show(conn, %{"id" => id}) do
    case ProductGet.get_product(id) do
      %Product{} = product ->
        conn
        |> put_status(:ok)
        |> render("show.json", product: product)

      nil ->
        conn
        |>render("success.json", message: "Product Not Found")
    end
  end

  def create(conn, params) do
    with {:ok, %Product{}} <- ProductCreate.create_product(params) do
      conn
      |> put_status(:created)
      |> render("success.json", %{message: "Product Created Successfully"})
    end
  end

  def update(conn, params) do
    with {:ok, %Product{}} <- ProductUpdate.update_product(params) do
      conn
      |> put_status(:ok)
      |> render("success.json", %{message: "Product Updated Successfully"})
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Product{}} <- ProductDelete.delete_product(id) do
      conn
      |> render("success.json", %{message: "Product Deleted Successfully"})
    end
  end
end
