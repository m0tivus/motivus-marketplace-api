defmodule MotivusMarketplaceApiWeb.PackageRegistry.AlgorithmUserControllerTest do
  use MotivusMarketplaceApiWeb.ConnCase

  alias MotivusMarketplaceApi.PackageRegistry.AlgorithmUser

  import MotivusMarketplaceApiWeb.AuthControllerCase

  import MotivusMarketplaceApi.Fixtures

  @create_attrs %{
    charge_schema: "PER_MINUTE",
    cost: 120.5,
    role: "MAINTAINER"
  }
  @update_attrs %{
    charge_schema: "PER_EXECUTION",
    cost: 456.7,
    role: "OWNER"
  }
  @invalid_attrs %{charge_schema: nil, cost: nil, role: nil}

  setup :with_auth

  setup %{conn: conn, user: user} do
    algorithm = algorithm_fixture(%{"name" => "package", "user_id" => user.id})

    {:ok, conn: put_req_header(conn, "accept", "application/json"), algorithm: algorithm}
  end

  describe "index" do
    test "lists all algorithm_users", %{conn: conn, algorithm: %{id: algorithm_id} = algorithm} do
      algorithm_fixture(%{"name" => "other"})

      conn =
        get(conn, Routes.package_registry_algorithm_algorithm_user_path(conn, :index, algorithm))

      assert [%{"role" => "OWNER", "algorithm_id" => ^algorithm_id}] =
               json_response(conn, 200)["data"]
    end

    test "does not allow non owners to list algorithm_users",
         %{algorithm: algorithm} = context do
      unrelated_user = user_fixture()
      {:ok, %{conn: conn}} = log_in_user(context, unrelated_user)

      conn =
        get(conn, Routes.package_registry_algorithm_algorithm_user_path(conn, :index, algorithm))

      assert response(conn, :forbidden)
    end
  end

  describe "create algorithm_user" do
    test "renders algorithm_user when data is valid", %{
      conn: conn,
      algorithm: %{id: algorithm_id} = algorithm
    } do
      %{id: user_id} = maintainer = user_fixture()

      conn =
        post(
          conn,
          Routes.package_registry_algorithm_algorithm_user_path(conn, :create, algorithm),
          algorithm_user:
            @create_attrs |> Enum.into(%{"username_or_email" => maintainer.username})
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn =
        get(
          conn,
          Routes.package_registry_algorithm_algorithm_user_path(conn, :show, algorithm, id)
        )

      assert %{
               "id" => ^id,
               "charge_schema" => "PER_MINUTE",
               "cost" => 120.5,
               "role" => "MAINTAINER",
               "algorithm_id" => ^algorithm_id,
               "user_id" => ^user_id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, algorithm: algorithm} do
      conn =
        post(
          conn,
          Routes.package_registry_algorithm_algorithm_user_path(conn, :create, algorithm),
          algorithm_user: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update algorithm_user" do
    setup [:create_algorithm_user]

    test "renders algorithm_user when data is valid", %{
      conn: conn,
      algorithm_user: %AlgorithmUser{id: id} = algorithm_user,
      algorithm: algorithm
    } do
      conn =
        put(
          conn,
          Routes.package_registry_algorithm_algorithm_user_path(
            conn,
            :update,
            algorithm,
            algorithm_user
          ),
          algorithm_user: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn =
        get(
          conn,
          Routes.package_registry_algorithm_algorithm_user_path(conn, :show, algorithm, id)
        )

      assert %{
               "id" => ^id,
               "charge_schema" => "PER_EXECUTION",
               "cost" => 456.7,
               "role" => "OWNER"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      algorithm_user: algorithm_user,
      algorithm: algorithm
    } do
      conn =
        put(
          conn,
          Routes.package_registry_algorithm_algorithm_user_path(
            conn,
            :update,
            algorithm,
            algorithm_user
          ),
          algorithm_user: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete algorithm_user" do
    setup [:create_algorithm_user]

    test "deletes chosen algorithm_user", %{
      conn: conn,
      algorithm_user: algorithm_user,
      algorithm: algorithm
    } do
      conn =
        delete(
          conn,
          Routes.package_registry_algorithm_algorithm_user_path(
            conn,
            :delete,
            algorithm,
            algorithm_user
          )
        )

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(
          conn,
          Routes.package_registry_algorithm_algorithm_user_path(
            conn,
            :show,
            algorithm,
            algorithm_user
          )
        )
      end
    end

    test "at least one owner must remain", %{conn: conn, algorithm: algorithm} do
      %{algorithm_users: [algorithm_user]} = algorithm

      conn =
        put(
          conn,
          Routes.package_registry_algorithm_algorithm_user_path(
            conn,
            :update,
            algorithm,
            algorithm_user
          ),
          algorithm_user: %{"role" => "USER"}
        )

      assert Map.fetch!(json_response(conn, 422)["errors"], "owners")

      conn =
        delete(
          conn,
          Routes.package_registry_algorithm_algorithm_user_path(
            conn,
            :delete,
            algorithm,
            algorithm_user
          )
        )

      assert Map.fetch!(json_response(conn, 422)["errors"], "owners")

      other_owner = user_fixture()

      algorithm_user_fixture(%{
        "user_id" => other_owner.id,
        "algorithm_id" => algorithm.id,
        "role" => "OWNER"
      })

      conn =
        delete(
          conn,
          Routes.package_registry_algorithm_algorithm_user_path(
            conn,
            :delete,
            algorithm,
            algorithm_user
          )
        )

      assert response(conn, 204)
    end
  end

  defp create_algorithm_user(%{algorithm: algorithm}) do
    user = user_fixture()

    algorithm_user =
      algorithm_user_fixture(%{
        "user_id" => user.id,
        "algorithm_id" => algorithm.id
      })

    {:ok, algorithm_user: algorithm_user}
  end
end
