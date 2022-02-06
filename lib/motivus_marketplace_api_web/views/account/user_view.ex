defmodule MotivusMarketplaceApiWeb.Account.UserView do
  use MotivusMarketplaceApiWeb, :view
  alias MotivusMarketplaceApiWeb.Account.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      name: user.name,
      username: user.username,
      avatar_url: user.avatar_url,
      provider: user.provider,
      uuid: user.uuid
    }
  end
end
