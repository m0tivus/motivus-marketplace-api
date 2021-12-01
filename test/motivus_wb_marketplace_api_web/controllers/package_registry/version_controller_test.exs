defmodule MotivusWbMarketplaceApiWeb.PackageRegistry.VersionControllerTest do
  use MotivusWbMarketplaceApiWeb.ConnCase

  alias MotivusWbMarketplaceApi.PackageRegistry.Version

  alias MotivusWbMarketplaceApi.Fixtures

  @create_attrs %{
    data_url: "some data_url",
    hash: "some hash",
    loader_url: "some loader_url",
    metadata: %{},
    name: "some name",
    wasm_url: "some wasm_url"
  }
  @update_attrs %{
    data_url: "some updated data_url",
    hash: "some updated hash",
    loader_url: "some updated loader_url",
    metadata: %{},
    name: "some updated name",
    wasm_url: "some updated wasm_url"
  }
  @invalid_attrs %{
    data_url: nil,
    hash: nil,
    loader_url: nil,
    metadata: nil,
    name: nil,
    wasm_url: nil
  }

  def fixture(:version), do: Fixtures.version_fixture()

  setup %{conn: conn} do
    algorithm = Fixtures.algorithm_fixture()
    {:ok, conn: put_req_header(conn, "accept", "application/json"), algorithm: algorithm}
  end

  describe "index" do
    test "lists all versions", %{conn: conn, algorithm: algorithm} do
      conn = get(conn, Routes.package_registry_algorithm_version_path(conn, :index, algorithm.id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create version" do
    test "renders version when data is valid", %{conn: conn, algorithm: algorithm} do
      conn =
        post(conn, Routes.package_registry_algorithm_version_path(conn, :create, algorithm),
          version: @create_attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.package_registry_algorithm_version_path(conn, :show, algorithm, id))

      assert %{
               "id" => id,
               "data_url" => "some data_url",
               "hash" => "some hash",
               "loader_url" => "some loader_url",
               "metadata" => %{},
               "name" => "some name",
               "wasm_url" => "some wasm_url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, algorithm: algorithm} do
      conn =
        post(conn, Routes.package_registry_algorithm_version_path(conn, :create, algorithm),
          version: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update version" do
    setup [:create_version]

    test "renders version when data is valid", %{
      conn: conn,
      version: %Version{id: id} = version,
      algorithm: algorithm
    } do
      conn =
        put(
          conn,
          Routes.package_registry_algorithm_version_path(conn, :update, algorithm, version),
          version: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.package_registry_algorithm_version_path(conn, :show, algorithm, id))

      assert %{
               "id" => id,
               "data_url" => "some updated data_url",
               "hash" => "some updated hash",
               "loader_url" => "some updated loader_url",
               "metadata" => %{},
               "name" => "some updated name",
               "wasm_url" => "some updated wasm_url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      version: version,
      algorithm: algorithm
    } do
      conn =
        put(
          conn,
          Routes.package_registry_algorithm_version_path(conn, :update, algorithm, version),
          version: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete version" do
    setup [:create_version]

    test "deletes chosen version", %{conn: conn, version: version, algorithm: algorithm} do
      conn =
        delete(
          conn,
          Routes.package_registry_algorithm_version_path(conn, :delete, algorithm, version)
        )

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.package_registry_algorithm_version_path(conn, :show, algorithm, version))
      end
    end
  end

  defp create_version(_) do
    version = fixture(:version)
    {:ok, version: version}
  end
end
