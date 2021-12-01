defmodule MotivusWbMarketplaceApiWeb.PackageRegistry.VersionController do
  use MotivusWbMarketplaceApiWeb, :controller

  alias MotivusWbMarketplaceApi.PackageRegistry
  alias MotivusWbMarketplaceApi.PackageRegistry.Version

  action_fallback MotivusWbMarketplaceApiWeb.FallbackController

  def index(conn, _params) do
    versions = PackageRegistry.list_versions()
    render(conn, "index.json", versions: versions)
  end

  def create(conn, %{"version" => version_params, "algorithm_id" => algorithm_id}) do
    with {:ok, %Version{} = version} <-
           PackageRegistry.create_version(version_params |> Map.put("algorithm_id", algorithm_id)) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.package_registry_algorithm_version_path(conn, :show, algorithm_id, version)
      )
      |> render("show.json", version: version)
    end
  end

  def show(conn, %{"id" => id}) do
    version = PackageRegistry.get_version!(id)
    render(conn, "show.json", version: version)
  end

  def update(conn, %{"id" => id, "version" => version_params}) do
    version = PackageRegistry.get_version!(id)

    with {:ok, %Version{} = version} <- PackageRegistry.update_version(version, version_params) do
      render(conn, "show.json", version: version)
    end
  end

  def delete(conn, %{"id" => id}) do
    version = PackageRegistry.get_version!(id)

    with {:ok, %Version{}} <- PackageRegistry.delete_version(version) do
      send_resp(conn, :no_content, "")
    end
  end
end
