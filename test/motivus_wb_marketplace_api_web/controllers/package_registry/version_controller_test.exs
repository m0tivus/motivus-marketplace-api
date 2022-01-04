defmodule MotivusWbMarketplaceApiWeb.PackageRegistry.VersionControllerTest do
  use MotivusWbMarketplaceApiWeb.ConnCase

  alias MotivusWbMarketplaceApi.Fixtures

  @create_attrs %{
    metadata: %{},
    name: "1.0.0",
    package: %Plug.Upload{
      path: 'test/support/fixtures/package-1.0.0.zip',
      filename: "package-1.0.0.zip"
    }
  }
  @invalid_attrs %{
    metadata: nil,
    name: nil,
    package: nil
  }

  setup %{conn: conn} do
    algorithm = Fixtures.algorithm_fixture(%{"name" => "package"})

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
               "id" => ^id,
               "hash" => nil,
               "metadata" => %{},
               "name" => "1.0.0",
               "data_url" => "https://" <> _linkd,
               "loader_url" => "https://" <> _linkl,
               "wasm_url" => "https://" <> _linkw,
               "inserted_at" => _date
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

    test "does not allow version update", %{
      conn: conn,
      version: version,
      algorithm: algorithm
    } do
      conn =
        put(
          conn,
          Routes.package_registry_algorithm_version_path(conn, :update, algorithm, version)
        )

      assert response(conn, 405)
    end
  end

  describe "delete version" do
    setup [:create_version]

    test "does not allow version deletion", %{conn: conn, version: version, algorithm: algorithm} do
      conn =
        delete(
          conn,
          Routes.package_registry_algorithm_version_path(conn, :delete, algorithm, version)
        )

      assert response(conn, 405)
    end
  end

  defp create_version(%{algorithm: %{id: algorithm_id}}) do
    version = Fixtures.version_fixture(%{"algorithm_id" => algorithm_id})

    {:ok, version: version}
  end
end
