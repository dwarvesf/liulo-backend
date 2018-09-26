use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :liulo, LiuloWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :liulo, Liulo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  database: "liulo_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10
