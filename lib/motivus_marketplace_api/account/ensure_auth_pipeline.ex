defmodule MotivusMarketplaceApi.Account.EnsureAuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :motivus_marketplace_api,
    error_handler: MotivusMarketplaceApi.Account.ErrorHandler,
    module: MotivusMarketplaceApi.Account.Guardian

  plug Guardian.Plug.VerifyHeader, schema: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
  plug MotivusMarketplaceApi.Account.Permissions
end
