defmodule MotivusWbMarketplaceApiWeb.Router do
  use MotivusWbMarketplaceApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug MotivusWbMarketplaceApi.Account.EnsureAuthPipeline
  end

  pipeline :maybe_auth do
    plug MotivusWbMarketplaceApi.Account.MaybeAuthPipeline
  end

  scope "/auth", MotivusWbMarketplaceApiWeb.Account do
    pipe_through :api

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/api", MotivusWbMarketplaceApiWeb do
    pipe_through :api

    scope "/account", Account, as: :account do
      pipe_through :auth
      get "/user", UserController, :show
      put "/user", UserController, :update
    end

    pipe_through :maybe_auth

    scope "/package_registry", PackageRegistry, as: :package_registry do
      # TODO auth
      resources "/algorithms", AlgorithmController, as: :algorithm do
        resources "/versions", VersionController
      end
    end
  end
end
