defmodule MotivusMarketplaceApiWeb.Account.UserController do
  use MotivusMarketplaceApiWeb, :controller

  alias MotivusMarketplaceApi.Account
  alias MotivusMarketplaceApi.Account.User

  action_fallback MotivusMarketplaceApiWeb.FallbackController

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"user" => user_params}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end
end
