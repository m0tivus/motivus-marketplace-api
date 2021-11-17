use Mix.Config

# Configure your database
config :motivus_wb_marketplace_api, MotivusWbMarketplaceApi.Repo,
  username: "postgres",
  password: "postgres",
  database: "motivus_wb_marketplace_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :motivus_wb_marketplace_api, MotivusWbMarketplaceApiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
