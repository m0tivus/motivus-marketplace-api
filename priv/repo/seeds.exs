# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MotivusWbMarketplaceApi.Repo.insert!(%MotivusWbMarketplaceApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias MotivusWbMarketplaceApi.PackageRegistry
alias MotivusWbMarketplaceApi.PackageRegistry.Algorithm
alias MotivusWbMarketplaceApi.PackageRegistry.Version

{:ok, %Algorithm{id: algorithm_id} = algorithm} =
  %{
    default_charge_schema: "PER_EXECUTION",
    default_cost: 120.5,
    is_public: true,
    name: "package"
  }
  |> PackageRegistry.create_algorithm()

{:ok, %{version_urls: %Version{} = version}} =
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
    default_charge_schema: "PER_EXECUTION",
    default_cost: 120.5,
    is_public: true,
    name: "traveling-salesman"
  }
  |> PackageRegistry.create_algorithm()

{:ok, %{version_urls: %Version{} = version}} =
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
    default_charge_schema: "PER_MINUTE",
    default_cost: 1.5,
    is_public: true,
    name: "sii-scraper"
  }
  |> PackageRegistry.create_algorithm()

{:ok, %{version_urls: %Version{} = version}} =
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
