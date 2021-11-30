defmodule MotivusWbMarketplaceApi.PackageRegistry.AlgorithmUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "algorithm_users" do
    field :charge_schema, :string
    field :cost, :float
    field :role, :string
    field :algorithm_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(algorithm_user, attrs) do
    algorithm_user
    |> cast(attrs, [:role, :cost, :charge_schema])
    |> validate_required([:role, :cost, :charge_schema])
  end
end
