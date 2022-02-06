defmodule MotivusMarketplaceApi.PackageRegistry.AlgorithmUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias MotivusMarketplaceApi.Account.User
  alias MotivusMarketplaceApi.PackageRegistry.Algorithm

  @roles ~w(USER MAINTAINER OWNER)
  @charge_schemas ~w(PER_EXECUTION PER_MINUTE)

  schema "algorithm_users" do
    field :charge_schema, :string
    field :cost, :float
    field :role, :string

    belongs_to :user, User
    belongs_to :algorithm, Algorithm

    timestamps()
  end

  @doc false
  def create_changeset(algorithm_user, attrs) do
    algorithm_user
    |> cast(attrs, [:role, :cost, :charge_schema, :algorithm_id, :user_id])
    |> validate_required([:role, :algorithm_id, :user_id])
    |> validate_inclusion(:role, @roles)
    |> validate_role()
    |> unique_constraint(:user_id, name: :algorithm_users_algorithm_id_user_id_index)
  end

  @doc false
  def update_changeset(algorithm_user, attrs) do
    algorithm_user
    |> cast(attrs, [:role, :cost, :charge_schema])
    |> validate_required([:role])
    |> validate_inclusion(:role, @roles)
    |> validate_inclusion(:charge_schema, @charge_schemas)
  end

  @doc false
  def algorithm_owner_changeset(algorithm_user, attrs) do
    algorithm_user
    |> cast(attrs, [:algorithm_id, :user_id])
    |> validate_required([:algorithm_id, :user_id])
    |> put_change(:role, "OWNER")
  end

  defp validate_role(chset) do
    with %{changes: %{role: "USER"}} <- chset do
      chset
      |> validate_required([:cost, :charge_schema])
      |> validate_inclusion(:charge_schema, @charge_schemas)
    else
      _ -> chset
    end
  end
end
