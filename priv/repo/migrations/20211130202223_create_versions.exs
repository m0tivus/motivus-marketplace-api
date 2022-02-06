defmodule MotivusMarketplaceApi.Repo.Migrations.CreateVersions do
  use Ecto.Migration

  def change do
    create table(:versions) do
      add :name, :string
      add :metadata, :map
      add :hash, :string
      add :wasm_url, :string
      add :loader_url, :string
      add :data_url, :string
      add :algorithm_id, references(:algorithms, on_delete: :nothing)

      timestamps()
    end

    create index(:versions, [:algorithm_id])
    create unique_index(:versions, [:name, :algorithm_id])
  end
end
