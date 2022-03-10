defmodule MotivusMarketplaceApi.PackageRegistry.Version do
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
  def create_changeset(version, attrs) do
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
    |> unique_constraint(:name, name: :versions_name_algorithm_id_index)
    |> validate_package_name(attrs)
    |> validate_package(attrs)
    |> validate_required([
      :metadata,
      :wasm_url,
      :loader_url,
      :algorithm_id
    ])
    |> changeset_metadata()
  end

  def update_changeset(version, attrs) do
    version
    |> cast(attrs, [
      :hash,
      :wasm_url,
      :loader_url,
      :data_url
    ])
    |> validate_required([
      :wasm_url,
      :loader_url
    ])
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

  def validate_package(chset, %{
        "algorithm" => algorithm,
        "package" => package = %Plug.Upload{}
      }) do
    file_extensions = ~w(.js .wasm .data.zip)

    unique_filename = UUID.uuid4(:hex)
    directory = '/tmp/#{unique_filename}'

    version_name = get_field(chset, :name) |> to_string

    file_whitelist =
      1..3
      |> Enum.map(fn _ -> algorithm.name <> "-" <> version_name end)
      |> Enum.zip(file_extensions)
      |> Enum.map(fn {file_name, extension} -> file_name <> extension end)
      |> Enum.map(&String.to_charlist/1)

    path = Path.absname(package.path) |> to_charlist

    with {:ok, file_list} <- :zip.unzip(path, cwd: directory, file_list: file_whitelist) do
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
      _ ->
        chset |> add_error(:package, "incorrect package contents")
    end
  end

  def validate_package(chset, %{
        "algorithm" => _algorithm
      }),
      do: chset |> add_error(:package, "can't be blank")

  def validate_package(chset, %{
        "package" => _package = %Plug.Upload{}
      }),
      do: chset |> add_error(:algorithm, "missing preload")

  def validate_package(chset, _),
    do: chset |> add_error(:algorithm, "missing preload") |> add_error(:package, "can't be blank")

  def validate_package_name(chset, %{
        "algorithm" => algorithm,
        "package" => package = %Plug.Upload{}
      }) do
    version_name = get_field(chset, :name) |> to_string
    package_name = package.filename

    case "#{algorithm.name}-#{version_name}.zip" do
      ^package_name -> chset
      n -> chset |> add_error(:package, "wrong package file name", hint: n)
    end
  end

  def validate_package_name(chset, _attrs), do: chset |> add_error(:package, "can't be blank")
end
