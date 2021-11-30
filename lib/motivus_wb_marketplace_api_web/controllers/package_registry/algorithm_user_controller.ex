defmodule MotivusWbMarketplaceApiWeb.PackageRegistry.AlgorithmUserController do
  use MotivusWbMarketplaceApiWeb, :controller

  alias MotivusWbMarketplaceApi.PackageRegistry
  alias MotivusWbMarketplaceApi.PackageRegistry.AlgorithmUser

  action_fallback MotivusWbMarketplaceApiWeb.FallbackController

  def index(conn, _params) do
    algorithm_users = PackageRegistry.list_algorithm_users()
    render(conn, "index.json", algorithm_users: algorithm_users)
  end

  def create(conn, %{"algorithm_user" => algorithm_user_params}) do
    with {:ok, %AlgorithmUser{} = algorithm_user} <- PackageRegistry.create_algorithm_user(algorithm_user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.package_registry_algorithm_user_path(conn, :show, algorithm_user))
      |> render("show.json", algorithm_user: algorithm_user)
    end
  end

  def show(conn, %{"id" => id}) do
    algorithm_user = PackageRegistry.get_algorithm_user!(id)
    render(conn, "show.json", algorithm_user: algorithm_user)
  end

  def update(conn, %{"id" => id, "algorithm_user" => algorithm_user_params}) do
    algorithm_user = PackageRegistry.get_algorithm_user!(id)

    with {:ok, %AlgorithmUser{} = algorithm_user} <- PackageRegistry.update_algorithm_user(algorithm_user, algorithm_user_params) do
      render(conn, "show.json", algorithm_user: algorithm_user)
    end
  end

  def delete(conn, %{"id" => id}) do
    algorithm_user = PackageRegistry.get_algorithm_user!(id)

    with {:ok, %AlgorithmUser{}} <- PackageRegistry.delete_algorithm_user(algorithm_user) do
      send_resp(conn, :no_content, "")
    end
  end
end
