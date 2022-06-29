SHELL := /bin/bash # to enable source command in run_app

MODULE=weevenetwork/boilerplate

lint:
	black src/
	flake8 src/
.phony: lint

run_app:
	set -a && source .env && set +a && python src/main.py
.phony: run_app

create_image:
	docker build -t ${MODULE} . -f docker/Dockerfile
.phony: create_image

run_image:
	docker run -p 80:80 --rm --env-file=./.env ${MODULE}:latest
.phony: run_image

run_docker_compose:
	docker-compose -f docker/docker-compose.yml up
.phony: run_docker_compose

stop_docker_compose:
	docker-compose -f docker/docker-compose.yml down
.phony: stop_docker_compose

push_latest:
	docker image push ${MODULE}
.phony: push_latest

create_and_push_multi_platform:
	docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v6,linux/arm/v7 -t ${MODULE} --push . -f docker/Dockerfile
.phony: create_and_push_multi_platform

run_listener:
	docker run --rm -p 8000:8000 \
	-e PORT=8000 \
	-e LOG_HTTP_BODY=true \
	-e LOG_HTTP_HEADERS=true \
	--name listener \
	jmalloc/echo-server
.phony: run_listener
