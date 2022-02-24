defmodule MotivusMarketplaceApiWeb.PackageRegistry.AlgorithmUserView do
  use MotivusMarketplaceApiWeb, :view
  alias MotivusMarketplaceApiWeb.PackageRegistry.AlgorithmUserView
  alias MotivusMarketplaceApiWeb.Account.UserView

  def render("index.json", %{algorithm_users: algorithm_users}) do
    %{data: render_many(algorithm_users, AlgorithmUserView, "algorithm_user.json")}
  end

  def render("show.json", %{algorithm_user: algorithm_user}) do
    %{data: render_one(algorithm_user, AlgorithmUserView, "algorithm_user.json")}
  end

  def render("algorithm_user.json", %{algorithm_user: algorithm_user}) do
    %{
      id: algorithm_user.id,
      role: algorithm_user.role,
      cost: algorithm_user.cost,
      charge_schema: algorithm_user.charge_schema,
      user_id: algorithm_user.user_id,
      algorithm_id: algorithm_user.algorithm_id,
      # TODO: safer user view
      user: algorithm_user.user |> render_one(UserView, "user.json")
    }
  end
end
