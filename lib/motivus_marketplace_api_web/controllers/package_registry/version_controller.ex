defmodule MotivusMarketplaceApiWeb.PackageRegistry.VersionController do
  use MotivusMarketplaceApiWeb, :controller
  use MotivusMarketplaceApiWeb.Plugs.RelationLoaderPlug

  alias MotivusMarketplaceApi.PackageRegistry
  alias MotivusMarketplaceApi.PackageRegistry.Version
  alias MotivusMarketplaceApiWeb.Plugs.AlgorithmUserRolePlug

  plug AlgorithmUserRolePlug, [must_be: ["OWNER", "MAINTAINER"]] when action in [:create]

  action_fallback MotivusMarketplaceApiWeb.FallbackController

  plug :load_algorithm

  def index(conn, _params) do
    token_type = MotivusMarketplaceApi.Account.JwtOrMwbt.get_token_type(conn)
    versions = PackageRegistry.list_versions()
    render(conn, "index.json", versions: versions, token_type: token_type)
  end

  def create(conn, %{"version" => version_params, "package" => %Plug.Upload{} = package} = params)
      when is_binary(version_params),
      do:
        create(
          conn,
          params
          |> Map.put("version", Jason.decode!(version_params) |> Map.put("package", package))
        )

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
    token_type = MotivusMarketplaceApi.Account.JwtOrMwbt.get_token_type(conn)
    version = PackageRegistry.get_version!(id)
    render(conn, "show.json", version: version, token_type: token_type)
  end

  def update(conn, _params), do: conn |> send_resp(:method_not_allowed, "not allowed")
  def delete(conn, _params), do: conn |> send_resp(:method_not_allowed, "not allowed")
end
