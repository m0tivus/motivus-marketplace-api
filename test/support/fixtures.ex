defmodule MotivusWbMarketplaceApi.Fixtures do
  alias MotivusWbMarketplaceApi.PackageRegistry
  alias MotivusWbMarketplaceApi.PackageRegistry.Version

  def algorithm_fixture(attrs \\ %{}) do
    {:ok, algorithm} =
      attrs
      |> Enum.into(%{
        default_charge_schema: "some default_charge_schema",
        default_cost: 120.5,
        is_public: true,
        name: "some name"
      })
      |> PackageRegistry.create_algorithm()

    algorithm
  end

  def version_fixture(attrs \\ %{}) do
    algorithm = algorithm_fixture(%{name: "package"})

    {:ok, %{version_urls: %Version{} = version}} =
      attrs
      |> Enum.into(%{
        "hash" => "some hash",
        "metadata" => %{},
        "name" => "1.0.0",
        "package" => %Plug.Upload{
          path: 'test/support/fixtures/package-v1.0.0.zip',
          filename: "package-v1.0.0.zip"
        }
      })
      |> Map.merge(%{"algorithm_id" => algorithm.id})
      |> Map.put("algorithm", algorithm)
      |> PackageRegistry.publish_version()

    version
  end
end
