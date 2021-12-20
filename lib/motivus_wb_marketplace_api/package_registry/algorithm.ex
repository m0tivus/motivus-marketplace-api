defmodule MotivusWbMarketplaceApi.PackageRegistry.Algorithm do
  use Ecto.Schema
  import Ecto.Changeset
  alias MotivusWbMarketplaceApi.PackageRegistry.Version

  @charge_schemas ~w(PER_EXECUTION PER_MINUTE)

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
    |> validate_inclusion(:default_charge_schema, @charge_schemas)
    |> unique_constraint(:name)
    |> validate_required([:name, :is_public, :default_cost, :default_charge_schema])
  end

  @doc false
  def update_changeset(algorithm, attrs) do
    algorithm
    |> cast(attrs, [:is_public, :default_cost, :default_charge_schema])
    |> validate_inclusion(:default_charge_schema, @charge_schemas)
    |> validate_required([:is_public, :default_cost, :default_charge_schema])
  end
end
