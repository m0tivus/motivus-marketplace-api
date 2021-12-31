defmodule MotivusWbMarketplaceApi.Account.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :motivus_wb_marketplace_api,
    error_handler: MotivusWbMarketplaceApi.Account.ErrorHandler,
    module: MotivusWbMarketplaceApi.Account.Guardian

  plug Guardian.Plug.VerifyHeader, schema: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
  plug MotivusWbMarketplaceApi.Account.Permissions
end
