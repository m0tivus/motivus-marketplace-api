defmodule MotivusWbMarketplaceApi.PackageRegistry.Version do
  use Ecto.Schema
  import Ecto.Changeset

  schema "versions" do
    field :data_url, :string
    field :hash, :string
    field :loader_url, :string
    field :metadata, :map
    field :name, :string
    field :wasm_url, :string
    field :algorithm_id, :id

    timestamps()
  end

  @doc false
  def changeset(version, attrs) do
    version
    |> cast(attrs, [:name, :metadata, :hash, :wasm_url, :loader_url, :data_url, :algorithm_id])
    |> validate_required([
      :name,
      :metadata,
      :hash,
      :wasm_url,
      :loader_url,
      :data_url,
      :algorithm_id
    ])
  end
end
