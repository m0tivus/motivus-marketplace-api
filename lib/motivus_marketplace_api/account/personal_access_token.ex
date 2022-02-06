defmodule MotivusMarketplaceApi.Account.PersonalAccessToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "personal_access_tokens" do
    field :description, :string
    field :valid, :boolean, default: false
    field :value, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(personal_access_token, attrs) do
    personal_access_token
    |> cast(attrs, [:valid, :description, :user_id])
    |> validate_required([:valid, :description, :user_id])
    |> unique_value()
  end

  @doc false
  def update_changeset(personal_access_token, attrs) do
    personal_access_token
    |> cast(attrs, [:description, :valid])
    |> validate_required([:description, :valid])
  end

  defp unique_value(chset), do: fetch_field(chset, :user_id) |> generate_value(chset)

  defp generate_value({:changes, user_id}, chset),
    do:
      put_change(
        chset,
        :value,
        "MWBpat#{Ecto.UUID.autogenerate() |> Plug.Crypto.KeyGenerator.generate("#{user_id}", iterations: 65536) |> Base.url_encode64()}"
      )

  defp generate_value(_, chset), do: chset
end
