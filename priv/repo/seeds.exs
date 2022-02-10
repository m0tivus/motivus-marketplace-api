# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MotivusMarketplaceApi.Repo.insert!(%MotivusMarketplaceApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

if Mix.env() in [:dev] do
  alias MotivusMarketplaceApi.PackageRegistry
  alias MotivusMarketplaceApi.PackageRegistry.Algorithm
  alias MotivusMarketplaceApi.PackageRegistry.Version
  alias MotivusMarketplaceApi.Account.User
  alias MotivusMarketplaceApi.Account

  {:ok, %User{id: user_id}} =
    %{
      avatar_url: "some avatar_url",
      email: "user@#{System.unique_integer()}.com",
      provider: "some provider",
      username: "username#{System.unique_integer()}",
      name: "some name",
      uuid: "7488a646-e31f-11e4-aace-600308960662"
    }
    |> Account.create_user()

  {:ok, %Algorithm{id: algorithm_id} = algorithm} =
    %{
      "charge_schema" => "PER_EXECUTION",
      "cost" => 120.5,
      "is_public" => true,
      "name" => "package",
      "user_id" => user_id
    }
    |> PackageRegistry.create_algorithm()

  {:ok, %{version_urls: %Version{}}} =
    %{
      "algorithm_id" => algorithm_id,
      "algorithm" => algorithm,
      "hash" => "some hash",
      "metadata" => %{},
      "name" => "1.0.0",
      "package" => %Plug.Upload{
        path: 'test/support/fixtures/package-1.0.0.zip',
        filename: "package-1.0.0.zip"
      }
    }
    |> PackageRegistry.publish_version()

  {:ok, %Algorithm{id: algorithm_id} = algorithm} =
    %{
      "charge_schema" => "PER_EXECUTION",
      "cost" => 120.5,
      "is_public" => true,
      "name" => "traveling-salesman",
      "user_id" => user_id
    }
    |> PackageRegistry.create_algorithm()

  {:ok, %{version_urls: %Version{}}} =
    %{
      "algorithm_id" => algorithm_id,
      "algorithm" => algorithm,
      "hash" => "some hash",
      "metadata" => %{
        "long_description" =>
          "#Traveling salesman
        **Given a list of cities and the distances between each pair of cities, what is the shortest possible route that visits each city exactly once and returns to the origin city?**",
        "short_description" => "Genetic algorithm for route optimization",
        "license" => "MIT",
        "author" => "CECs",
        "url" => "http://www.cecs.cl/website/",
        "upstream_url" => "https://github.com/kezada94/CECs-HFFVRP"
      },
      "name" => "1.0.0",
      "package" => %Plug.Upload{
        path: 'test/support/fixtures/traveling-salesman-1.0.0.zip',
        filename: "traveling-salesman-1.0.0.zip"
      }
    }
    |> PackageRegistry.publish_version()

  {:ok, %Algorithm{id: algorithm_id} = algorithm} =
    %{
      "charge_schema" => "PER_MINUTE",
      "cost" => 1.5,
      "is_public" => true,
      "name" => "sii-scraper",
      "user_id" => user_id
    }
    |> PackageRegistry.create_algorithm()

  {:ok, %{version_urls: %Version{}}} =
    %{
      "algorithm_id" => algorithm_id,
      "algorithm" => algorithm,
      "hash" => "some hash",
      "metadata" => %{
        "long_description" => "#SII scraper
        **Get your business DTEs in seconds**",
        "short_description" => "Get your business DTEs in seconds",
        "license" => "MIT",
        "author" => "Motivus",
        "url" => "https://motivus.cl/",
        "upstream_url" => "https://github.com/m0tivus/dairylink-api/tree/main/scraper"
      },
      "name" => "1.0.0",
      "package" => %Plug.Upload{
        path: 'test/support/fixtures/sii-scraper-1.0.0.zip',
        filename: "sii-scraper-1.0.0.zip"
      }
    }
    |> PackageRegistry.publish_version()
end
