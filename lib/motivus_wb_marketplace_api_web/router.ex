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

      resources "/application_tokens", ApplicationTokenController
    end

    pipe_through :maybe_auth

    scope "/package_registry", PackageRegistry, as: :package_registry do
      # TODO: public and private
      resources "/algorithms", AlgorithmController, as: :algorithm do
        # TODO: personal_access_token -> push
        # TODO: application_tokens -> fetch
        resources "/versions", VersionController

        pipe_through :auth
        resources "/users", AlgorithmUserController
      end
    end
  end
end
