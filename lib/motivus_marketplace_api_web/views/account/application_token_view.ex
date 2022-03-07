defmodule MotivusMarketplaceApiWeb.Account.ApplicationTokenView do
  use MotivusMarketplaceApiWeb, :view
  alias MotivusMarketplaceApiWeb.Account.ApplicationTokenView

  def render("index.json", %{application_tokens: application_tokens}) do
    %{data: render_many(application_tokens, ApplicationTokenView, "application_token.json")}
  end

  def render("show.json", %{application_token: application_token}) do
    %{data: render_one(application_token, ApplicationTokenView, "application_token.json")}
  end

  def render("application_token.json", %{application_token: application_token}) do
    %{
      id: application_token.id,
      value: application_token.value,
      valid: application_token.valid,
      description: application_token.description,
      inserted_at: application_token.inserted_at
    }
  end
end
