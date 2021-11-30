defmodule MotivusWbMarketplaceApiWeb.PackageRegistry.AlgorithmControllerTest do
  use MotivusWbMarketplaceApiWeb.ConnCase

  alias MotivusWbMarketplaceApi.PackageRegistry
  alias MotivusWbMarketplaceApi.PackageRegistry.Algorithm

  @create_attrs %{
    default_charge_schema: "some default_charge_schema",
    default_cost: 120.5,
    is_public: true,
    name: "some name"
  }
  @update_attrs %{
    default_charge_schema: "some updated default_charge_schema",
    default_cost: 456.7,
    is_public: false,
    name: "some updated name"
  }
  @invalid_attrs %{default_charge_schema: nil, default_cost: nil, is_public: nil, name: nil}

  def fixture(:algorithm) do
    {:ok, algorithm} = PackageRegistry.create_algorithm(@create_attrs)
    algorithm
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all algorithms", %{conn: conn} do
      conn = get(conn, Routes.package_registry_algorithm_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create algorithm" do
    test "renders algorithm when data is valid", %{conn: conn} do
      conn = post(conn, Routes.package_registry_algorithm_path(conn, :create), algorithm: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.package_registry_algorithm_path(conn, :show, id))

      assert %{
               "id" => id,
               "default_charge_schema" => "some default_charge_schema",
               "default_cost" => 120.5,
               "is_public" => true,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.package_registry_algorithm_path(conn, :create), algorithm: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update algorithm" do
    setup [:create_algorithm]

    test "renders algorithm when data is valid", %{conn: conn, algorithm: %Algorithm{id: id} = algorithm} do
      conn = put(conn, Routes.package_registry_algorithm_path(conn, :update, algorithm), algorithm: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.package_registry_algorithm_path(conn, :show, id))

      assert %{
               "id" => id,
               "default_charge_schema" => "some updated default_charge_schema",
               "default_cost" => 456.7,
               "is_public" => false,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, algorithm: algorithm} do
      conn = put(conn, Routes.package_registry_algorithm_path(conn, :update, algorithm), algorithm: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete algorithm" do
    setup [:create_algorithm]

    test "deletes chosen algorithm", %{conn: conn, algorithm: algorithm} do
      conn = delete(conn, Routes.package_registry_algorithm_path(conn, :delete, algorithm))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.package_registry_algorithm_path(conn, :show, algorithm))
      end
    end
  end

  defp create_algorithm(_) do
    algorithm = fixture(:algorithm)
    {:ok, algorithm: algorithm}
  end
end
