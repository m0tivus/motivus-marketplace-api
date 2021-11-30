defmodule MotivusWbMarketplaceApi.PackageRegistry do
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
    Repo.all(Algorithm)
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
  def get_algorithm!(id), do: Repo.get!(Algorithm, id)

  @doc """
  Creates a algorithm.

  ## Examples

      iex> create_algorithm(%{field: value})
      {:ok, %Algorithm{}}

      iex> create_algorithm(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_algorithm(attrs \\ %{}) do
    %Algorithm{}
    |> Algorithm.changeset(attrs)
    |> Repo.insert()
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
    |> Algorithm.changeset(attrs)
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
    Algorithm.changeset(algorithm, %{})
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
    |> Version.changeset(attrs)
    |> Repo.insert()
  end

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
    |> Version.changeset(attrs)
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
    Version.changeset(version, %{})
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
