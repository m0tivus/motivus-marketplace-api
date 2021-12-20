defmodule MotivusWbMarketplaceApi.Repo.Migrations.CreateAlgorithms do
  use Ecto.Migration

  def change do
    create table(:algorithms) do
      add :name, :string
      add :is_public, :boolean, default: false, null: false
      add :default_cost, :float
      add :default_charge_schema, :string

      timestamps()
    end

    create unique_index(:algorithms, [:name])
  end
end
