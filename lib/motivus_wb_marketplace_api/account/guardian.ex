defmodule MotivusWbMarketplaceApi.Account.Guardian do
  use Guardian,
    otp_app: :motivus_wb_marketplace_api,
    token_module: MotivusWbMarketplaceApi.Account.JwtOrMwbt

  alias MotivusWbMarketplaceApi.Account

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = Account.get_user!(id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end
end
