defmodule MotivusWbMarketplaceApiWeb.Router do
  use MotivusWbMarketplaceApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MotivusWbMarketplaceApiWeb do
    pipe_through :api
  end
end
