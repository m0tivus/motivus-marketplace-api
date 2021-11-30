defmodule MotivusWbMarketplaceApiWeb.PackageRegistry.VersionControllerTest do
  use MotivusWbMarketplaceApiWeb.ConnCase

  alias MotivusWbMarketplaceApi.PackageRegistry
  alias MotivusWbMarketplaceApi.PackageRegistry.Version

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
  @invalid_attrs %{data_url: nil, hash: nil, loader_url: nil, metadata: nil, name: nil, wasm_url: nil}

  def fixture(:version) do
    {:ok, version} = PackageRegistry.create_version(@create_attrs)
    version
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all versions", %{conn: conn} do
      conn = get(conn, Routes.package_registry_version_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create version" do
    test "renders version when data is valid", %{conn: conn} do
      conn = post(conn, Routes.package_registry_version_path(conn, :create), version: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.package_registry_version_path(conn, :show, id))

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

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.package_registry_version_path(conn, :create), version: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update version" do
    setup [:create_version]

    test "renders version when data is valid", %{conn: conn, version: %Version{id: id} = version} do
      conn = put(conn, Routes.package_registry_version_path(conn, :update, version), version: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.package_registry_version_path(conn, :show, id))

      assert %{
               "id" => id,
               "data_url" => "some updated data_url",
               "hash" => "some updated hash",
               "loader_url" => "some updated loader_url",
               "metadata" => {},
               "name" => "some updated name",
               "wasm_url" => "some updated wasm_url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, version: version} do
      conn = put(conn, Routes.package_registry_version_path(conn, :update, version), version: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete version" do
    setup [:create_version]

    test "deletes chosen version", %{conn: conn, version: version} do
      conn = delete(conn, Routes.package_registry_version_path(conn, :delete, version))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.package_registry_version_path(conn, :show, version))
      end
    end
  end

  defp create_version(_) do
    version = fixture(:version)
    {:ok, version: version}
  end
end
