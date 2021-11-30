defmodule MotivusWbMarketplaceApi.Repo.Migrations.CreateAlgorithmUsers do
  use Ecto.Migration

  def change do
    create table(:algorithm_users) do
      add :role, :string
      add :cost, :float
      add :charge_schema, :string
      add :algorithm_id, references(:algorithms, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:algorithm_users, [:algorithm_id])
    create index(:algorithm_users, [:user_id])
  end
end
