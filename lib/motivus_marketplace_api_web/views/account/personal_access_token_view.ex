defmodule MotivusMarketplaceApiWeb.Account.PersonalAccessTokenView do
  use MotivusMarketplaceApiWeb, :view
  alias MotivusMarketplaceApiWeb.Account.PersonalAccessTokenView

  def render("index.json", %{personal_access_tokens: personal_access_tokens}) do
    %{
      data:
        render_many(personal_access_tokens, PersonalAccessTokenView, "personal_access_token.json")
    }
  end

  def render("show.json", %{personal_access_token: personal_access_token}) do
    %{
      data:
        render_one(personal_access_token, PersonalAccessTokenView, "personal_access_token.json")
    }
  end

  def render("personal_access_token.json", %{personal_access_token: personal_access_token}) do
    %{
      id: personal_access_token.id,
      value: personal_access_token.value,
      valid: personal_access_token.valid,
      description: personal_access_token.description,
      inserted_at: personal_access_token.inserted_at
    }
  end
end
