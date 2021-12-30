# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :motivus_wb_marketplace_api,
  ecto_repos: [MotivusWbMarketplaceApi.Repo]

# Configures the endpoint
config :motivus_wb_marketplace_api, MotivusWbMarketplaceApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uyvlxmmK0GTQHcRCDIIZWmFQwrL/81CszsKdmS2M6MV5fxVMXfz+aqhp57j64fGE",
  render_errors: [view: MotivusWbMarketplaceApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: MotivusWbMarketplaceApi.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "sRmhueH+"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ex_aws,
  access_key_id: "AKIAXTPV4Y3S7GNVOAOY",
  secret_access_key: "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",
  region: "us-east-1",
  bucket: "wb-marketplace-test"

config :ex_aws, :s3,
  scheme: "https://",
  host: "wb-marketplace-test.s3.amazonaws.com",
  region: "us-east-1"

config :motivus_wb_marketplace_api, MotivusWbMarketplaceApi.Account.Guardian,
  issuer: "motivus_wb_marketplace_api",
  secret_key: "ivmFeKzF+WdQVIv5aRHcACepNFPuS/oty3vF4ddW1Lgmpiq2okNMEAz4b2hzeMQ8"

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [send_redirect_uri: false, default_scope: "user"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: {:system, "GITHUB_CLIENT_ID"},
  client_secret: {:system, "GITHUB_CLIENT_SECRET"}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
