defmodule MotivusMarketplaceApiWeb.PackageRegistry.AlgorithmController do
  use MotivusMarketplaceApiWeb, :controller

  alias MotivusMarketplaceApi.PackageRegistry
  alias MotivusMarketplaceApi.PackageRegistry.Algorithm
  alias MotivusMarketplaceApi.Account.Guardian
  alias MotivusMarketplaceApiWeb.Plugs.AlgorithmUserRolePlug

  plug AlgorithmUserRolePlug, [must_be: ["OWNER"]] when action in [:update]

  action_fallback MotivusMarketplaceApiWeb.FallbackController

  def index(conn, params) do
    token_type = MotivusMarketplaceApi.Account.JwtOrMwbt.get_token_type(conn)

    user_id =
      case Guardian.Plug.current_resource(conn) do
        %{id: user_id} -> user_id
        _ -> nil
      end

    algorithms = PackageRegistry.list_available_algorithms(user_id, params)
    render(conn, "index.json", algorithms: algorithms, token_type: token_type)
  end

  def create(conn, %{"algorithm" => algorithm_params}) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)

    with {:ok, %Algorithm{} = algorithm} <-
           PackageRegistry.create_algorithm(
             algorithm_params
             |> Enum.into(%{"user_id" => user_id})
           ) do
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
    token_type = MotivusMarketplaceApi.Account.JwtOrMwbt.get_token_type(conn)

    user_id =
      case Guardian.Plug.current_resource(conn) do
        %{id: user_id} -> user_id
        _ -> nil
      end

    algorithm = PackageRegistry.get_algorithm!(user_id, id)
    render(conn, "show.json", algorithm: algorithm, token_type: token_type)
  end

  def update(conn, %{"id" => id, "algorithm" => algorithm_params}) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)
    algorithm = PackageRegistry.get_algorithm!(user_id, id)

    with {:ok, %Algorithm{} = algorithm} <-
           PackageRegistry.update_algorithm(algorithm, algorithm_params) do
      render(conn, "show.json", algorithm: algorithm)
    end
  end

  def delete(conn, _params), do: conn |> send_resp(:method_not_allowed, "not allowed")
end
