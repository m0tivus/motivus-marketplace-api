defmodule MotivusMarketplaceApiWeb.Account.ApplicationTokenControllerTest do
  use MotivusMarketplaceApiWeb.ConnCase

  import MotivusMarketplaceApiWeb.AuthControllerCase

  alias MotivusMarketplaceApi.Account.ApplicationToken
  alias MotivusMarketplaceApi.Fixtures

  @create_attrs %{
    valid: true,
    value: "some value",
    description: "some description"
  }
  @update_attrs %{
    valid: false,
    value: "some updated value",
    description: "some updated description"
  }
  @invalid_attrs %{valid: nil, value: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup :with_auth

  describe "index" do
    test "lists all application_tokens", %{conn: conn} do
      conn = get(conn, Routes.account_application_token_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create application_token" do
    test "renders application_token when data is valid", %{conn: conn} do
      conn =
        post(conn, Routes.account_application_token_path(conn, :create),
          application_token: @create_attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.account_application_token_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "valid" => true,
               "value" => "MWBat" <> _token,
               "description" => "some description"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.account_application_token_path(conn, :create),
          application_token: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update application_token" do
    setup [:create_application_token]

    test "renders application_token when data is valid", %{
      conn: conn,
      application_token: %ApplicationToken{id: id, value: value} = application_token
    } do
      conn =
        put(conn, Routes.account_application_token_path(conn, :update, application_token),
          application_token: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.account_application_token_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "valid" => false,
               "value" => ^value,
               "description" => "some updated description"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      application_token: application_token
    } do
      conn =
        put(conn, Routes.account_application_token_path(conn, :update, application_token),
          application_token: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete application_token" do
    setup [:create_application_token]

    test "deletes chosen application_token", %{conn: conn, application_token: application_token} do
      conn = delete(conn, Routes.account_application_token_path(conn, :delete, application_token))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.account_application_token_path(conn, :show, application_token))
      end
    end
  end

  defp create_application_token(%{user: %{id: user_id}}) do
    application_token = Fixtures.application_token_fixture(%{"user_id" => user_id})
    {:ok, application_token: application_token}
  end
end
