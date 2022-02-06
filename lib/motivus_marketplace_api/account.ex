defmodule MotivusMarketplaceApi.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias MotivusMarketplaceApi.Repo

  alias MotivusMarketplaceApi.Account.User

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

  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  def find_user!(email_or_username),
    do:
      User
      |> where(email: ^email_or_username)
      |> or_where(username: ^email_or_username)
      |> Repo.one!()

  def user_finder_parser(attrs) do
    types = %{username_or_email: :string}

    {%{}, types}
    |> Ecto.Changeset.cast(attrs, Map.keys(types))
    |> Ecto.Changeset.validate_required(:username_or_email)
  end

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
    |> User.update_changeset(attrs)
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

  alias MotivusMarketplaceApi.Account.ApplicationToken

  @doc """
  Returns the list of application_tokens.

  ## Examples

      iex> list_application_tokens()
      [%ApplicationToken{}, ...]

  """
  def list_application_tokens do
    Repo.all(ApplicationToken)
  end

  def list_application_tokens(user_id),
    do: ApplicationToken |> where(user_id: ^user_id) |> Repo.all()

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

  def get_application_token!(user_id, id),
    do: ApplicationToken |> where(user_id: ^user_id, id: ^id) |> Repo.one!()

  def get_application_token_from_value!(value),
    do: ApplicationToken |> where(value: ^value) |> Repo.one!()

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
    |> ApplicationToken.update_changeset(attrs)
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
    ApplicationToken.update_changeset(application_token, %{})
  end

  alias MotivusMarketplaceApi.Account.PersonalAccessToken

  @doc """
  Returns the list of personal_access_tokens.

  ## Examples

      iex> list_personal_access_tokens()
      [%PersonalAccessToken{}, ...]

  """
  def list_personal_access_tokens do
    Repo.all(PersonalAccessToken)
  end

  def list_personal_access_tokens(user_id),
    do: PersonalAccessToken |> where(user_id: ^user_id) |> Repo.all()

  @doc """
  Gets a single personal_access_token.

  Raises `Ecto.NoResultsError` if the Personal access token does not exist.

  ## Examples

      iex> get_personal_access_token!(123)
      %PersonalAccessToken{}

      iex> get_personal_access_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_personal_access_token!(id), do: Repo.get!(PersonalAccessToken, id)

  def get_personal_access_token!(user_id, id),
    do: PersonalAccessToken |> where(user_id: ^user_id, id: ^id) |> Repo.one!()

  def get_personal_access_token_from_value!(value),
    do: PersonalAccessToken |> where(value: ^value) |> Repo.one!()

  @doc """
  Creates a personal_access_token.

  ## Examples

      iex> create_personal_access_token(%{field: value})
      {:ok, %PersonalAccessToken{}}

      iex> create_personal_access_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_personal_access_token(attrs \\ %{}) do
    %PersonalAccessToken{}
    |> PersonalAccessToken.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a personal_access_token.

  ## Examples

      iex> update_personal_access_token(personal_access_token, %{field: new_value})
      {:ok, %PersonalAccessToken{}}

      iex> update_personal_access_token(personal_access_token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_personal_access_token(%PersonalAccessToken{} = personal_access_token, attrs) do
    personal_access_token
    |> PersonalAccessToken.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a personal_access_token.

  ## Examples

      iex> delete_personal_access_token(personal_access_token)
      {:ok, %PersonalAccessToken{}}

      iex> delete_personal_access_token(personal_access_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_personal_access_token(%PersonalAccessToken{} = personal_access_token) do
    Repo.delete(personal_access_token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking personal_access_token changes.

  ## Examples

      iex> change_personal_access_token(personal_access_token)
      %Ecto.Changeset{data: %PersonalAccessToken{}}

  """
  def change_personal_access_token(%PersonalAccessToken{} = personal_access_token, attrs \\ %{}) do
    PersonalAccessToken.update_changeset(personal_access_token, attrs)
  end
end
