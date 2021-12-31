defmodule MotivusWbMarketplaceApiWeb.AuthControllerCase do
  alias MotivusWbMarketplaceApi.Fixtures
  alias MotivusWbMarketplaceApi.Account.Guardian
  import Plug.Conn

  def with_auth(%{conn: conn}) do
    user = Fixtures.user_fixture()

    token =
      conn
      |> Guardian.Plug.sign_in(%{id: user.id}, %{})
      |> Guardian.Plug.current_token()

    {
      :ok,
      user: user,
      conn:
        put_req_header(conn, "accept", "application/json")
        |> put_req_header("authorization", "Bearer: " <> token)
    }
  end
end
