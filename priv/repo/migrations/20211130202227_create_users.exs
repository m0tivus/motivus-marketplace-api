defmodule MotivusWbMarketplaceApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :username, :string
      add :avatar_url, :string
      add :provider, :string
      add :uuid, :uuid

      timestamps()
    end

  end
end
