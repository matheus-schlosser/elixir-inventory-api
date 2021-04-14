defmodule AdminApiWeb.Router do
  use AdminApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug AdminApi.Accounts.Auth.Pipeline
  end

  scope "/api/auth", AdminApiWeb do
    post "/signup", UsersController, :signup
    post "/signin", UsersController, :signin
  end

  scope "/v1", AdminApiWeb do
    pipe_through [:api, :auth]

    get "/clients", ClientsController, :index
    get "/clients/:id", ClientsController, :show
    post "/clients/create-client", ClientsController, :create
    put "/clients/edit-client/:id", ClientsController, :update
    delete "/clients/delete-client/:id", ClientsController, :delete

    get "/categories/products", ProductsController, :index
    get "/categories/products/:id", ProductsController, :show
    post "/categories/products/create-product", ProductsController, :create
    put "/categories/products/edit-product/:id", ProductsController, :update
    delete "/categories/products/delete-product/:id", ProductsController, :delete

    get "/categories", CategoriesController, :index
    get "/categories/:id", CategoriesController, :show
    post "/categories/create-category", CategoriesController, :create
    put "/categories/edit-category/:id", CategoriesController, :update
    delete "/categories/delete-category/:id", CategoriesController, :delete

    get "/orders", OrdersController, :index
    get "/orders/:id", OrdersController, :show
    post "/orders/create-order", OrdersController, :create
    put "/orders/edit-order/:id", OrdersController, :update
    delete "/orders/delete-order/:id", OrdersController, :delete

    get "/stats", StatsController, :index

  end

end
