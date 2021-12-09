defmodule MotivusWbMarketplaceApi.PackageRegistry do
  alias ExAws.S3

  @moduledoc """
  The PackageRegistry context.
  """

  import Ecto.Query, warn: false
  alias MotivusWbMarketplaceApi.Repo

  alias MotivusWbMarketplaceApi.PackageRegistry.Algorithm

  @doc """
  Returns the list of algorithms.

  ## Examples

      iex> list_algorithms()
      [%Algorithm{}, ...]

  """
  def list_algorithms do
    Algorithm
    |> preload(:versions)
    |> Repo.all()
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
  def get_algorithm!(id), do: Algorithm |> preload(:versions) |> Repo.get!(id)

  @doc """
  Creates a algorithm.

  ## Examples

      iex> create_algorithm(%{field: value})
      {:ok, %Algorithm{}}

      iex> create_algorithm(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_algorithm(attrs \\ %{}) do
    with {:ok, algorithm} <-
           %Algorithm{}
           |> Algorithm.create_changeset(attrs)
           |> Repo.insert() do
      {:ok, algorithm |> Repo.preload(:versions)}
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

  alias MotivusWbMarketplaceApi.PackageRegistry.Version

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
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:version, %Version{} |> Version.create_changeset(attrs))
    |> Ecto.Multi.run(:s3, fn _repo, %{version: version} -> upload_package(version) end)
    |> Ecto.Multi.update(:version_urls, fn %{s3: links, version: version} ->
      version |> Version.update_changeset(links)
    end)
    |> Repo.transaction()
  end

  def upload_package(version) do
    bucket = Application.get_env(:ex_aws, :bucket)

    upload_file = fn {src_path, dest_path} ->
      S3.put_object(bucket, dest_path, File.read!(src_path), acl: :public_read)
      |> ExAws.request!()
    end

    paths =
      Map.take(version, [:wasm_url, :loader_url, :data_url])
      |> Map.values()
      |> Enum.map(fn path -> {to_string(path), to_string(path)} end)
      |> Enum.into(%{})

    [_, _, uuid | _] = version.wasm_url |> to_string |> String.split("/")

    # TODO use client uuid hash instead of tmp
    with :ok <-
           paths
           |> Task.async_stream(upload_file, max_concurrency: 10)
           # TODO rm dir
           |> Stream.run(),
         File.rm_rf!("/tmp/" <> uuid) do
      {:ok, version |> put_version_urls(bucket)}
    end
  end

  defp put_version_urls(version, bucket),
    do:
      Map.take(version, [:wasm_url, :loader_url, :data_url])
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

  alias MotivusWbMarketplaceApi.PackageRegistry.AlgorithmUser

  @doc """
  Returns the list of algorithm_users.

  ## Examples

      iex> list_algorithm_users()
      [%AlgorithmUser{}, ...]

  """
  def list_algorithm_users do
    Repo.all(AlgorithmUser)
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
  def get_algorithm_user!(id), do: Repo.get!(AlgorithmUser, id)

  @doc """
  Creates a algorithm_user.

  ## Examples

      iex> create_algorithm_user(%{field: value})
      {:ok, %AlgorithmUser{}}

      iex> create_algorithm_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_algorithm_user(attrs \\ %{}) do
    %AlgorithmUser{}
    |> AlgorithmUser.changeset(attrs)
    |> Repo.insert()
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
    algorithm_user
    |> AlgorithmUser.changeset(attrs)
    |> Repo.update()
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
    AlgorithmUser.changeset(algorithm_user, %{})
  end
end
