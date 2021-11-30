defmodule MotivusWbMarketplaceApi.PackageRegistry.Algorithm do
  use Ecto.Schema
  import Ecto.Changeset

  schema "algorithms" do
    field :default_charge_schema, :string
    field :default_cost, :float
    field :is_public, :boolean, default: false
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(algorithm, attrs) do
    algorithm
    |> cast(attrs, [:name, :is_public, :default_cost, :default_charge_schema])
    |> validate_required([:name, :is_public, :default_cost, :default_charge_schema])
  end
end
