defmodule MotivusWbMarketplaceApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: MotivusWbMargetplaceApi.PubSub},
      # Start the Ecto repository
      MotivusWbMarketplaceApi.Repo,
      # Start the endpoint when the application starts
      MotivusWbMarketplaceApiWeb.Endpoint
      # Starts a worker by calling: MotivusWbMarketplaceApi.Worker.start_link(arg)
      # {MotivusWbMarketplaceApi.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MotivusWbMarketplaceApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MotivusWbMarketplaceApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
