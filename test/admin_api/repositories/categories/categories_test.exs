defmodule AdminApi.CategoriesTest do
  use AdminApi.DataCase, async: true

  alias AdminApi.Repo
  alias AdminApi.Repositories.Categories.Create, as: CategoryCreate
  alias AdminApi.Repositories.Categories.Delete, as: CategoryDelete
  alias AdminApi.Repositories.Categories.Edit, as: CategoryUpdate
  alias AdminApi.Repositories.Categories.Get, as: CategoryGet
  alias AdminApi.Schemas.Category

  describe "Categories" do

    @create_params %{name: "Category name", image: "Some image"}
    @update_params %{name: "Updated name", image: "Updated image"}
    @invalid_params %{name: nil, image: nil}

    test "lists all categories on index" do
      {:ok, %Category{} = categories} = CategoryCreate.create_category(@create_params)

      categories = Repo.preload(categories, :product)
      assert CategoryGet.get_categories() == [categories]
    end

    test "get_category/1 returns the category with given id" do
      {:ok, %Category{} = category} = CategoryCreate.create_category(@create_params)

      category = CategoryGet.get_category(category.id)
      category_products = Repo.preload(category, :product)

      assert CategoryGet.get_category(category.id) == category_products
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = CategoryCreate.create_category(@create_params)
      assert category.name == "Category name"
      assert category.image == "Some image"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CategoryCreate.create_category(@invalid_params)
    end

    test "update_category/2 with valid data updates the category" do
      {:ok, %Category{id: id}} = CategoryCreate.create_category(@create_params)

      params = Map.put(@update_params, :id, id)

      assert {:ok, %Category{} = category} = CategoryUpdate.update_category(params)
      assert category.name == "Updated name"
      assert category.image == "Updated image"
    end

    test "update_category/2 with invalid data returns error changeset" do
      {:ok, %Category{id: id}} = CategoryCreate.create_category(@create_params)

      params = Map.put(@invalid_params, :id, id)

      assert {:error, %Ecto.Changeset{}} = CategoryUpdate.update_category(params)
    end

    test "delete_category/1 deletes the category" do
      {:ok, %Category{id: id}} = CategoryCreate.create_category(@create_params)

      assert {:ok, %Category{}} = CategoryDelete.delete_category(id)
    end

  end
end
