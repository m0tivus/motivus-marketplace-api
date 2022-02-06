defmodule MotivusMarketplaceApiWeb.PackageRegistry.VersionView do
  use MotivusMarketplaceApiWeb, :view
  alias MotivusMarketplaceApiWeb.PackageRegistry.VersionView

  def render("index.json", %{versions: versions, token_type: :application_token}),
    do: %{data: render_many(versions, VersionView, "version.json")}

  def render("index.json", %{versions: versions}),
    do: %{data: render_many(versions, VersionView, "version_safe.json")}

  def render("show.json", %{version: version, token_type: :application_token}),
    do: %{data: render_one(version, VersionView, "version.json")}

  def render("show.json", %{version: version}),
    do: %{data: render_one(version, VersionView, "version_safe.json")}

  def render("version_safe.json", %{version: version}),
    do: %{
      id: version.id,
      name: version.name,
      metadata: version.metadata,
      inserted_at: version.inserted_at
    }

  def render("version.json", %{version: version} = assigns),
    do:
      %{
        hash: version.hash,
        wasm_url: version.wasm_url,
        loader_url: version.loader_url,
        data_url: version.data_url
      }
      |> Enum.into(render("version_safe.json", assigns))
end
