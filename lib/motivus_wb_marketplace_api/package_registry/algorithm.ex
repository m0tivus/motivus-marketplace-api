defmodule MotivusWbMarketplaceApi.PackageRegistry.Algorithm do
  use Ecto.Schema
  import Ecto.Changeset
  alias MotivusWbMarketplaceApi.PackageRegistry.Version

  schema "algorithms" do
    field :default_charge_schema, :string
    field :default_cost, :float
    field :is_public, :boolean, default: false
    field :name, :string

    has_many :versions, Version

    timestamps()
  end

  @doc false
  def create_changeset(algorithm, attrs) do
    algorithm
    |> cast(attrs, [:name, :is_public, :default_cost, :default_charge_schema])
    |> validate_required([:name, :is_public, :default_cost, :default_charge_schema])
  end

  @doc false
  def update_changeset(algorithm, attrs) do
    algorithm
    |> cast(attrs, [:is_public, :default_cost, :default_charge_schema])
    |> validate_required([:is_public, :default_cost, :default_charge_schema])
  end
end
