defmodule AdminApiWeb.CategoriesController do
  use AdminApiWeb, :controller
  alias AdminApi.Schemas.Category

  alias AdminApi.Repositories.Categories.Create, as: CategoryCreate
  alias AdminApi.Repositories.Categories.Delete, as: CategoryDelete
  alias AdminApi.Repositories.Categories.Edit, as: CategoryUpdate
  alias AdminApi.Repositories.Categories.Get, as: CategoryGet

  action_fallback AdminApiWeb.FallbackController

  def index(conn, _) do
    categories = CategoryGet.get_categories()

    conn
    |> put_status(:ok)
    |> render("index.json", categories: categories)
  end

  def show(conn, %{"id" => id}) do
    case CategoryGet.get_category(id) do
      %Category{} = category ->
        conn
        |> put_status(:ok)
        |> render("show.json", category: category)

      nil ->
        conn
        |>render("success.json", message: "Category Not Found")
    end
  end

  def create(conn, params) do
    with {:ok, %Category{}} <- CategoryCreate.create_category(params) do
      conn
      |> put_status(:created)
      |>render("success.json", message: "Category Created Successfully")
    end
  end

  def update(conn, params) do
    with {:ok, %Category{}} <- CategoryUpdate.update_category(params) do
      conn
      |> put_status(:ok)
      |>render("success.json", message: "Category Updated Successfully")
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Category{}} <- CategoryDelete.delete_category(id) do
      conn
      |> put_status(:ok)
      |>render("success.json", message: "Category Deleted Successfully")
    end
  end
end
