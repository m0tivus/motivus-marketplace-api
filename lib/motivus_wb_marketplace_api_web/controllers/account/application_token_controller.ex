defmodule MotivusWbMarketplaceApiWeb.Account.ApplicationTokenController do
  use MotivusWbMarketplaceApiWeb, :controller

  alias MotivusWbMarketplaceApi.Account
  alias MotivusWbMarketplaceApi.Account.ApplicationToken

  action_fallback MotivusWbMarketplaceApiWeb.FallbackController

  def index(conn, _params) do
    application_tokens = Account.list_application_tokens()
    render(conn, "index.json", application_tokens: application_tokens)
  end

  def create(conn, %{"application_token" => application_token_params}) do
    with {:ok, %ApplicationToken{} = application_token} <- Account.create_application_token(application_token_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.account_application_token_path(conn, :show, application_token))
      |> render("show.json", application_token: application_token)
    end
  end

  def show(conn, %{"id" => id}) do
    application_token = Account.get_application_token!(id)
    render(conn, "show.json", application_token: application_token)
  end

  def update(conn, %{"id" => id, "application_token" => application_token_params}) do
    application_token = Account.get_application_token!(id)

    with {:ok, %ApplicationToken{} = application_token} <- Account.update_application_token(application_token, application_token_params) do
      render(conn, "show.json", application_token: application_token)
    end
  end

  def delete(conn, %{"id" => id}) do
    application_token = Account.get_application_token!(id)

    with {:ok, %ApplicationToken{}} <- Account.delete_application_token(application_token) do
      send_resp(conn, :no_content, "")
    end
  end
end
