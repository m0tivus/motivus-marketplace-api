defmodule MotivusMarketplaceApi.Fixtures do
  alias MotivusMarketplaceApi.Account
  alias MotivusMarketplaceApi.PackageRegistry
  alias MotivusMarketplaceApi.PackageRegistry.Version

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        avatar_url: "some avatar_url",
        email: "user@#{System.unique_integer()}.com",
        provider: "some provider",
        username: "username#{System.unique_integer()}",
        name: "some name",
        uuid: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> Account.create_user()

    user
  end

  def application_token_fixture(attrs \\ %{}) do
    user =
      case attrs do
        %{"user_id" => user_id} -> Account.get_user!(user_id)
        _ -> user_fixture()
      end

    {:ok, application_token} =
      attrs
      |> Enum.into(%{
        "valid" => true,
        "value" => "some value",
        "user_id" => user.id,
        "description" => "some description"
      })
      |> Account.create_application_token()

    application_token
  end

  def algorithm_fixture(attrs \\ %{}) do
    user =
      case attrs do
        %{"user_id" => user_id} -> Account.get_user!(user_id)
        _ -> user_fixture()
      end

    {:ok, algorithm} =
      attrs
      |> Enum.into(%{
        "charge_schema" => "PER_EXECUTION",
        "cost" => 120.5,
        "is_public" => true,
        "name" => "package",
        "user_id" => user.id
      })
      |> PackageRegistry.create_algorithm()

    algorithm
  end

  def version_fixture(attrs \\ %{}) do
    algorithm =
      case attrs do
        %{"algorithm_id" => algorithm_id} -> PackageRegistry.get_algorithm!(algorithm_id)
        _ -> algorithm_fixture()
      end

    {:ok, %{version_urls: %Version{} = version}} =
      attrs
      |> Enum.into(%{
        "hash" => "some hash",
        "metadata" => %{},
        "name" => "1.0.0",
        "package" => %Plug.Upload{
          path: 'test/support/fixtures/package-1.0.0.zip',
          filename: "package-1.0.0.zip"
        }
      })
      |> Map.put("algorithm_id", algorithm.id)
      |> Map.put("algorithm", algorithm)
      |> PackageRegistry.publish_version()

    version
  end

  def algorithm_user_fixture(attrs \\ %{}) do
    algorithm =
      case attrs["algorithm_id"] do
        nil -> algorithm_fixture()
        id -> PackageRegistry.get_algorithm!(id)
      end

    user =
      case attrs["user_id"] do
        nil -> user_fixture()
        id -> Account.get_user!(id)
      end

    {:ok, algorithm_user} =
      attrs
      |> Enum.into(%{
        "charge_schema" => "PER_MINUTE",
        "cost" => 120.5,
        "role" => "USER",
        "algorithm_id" => algorithm.id,
        "user_id" => user.id
      })
      |> PackageRegistry.create_algorithm_user()

    algorithm_user
  end

  def personal_access_token_fixture(attrs \\ %{}) do
    user =
      case attrs["user_id"] do
        nil -> user_fixture()
        id -> Account.get_user!(id)
      end

    {:ok, personal_access_token} =
      attrs
      |> Enum.into(%{
        "description" => "some description",
        "valid" => true,
        "value" => "some value",
        "user_id" => user.id
      })
      |> Account.create_personal_access_token()

    personal_access_token
  end
end
