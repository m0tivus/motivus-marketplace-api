import Config

# Configure your database
config :motivus_marketplace_api, MotivusMarketplaceApi.Repo,
  username: "postgres",
  password: "postgres",
  database: "motivus_marketplace_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :motivus_marketplace_api, MotivusMarketplaceApiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :ex_aws,
  access_key_id: "AKIAXTPV4Y3S7GNVOAOY",
  secret_access_key: "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",
  region: "us-east-1",
  bucket: "wb-marketplace-test"

config :ex_aws, :s3,
  scheme: "https://",
  host: "wb-marketplace-test.s3.amazonaws.com",
  region: "us-east-1"
