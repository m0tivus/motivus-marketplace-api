# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :motivus_marketplace_api,
  ecto_repos: [MotivusMarketplaceApi.Repo]

# Configures the endpoint
config :motivus_marketplace_api, MotivusMarketplaceApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uyvlxmmK0GTQHcRCDIIZWmFQwrL/81CszsKdmS2M6MV5fxVMXfz+aqhp57j64fGE",
  render_errors: [view: MotivusMarketplaceApiWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: MotivusMarketplaceApi.PubSub,
  live_view: [signing_salt: "sRmhueH+"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :motivus_marketplace_api, MotivusMarketplaceApi.Account.Guardian,
  issuer: "motivus_marketplace_api",
  secret_key: "ivmFeKzF+WdQVIv5aRHcACepNFPuS/oty3vF4ddW1Lgmpiq2okNMEAz4b2hzeMQ8"

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [send_redirect_uri: false, default_scope: "user"]},
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: {:system, "GITHUB_CLIENT_ID"},
  client_secret: {:system, "GITHUB_CLIENT_SECRET"}

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: {System, :get_env, ["GOOGLE_CLIENT_ID"]},
  client_secret: {System, :get_env, ["GOOGLE_CLIENT_SECRET"]}

config :cors_plug,
  origin: ["http://localhost:3000", "http://localhost:8000", "http://motivus.clx"],
  max_age: 86400,
  methods: ["GET", "POST", "PUT", "DELETE"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
