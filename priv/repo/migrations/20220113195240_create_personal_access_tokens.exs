defmodule MotivusMarketplaceApi.Repo.Migrations.CreatePersonalAccessTokens do
  use Ecto.Migration

  def change do
    create table(:personal_access_tokens) do
      add :value, :string
      add :valid, :boolean, default: false, null: false
      add :description, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:personal_access_tokens, [:user_id])
  end
end
