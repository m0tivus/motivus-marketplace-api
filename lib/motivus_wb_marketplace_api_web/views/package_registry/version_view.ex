defmodule MotivusWbMarketplaceApiWeb.PackageRegistry.VersionView do
  use MotivusWbMarketplaceApiWeb, :view
  alias MotivusWbMarketplaceApiWeb.PackageRegistry.VersionView

  def render("index.json", %{versions: versions}) do
    %{data: render_many(versions, VersionView, "version.json")}
  end

  def render("show.json", %{version: version}) do
    %{data: render_one(version, VersionView, "version.json")}
  end

  def render("version.json", %{version: version}) do
    %{
      id: version.id,
      name: version.name,
      metadata: version.metadata,
      hash: version.hash,
      wasm_url: version.wasm_url,
      loader_url: version.loader_url,
      data_url: version.data_url,
      inserted_at: version.inserted_at
    }
  end
end
