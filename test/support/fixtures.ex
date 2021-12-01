defmodule MotivusWbMarketplaceApi.Fixtures do
  alias MotivusWbMarketplaceApi.PackageRegistry

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
    algorithm = algorithm_fixture()

    {:ok, version} =
      attrs
      |> Enum.into(%{
        data_url: "some data_url",
        hash: "some hash",
        loader_url: "some loader_url",
        metadata: %{},
        name: "some name",
        wasm_url: "some wasm_url"
      })
      |> Map.merge(%{algorithm_id: algorithm.id})
      |> PackageRegistry.create_version()

    version
  end
end
