defmodule AdminApiWeb.CategoriesView do
  use AdminApiWeb, :view

  alias AdminApiWeb.ProductsView

  def render("category.json", %{category: category}) do
    %{
      id: category.id,
      name: category.name,
      image: category.image,
    }
  end

  def render("category_products.json", %{category: category}) do
    %{
      id: category.id,
      name: category.name,
      image: category.image,
      products: render_many(category.product, ProductsView, "product.json", as: :product)
    }
  end

  def render("index.json", %{categories: categories}) do
    %{
      data: render_many(categories, __MODULE__, "category_products.json", as: :category)
    }
  end

  def render("show.json", %{category: category}) do
    %{
      data: render_one(category, __MODULE__, "category_products.json", as: :category)
    }
  end

  def render("success.json", %{message: message}) do
    %{message: message}
  end

end
