defmodule MotivusMarketplaceApiWeb.HealthCheckController do
  use MotivusMarketplaceApiWeb, :controller

  def health_check(conn, _) do
    text(conn, "OK")
  end
end
