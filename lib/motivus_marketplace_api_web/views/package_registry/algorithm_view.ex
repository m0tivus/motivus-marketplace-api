defmodule MotivusMarketplaceApiWeb.PackageRegistry.AlgorithmView do
  use MotivusMarketplaceApiWeb, :view
  alias MotivusMarketplaceApiWeb.PackageRegistry.AlgorithmView
  alias MotivusMarketplaceApiWeb.PackageRegistry.VersionView

  def render("index.json", %{algorithms: algorithms, token_type: :application_token}),
    do: %{data: render_many(algorithms, AlgorithmView, "algorithm.json")}

  def render("index.json", %{algorithms: algorithms}),
    do: %{data: render_many(algorithms, AlgorithmView, "algorithm_safe.json")}

  def render("show.json", %{algorithm: algorithm, token_type: :application_token}),
    do: %{data: render_one(algorithm, AlgorithmView, "algorithm.json")}

  def render("show.json", %{algorithm: algorithm}) do
    %{data: render_one(algorithm, AlgorithmView, "algorithm_safe.json")}
  end

  def render("algorithm_safe.json", %{algorithm: algorithm}),
    do: %{
      id: algorithm.id,
      name: algorithm.name,
      is_public: algorithm.is_public,
      cost: algorithm.cost,
      charge_schema: algorithm.charge_schema,
      inserted_at: algorithm.inserted_at,
      versions: render_many(algorithm.versions, VersionView, "version_safe.json")
    }

  def render("algorithm.json", %{algorithm: algorithm} = assigns),
    do:
      %{
        versions: render_many(algorithm.versions, VersionView, "version.json")
      }
      |> Enum.into(render("algorithm_safe.json", assigns))
end
