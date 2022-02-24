defmodule MotivusMarketplaceApiWeb.Account.UserControllerTest do
  use MotivusMarketplaceApiWeb.ConnCase

  import MotivusMarketplaceApiWeb.AuthControllerCase

  alias MotivusMarketplaceApi.Account.User

  @update_attrs %{
    avatar_url: "some updated avatar_url",
    username: "some updated username",
    name: "some updated name"
  }
  @invalid_attrs %{avatar_url: nil, email: nil, provider: nil, username: nil, uuid: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup :with_auth

  describe "show user" do
    test "renders current user", %{conn: conn, user: %User{id: id} = user} = context do
      conn = get(conn, Routes.account_user_path(conn, :show))

      assert %{
               "id" => ^id,
               "avatar_url" => "some avatar_url",
               "email" => "user@" <> _unique_mail,
               "provider" => "some provider",
               "username" => "username" <> _unique_username,
               "name" => "some name"
             } = json_response(conn, 200)["data"]

      {:ok, %{conn: conn}} = log_in_user(context, user, nil, :application_token)
      conn = get(conn, Routes.account_user_path(conn, :show))

      assert %{
               "id" => ^id,
               "avatar_url" => "some avatar_url",
               "email" => "user@" <> _unique_mail,
               "provider" => "some provider",
               "username" => "username" <> _unique_username,
               "name" => "some name",
               "uuid" => _uuid
             } = json_response(conn, 200)["data"]
    end
  end

  describe "update user" do
    test "renders user when data is valid", %{conn: conn, user: %User{id: id}} do
      conn = put(conn, Routes.account_user_path(conn, :update), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.account_user_path(conn, :show))

      assert %{
               "id" => ^id,
               "avatar_url" => "some updated avatar_url",
               "email" => "user@" <> _unique_mail,
               "provider" => "some provider",
               "username" => "some updated username",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = put(conn, Routes.account_user_path(conn, :update), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
