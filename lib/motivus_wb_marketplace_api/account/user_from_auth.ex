defmodule MotivusWbMarketplaceApi.Account.UserFromAuth do
  @moduledoc """
  Retrieve the user information from an auth request
  """
  require Logger

  alias Ueberauth.Auth
  alias MotivusWbMarketplaceApi.Account

  def find_or_create(%Auth{provider: :identity} = auth) do
    case validate_pass(auth.credentials) do
      :ok ->
        {:ok, basic_info(auth)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def find_or_create(%Auth{} = auth) do
    user_info = basic_info(auth)

    case Account.get_user_by_email(user_info.email) do
      nil ->
        user_info
        |> Map.put(:mail, Map.get(user_info, :email))
        |> Map.put(:uuid, Ecto.UUID.bingenerate())
        |> Map.put(:last_sign_in, DateTime.utc_now())
        |> Account.create_user()
        |> IO.inspect()

      user ->
        {:ok, user}
    end
  end

  # github does it this way
  defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}}), do: image

  # facebook does it this way
  defp avatar_from_auth(%{info: %{image: image}}), do: image

  # default case if nothing matches
  defp avatar_from_auth(auth) do
    Logger.warn("#{auth.provider} needs to find an avatar URL!")
    # Logger.debug(Poison.encode!(auth))
    nil
  end

  defp basic_info(auth) do
    %{
      id: auth.uid,
      name: name_from_auth(auth),
      username: username_from_auth(auth),
      avatar_url: avatar_from_auth(auth),
      email: auth.info.email,
      provider: Atom.to_string(auth.provider),
      request_arn: false,
      validate_arn: false
    }
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name =
        [auth.info.first_name, auth.info.last_name]
        |> Enum.filter(&(&1 != nil and &1 != ""))

      if Enum.empty?(name) do
        auth.info.nickname
      else
        Enum.join(name, " ")
      end
    end
  end

  defp username_from_auth(auth), do: auth.info.nickname

  defp validate_pass(%{other: %{password: ""}}) do
    {:error, "Password required"}
  end

  defp validate_pass(%{other: %{password: pw, password_confirmation: pw}}) do
    :ok
  end

  defp validate_pass(%{other: %{password: _}}) do
    {:error, "Passwords do not match"}
  end

  defp validate_pass(_), do: {:error, "Password Required"}
end
