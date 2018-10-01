# liulo
> My Elixir Phoenix Project

![https://travis-ci.org/dwarvesf/liulo-backend/builds/435549922#

## Setup your project before run
Update content in `config/dev.exs` and `config/test.exs`

```Elixir
# Configure your database
config :liulo, liulo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  database: "liulo_(dev|test)",
  pool_size: 10
```

## How to run your project
```
make run
```

## How to test your project
```
make test
```

## How to run mix tasks
```
docker-compose run --rm web mix ...
```
## License

MIT &copy; [Dwarves Team](github.com/dwarvesf)
