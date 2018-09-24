DC=docker-compose
DCR=$(DC) run --rm

.PHONY: setup compile test run rund swagger

compile:
	$(DCR) web mix do deps.get, ecto.setup

remove:
	$(DC) rm -f web

build:
	$(DC) build

run: remove build compile
	$(DC) up web

rund: compile remove
	$(DC) up -d

credo:
	$(DCR) web mix credo --strict

test:
	$(DCR) test
