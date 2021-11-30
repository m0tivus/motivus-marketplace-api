defmodule MotivusWbMarketplaceApiWeb.Account.ApplicationTokenControllerTest do
  use MotivusWbMarketplaceApiWeb.ConnCase

  alias MotivusWbMarketplaceApi.Account
  alias MotivusWbMarketplaceApi.Account.ApplicationToken

  @create_attrs %{
    valid: true,
    value: "some value"
  }
  @update_attrs %{
    valid: false,
    value: "some updated value"
  }
  @invalid_attrs %{valid: nil, value: nil}

  def fixture(:application_token) do
    {:ok, application_token} = Account.create_application_token(@create_attrs)
    application_token
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all application_tokens", %{conn: conn} do
      conn = get(conn, Routes.account_application_token_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create application_token" do
    test "renders application_token when data is valid", %{conn: conn} do
      conn = post(conn, Routes.account_application_token_path(conn, :create), application_token: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.account_application_token_path(conn, :show, id))

      assert %{
               "id" => id,
               "valid" => true,
               "value" => "some value"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.account_application_token_path(conn, :create), application_token: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update application_token" do
    setup [:create_application_token]

    test "renders application_token when data is valid", %{conn: conn, application_token: %ApplicationToken{id: id} = application_token} do
      conn = put(conn, Routes.account_application_token_path(conn, :update, application_token), application_token: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.account_application_token_path(conn, :show, id))

      assert %{
               "id" => id,
               "valid" => false,
               "value" => "some updated value"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, application_token: application_token} do
      conn = put(conn, Routes.account_application_token_path(conn, :update, application_token), application_token: @invalid_attrs)
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

  defp create_application_token(_) do
    application_token = fixture(:application_token)
    {:ok, application_token: application_token}
  end
end
