defmodule MotivusMarketplaceApi.AccountTest do
  use MotivusMarketplaceApi.DataCase

  import MotivusMarketplaceApi.Fixtures
  alias MotivusMarketplaceApi.Account

  describe "users" do
    alias MotivusMarketplaceApi.Account.User

    @valid_attrs %{
      avatar_url: "some avatar_url",
      email: "some email",
      provider: "some provider",
      username: "some username",
      name: "some name",
      uuid: "7488a646-e31f-11e4-aace-600308960662"
    }
    @update_attrs %{
      avatar_url: "some updated avatar_url",
      username: "some updated username",
      name: "some updated name"
    }
    @invalid_attrs %{avatar_url: nil, email: nil, provider: nil, username: nil, uuid: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Enum.member?(Account.list_users(), user)
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "get_user_by_email!/1 returns the user with given email" do
      user1 = user_fixture(%{email: "test@test.cl", username: UUID.uuid4(:hex)})
      _user2 = user_fixture(%{email: "test2@test.cl", username: UUID.uuid4(:hex)})
      assert Account.get_user_by_email("test@test.cl") == user1
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.avatar_url == "some avatar_url"
      assert user.email == "some email"
      assert user.provider == "some provider"
      assert user.username == "some username"
      assert user.name == "some name"
      assert user.uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = %{uuid: uuid} = user_fixture(%{email: "some email"})

      assert {:ok, %User{} = user} =
               Account.update_user(
                 user,
                 @update_attrs |> Enum.into(%{username: "some updated username"})
               )

      assert user.avatar_url == "some updated avatar_url"
      assert user.email == "some email"
      assert user.provider == "some provider"
      assert user.username == "some updated username"
      assert user.name == "some updated name"
      assert user.uuid == uuid
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
    alias MotivusMarketplaceApi.Account.ApplicationToken

    @valid_attrs %{
      "valid" => true,
      "value" => "some value",
      "description" => "some description"
    }
    @update_attrs %{
      "valid" => false,
      "value" => "some updated value",
      "description" => "some updated description"
    }
    @invalid_attrs %{valid: nil, value: nil, description: nil}

    test "list_application_tokens/0 returns all application_tokens" do
      application_token = application_token_fixture()
      assert Account.list_application_tokens() == [application_token]
    end

    test "list_application_tokens/1 returns all application_tokens from user" do
      application_token = application_token_fixture()
      _application_token = application_token_fixture()
      assert Account.list_application_tokens(application_token.user_id) == [application_token]
    end

    test "get_application_token!/1 returns the application_token with given id" do
      application_token = application_token_fixture()
      assert Account.get_application_token!(application_token.id) == application_token
    end

    test "get_application_token!/2 returns the application_token with given user_id and id" do
      application_token = application_token_fixture()

      assert Account.get_application_token!(application_token.user_id, application_token.id) ==
               application_token

      assert_raise Ecto.NoResultsError, fn ->
        Account.get_application_token!(
          System.unique_integer(),
          application_token.id
        )
      end
    end

    test "get_application_token_from_value!/1 returns the application_token with given id" do
      application_token = application_token_fixture()

      assert Account.get_application_token_from_value!(application_token.value) ==
               application_token
    end

    test "create_application_token/1 with valid data creates a application_token" do
      user = user_fixture()

      assert {:ok, %ApplicationToken{value: value} = application_token} =
               Account.create_application_token(
                 @valid_attrs
                 |> Enum.into(%{"user_id" => user.id})
               )

      assert application_token.valid == true
      assert application_token.value == value
    end

    test "create_application_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_application_token(@invalid_attrs)
    end

    test "update_application_token/2 with valid data updates the application_token" do
      %{value: value} = application_token = application_token_fixture()

      assert {:ok, %ApplicationToken{} = application_token} =
               Account.update_application_token(application_token, @update_attrs)

      assert application_token.valid == false
      assert application_token.value == value
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

  describe "personal_access_tokens" do
    alias MotivusMarketplaceApi.Account.PersonalAccessToken

    @invalid_attrs %{description: nil, valid: nil, value: nil}

    test "list_personal_access_tokens/0 returns all personal_access_tokens" do
      personal_access_token = personal_access_token_fixture()
      assert Account.list_personal_access_tokens() == [personal_access_token]
    end

    test "get_personal_access_token!/1 returns the personal_access_token with given id" do
      personal_access_token = personal_access_token_fixture()
      assert Account.get_personal_access_token!(personal_access_token.id) == personal_access_token
    end

    test "create_personal_access_token/1 with valid data creates a personal_access_token" do
      user = user_fixture()

      valid_attrs = %{
        "description" => "some description",
        "valid" => true,
        "value" => "some value"
      }

      assert {:ok, %PersonalAccessToken{} = personal_access_token} =
               valid_attrs
               |> Enum.into(%{"user_id" => user.id})
               |> Account.create_personal_access_token()

      assert personal_access_token.description == "some description"
      assert personal_access_token.valid == true
      assert "MWBpat" <> _unique = personal_access_token.value
    end

    test "create_personal_access_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_personal_access_token(@invalid_attrs)
    end

    test "update_personal_access_token/2 with valid data updates the personal_access_token" do
      personal_access_token = personal_access_token_fixture()

      update_attrs = %{
        description: "some updated description",
        valid: false,
        value: "some updated value"
      }

      assert {:ok, %PersonalAccessToken{} = personal_access_token} =
               Account.update_personal_access_token(personal_access_token, update_attrs)

      assert personal_access_token.description == "some updated description"
      assert personal_access_token.valid == false
      assert "MWBpat" <> _unique = personal_access_token.value
    end

    test "update_personal_access_token/2 with invalid data returns error changeset" do
      personal_access_token = personal_access_token_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Account.update_personal_access_token(personal_access_token, @invalid_attrs)

      assert personal_access_token == Account.get_personal_access_token!(personal_access_token.id)
    end

    test "delete_personal_access_token/1 deletes the personal_access_token" do
      personal_access_token = personal_access_token_fixture()

      assert {:ok, %PersonalAccessToken{}} =
               Account.delete_personal_access_token(personal_access_token)

      assert_raise Ecto.NoResultsError, fn ->
        Account.get_personal_access_token!(personal_access_token.id)
      end
    end

    test "change_personal_access_token/1 returns a personal_access_token changeset" do
      personal_access_token = personal_access_token_fixture()
      assert %Ecto.Changeset{} = Account.change_personal_access_token(personal_access_token)
    end
  end
end
