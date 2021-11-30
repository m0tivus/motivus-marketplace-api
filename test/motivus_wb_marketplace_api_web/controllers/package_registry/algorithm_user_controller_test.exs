defmodule MotivusWbMarketplaceApiWeb.PackageRegistry.AlgorithmUserControllerTest do
  use MotivusWbMarketplaceApiWeb.ConnCase

  alias MotivusWbMarketplaceApi.PackageRegistry
  alias MotivusWbMarketplaceApi.PackageRegistry.AlgorithmUser

  @create_attrs %{
    charge_schema: "some charge_schema",
    cost: 120.5,
    role: "some role"
  }
  @update_attrs %{
    charge_schema: "some updated charge_schema",
    cost: 456.7,
    role: "some updated role"
  }
  @invalid_attrs %{charge_schema: nil, cost: nil, role: nil}

  def fixture(:algorithm_user) do
    {:ok, algorithm_user} = PackageRegistry.create_algorithm_user(@create_attrs)
    algorithm_user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all algorithm_users", %{conn: conn} do
      conn = get(conn, Routes.package_registry_algorithm_user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create algorithm_user" do
    test "renders algorithm_user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.package_registry_algorithm_user_path(conn, :create), algorithm_user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.package_registry_algorithm_user_path(conn, :show, id))

      assert %{
               "id" => id,
               "charge_schema" => "some charge_schema",
               "cost" => 120.5,
               "role" => "some role"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.package_registry_algorithm_user_path(conn, :create), algorithm_user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update algorithm_user" do
    setup [:create_algorithm_user]

    test "renders algorithm_user when data is valid", %{conn: conn, algorithm_user: %AlgorithmUser{id: id} = algorithm_user} do
      conn = put(conn, Routes.package_registry_algorithm_user_path(conn, :update, algorithm_user), algorithm_user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.package_registry_algorithm_user_path(conn, :show, id))

      assert %{
               "id" => id,
               "charge_schema" => "some updated charge_schema",
               "cost" => 456.7,
               "role" => "some updated role"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, algorithm_user: algorithm_user} do
      conn = put(conn, Routes.package_registry_algorithm_user_path(conn, :update, algorithm_user), algorithm_user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete algorithm_user" do
    setup [:create_algorithm_user]

    test "deletes chosen algorithm_user", %{conn: conn, algorithm_user: algorithm_user} do
      conn = delete(conn, Routes.package_registry_algorithm_user_path(conn, :delete, algorithm_user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.package_registry_algorithm_user_path(conn, :show, algorithm_user))
      end
    end
  end

  defp create_algorithm_user(_) do
    algorithm_user = fixture(:algorithm_user)
    {:ok, algorithm_user: algorithm_user}
  end
end
