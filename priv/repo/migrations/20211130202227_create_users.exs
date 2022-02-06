defmodule MotivusMarketplaceApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :name, :string
      add :username, :string
      add :avatar_url, :string
      add :provider, :string
      add :uuid, :uuid

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:username])
  end
end
