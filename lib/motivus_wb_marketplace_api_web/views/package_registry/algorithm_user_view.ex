defmodule MotivusWbMarketplaceApiWeb.PackageRegistry.AlgorithmUserView do
  use MotivusWbMarketplaceApiWeb, :view
  alias MotivusWbMarketplaceApiWeb.PackageRegistry.AlgorithmUserView

  def render("index.json", %{algorithm_users: algorithm_users}) do
    %{data: render_many(algorithm_users, AlgorithmUserView, "algorithm_user.json")}
  end

  def render("show.json", %{algorithm_user: algorithm_user}) do
    %{data: render_one(algorithm_user, AlgorithmUserView, "algorithm_user.json")}
  end

  def render("algorithm_user.json", %{algorithm_user: algorithm_user}) do
    %{id: algorithm_user.id,
      role: algorithm_user.role,
      cost: algorithm_user.cost,
      charge_schema: algorithm_user.charge_schema}
  end
end
