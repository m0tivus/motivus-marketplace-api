defmodule MotivusWbMarketplaceApi.Account.ApplicationToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "application_tokens" do
    field :valid, :boolean, default: false
    field :value, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(application_token, attrs) do
    application_token
    |> cast(attrs, [:value, :valid])
    |> validate_required([:value, :valid])
  end
end
