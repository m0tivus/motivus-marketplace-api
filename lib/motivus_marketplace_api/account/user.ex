defmodule MotivusMarketplaceApi.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :avatar_url, :string
    field :email, :string
    field :provider, :string
    field :username, :string
    field :name, :string
    field :uuid, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :avatar_url, :provider, :uuid, :name])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> validate_required([:email, :avatar_url, :provider, :uuid])
  end

  @doc false
  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :avatar_url, :name])
    |> unique_constraint(:username)
    |> validate_required([:avatar_url])
  end
end
