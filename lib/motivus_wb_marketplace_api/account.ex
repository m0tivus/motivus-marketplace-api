defmodule MotivusWbMarketplaceApi.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias MotivusWbMarketplaceApi.Repo

  alias MotivusWbMarketplaceApi.Account.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias MotivusWbMarketplaceApi.Account.ApplicationToken

  @doc """
  Returns the list of application_tokens.

  ## Examples

      iex> list_application_tokens()
      [%ApplicationToken{}, ...]

  """
  def list_application_tokens do
    Repo.all(ApplicationToken)
  end

  @doc """
  Gets a single application_token.

  Raises `Ecto.NoResultsError` if the Application token does not exist.

  ## Examples

      iex> get_application_token!(123)
      %ApplicationToken{}

      iex> get_application_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_application_token!(id), do: Repo.get!(ApplicationToken, id)

  @doc """
  Creates a application_token.

  ## Examples

      iex> create_application_token(%{field: value})
      {:ok, %ApplicationToken{}}

      iex> create_application_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_application_token(attrs \\ %{}) do
    %ApplicationToken{}
    |> ApplicationToken.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a application_token.

  ## Examples

      iex> update_application_token(application_token, %{field: new_value})
      {:ok, %ApplicationToken{}}

      iex> update_application_token(application_token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_application_token(%ApplicationToken{} = application_token, attrs) do
    application_token
    |> ApplicationToken.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a application_token.

  ## Examples

      iex> delete_application_token(application_token)
      {:ok, %ApplicationToken{}}

      iex> delete_application_token(application_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_application_token(%ApplicationToken{} = application_token) do
    Repo.delete(application_token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking application_token changes.

  ## Examples

      iex> change_application_token(application_token)
      %Ecto.Changeset{source: %ApplicationToken{}}

  """
  def change_application_token(%ApplicationToken{} = application_token) do
    ApplicationToken.changeset(application_token, %{})
  end
end
