defmodule MotivusMarketplaceApiWeb.AuthControllerCase do
  alias MotivusMarketplaceApi.Fixtures
  alias MotivusMarketplaceApi.Account.Guardian
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

  def log_out_user(context) do
    {:ok, %{conn: context.conn |> delete_req_header("authorization")}}
  end

  def log_in_user(context, user, _, :application_token),
    do: log_in_user(context, user, %{typ: "mwbat", description: "some description"})

  def log_in_user(context, user, _, :personal_access_token),
    do: log_in_user(context, user, %{typ: "mwbpat", description: "some description"})
end
