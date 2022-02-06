defmodule MotivusMarketplaceApi.Account.ApplicationToken do
  use Ecto.Schema
  import Ecto.Changeset
  alias MotivusMarketplaceApi.Account.User

  schema "application_tokens" do
    field :valid, :boolean, default: true
    field :value, :string
    field :description, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(application_token, attrs) do
    application_token
    |> cast(attrs, [:value, :valid, :user_id, :description])
    |> validate_required([:valid, :user_id, :description])
    |> unique_value()
  end

  @doc false
  def update_changeset(application_token, attrs) do
    application_token
    |> cast(attrs, [:description, :valid])
    |> validate_required([:description, :valid])
  end

  defp unique_value(chset), do: fetch_field(chset, :user_id) |> generate_value(chset)

  defp generate_value({:changes, user_id}, chset),
    do:
      put_change(
        chset,
        :value,
        "MWBat#{Ecto.UUID.autogenerate() |> Plug.Crypto.KeyGenerator.generate("#{user_id}", iterations: 65536) |> Base.url_encode64()}"
      )

  defp generate_value(_, chset), do: chset
end
