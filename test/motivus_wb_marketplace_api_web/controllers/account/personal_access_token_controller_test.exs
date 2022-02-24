defmodule MotivusMarketplaceApiWeb.Account.PersonalAccessTokenControllerTest do
  use MotivusMarketplaceApiWeb.ConnCase
  import MotivusMarketplaceApiWeb.AuthControllerCase

  import MotivusMarketplaceApi.Fixtures

  alias MotivusMarketplaceApi.Account.PersonalAccessToken

  @create_attrs %{
    "description" => "some description",
    "valid" => true
  }
  @update_attrs %{
    "description" => "some updated description",
    "valid" => false
  }
  @invalid_attrs %{description: nil, valid: nil, value: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup :with_auth

  describe "index" do
    test "lists all personal_access_tokens", %{conn: conn} do
      conn = get(conn, Routes.account_personal_access_token_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create personal_access_token" do
    test "renders personal_access_token when data is valid", %{conn: conn} do
      conn =
        post(conn, Routes.account_personal_access_token_path(conn, :create),
          personal_access_token: @create_attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.account_personal_access_token_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "description" => "some description",
               "valid" => true,
               "value" => "MWBpat" <> _unique
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.account_personal_access_token_path(conn, :create),
          personal_access_token: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update personal_access_token" do
    setup [:create_personal_access_token]

    test "renders personal_access_token when data is valid", %{
      conn: conn,
      personal_access_token: %PersonalAccessToken{id: id} = personal_access_token
    } do
      conn =
        put(conn, Routes.account_personal_access_token_path(conn, :update, personal_access_token),
          personal_access_token: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.account_personal_access_token_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "valid" => false,
               "value" => "MWBpat" <> _unique
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      personal_access_token: personal_access_token
    } do
      conn =
        put(conn, Routes.account_personal_access_token_path(conn, :update, personal_access_token),
          personal_access_token: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete personal_access_token" do
    setup [:create_personal_access_token]

    test "deletes chosen personal_access_token", %{
      conn: conn,
      personal_access_token: personal_access_token
    } do
      conn =
        delete(
          conn,
          Routes.account_personal_access_token_path(conn, :delete, personal_access_token)
        )

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.account_personal_access_token_path(conn, :show, personal_access_token))
      end
    end
  end

  defp create_personal_access_token(%{user: %{id: user_id}}) do
    personal_access_token = personal_access_token_fixture(%{"user_id" => user_id})
    %{personal_access_token: personal_access_token}
  end
end
