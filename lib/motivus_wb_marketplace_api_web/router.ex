defmodule MotivusWbMarketplaceApiWeb.Router do
  use MotivusWbMarketplaceApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug MotivusWbMarketplaceApi.Account.Pipeline
  end

  scope "/auth", MotivusWbMarketplaceApiWeb.Account do
    pipe_through :api

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/api", MotivusWbMarketplaceApiWeb do
    pipe_through :api

    scope "/package_registry", PackageRegistry, as: :package_registry do
      resources "/algorithms", AlgorithmController, as: :algorithm do
        resources "/versions", VersionController
      end
    end
  end
end
