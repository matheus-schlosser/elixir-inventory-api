defmodule AdminApiWeb.ProductsView do
  use AdminApiWeb, :view

  def render("product.json", %{product: product}) do
    %{
      id: product.id,
      name: product.name,
      category_id: product.category_id,
      image: product.image,
      price: product.price
    }
  end

  def render("show.json", %{product: product}) do
    %{
      data: render_one(product, __MODULE__, "product.json", as: :product)
    }
  end

  def render("index.json", %{products: products}) do
    %{
      data: render_many(products, __MODULE__, "product.json", as: :product)
    }
  end

  def render("success.json", %{message: message}) do
    %{message: message}
  end
end
