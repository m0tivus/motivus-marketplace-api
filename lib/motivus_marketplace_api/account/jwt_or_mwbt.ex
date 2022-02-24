defmodule MotivusMarketplaceApi.Account.JwtOrMwbt do
  alias Guardian.Token.Jwt
  alias MotivusMarketplaceApi.Account

  @behaviour Guardian.Token
  def peek(_mod, "MWBat" <> _token) do
    %{}
  end

  def get_token_type(%{private: %{guardian_default_claims: %{"typ" => "mwbat"}}}),
    do: :application_token

  def get_token_type(%{private: %{guardian_default_claims: %{"typ" => "mwbpat"}}}),
    do: :personal_access_token

  def get_token_type(%{private: %{guardian_default_claims: %{"typ" => "access"}}}),
    do: :access_token

  def get_token_type(_), do: :other

  def create_token(mod, claims, options \\ [])

  def create_token(mod, %{"typ" => "mwbat", "description" => description} = claims, _options) do
    {:ok, user} = Guardian.returning_tuple({mod, :resource_from_claims, [claims]})

    {:ok, application_token} =
      Account.create_application_token(%{"description" => description, "user_id" => user.id})

    {:ok, application_token.value}
  end

  def create_token(mod, %{"typ" => "mwbpat", "description" => description} = claims, _options) do
    {:ok, user} = Guardian.returning_tuple({mod, :resource_from_claims, [claims]})

    {:ok, personal_access_token} =
      Account.create_personal_access_token(%{"description" => description, "user_id" => user.id})

    {:ok, personal_access_token.value}
  end

  def create_token(mod, claims, options), do: Jwt.create_token(mod, claims, options)

  def decode_token(mod, token, options \\ [])

  def decode_token(_mod, "MWBat" <> _token_part = token, _options) do
    %{user_id: user_id, description: description} =
      Account.get_application_token_from_value!(token)

    {:ok, %{"sub" => user_id, "typ" => "mwbat", "description" => description}}
  end

  def decode_token(_mod, "MWBpat" <> _token_part = token, _options) do
    %{user_id: user_id, description: description} =
      Account.get_personal_access_token_from_value!(token)

    {:ok, %{"sub" => user_id, "typ" => "mwbpat", "description" => description}}
  end

  def decode_token(mod, token, options), do: Jwt.decode_token(mod, token, options)

  def verify_claims(_mod, "MWBat" <> _claims = _token, _options), do: %{}

  def verify_claims(mod, claims, options), do: Jwt.verify_claims(mod, claims, options)

  def revoke(_mod, claims, "MWBat" <> _token, _options), do: {:ok, claims}
  def revoke(mod, claims, token, options), do: Jwt.revoke(mod, claims, token, options)

  def refresh(_mod, "MWBat" <> _token = old_token, _options),
    do: {:ok, {old_token, %{}}, {old_token, %{}}}

  def refresh(mod, old_token, options), do: Jwt.refresh(mod, old_token, options)

  def exchange(mod, old_token, from_type, to_type, options),
    do: Jwt.exchange(mod, old_token, from_type, to_type, options)

  def token_id, do: Jwt.token_id()

  def build_claims(mod, resource, sub, claims \\ %{}, options \\ []),
    do: Jwt.build_claims(mod, resource, sub, claims, options)
end
