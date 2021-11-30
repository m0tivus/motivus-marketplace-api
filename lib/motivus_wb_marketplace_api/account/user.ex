defmodule MotivusWbMarketplaceApi.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :avatar_url, :string
    field :email, :string
    field :provider, :string
    field :username, :string
    field :uuid, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :avatar_url, :provider, :uuid])
    |> validate_required([:email, :username, :avatar_url, :provider, :uuid])
  end
end
