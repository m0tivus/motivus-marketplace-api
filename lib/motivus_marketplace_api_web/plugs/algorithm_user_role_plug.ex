defmodule MotivusMarketplaceApiWeb.Plugs.AlgorithmUserRolePlug do
  import Plug.Conn
  alias MotivusMarketplaceApi.Account.User
  alias MotivusMarketplaceApi.Account.Guardian
  alias MotivusMarketplaceApi.PackageRegistry
  alias MotivusMarketplaceApi.PackageRegistry.AlgorithmUser

  def init(options), do: options |> Enum.into(%{})

  def call(conn, %{must_be: allowed_roles}) do
    with %User{id: user_id} <- Guardian.Plug.current_resource(conn),
         algorithm_id <- conn.params |> get_algorithm_id,
         %AlgorithmUser{} = algorithm_user <-
           PackageRegistry.get_algorithm_user!(algorithm_id, user_id),
         true <- algorithm_user.role in allowed_roles do
      conn
    else
      _ ->
        conn
        |> resp(:forbidden, "Not enough user previlieges")
        |> halt()
    end
  end

  def call(conn, _opts), do: conn

  defp get_algorithm_id(%{"algorithm_id" => id}), do: id
  defp get_algorithm_id(%{"id" => id}), do: id
end
