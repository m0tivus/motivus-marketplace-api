defmodule MotivusMarketplaceApi.Repo.Migrations.CreateApplicationTokens do
  use Ecto.Migration

  def change do
    create table(:application_tokens) do
      add :value, :string
      add :valid, :boolean, default: true, null: true
      add :description, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:application_tokens, [:user_id])
  end
end
