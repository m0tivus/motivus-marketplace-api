defmodule MotivusMarketplaceApi.PackageRegistry.Algorithm do
  use Ecto.Schema
  import Ecto.Changeset
  alias MotivusMarketplaceApi.PackageRegistry.Version
  alias MotivusMarketplaceApi.PackageRegistry.AlgorithmUser

  @charge_schemas ~w(PER_EXECUTION PER_MINUTE)
  @create_attrs ~w(name is_public cost charge_schema)a
  @update_attrs ~w(is_public cost charge_schema)a

  schema "algorithms" do
    field :charge_schema, :string
    field :cost, :float
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
    |> validate_inclusion(:charge_schema, @charge_schemas)
    |> validate_required(@create_attrs)
    |> validate_format(:name, ~r/^[a-z0-9]+([-_\S]{1}[a-z0-9]+)*$/i,
      message: "use only lowercase letters, numbers and - _ "
    )
    |> unique_constraint(:name)
  end

  @doc false
  def update_changeset(algorithm, attrs) do
    algorithm
    |> cast(attrs, @update_attrs)
    |> validate_inclusion(:charge_schema, @charge_schemas)
    |> validate_required(@update_attrs)
  end
end
