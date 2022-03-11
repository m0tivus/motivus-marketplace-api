# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

# database_url =
#   System.get_env("DATABASE_URL") ||
#     raise """
#     environment variable DATABASE_URL is missing.
#     For example: ecto://USER:PASS@HOST/DATABASE
#     """

config :motivus_marketplace_api, MotivusMarketplaceApi.Repo,
  # ssl: true,
  # url: database_url,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  database: System.get_env("DB_NAME"),
  hostname: System.get_env("DB_HOST"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  port: 5432,
  queue_target: 30000,
  queue_interval: 30000

secret_key_base =
  System.get_env(
    "SECRET_KEY_BASE",
    "73o77n1g16Z8FvEBL4O+ZWd5nLkpWp1fqk9iABFasuundiTIil+tIpLwz1GCNqUo"
  )

config :motivus_marketplace_api, MotivusMarketplaceApiWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :motivus_marketplace_api, MotivusMarketplaceApiWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.

config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION"),
  bucket: System.get_env("AWS_S3_BUCKET_NAME")

config :ex_aws, :s3,
  scheme: "https://",
  host: System.get_env("AWS_S3_HOST"),
  region: System.get_env("AWS_REGION")
