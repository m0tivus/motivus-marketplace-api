defmodule MotivusWbMarketplaceApiWeb.AuthControllerCase do
  alias MotivusWbMarketplaceApi.Fixtures
  alias MotivusWbMarketplaceApi.Account.Guardian
  import Plug.Conn

  def with_auth(%{conn: _conn} = context) do
    user = Fixtures.user_fixture()
    log_in_user(context, user)
  end

  def log_in_user(%{conn: conn}, user, claims \\ %{}) do
    token =
      conn
      |> Guardian.Plug.sign_in(%{id: user.id}, claims)
      |> Guardian.Plug.current_token()

    {
      :ok,
      %{
        user: user,
        conn:
          put_req_header(conn, "accept", "application/json")
          |> put_req_header("authorization", "Bearer: " <> token)
      }
    }
  end

  def log_in_user(context, user, _, :application_token),
    do: log_in_user(context, user, %{typ: "mwbat", description: "some description"})
end