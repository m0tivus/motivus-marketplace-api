defmodule MotivusMarketplaceApiWeb.Account.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use MotivusMarketplaceApiWeb, :controller
  plug Ueberauth

  alias MotivusMarketplaceApi.Account.Guardian
  alias MotivusMarketplaceApi.Account

  def callback(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    conn
    |> json(%{"error" => fails})
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    with {:ok, user} <- Account.UserFromAuth.find_or_create(auth) do
      conn
      |> Guardian.Plug.sign_in(%{id: user.id}, %{})
      |> redirect_to_spa()
    end
  end

  defp redirect_to_spa(conn) do
    token = Guardian.Plug.current_token(conn)

    redirect(conn,
      external:
        Application.get_env(:motivus_marketplace_api, :spa_oauth_redirect_uri) <>
          "?" <>
          URI.encode_query(%{"token" => token})
    )
  end
end
