defmodule MotivusMarketplaceApi.Repo do
  use Ecto.Repo,
    otp_app: :motivus_marketplace_api,
    adapter: Ecto.Adapters.Postgres
end
