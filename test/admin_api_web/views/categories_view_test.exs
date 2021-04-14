defmodule AdminApiWeb.CategoriesViewTest do
  use AdminApiWeb.ConnCase, async: true

  import Phoenix.View

  alias AdminApi.Repositories.Categories.Create, as: CategoryCreate
  alias AdminApi.Repositories.Categories.Delete, as: CategoryDelete
  alias AdminApi.Repositories.Categories.Edit, as: CategoryUpdate

  alias AdminApi.Schemas.Category
  alias AdminApiWeb.CategoriesView

  test "renders success.json on create" do
    params = %{
      "name" => "Company 1",
      "image" => "https://www.flaticon.com/svg/vstatic/svg/570/570975.svg?token=exp=1615414043~hmac=e2e9ecb2f84f52b1c9036c4566183bda"
    }

    {:ok, %Category{}} = CategoryCreate.create_category(params)

    response = render(CategoriesView, "success.json", %{message: "Category Created Successfully"})

    expected_response = %{message: "Category Created Successfully"}

    assert expected_response == response
  end

  test "renders success.json on update" do
    params = %{
      "name" => "Category",
      "image" => "https://www.flaticon.com/svg/vstatic/svg/570/570975.svg?token=exp=1615414043~hmac=e2e9ecb2f84f52b1c9036c4566183bda"
    }

    {:ok, %Category{id: id}} = CategoryCreate.create_category(params)

    params_to_update = %{
      "id" => id,
      "name" => "Category Name Update",
      "image" => "https://www.flaticon.com/svg/vstatic/svg/570/570975.svg?token=exp=1615414043~hmac=e2e9ecb2f84f52b1c9036c4566183bda"
    }

    {:ok, %Category{}} = CategoryUpdate.update_category(params_to_update)

    response = render(CategoriesView, "success.json", %{message: "Category Updated Successfully"})

    expected_response = %{message: "Category Updated Successfully"}

    assert expected_response == response
  end

  test "renders success.json on delete" do
    params = %{
      "name" => "Company Test",
      "image" => "https://www.flaticon.com/svg/vstatic/svg/570/570975.svg?token=exp=1615414043~hmac=e2e9ecb2f84f52b1c9036c4566183bda"
    }

    {:ok, %Category{id: id}} = CategoryCreate.create_category(params)

    {:ok, %Category{}} = CategoryDelete.delete_category(id)

    response = render(CategoriesView, "success.json", %{message: "Category Deleted Successfully"})

    expected_response = %{message: "Category Deleted Successfully"}

    assert expected_response == response
  end
end
