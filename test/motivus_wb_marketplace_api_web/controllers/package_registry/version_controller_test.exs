defmodule MotivusMarketplaceApiWeb.PackageRegistry.VersionControllerTest do
  use MotivusMarketplaceApiWeb.ConnCase

  import MotivusMarketplaceApiWeb.AuthControllerCase

  import MotivusMarketplaceApi.Fixtures

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

  setup :with_auth

  setup %{conn: conn, user: user} do
    algorithm = algorithm_fixture(%{"name" => "package", "user_id" => user.id})

    {:ok, conn: put_req_header(conn, "accept", "application/json"), algorithm: algorithm}
  end

  describe "index" do
    test "lists all versions", %{conn: conn, algorithm: algorithm} do
      conn = get(conn, Routes.package_registry_algorithm_version_path(conn, :index, algorithm.id))
      assert json_response(conn, 200)["data"] == []
    end

    test "does not show links for regular user", %{conn: conn, algorithm: algorithm} do
      %{id: id} = version_fixture(%{"algorithm_id" => algorithm.id})

      conn = get(conn, Routes.package_registry_algorithm_version_path(conn, :show, algorithm, id))

      version = json_response(conn, 200)["data"]
      assert Map.get(version, "id") == id
      assert Map.get(version, "wasm_url") == nil, "data should not include link"
    end

    test "shows links for application_token user",
         %{algorithm: algorithm, user: user} = context do
      {:ok, %{conn: conn}} = log_in_user(context, user, nil, :application_token)

      %{id: id} = version_fixture(%{"algorithm_id" => algorithm.id})

      conn = get(conn, Routes.package_registry_algorithm_version_path(conn, :show, algorithm, id))

      assert %{
               "id" => ^id,
               "metadata" => %{},
               "name" => "1.0.0",
               "data_url" => "https://" <> _linkd,
               "loader_url" => "https://" <> _linkl,
               "wasm_url" => "https://" <> _linkw,
               "inserted_at" => _date
             } = json_response(conn, 200)["data"]
    end
  end

  describe "create version" do
    test "renders version when data is valid",
         %{conn: conn, algorithm: algorithm, user: user} = context do
      algorithm_no_data = algorithm_fixture(%{"user_id" => user.id, "name" => "no-data"})

      conn =
        post(
          conn,
          Routes.package_registry_algorithm_version_path(conn, :create, algorithm_no_data),
          version: %{
            metadata: %{},
            name: "1.0.0",
            package: %Plug.Upload{
              path: 'test/support/fixtures/no-data-1.0.0.zip',
              filename: "no-data-1.0.0.zip"
            }
          }
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      {:ok, %{conn: conn}} = log_in_user(context, user, nil, :application_token)
      conn = get(conn, Routes.package_registry_algorithm_version_path(conn, :show, algorithm, id))

      assert %{
               "id" => ^id,
               "metadata" => %{},
               "name" => "1.0.0",
               "inserted_at" => _date,
               "data_url" => nil
             } = json_response(conn, 200)["data"]

      {:ok, %{conn: conn}} = log_in_user(context, user)

      conn =
        post(conn, Routes.package_registry_algorithm_version_path(conn, :create, algorithm),
          version: @create_attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.package_registry_algorithm_version_path(conn, :show, algorithm, id))

      assert %{
               "id" => ^id,
               "metadata" => %{},
               "name" => "1.0.0",
               "inserted_at" => _date
             } = json_response(conn, 200)["data"]

      {:ok, %{conn: conn}} = log_in_user(context, user, nil, :application_token)

      conn =
        post(conn, Routes.package_registry_algorithm_version_path(conn, :create, algorithm),
          version: @create_attrs
        )

      assert response(conn, :forbidden)
    end

    test "renders version when data is valid using personal_access_token",
         %{algorithm: algorithm, user: user} = context do
      {:ok, %{conn: conn}} = log_in_user(context, user, nil, :personal_access_token)

      conn =
        post(conn, Routes.package_registry_algorithm_version_path(conn, :create, algorithm),
          version: @create_attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.package_registry_algorithm_version_path(conn, :show, algorithm, id))

      assert %{
               "id" => ^id,
               "metadata" => %{},
               "name" => "1.0.0",
               "inserted_at" => _date
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when user has no permissions", %{algorithm: algorithm} = context do
      unrelated_user = user_fixture()
      {:ok, %{conn: conn}} = log_in_user(context, unrelated_user)

      conn =
        post(conn, Routes.package_registry_algorithm_version_path(conn, :create, algorithm),
          version: @create_attrs
        )

      assert response(conn, :forbidden)

      just_user = user_fixture()

      algorithm_user_fixture(%{
        "algorithm_id" => algorithm.id,
        "user_id" => just_user.id,
        "role" => "USER"
      })

      {:ok, %{conn: conn}} = log_in_user(context, just_user)

      conn =
        post(conn, Routes.package_registry_algorithm_version_path(conn, :create, algorithm),
          version: @create_attrs
        )

      assert response(conn, :forbidden)
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

      assert response(conn, :method_not_allowed)
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

      assert response(conn, :method_not_allowed)
    end
  end

  defp create_version(%{algorithm: %{id: algorithm_id}}) do
    version = version_fixture(%{"algorithm_id" => algorithm_id})

    {:ok, version: version}
  end
end
