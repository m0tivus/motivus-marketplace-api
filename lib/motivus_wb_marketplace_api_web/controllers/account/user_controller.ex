defmodule MotivusWbMarketplaceApiWeb.Account.UserController do
  use MotivusWbMarketplaceApiWeb, :controller

  alias MotivusWbMarketplaceApi.Account
  alias MotivusWbMarketplaceApi.Account.User

  action_fallback MotivusWbMarketplaceApiWeb.FallbackController

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
