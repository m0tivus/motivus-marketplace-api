defmodule MotivusWbMarketplaceApiWeb.PackageRegistry.AlgorithmController do
  use MotivusWbMarketplaceApiWeb, :controller

  alias MotivusWbMarketplaceApi.PackageRegistry
  alias MotivusWbMarketplaceApi.PackageRegistry.Algorithm

  action_fallback MotivusWbMarketplaceApiWeb.FallbackController

  def index(conn, _params) do
    algorithms = PackageRegistry.list_algorithms()
    render(conn, "index.json", algorithms: algorithms)
  end

  def create(conn, %{"algorithm" => algorithm_params}) do
    with {:ok, %Algorithm{} = algorithm} <- PackageRegistry.create_algorithm(algorithm_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.package_registry_algorithm_path(conn, :show, algorithm)
      )
      |> render("show.json", algorithm: algorithm)
    end
  end

  def show(conn, %{"id" => id}) do
    algorithm = PackageRegistry.get_algorithm!(id)
    render(conn, "show.json", algorithm: algorithm)
  end

  def update(conn, %{"id" => id, "algorithm" => algorithm_params}) do
    algorithm = PackageRegistry.get_algorithm!(id)

    with {:ok, %Algorithm{} = algorithm} <-
           PackageRegistry.update_algorithm(algorithm, algorithm_params) do
      render(conn, "show.json", algorithm: algorithm)
    end
  end

  def delete(conn, _params), do: conn |> send_resp(:method_not_allowed, "not allowed")
end
