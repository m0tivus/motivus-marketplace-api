defmodule MotivusWbMarketplaceApiWeb.PackageRegistry.VersionController do
  use MotivusWbMarketplaceApiWeb, :controller

  alias MotivusWbMarketplaceApi.PackageRegistry
  alias MotivusWbMarketplaceApi.PackageRegistry.Version

  action_fallback MotivusWbMarketplaceApiWeb.FallbackController

  plug :load_algorithm

  defp load_algorithm(conn, _) do
    algorithm = PackageRegistry.get_algorithm!(conn.params["algorithm_id"])
    assign(conn, :algorithm, algorithm)
  end

  def index(conn, _params) do
    versions = PackageRegistry.list_versions()
    render(conn, "index.json", versions: versions)
  end

  def create(conn, %{"version" => version_params, "algorithm_id" => algorithm_id}) do
    with {:ok, %{version_urls: %Version{} = version}} <-
           PackageRegistry.publish_version(
             version_params
             |> Map.put("algorithm_id", algorithm_id)
             |> Map.put("algorithm", conn.assigns.algorithm)
           ) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.package_registry_algorithm_version_path(conn, :show, algorithm_id, version)
      )
      |> render("show.json", version: version)
    else
      {:error, _, %Ecto.Changeset{} = chset, _} -> {:error, chset}
      e -> e
    end
  end

  def show(conn, %{"id" => id}) do
    version = PackageRegistry.get_version!(id)
    render(conn, "show.json", version: version)
  end

  def update(conn, _params), do: conn |> send_resp(:method_not_allowed, "not allowed")
  def delete(conn, _params), do: conn |> send_resp(:method_not_allowed, "not allowed")
end
