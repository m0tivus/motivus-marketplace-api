defmodule MotivusWbMarketplaceApiWeb.Router do
  use MotivusWbMarketplaceApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
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
