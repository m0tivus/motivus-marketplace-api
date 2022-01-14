defmodule MotivusWbMarketplaceApi.MwbtJwtTest do
  use MotivusWbMarketplaceApi.DataCase

  import MotivusWbMarketplaceApi.Fixtures

  describe "mwbat" do
    alias MotivusWbMarketplaceApi.Account.Guardian

    test "encode_and_sign/1 returns JWT" do
      user = user_fixture()
      assert {:ok, "ey" <> _token, _full_claims} = Guardian.encode_and_sign(user)
    end

    test "encode_and_sign/2 with mwbat claim returns MWBat" do
      user = user_fixture()

      assert {:ok, "MWBat" <> _token, _full_claims} =
               Guardian.encode_and_sign(user, %{typ: "mwbat", description: "some description"})
    end

    test "encode_and_sign/2 with mwbpat claim returns MWBpat" do
      user = user_fixture()

      assert {:ok, "MWBpat" <> _token, _full_claims} =
               Guardian.encode_and_sign(user, %{typ: "mwbpat", description: "some description"})
    end

    test "resource_from_token/1 JWT returns user" do
      user = user_fixture()

      assert {:ok, "ey" <> _token = token_string, _full_claims} = Guardian.encode_and_sign(user)
      assert {:ok, ^user, _claims} = Guardian.resource_from_token(token_string)
    end

    test "resource_from_token/1 MWBat returns user" do
      user = user_fixture()

      assert {:ok, "MWBat" <> _token = token_string, _full_claims} =
               Guardian.encode_and_sign(user, %{typ: "mwbat", description: "some description"})

      assert {:ok, ^user, _claims} = Guardian.resource_from_token(token_string)
    end

    test "resource_from_token/1 MWBpat returns user" do
      user = user_fixture()

      assert {:ok, "MWBpat" <> _token = token_string, _full_claims} =
               Guardian.encode_and_sign(user, %{typ: "mwbpat", description: "some description"})

      assert {:ok, ^user, _claims} = Guardian.resource_from_token(token_string)
    end
  end
end
