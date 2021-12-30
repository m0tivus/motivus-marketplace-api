defmodule MotivusWbMarketplaceApi.AccountTest do
  use MotivusWbMarketplaceApi.DataCase

  alias MotivusWbMarketplaceApi.Account

  describe "users" do
    alias MotivusWbMarketplaceApi.Account.User

    @valid_attrs %{
      avatar_url: "some avatar_url",
      email: "some email",
      provider: "some provider",
      username: "some username",
      uuid: "7488a646-e31f-11e4-aace-600308960662"
    }
    @update_attrs %{
      avatar_url: "some updated avatar_url",
      email: "some updated email",
      provider: "some updated provider",
      username: "some updated username",
      uuid: "7488a646-e31f-11e4-aace-600308960668"
    }
    @invalid_attrs %{avatar_url: nil, email: nil, provider: nil, username: nil, uuid: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "get_user_by_email!/1 returns the user with given email" do
      user1 = user_fixture(%{email: "test@test.cl"})
      user2 = user_fixture(%{email: "test2@test.cl"})
      assert Account.get_user_by_email("test@test.cl") == user1
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.avatar_url == "some avatar_url"
      assert user.email == "some email"
      assert user.provider == "some provider"
      assert user.username == "some username"
      assert user.uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Account.update_user(user, @update_attrs)
      assert user.avatar_url == "some updated avatar_url"
      assert user.email == "some updated email"
      assert user.provider == "some updated provider"
      assert user.username == "some updated username"
      assert user.uuid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end

  describe "application_tokens" do
    alias MotivusWbMarketplaceApi.Account.ApplicationToken

    @valid_attrs %{valid: true, value: "some value"}
    @update_attrs %{valid: false, value: "some updated value"}
    @invalid_attrs %{valid: nil, value: nil}

    def application_token_fixture(attrs \\ %{}) do
      {:ok, application_token} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_application_token()

      application_token
    end

    test "list_application_tokens/0 returns all application_tokens" do
      application_token = application_token_fixture()
      assert Account.list_application_tokens() == [application_token]
    end

    test "get_application_token!/1 returns the application_token with given id" do
      application_token = application_token_fixture()
      assert Account.get_application_token!(application_token.id) == application_token
    end

    test "create_application_token/1 with valid data creates a application_token" do
      assert {:ok, %ApplicationToken{} = application_token} =
               Account.create_application_token(@valid_attrs)

      assert application_token.valid == true
      assert application_token.value == "some value"
    end

    test "create_application_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_application_token(@invalid_attrs)
    end

    test "update_application_token/2 with valid data updates the application_token" do
      application_token = application_token_fixture()

      assert {:ok, %ApplicationToken{} = application_token} =
               Account.update_application_token(application_token, @update_attrs)

      assert application_token.valid == false
      assert application_token.value == "some updated value"
    end

    test "update_application_token/2 with invalid data returns error changeset" do
      application_token = application_token_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Account.update_application_token(application_token, @invalid_attrs)

      assert application_token == Account.get_application_token!(application_token.id)
    end

    test "delete_application_token/1 deletes the application_token" do
      application_token = application_token_fixture()
      assert {:ok, %ApplicationToken{}} = Account.delete_application_token(application_token)

      assert_raise Ecto.NoResultsError, fn ->
        Account.get_application_token!(application_token.id)
      end
    end

    test "change_application_token/1 returns a application_token changeset" do
      application_token = application_token_fixture()
      assert %Ecto.Changeset{} = Account.change_application_token(application_token)
    end
  end
end
