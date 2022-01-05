defmodule MotivusWbMarketplaceApi.PackageRegistry.Algorithm do
  use Ecto.Schema
  import Ecto.Changeset
  alias MotivusWbMarketplaceApi.PackageRegistry.Version
  alias MotivusWbMarketplaceApi.PackageRegistry.User
  alias MotivusWbMarketplaceApi.PackageRegistry.AlgorithmUser

  @charge_schemas ~w(PER_EXECUTION PER_MINUTE)
  @create_attrs ~w(name is_public default_cost default_charge_schema)a
  @update_attrs ~w(is_public default_cost default_charge_schema)a

  schema "algorithms" do
    field :default_charge_schema, :string
    field :default_cost, :float
    field :is_public, :boolean, default: false
    field :name, :string

    has_many :versions, Version
    has_many :algorithm_users, AlgorithmUser
    has_many :users, through: [:algorithm_users, :user]

    timestamps()
  end

  @doc false
  def create_changeset(algorithm, attrs) do
    algorithm
    |> cast(attrs, @create_attrs)
    |> validate_inclusion(:default_charge_schema, @charge_schemas)
    |> validate_required(@create_attrs)
    |> unique_constraint(:name)
  end

  @doc false
  def update_changeset(algorithm, attrs) do
    algorithm
    |> cast(attrs, @update_attrs)
    |> validate_inclusion(:default_charge_schema, @charge_schemas)
    |> validate_required(@update_attrs)
  end
end
