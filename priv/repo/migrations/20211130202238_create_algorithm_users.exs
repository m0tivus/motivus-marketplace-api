defmodule MotivusMarketplaceApi.Repo.Migrations.CreateAlgorithmUsers do
  use Ecto.Migration

  def change do
    create table(:algorithm_users) do
      add :role, :string
      add :cost, :float
      add :charge_schema, :string
      add :algorithm_id, references(:algorithms, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:algorithm_users, [:algorithm_id])
    create index(:algorithm_users, [:user_id])
    create unique_index(:algorithm_users, [:algorithm_id, :user_id])
  end
end
