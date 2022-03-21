defmodule MotivusMarketplaceApi.PackageRegistry do
  alias ExAws.S3

  @moduledoc """
  The PackageRegistry context.
  """

  import Ecto.Query, warn: false
  alias MotivusMarketplaceApi.Repo
  alias Ecto.Multi

  alias MotivusMarketplaceApi.PackageRegistry.Algorithm
  alias MotivusMarketplaceApi.PackageRegistry.AlgorithmUser

  @doc """
  Returns the list of algorithms.

  ## Examples

      iex> list_algorithms()
      [%Algorithm{}, ...]

  """

  @algorithm_preload_default [:versions, algorithm_users: [:user]]
  def list_algorithms(params \\ %{})

  def list_algorithms(%{"name" => name}) do
    Algorithm
    |> preload(^@algorithm_preload_default)
    |> where(name: ^name)
    |> Repo.all()
  end

  def list_algorithms(_) do
    Algorithm
    |> preload(^@algorithm_preload_default)
    |> Repo.all()
  end

  def list_available_algorithms(nil, filter) do
    query =
      from a in Algorithm,
        where: a.is_public == true

    query =
      case filter do
        %{"name" => name} ->
          from [a] in query, where: a.name == ^name

        _ ->
          query
      end

    query
    |> preload(^@algorithm_preload_default)
    |> Repo.all()
  end

  def list_available_algorithms(user_id, filter) do
    query =
      case filter do
        %{"role" => role} when role in ~w(OWNER MAINTAINER) ->
          from a in Algorithm,
            join: au in assoc(a, :algorithm_users),
            or_where: au.user_id == ^user_id,
            preload: [algorithm_users: au]

        _ ->
          from a in Algorithm,
            join: au in assoc(a, :algorithm_users),
            where: a.is_public == true,
            or_where: au.user_id == ^user_id,
            preload: [algorithm_users: au]
      end

    query =
      case filter do
        %{"name" => name} ->
          from [a] in query, where: a.name == ^name

        %{"role" => role} when role in ~w(OWNER MAINTAINER) ->
          from [a, au] in query,
            where: au.role == ^role

        _ ->
          query
      end

    query
    |> preload(^@algorithm_preload_default)
    |> Repo.all()
    |> apply_role_cost()
  end

  def apply_role_cost(algorithms) do
    algorithms
    |> Enum.map(fn a ->
      case a.algorithm_users do
        [au] ->
          case au.role do
            "OWNER" -> a
            _ -> a |> Map.merge(%{cost: au.cost, charge_schema: au.charge_schema})
          end

        _ ->
          a
      end
    end)
  end

  @doc """
  Gets a single algorithm.

  Raises `Ecto.NoResultsError` if the Algorithm does not exist.

  ## Examples

      iex> get_algorithm!(123)
      %Algorithm{}

      iex> get_algorithm!(456)
      ** (Ecto.NoResultsError)

  """
  def get_algorithm!(id), do: Algorithm |> preload(^@algorithm_preload_default) |> Repo.get!(id)

  def get_algorithm!(nil, id) do
    query =
      from a in Algorithm,
        where: a.id == ^id,
        where: a.is_public == true

    query
    |> preload(^@algorithm_preload_default)
    |> Repo.one!()
  end

  def get_algorithm!(user_id, id) do
    query =
      from a in Algorithm,
        join: au in assoc(a, :algorithm_users),
        where: a.id == ^id,
        where: a.is_public == true or au.user_id == ^user_id,
        preload: [algorithm_users: au]

    algorithm =
      query
      |> preload(^@algorithm_preload_default)
      |> Repo.one!()

    [algorithm]
    |> apply_role_cost()
    |> List.first()
  end

  @doc """
  Creates a algorithm.

  ## Examples

      iex> create_algorithm(%{field: value})
      {:ok, %Algorithm{}}

      iex> create_algorithm(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_algorithm(attrs) do
    with {:ok, %{algorithm: algorithm}} <-
           Multi.new()
           |> Multi.insert(
             :algorithm,
             %Algorithm{}
             |> Algorithm.create_changeset(attrs)
           )
           |> Multi.insert(:owner, fn %{algorithm: algorithm} ->
             %AlgorithmUser{}
             |> AlgorithmUser.algorithm_owner_changeset(
               attrs
               |> Enum.into(%{"algorithm_id" => algorithm.id})
             )
           end)
           |> Repo.transaction() do
      {:ok, algorithm |> Repo.preload(@algorithm_preload_default)}
    else
      {:error, :algorithm, chset, _} -> {:error, chset}
      e -> e
    end
  end

  @doc """
  Updates a algorithm.

  ## Examples

      iex> update_algorithm(algorithm, %{field: new_value})
      {:ok, %Algorithm{}}

      iex> update_algorithm(algorithm, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_algorithm(%Algorithm{} = algorithm, attrs) do
    algorithm
    |> Algorithm.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a algorithm.

  ## Examples

      iex> delete_algorithm(algorithm)
      {:ok, %Algorithm{}}

      iex> delete_algorithm(algorithm)
      {:error, %Ecto.Changeset{}}

  """
  def delete_algorithm(%Algorithm{} = algorithm) do
    Repo.delete(algorithm)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking algorithm changes.

  ## Examples

      iex> change_algorithm(algorithm)
      %Ecto.Changeset{source: %Algorithm{}}

  """
  def change_algorithm(%Algorithm{} = algorithm) do
    Algorithm.update_changeset(algorithm, %{})
  end

  alias MotivusMarketplaceApi.PackageRegistry.Version

  @doc """
  Returns the list of versions.

  ## Examples

      iex> list_versions()
      [%Version{}, ...]

  """
  def list_versions do
    Repo.all(Version)
  end

  @doc """
  Gets a single version.

  Raises `Ecto.NoResultsError` if the Version does not exist.

  ## Examples

      iex> get_version!(123)
      %Version{}

      iex> get_version!(456)
      ** (Ecto.NoResultsError)

  """
  def get_version!(id), do: Repo.get!(Version, id)

  @doc """
  Creates a version.

  ## Examples

      iex> create_version(%{field: value})
      {:ok, %Version{}}

      iex> create_version(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_version(attrs \\ %{}) do
    %Version{}
    |> Version.create_changeset(attrs)
    |> Repo.insert()
  end

  def publish_version(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:version, %Version{} |> Version.create_changeset(attrs))
    |> Multi.run(:s3, fn _repo, %{version: version} -> upload_package(version) end)
    |> Multi.update(:version_urls, fn %{s3: links, version: version} ->
      version |> Version.update_changeset(links)
    end)
    |> Repo.transaction()
  end

  def upload_package(version) do
    bucket = Application.get_env(:ex_aws, :bucket)

    upload_file = fn {src_path, dest_path} ->
      S3.put_object(bucket, dest_path, File.read!(src_path))
      |> ExAws.request!()
    end

    paths =
      Map.take(version, [:wasm_url, :loader_url, :data_url])
      |> Map.values()
      |> Enum.reject(&is_nil/1)
      |> Enum.map(fn path -> {to_string(path), to_string(path)} end)
      |> Enum.into(%{})

    [_, _, uuid | _] = version.wasm_url |> to_string |> String.split("/")

    # TODO use client uuid hash instead of tmp
    with :ok <-
           paths
           |> Task.async_stream(upload_file, max_concurrency: 10, timeout: 30_000)
           |> Stream.run(),
         File.rm_rf!("/tmp/" <> uuid) do
      {:ok, version |> put_version_urls(bucket)}
    end
  end

  defp put_version_urls(version, bucket),
    do:
      Map.take(version, [:wasm_url, :loader_url, :data_url])
      |> Enum.reject(fn {_k, v} -> is_nil(v) end)
      |> Enum.map(fn {k, v} ->
        {k, "https://#{bucket}.s3.amazonaws.com/#{bucket}#{v |> to_string()}"}
      end)
      |> Enum.into(%{})

  @doc """
  Updates a version.

  ## Examples

      iex> update_version(version, %{field: new_value})
      {:ok, %Version{}}

      iex> update_version(version, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_version(%Version{} = version, attrs) do
    version
    |> Version.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a version.

  ## Examples

      iex> delete_version(version)
      {:ok, %Version{}}

      iex> delete_version(version)
      {:error, %Ecto.Changeset{}}

  """
  def delete_version(%Version{} = version) do
    Repo.delete(version)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking version changes.

  ## Examples

      iex> change_version(version)
      %Ecto.Changeset{source: %Version{}}

  """
  def change_version(%Version{} = version) do
    Version.update_changeset(version, %{})
  end

  @doc """
  Returns the list of algorithm_users.

  ## Examples

      iex> list_algorithm_users()
      [%AlgorithmUser{}, ...]

  """
  def list_algorithm_users do
    AlgorithmUser |> preload(:user) |> Repo.all()
  end

  def list_algorithm_users(algorithm_id) do
    AlgorithmUser |> where(algorithm_id: ^algorithm_id) |> preload(:user) |> Repo.all()
  end

  def list_algorithm_users(algorithm_id, role) do
    AlgorithmUser
    |> where(algorithm_id: ^algorithm_id, role: ^role)
    |> preload(:user)
    |> Repo.all()
  end

  @doc """
  Gets a single algorithm_user.

  Raises `Ecto.NoResultsError` if the Algorithm user does not exist.

  ## Examples

      iex> get_algorithm_user!(123)
      %AlgorithmUser{}

      iex> get_algorithm_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_algorithm_user!(id), do: AlgorithmUser |> preload(:user) |> Repo.get!(id)

  def get_algorithm_user!(algorithm_id, user_id),
    do:
      AlgorithmUser
      |> preload(:user)
      |> where(algorithm_id: ^algorithm_id, user_id: ^user_id)
      |> Repo.one()

  @doc """
  Creates a algorithm_user.

  ## Examples

      iex> create_algorithm_user(%{field: value})
      {:ok, %AlgorithmUser{}}

      iex> create_algorithm_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_algorithm_user(attrs \\ %{}) do
    with {:ok, algorithm_user} <-
           %AlgorithmUser{}
           |> AlgorithmUser.create_changeset(attrs)
           |> Repo.insert() do
      {:ok, algorithm_user |> Repo.preload(:user)}
    end
  end

  @doc """
  Updates a algorithm_user.

  ## Examples

      iex> update_algorithm_user(algorithm_user, %{field: new_value})
      {:ok, %AlgorithmUser{}}

      iex> update_algorithm_user(algorithm_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_algorithm_user(%AlgorithmUser{} = algorithm_user, attrs) do
    with {:ok, algorithm_user} <-
           algorithm_user
           |> AlgorithmUser.update_changeset(attrs)
           |> Repo.update() do
      {:ok, algorithm_user |> Repo.preload(:user)}
    end
  end

  @doc """
  Deletes a algorithm_user.

  ## Examples

      iex> delete_algorithm_user(algorithm_user)
      {:ok, %AlgorithmUser{}}

      iex> delete_algorithm_user(algorithm_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_algorithm_user(%AlgorithmUser{} = algorithm_user) do
    Repo.delete(algorithm_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking algorithm_user changes.

  ## Examples

      iex> change_algorithm_user(algorithm_user)
      %Ecto.Changeset{source: %AlgorithmUser{}}

  """
  def change_algorithm_user(%AlgorithmUser{} = algorithm_user) do
    AlgorithmUser.create_changeset(algorithm_user, %{})
  end

  def validate_update_algorithm_user(%AlgorithmUser{} = algorithm_user, params) do
    types = %{role: :string}

    case {%AlgorithmUser{} = algorithm_user, types}
         |> Ecto.Changeset.cast(params, Map.keys(types))
         |> Ecto.Changeset.validate_required([:role])
         |> ensure_remaining_owner() do
      %{valid?: true} = chset -> {:ok, Ecto.Changeset.apply_changes(chset)}
      %{valid?: false} = chset -> {:error, chset}
    end
  end

  def validate_delete_algorithm_user(%AlgorithmUser{} = algorithm_user),
    do: validate_update_algorithm_user(algorithm_user, %{role: "-"})

  def ensure_remaining_owner(chset) do
    algorithm_user_roles_after = [
      %{role: chset.changes["role"]}
      | list_algorithm_users(chset.data.algorithm_id, "OWNER")
        |> Enum.filter(fn au -> au.id != chset.data.id end)
        |> Enum.map(fn %{role: role} -> %{role: role} end)
    ]

    case algorithm_user_roles_after
         |> Enum.filter(fn %{role: role} -> role == "OWNER" end) do
      [] -> chset |> Ecto.Changeset.add_error(:owners, "At least one owner must remain")
      _ -> chset
    end
  end
end
