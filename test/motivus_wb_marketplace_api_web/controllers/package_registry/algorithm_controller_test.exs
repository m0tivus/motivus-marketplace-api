defmodule MotivusMarketplaceApiWeb.PackageRegistry.AlgorithmControllerTest do
  use MotivusMarketplaceApiWeb.ConnCase

  import MotivusMarketplaceApiWeb.AuthControllerCase

  alias MotivusMarketplaceApi.PackageRegistry.Algorithm
  import MotivusMarketplaceApi.Fixtures

  @create_attrs %{
    "charge_schema" => "PER_EXECUTION",
    "cost" => 120.5,
    "is_public" => true,
    "name" => "package"
  }
  @update_attrs %{
    "charge_schema" => "PER_MINUTE",
    "cost" => 456.7,
    "is_public" => false
  }
  @invalid_attrs %{charge_schema: nil, cost: nil, is_public: nil, name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup :with_auth

  describe "index" do
    test "lists all algorithms", %{conn: conn} = context do
      conn = get(conn, Routes.package_registry_algorithm_path(conn, :index))
      assert json_response(conn, 200)["data"] == []

      {:ok, %{conn: conn}} = log_out_user(context)

      conn = get(conn, Routes.package_registry_algorithm_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end

    test "lists all algorithms that a user has access to", %{conn: conn, user: user} do
      %{id: public_algorithm_id} = algorithm_fixture(%{"is_public" => true})

      %{id: owner_algorithm_id} =
        algorithm_fixture(%{
          "name" => "private-owner",
          "is_public" => false,
          "cost" => 100,
          "user_id" => user.id
        })

      %{id: user_algorithm_id} =
        algorithm_fixture(%{"name" => "private-user", "is_public" => false, "cost" => 100})

      algorithm_user_fixture(%{
        "algorithm_id" => user_algorithm_id,
        "user_id" => user.id,
        "role" => "USER",
        "cost" => 50
      })

      %{id: maintainer_algorithm_id} =
        algorithm_fixture(%{"name" => "private-maintainer", "is_public" => false, "cost" => 100})

      algorithm_user_fixture(%{
        "algorithm_id" => maintainer_algorithm_id,
        "user_id" => user.id,
        "role" => "MAINTAINER"
      })

      conn = get(conn, Routes.package_registry_algorithm_path(conn, :index))

      assert [
               %{
                 "id" => ^public_algorithm_id
               },
               %{
                 "id" => ^owner_algorithm_id
               },
               %{"id" => ^user_algorithm_id, "cost" => 50.0},
               %{"id" => ^maintainer_algorithm_id}
             ] = json_response(conn, 200)["data"]

      conn = get(conn, Routes.package_registry_algorithm_path(conn, :index, %{"role" => "OWNER"}))

      assert [
               %{
                 "id" => ^owner_algorithm_id
               }
             ] = json_response(conn, 200)["data"]

      conn =
        get(conn, Routes.package_registry_algorithm_path(conn, :index, %{"role" => "MAINTAINER"}))

      assert [
               %{
                 "id" => ^maintainer_algorithm_id
               }
             ] = json_response(conn, 200)["data"]
    end

    test "lists all algorithms that a user has access to using custom access_tokens", context do
      _algorithm = algorithm_fixture(%{"is_public" => false})

      %{id: id} = algorithm_fixture(%{"name" => "private-with-access", "is_public" => false})

      user = user_fixture()
      algorithm_user_fixture(%{"user_id" => user.id, "algorithm_id" => id, "role" => "USER"})

      {:ok, %{conn: conn}} = log_in_user(context, user, nil, :application_token)
      conn = get(conn, Routes.package_registry_algorithm_path(conn, :index))

      assert [
               %{
                 "id" => ^id
               }
             ] = json_response(conn, 200)["data"]

      {:ok, %{conn: conn}} = log_in_user(context, user, nil, :personal_access_token)
      conn = get(conn, Routes.package_registry_algorithm_path(conn, :index))

      assert [
               %{
                 "id" => ^id
               }
             ] = json_response(conn, 200)["data"]
    end

    test "renders single algorithm according to permissions",
         %{conn: conn, user: user} = context do
      %{id: id} = algorithm_fixture(%{"is_public" => false, "user_id" => user.id})
      version_fixture(%{"algorithm_id" => id})

      client = user_fixture()

      algorithm_user_fixture(%{
        "user_id" => client.id,
        "algorithm_id" => id,
        "cost" => 1,
        "charge_schema" => "PER_MINUTE"
      })

      conn = get(conn, Routes.package_registry_algorithm_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "charge_schema" => "PER_EXECUTION",
               "cost" => 120.5,
               "is_public" => false
             } = json_response(conn, 200)["data"]

      {:ok, %{conn: conn}} = log_in_user(context, client)

      conn = get(conn, Routes.package_registry_algorithm_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "charge_schema" => "PER_MINUTE",
               "cost" => 1.0,
               "is_public" => false
             } = json_response(conn, 200)["data"]
    end
  end

  describe "create algorithm" do
    test "renders algorithm when data is valid", %{conn: conn, user: user} = context do
      conn =
        post(conn, Routes.package_registry_algorithm_path(conn, :create), algorithm: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]
      %{id: version_id} = version_fixture(%{"algorithm_id" => id})

      conn = get(conn, Routes.package_registry_algorithm_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "charge_schema" => "PER_EXECUTION",
               "cost" => 120.5,
               "is_public" => true,
               "name" => "package",
               "versions" => versions,
               "inserted_at" => _date
             } = json_response(conn, 200)["data"]

      assert [%{"id" => ^version_id}] = versions
      [version] = versions
      assert Map.get(version, "wasm_url") == nil

      {:ok, %{conn: conn}} = log_in_user(context, user, nil, :application_token)
      conn = get(conn, Routes.package_registry_algorithm_path(conn, :show, id))
      %{"versions" => versions} = json_response(conn, 200)["data"]
      [version] = versions
      link = Map.get(version, "wasm_url")
      assert "https://" <> _link = link
    end

    test "renders errors when auth is provided by application_token", context do
      user = user_fixture()

      {:ok, %{conn: conn}} = log_in_user(context, user, nil, :application_token)

      conn =
        post(conn, Routes.package_registry_algorithm_path(conn, :create), algorithm: @create_attrs)

      assert response(conn, :forbidden)
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
               "charge_schema" => "PER_MINUTE",
               "cost" => 456.7,
               "is_public" => false,
               "name" => "package"
             } = json_response(conn, 200)["data"]
    end

    test "renders error when user is not owner", %{algorithm: algorithm} = context do
      unrelated_user = user_fixture()
      {:ok, %{conn: conn}} = log_in_user(context, unrelated_user)

      conn =
        put(conn, Routes.package_registry_algorithm_path(conn, :update, algorithm),
          algorithm: @update_attrs
        )

      assert response(conn, :forbidden)
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
      assert response(conn, :method_not_allowed)
    end
  end

  defp create_algorithm(%{user: %{id: user_id}}) do
    algorithm = algorithm_fixture(%{"user_id" => user_id})
    {:ok, algorithm: algorithm}
  end
end
