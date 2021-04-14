defmodule AdminApi.ProductsTest do
  use AdminApi.DataCase, async: true

  alias AdminApi.Repositories.Categories.Create, as: CategoryCreate
  alias AdminApi.Repositories.Products.Create, as: ProductCreate
  alias AdminApi.Repositories.Products.Delete, as: ProductDelete
  alias AdminApi.Repositories.Products.Edit, as: ProductUpdate
  alias AdminApi.Repositories.Products.Get, as: ProductGet
  alias AdminApi.Schemas.{Category, Product}

  describe "Products" do

    defp fixture() do
      category_params = %{name: "Category Name", image: "Some image"}
      {:ok, %Category{id: category_id}} = CategoryCreate.create_category(category_params)

      %{category_id: category_id}
    end

    test "lists all products on index" do
      data = fixture()
      product_params = %{category_id: data.category_id, name: "Product Name", image: "Some Image", price: "5.99"}

      {:ok, %Product{} = products} = ProductCreate.create_product(product_params)

      assert ProductGet.get_products() == [products]
    end

    test "get_product/1 returns the product with given id" do
      data = fixture()
      product_params = %{category_id: data.category_id, name: "Product Name", image: "Some Image", price: "5.99"}

      {:ok, %Product{} = product} = ProductCreate.create_product(product_params)

      assert ProductGet.get_product(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      data = fixture()

      product_params = %{category_id: data.category_id, name: "Product Name", image: "Some Image", price: "5.99"}

      assert {:ok, %Product{} = product} = ProductCreate.create_product(product_params)
      assert product.category_id == data.category_id
      assert product.name == "Product Name"
      assert product.image == "Some Image"
      assert product.price == "5.99"
    end

    test "create_product/1 with invalid data returns error changeset" do
      data = fixture()

      product_invalid_params = %{category_id: data.category_id, name: "", image: "", price: ""}
      assert {:error, %Ecto.Changeset{}} = ProductCreate.create_product(product_invalid_params)
    end

    test "update_product/2 with valid data updates the product" do
      data = fixture()
      product_params = %{category_id: data.category_id, name: "Product Name", image: "Some Image", price: "5.99"}
      product_updated_params = %{category_id: data.category_id, name: "Product Name Updated", image: "Some Image Updated", price: "9.99"}

      {:ok, %Product{id: id}} = ProductCreate.create_product(product_params)

      params = Map.put(product_updated_params, :id, id)

      assert {:ok, %Product{} = product} = ProductUpdate.update_product(params)
      assert product.category_id == product.category_id
      assert product.name == "Product Name Updated"
      assert product.image == "Some Image Updated"
      assert product.price == "9.99"
    end

    test "delete_product/1 deletes the product" do
      data = fixture()
      product_params = %{category_id: data.category_id, name: "Product Name", image: "Some Image", price: "5.99"}

      {:ok, %Product{id: id}} = ProductCreate.create_product(product_params)

      assert {:ok, %Product{}} = ProductDelete.delete_product(id)
    end
  end
end
