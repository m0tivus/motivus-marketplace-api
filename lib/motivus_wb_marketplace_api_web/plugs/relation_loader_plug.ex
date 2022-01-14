defmodule MotivusWbMarketplaceApiWeb.Plugs.RelationLoaderPlug do
  defmacro __using__(_) do
    quote do
      alias MotivusWbMarketplaceApi.PackageRegistry

      def load_algorithm(conn, _) do
        algorithm = PackageRegistry.get_algorithm!(conn.params["algorithm_id"])
        assign(conn, :algorithm, algorithm)
      end
    end
  end
end
