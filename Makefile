DC=docker-compose
DCR=$(DC) run --rm
IMAGE?=hub.dwarvesf.com/liulo/backend

.PHONY: setup compile test run rund swagger

get:
	$(DCR) web mix do deps.get

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

test: get compile
	$(DCR) test


build-prod:
	MIX_ENV=prod PORT=80 docker build -f Dockerfile.prod -t $(IMAGE) .

ship-prod: build-prod
	@echo $(DOCKER_PASSWORD) | docker login -u $(DOCKER_USERNAME) --password-stdin hub.dwarvesf.com
	docker push $(IMAGE)

deploy:
	@sed -i 's/{{UPDATED_TS}}/'$(shell date | sed 's/ /-/g' | sed 's/:/-/g')'/g' k8s/deployment.yaml
	@kubectl apply -f k8s/deployment.yaml