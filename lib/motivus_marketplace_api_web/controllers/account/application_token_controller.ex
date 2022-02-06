defmodule MotivusMarketplaceApiWeb.Account.ApplicationTokenController do
  use MotivusMarketplaceApiWeb, :controller

  alias MotivusMarketplaceApi.Account
  alias MotivusMarketplaceApi.Account.ApplicationToken

  action_fallback MotivusMarketplaceApiWeb.FallbackController

  def index(conn, _params) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)

    application_tokens = Account.list_application_tokens(user_id)
    render(conn, "index.json", application_tokens: application_tokens)
  end

  def create(conn, %{"application_token" => application_token_params}) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)

    with {:ok, %ApplicationToken{} = application_token} <-
           Account.create_application_token(
             application_token_params
             |> Enum.into(%{"user_id" => user_id})
           ) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.account_application_token_path(conn, :show, application_token)
      )
      |> render("show.json", application_token: application_token)
    end
  end

  def show(conn, %{"id" => id}) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)
    application_token = Account.get_application_token!(user_id, id)
    render(conn, "show.json", application_token: application_token)
  end

  def update(conn, %{"id" => id, "application_token" => application_token_params}) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)
    application_token = Account.get_application_token!(user_id, id)

    with {:ok, %ApplicationToken{} = application_token} <-
           Account.update_application_token(application_token, application_token_params) do
      render(conn, "show.json", application_token: application_token)
    end
  end

  def delete(conn, %{"id" => id}) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)
    application_token = Account.get_application_token!(user_id, id)

    with {:ok, %ApplicationToken{}} <- Account.delete_application_token(application_token) do
      send_resp(conn, :no_content, "")
    end
  end
end
