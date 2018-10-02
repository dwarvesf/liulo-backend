# liulo
> My Elixir Phoenix Project

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

## About this app
- Our app description https://github.com/dwarvesf/liulo
- Our database diagram [here](document/Database.md "Liulo Database Diagram")

## How to contribute to our project
1. Please follow git-flow guideline https://github.com/dwarvesf/team/blob/master/gitlab.md
2. Assign your self in unassign issues

## License

MIT &copy; [Dwarves Team](github.com/dwarvesf)
