defmodule MotivusMarketplaceApiWeb.Router do
  use MotivusMarketplaceApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth, do: plug(MotivusMarketplaceApi.Account.EnsureAuthPipeline)
  pipeline :maybe_auth, do: plug(MotivusMarketplaceApi.Account.MaybeAuthPipeline)

  pipeline :application_token,
    do:
      plug(MotivusMarketplaceApi.Account.ApplicationTokenPipeline,
        allowed: [
          package_registry_algorithm: [:index, :show],
          package_registry_algorithm_version: [:index, :show],
          account_user: :show
        ]
      )

  scope "/" do
    get "/", MotivusMarketplaceApiWeb.HealthCheckController, :health_check
  end

  scope "/auth", MotivusMarketplaceApiWeb.Account do
    pipe_through :api

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/api", MotivusMarketplaceApiWeb do
    pipe_through :api

    scope "/account", Account, as: :account do
      pipe_through [:auth, :application_token]

      get "/user", UserController, :show
      put "/user", UserController, :update

      resources "/application_tokens", ApplicationTokenController
      resources "/personal_access_tokens", PersonalAccessTokenController
    end

    pipe_through :maybe_auth

    scope "/package_registry", PackageRegistry, as: :package_registry do
      pipe_through :application_token

      resources "/algorithms", AlgorithmController, as: :algorithm do
        resources "/versions", VersionController

        pipe_through :auth
        resources "/users", AlgorithmUserController
      end
    end
  end
end
