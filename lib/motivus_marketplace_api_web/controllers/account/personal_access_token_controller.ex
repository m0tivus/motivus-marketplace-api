defmodule MotivusMarketplaceApiWeb.Account.PersonalAccessTokenController do
  use MotivusMarketplaceApiWeb, :controller

  alias MotivusMarketplaceApi.Account
  alias MotivusMarketplaceApi.Account.PersonalAccessToken

  action_fallback MotivusMarketplaceApiWeb.FallbackController

  def index(conn, _params) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)
    personal_access_tokens = Account.list_personal_access_tokens(user_id)
    render(conn, "index.json", personal_access_tokens: personal_access_tokens)
  end

  def create(conn, %{"personal_access_token" => personal_access_token_params}) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)

    with {:ok, %PersonalAccessToken{} = personal_access_token} <-
           Account.create_personal_access_token(
             personal_access_token_params
             |> Enum.into(%{"user_id" => user_id})
           ) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.account_personal_access_token_path(conn, :show, personal_access_token)
      )
      |> render("show.json", personal_access_token: personal_access_token)
    end
  end

  def show(conn, %{"id" => id}) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)
    personal_access_token = Account.get_personal_access_token!(user_id, id)
    render(conn, "show.json", personal_access_token: personal_access_token)
  end

  def update(conn, %{"id" => id, "personal_access_token" => personal_access_token_params}) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)
    personal_access_token = Account.get_personal_access_token!(user_id, id)

    with {:ok, %PersonalAccessToken{} = personal_access_token} <-
           Account.update_personal_access_token(
             personal_access_token,
             personal_access_token_params
           ) do
      render(conn, "show.json", personal_access_token: personal_access_token)
    end
  end

  def delete(conn, %{"id" => id}) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)
    personal_access_token = Account.get_personal_access_token!(user_id, id)

    with {:ok, %PersonalAccessToken{}} <-
           Account.delete_personal_access_token(personal_access_token) do
      send_resp(conn, :no_content, "")
    end
  end
end
