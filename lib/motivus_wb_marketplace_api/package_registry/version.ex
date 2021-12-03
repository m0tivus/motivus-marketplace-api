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
    |> cast(attrs, [
      :name,
      :metadata,
      :hash,
      :wasm_url,
      :loader_url,
      :data_url,
      :algorithm_id
    ])
    |> validate_required([
      :name
    ])
    |> check_package(attrs)
    |> validate_required([
      :metadata,
      :wasm_url,
      :loader_url,
      :data_url,
      :algorithm_id
    ])
    |> changeset_metadata()
  end

  def changeset_metadata(chset) do
    types = %{
      long_description: :string,
      short_description: :string,
      license: :string,
      author: :string,
      url: :string,
      upstream_url: :string
    }

    with {:changes, %{} = metadata} <- fetch_field(chset, :metadata) do
      chset
      |> put_change(
        :metadata,
        {%{}, types} |> cast(metadata, Map.keys(types)) |> Map.get(:changes)
      )
    else
      _ -> chset
    end
  end

  def check_package(chset, attrs) do
    file_extensions = ~w(.js .wasm .data.zip)

    unique_filename = UUID.uuid4(:hex)
    directory = '/tmp/#{unique_filename}'

    name = get_field(chset, :name) |> to_string

    file_whitelist =
      1..3
      |> Enum.map(fn _ -> "package" <> "-" <> name end)
      |> Enum.zip(file_extensions)
      |> Enum.map(fn {file_name, extension} -> file_name <> extension end)
      |> Enum.map(&String.to_charlist/1)

    with %Plug.Upload{} = package <- attrs["package"],
         {:ok, file_list} <- :zip.unzip(package.path, cwd: directory, file_list: file_whitelist) do
      file_list
      |> Enum.reduce(chset, fn file_path, chset_ ->
        path_string = file_path |> to_string

        case path_string |> String.split(".") |> List.last() do
          "js" -> put_change(chset_, :loader_url, path_string)
          "wasm" -> put_change(chset_, :wasm_url, path_string)
          "zip" -> put_change(chset_, :data_url, path_string)
        end
      end)
    else
      nil ->
        case chset.action do
          :create -> chset |> add_error(:package, "can't be blank")
          _ -> chset
        end

      _ ->
        chset |> add_error(:package, "incorrect package contents")
    end
  end
end
