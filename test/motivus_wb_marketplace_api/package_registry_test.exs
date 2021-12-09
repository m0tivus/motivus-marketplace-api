defmodule MotivusWbMarketplaceApi.PackageRegistryTest do
  use MotivusWbMarketplaceApi.DataCase
  import MotivusWbMarketplaceApi.Fixtures

  alias MotivusWbMarketplaceApi.PackageRegistry

  describe "algorithms" do
    alias MotivusWbMarketplaceApi.PackageRegistry.Algorithm

    @valid_attrs %{
      default_charge_schema: "PER_EXECUTION",
      default_cost: 120.5,
      is_public: true,
      name: "package"
    }
    @update_attrs %{
      default_charge_schema: "PER_MINUTE",
      default_cost: 456.7,
      is_public: false,
      name: "some updated name"
    }
    @invalid_attrs %{default_charge_schema: nil, default_cost: nil, is_public: nil, name: nil}

    test "list_algorithms/0 returns all algorithms" do
      algorithm = algorithm_fixture()
      assert PackageRegistry.list_algorithms() == [algorithm]
    end

    test "get_algorithm!/1 returns the algorithm with given id" do
      algorithm = algorithm_fixture()
      assert PackageRegistry.get_algorithm!(algorithm.id) == algorithm
    end

    test "create_algorithm/1 with valid data creates a algorithm" do
      assert {:ok, %Algorithm{} = algorithm} = PackageRegistry.create_algorithm(@valid_attrs)
      assert algorithm.default_charge_schema == "PER_EXECUTION"
      assert algorithm.default_cost == 120.5
      assert algorithm.is_public == true
      assert algorithm.name == "package"
    end

    test "create_algorithm/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PackageRegistry.create_algorithm(@invalid_attrs)
    end

    test "update_algorithm/2 with valid data updates the algorithm" do
      algorithm = algorithm_fixture()

      assert {:ok, %Algorithm{} = algorithm} =
               PackageRegistry.update_algorithm(algorithm, @update_attrs)

      assert algorithm.default_charge_schema == "PER_MINUTE"
      assert algorithm.default_cost == 456.7
      assert algorithm.is_public == false
      assert algorithm.name == "package"
    end

    test "update_algorithm/2 with invalid data returns error changeset" do
      algorithm = algorithm_fixture()

      assert {:error, %Ecto.Changeset{}} =
               PackageRegistry.update_algorithm(algorithm, @invalid_attrs)

      assert algorithm == PackageRegistry.get_algorithm!(algorithm.id)
    end

    test "delete_algorithm/1 deletes the algorithm" do
      algorithm = algorithm_fixture()
      assert {:ok, %Algorithm{}} = PackageRegistry.delete_algorithm(algorithm)
      assert_raise Ecto.NoResultsError, fn -> PackageRegistry.get_algorithm!(algorithm.id) end
    end

    test "change_algorithm/1 returns a algorithm changeset" do
      algorithm = algorithm_fixture()
      assert %Ecto.Changeset{} = PackageRegistry.change_algorithm(algorithm)
    end
  end

  describe "versions" do
    alias MotivusWbMarketplaceApi.PackageRegistry.Version

    @valid_attrs %{
      "hash" => "some hash",
      "metadata" => %{
        "long_description" => "#README
        test",
        "short_description" => "test",
        "license" => "MIT",
        "author" => "cristian@motivus.cl",
        "url" => "test.com",
        "upstream_url" => "https://github.com/test/test",
        "ignored" => "should be ignored"
      },
      "name" => "1.0.0",
      "package" => %Plug.Upload{
        path: 'test/support/fixtures/package-1.0.0.zip',
        filename: "package-1.0.0.zip"
      }
    }
    @update_attrs %{
      data_url: "some updated data_url",
      loader_url: "some updated loader_url",
      wasm_url: "some updated wasm_url"
    }
    @invalid_attrs %{
      hash: nil,
      metadata: nil,
      name: nil,
      package: nil,
      data_url: nil,
      loader_url: nil,
      wasm_url: nil
    }

    test "list_versions/0 returns all versions" do
      version = version_fixture()
      assert PackageRegistry.list_versions() == [version]
    end

    test "get_version!/1 returns the version with given id" do
      version = version_fixture()
      assert PackageRegistry.get_version!(version.id) == version
    end

    test "create_version/1 with valid data creates a version" do
      algorithm = algorithm_fixture(%{name: "package"})

      assert {:ok, %Version{} = version} =
               PackageRegistry.create_version(
                 @valid_attrs
                 |> Map.put("algorithm_id", algorithm.id)
                 |> Map.put("algorithm", algorithm)
               )

      assert version.hash == "some hash"

      assert version.metadata == %{
               long_description: "#README
        test",
               short_description: "test",
               license: "MIT",
               author: "cristian@motivus.cl",
               url: "test.com",
               upstream_url: "https://github.com/test/test"
             }

      assert version.name == "1.0.0"
      assert version.algorithm_id == algorithm.id
    end

    test "create_version/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PackageRegistry.create_version(@invalid_attrs)
    end

    test "update_version/2 with valid data updates the version" do
      version = version_fixture()
      assert {:ok, %Version{} = version} = PackageRegistry.update_version(version, @update_attrs)
      assert version.data_url == "some updated data_url"
      assert version.loader_url == "some updated loader_url"
      assert version.wasm_url == "some updated wasm_url"
    end

    test "update_version/2 with invalid data returns error changeset" do
      version = version_fixture()
      assert {:error, %Ecto.Changeset{}} = PackageRegistry.update_version(version, @invalid_attrs)
      assert version == PackageRegistry.get_version!(version.id)
    end

    test "delete_version/1 deletes the version" do
      version = version_fixture()
      assert {:ok, %Version{}} = PackageRegistry.delete_version(version)
      assert_raise Ecto.NoResultsError, fn -> PackageRegistry.get_version!(version.id) end
    end

    test "change_version/1 returns a version changeset" do
      version = version_fixture()
      assert %Ecto.Changeset{} = PackageRegistry.change_version(version)
    end
  end

  describe "algorithm_users" do
    alias MotivusWbMarketplaceApi.PackageRegistry.AlgorithmUser

    @valid_attrs %{charge_schema: "some charge_schema", cost: 120.5, role: "some role"}
    @update_attrs %{
      charge_schema: "some updated charge_schema",
      cost: 456.7,
      role: "some updated role"
    }
    @invalid_attrs %{charge_schema: nil, cost: nil, role: nil}

    def algorithm_user_fixture(attrs \\ %{}) do
      {:ok, algorithm_user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PackageRegistry.create_algorithm_user()

      algorithm_user
    end

    test "list_algorithm_users/0 returns all algorithm_users" do
      algorithm_user = algorithm_user_fixture()
      assert PackageRegistry.list_algorithm_users() == [algorithm_user]
    end

    test "get_algorithm_user!/1 returns the algorithm_user with given id" do
      algorithm_user = algorithm_user_fixture()
      assert PackageRegistry.get_algorithm_user!(algorithm_user.id) == algorithm_user
    end

    test "create_algorithm_user/1 with valid data creates a algorithm_user" do
      assert {:ok, %AlgorithmUser{} = algorithm_user} =
               PackageRegistry.create_algorithm_user(@valid_attrs)

      assert algorithm_user.charge_schema == "some charge_schema"
      assert algorithm_user.cost == 120.5
      assert algorithm_user.role == "some role"
    end

    test "create_algorithm_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PackageRegistry.create_algorithm_user(@invalid_attrs)
    end

    test "update_algorithm_user/2 with valid data updates the algorithm_user" do
      algorithm_user = algorithm_user_fixture()

      assert {:ok, %AlgorithmUser{} = algorithm_user} =
               PackageRegistry.update_algorithm_user(algorithm_user, @update_attrs)

      assert algorithm_user.charge_schema == "some updated charge_schema"
      assert algorithm_user.cost == 456.7
      assert algorithm_user.role == "some updated role"
    end

    test "update_algorithm_user/2 with invalid data returns error changeset" do
      algorithm_user = algorithm_user_fixture()

      assert {:error, %Ecto.Changeset{}} =
               PackageRegistry.update_algorithm_user(algorithm_user, @invalid_attrs)

      assert algorithm_user == PackageRegistry.get_algorithm_user!(algorithm_user.id)
    end

    test "delete_algorithm_user/1 deletes the algorithm_user" do
      algorithm_user = algorithm_user_fixture()
      assert {:ok, %AlgorithmUser{}} = PackageRegistry.delete_algorithm_user(algorithm_user)

      assert_raise Ecto.NoResultsError, fn ->
        PackageRegistry.get_algorithm_user!(algorithm_user.id)
      end
    end

    test "change_algorithm_user/1 returns a algorithm_user changeset" do
      algorithm_user = algorithm_user_fixture()
      assert %Ecto.Changeset{} = PackageRegistry.change_algorithm_user(algorithm_user)
    end
  end
end
