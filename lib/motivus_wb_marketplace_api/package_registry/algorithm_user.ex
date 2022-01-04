defmodule MotivusWbMarketplaceApi.PackageRegistry.AlgorithmUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias MotivusWbMarketplaceApi.Account.User
  alias MotivusWbMarketplaceApi.PackageRegistry.Algorithm

  schema "algorithm_users" do
    field :charge_schema, :string
    field :cost, :float
    field :role, :string

    belongs_to :user, User
    belongs_to :algorithm, Algorithm

    timestamps()
  end

  @doc false
  def changeset(algorithm_user, attrs) do
    algorithm_user
    |> cast(attrs, [:role, :cost, :charge_schema, :algorithm_id, :user_id])
    |> validate_required([:role, :cost, :charge_schema, :algorithm_id, :user_id])
    |> unique_constraint(:user_id, name: :algorithm_users_algorithm_id_user_id_index)
  end

  @doc false
  def algorithm_owner_changeset(algorithm_user, attrs) do
    algorithm_user
    |> cast(attrs, [:algorithm_id, :user_id])
    |> validate_required([:algorithm_id, :user_id])
    |> put_change(:role, "OWNER")
  end
end
