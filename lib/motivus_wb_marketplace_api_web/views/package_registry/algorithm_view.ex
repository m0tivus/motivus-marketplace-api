defmodule MotivusWbMarketplaceApiWeb.PackageRegistry.AlgorithmView do
  use MotivusWbMarketplaceApiWeb, :view
  alias MotivusWbMarketplaceApiWeb.PackageRegistry.AlgorithmView
  alias MotivusWbMarketplaceApiWeb.PackageRegistry.VersionView

  def render("index.json", %{algorithms: algorithms}) do
    %{data: render_many(algorithms, AlgorithmView, "algorithm.json")}
  end

  def render("show.json", %{algorithm: algorithm}) do
    %{data: render_one(algorithm, AlgorithmView, "algorithm.json")}
  end

  def render("algorithm.json", %{algorithm: algorithm}) do
    %{
      id: algorithm.id,
      name: algorithm.name,
      is_public: algorithm.is_public,
      default_cost: algorithm.default_cost,
      default_charge_schema: algorithm.default_charge_schema,
      inserted_at: algorithm.inserted_at,
      versions: render_many(algorithm.versions, VersionView, "version.json")
    }
  end
end
