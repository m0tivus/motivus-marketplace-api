defmodule MotivusWbMarketplaceApiWeb.PackageRegistry.AlgorithmControllerTest do
  use MotivusWbMarketplaceApiWeb.ConnCase

  import MotivusWbMarketplaceApiWeb.AuthControllerCase

  alias MotivusWbMarketplaceApi.PackageRegistry.Algorithm
  alias MotivusWbMarketplaceApi.Fixtures

  @create_attrs %{
    "default_charge_schema" => "PER_EXECUTION",
    "default_cost" => 120.5,
    "is_public" => true,
    "name" => "package"
  }
  @update_attrs %{
    "default_charge_schema" => "PER_MINUTE",
    "default_cost" => 456.7,
    "is_public" => false
  }
  @invalid_attrs %{default_charge_schema: nil, default_cost: nil, is_public: nil, name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup :with_auth

  describe "index" do
    test "lists all algorithms", %{conn: conn} do
      conn = get(conn, Routes.package_registry_algorithm_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create algorithm" do
    test "renders algorithm when data is valid", %{conn: conn} do
      conn =
        post(conn, Routes.package_registry_algorithm_path(conn, :create), algorithm: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]
      %{id: version_id} = Fixtures.version_fixture(%{"algorithm_id" => id})

      conn = get(conn, Routes.package_registry_algorithm_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "default_charge_schema" => "PER_EXECUTION",
               "default_cost" => 120.5,
               "is_public" => true,
               "name" => "package",
               "versions" => versions,
               "inserted_at" => _date
             } = json_response(conn, 200)["data"]

      assert [%{"id" => ^version_id}] = versions
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.package_registry_algorithm_path(conn, :create),
          algorithm: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update algorithm" do
    setup [:create_algorithm]

    test "renders algorithm when data is valid", %{
      conn: conn,
      algorithm: %Algorithm{id: id} = algorithm
    } do
      conn =
        put(conn, Routes.package_registry_algorithm_path(conn, :update, algorithm),
          algorithm: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.package_registry_algorithm_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "default_charge_schema" => "PER_MINUTE",
               "default_cost" => 456.7,
               "is_public" => false,
               "name" => "package"
             } = json_response(conn, 200)["data"]
    end

    test "renders error when user is not owner", %{algorithm: algorithm} = context do
      unrelated_user = Fixtures.user_fixture()
      {:ok, %{conn: conn}} = log_in_user(context, unrelated_user)

      conn =
        put(conn, Routes.package_registry_algorithm_path(conn, :update, algorithm),
          algorithm: @update_attrs
        )

      assert response(conn, 405)
    end

    test "renders errors when data is invalid", %{conn: conn, algorithm: algorithm} do
      conn =
        put(conn, Routes.package_registry_algorithm_path(conn, :update, algorithm),
          algorithm: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete algorithm" do
    setup [:create_algorithm]

    test "does not allow algorithm deletion", %{conn: conn, algorithm: algorithm} do
      conn = delete(conn, Routes.package_registry_algorithm_path(conn, :delete, algorithm))
      assert response(conn, 405)
    end
  end

  defp create_algorithm(%{user: %{id: user_id}}) do
    algorithm = Fixtures.algorithm_fixture(%{"user_id" => user_id})
    {:ok, algorithm: algorithm}
  end
end
