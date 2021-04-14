defmodule AdminApiWeb.ProductsViewTest do
  use AdminApiWeb.ConnCase, async: true

  import Phoenix.View

  alias AdminApi.Repositories.Categories.Create, as: CategoryCreate
  alias AdminApi.Repositories.Products.Create, as: ProductCreate
  alias AdminApi.Repositories.Products.Delete, as: ProductDelete
  alias AdminApi.Repositories.Products.Edit, as: ProductUpdate

  alias AdminApi.Schemas.Category
  alias AdminApi.Schemas.Product
  alias AdminApiWeb.ProductsView

  test "renders create.json" do
    category_params = %{
      "name" => "Category",
      "image" => "https://www.flaticon.com/svg/vstatic/svg/570/570975.svg?token=exp=1615414043~hmac=e2e9ecb2f84f52b1c9036c4566183bda"
    }

    {:ok, %Category{id: id}} = CategoryCreate.create_category(category_params)

    params = %{
      "category_id" => id,
      "name" => "Product",
      "image" => "https://www.flaticon.com/svg/vstatic/svg/570/570975.svg?token=exp=1615414043~hmac=e2e9ecb2f84f52b1c9036c4566183bda",
      "price" => "2.99"
    }

    {:ok, %Product{}} = ProductCreate.create_product(params)

    response = render(ProductsView, "success.json", %{message: "Product Created Successfully"})

    expected_response = %{message: "Product Created Successfully"}

    assert expected_response == response
  end

  test "renders success.json on update" do
    category_params = %{
      "name" => "Category",
      "image" => "https://www.flaticon.com/svg/vstatic/svg/570/570975.svg?token=exp=1615414043~hmac=e2e9ecb2f84f52b1c9036c4566183bda"
    }

    {:ok, %Category{id: category_id}} = CategoryCreate.create_category(category_params)

    params = %{
      "category_id" => category_id,
      "name" => "Product",
      "image" => "https://www.flaticon.com/svg/vstatic/svg/570/570975.svg?token=exp=1615414043~hmac=e2e9ecb2f84f52b1c9036c4566183bda",
      "price" => "2.99"
    }

    {:ok, %Product{id: id,category_id: category_id}} = ProductCreate.create_product(params)

    params_to_update = %{
      "id" => id,
      "category_id" => category_id,
      "name" => "Product Updated",
      "image" => "https://www.flaticon.com/svg/vstatic/svg/570/570975.svg?token=exp=1615414043~hmac=e2e9ecb2f84f52b1c9036c4566183bda",
      "price" => "5.99"
    }

    {:ok, %Product{}} = ProductUpdate.update_product(params_to_update)

    response = render(ProductsView, "success.json", %{message: "Product Updated Successfully"})

    expected_response = %{message: "Product Updated Successfully"}

    assert expected_response == response
  end

  test "renders success.json on delete" do
    category_params = %{
      "name" => "Category",
      "image" => "https://www.flaticon.com/svg/vstatic/svg/570/570975.svg?token=exp=1615414043~hmac=e2e9ecb2f84f52b1c9036c4566183bda"
    }

    {:ok, %Category{id: category_id}} = CategoryCreate.create_category(category_params)

    params = %{
      "category_id" => category_id,
      "name" => "Product",
      "image" => "https://www.flaticon.com/svg/vstatic/svg/570/570975.svg?token=exp=1615414043~hmac=e2e9ecb2f84f52b1c9036c4566183bda",
      "price" => "2.99"
    }

    {:ok, %Product{id: id}} = ProductCreate.create_product(params)

    {:ok, %Product{}} = ProductDelete.delete_product(id)

    response = render(ProductsView, "success.json", %{message: "Product Deleted Successfully"})

    expected_response = %{message: "Product Deleted Successfully"}

    assert expected_response == response
  end
end
