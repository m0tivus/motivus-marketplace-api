defmodule MotivusMarketplaceApiWeb.PackageRegistry.AlgorithmUserController do
  use MotivusMarketplaceApiWeb, :controller
  use MotivusMarketplaceApiWeb.Plugs.RelationLoaderPlug

  alias MotivusMarketplaceApi.PackageRegistry
  alias MotivusMarketplaceApi.Account.User
  alias MotivusMarketplaceApi.Account
  alias MotivusMarketplaceApi.PackageRegistry.AlgorithmUser
  alias MotivusMarketplaceApiWeb.Plugs.AlgorithmUserRolePlug

  plug AlgorithmUserRolePlug, must_be: ["OWNER"]
  plug :load_algorithm

  action_fallback MotivusMarketplaceApiWeb.FallbackController

  def index(conn, _params) do
    %{id: algorithm_id} = conn.assigns.algorithm
    algorithm_users = PackageRegistry.list_algorithm_users(algorithm_id)
    render(conn, "index.json", algorithm_users: algorithm_users)
  end

  def create(conn, %{"algorithm_user" => algorithm_user_params}) do
    %{id: algorithm_id} = conn.assigns.algorithm

    params_chset = Account.user_finder_parser(algorithm_user_params)

    case params_chset.valid? do
      true ->
        with %Ecto.Changeset{changes: %{username_or_email: username_or_email}} <- params_chset,
             %User{id: user_id} <-
               Account.find_user!(username_or_email),
             {:ok, %AlgorithmUser{} = algorithm_user} <-
               PackageRegistry.create_algorithm_user(
                 algorithm_user_params
                 |> Enum.into(%{
                   "user_id" => user_id,
                   "algorithm_id" => algorithm_id
                 })
               ) do
          conn
          |> put_status(:created)
          |> put_resp_header(
            "location",
            Routes.package_registry_algorithm_algorithm_user_path(
              conn,
              :show,
              algorithm_id,
              algorithm_user
            )
          )
          |> render("show.json", algorithm_user: algorithm_user)
        end

      false ->
        {:error, params_chset}
    end
  end

  def show(conn, %{"id" => id}) do
    algorithm_user = PackageRegistry.get_algorithm_user!(id)
    render(conn, "show.json", algorithm_user: algorithm_user)
  end

  # TODO: only owned algorithm users
  def update(conn, %{"id" => id, "algorithm_user" => algorithm_user_params}) do
    algorithm_user = PackageRegistry.get_algorithm_user!(id)

    with {:ok, _} <-
           PackageRegistry.validate_update_algorithm_user(algorithm_user, algorithm_user_params),
         {:ok, %AlgorithmUser{} = algorithm_user} <-
           PackageRegistry.update_algorithm_user(algorithm_user, algorithm_user_params) do
      render(conn, "show.json", algorithm_user: algorithm_user)
    end
  end

  def delete(conn, %{"id" => id}) do
    algorithm_user = PackageRegistry.get_algorithm_user!(id)

    with {:ok, _} <-
           PackageRegistry.validate_delete_algorithm_user(algorithm_user),
         {:ok, %AlgorithmUser{}} <- PackageRegistry.delete_algorithm_user(algorithm_user) do
      send_resp(conn, :no_content, "")
    end
  end
end
