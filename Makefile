#
#  Makefile
#

export SHELL ?= /bin/bash
export DOCKER_CLI_EXPERIMENTAL = enabled

# Project owner used in package name
OWNER = gesquive

# Project name used in package name
PROJECT_NAME = master-builder

# Project url used for builds
# examples: index.docker.io, registry.gitlab.com
REGISTRY_URL = docker.io

IMAGE := ${REGISTRY_URL}/${OWNER}/${PROJECT_NAME}
DK_VERSION = $(shell git describe --always --tags | sed 's/^v//' | sed 's/-g/-/')

DOCKER ?= docker

default: build

.PHONY: help
help:
	@echo 'Management commands for $(PROJECT_NAME):'
	@grep -Eh '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
	 awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build the image
	@echo "building ${IMAGE_TAG}"
	${DOCKER} info
	${DOCKER} build  --pull -t ${IMAGE} .

.PHONY: release
release: ## Tag and release the image
	@echo "building '${DK_VERSION}' docker image"
	${DOCKER} build --pull -t ${IMAGE}:${DK_VERSION} .
	${DOCKER} push ${IMAGE}:${DK_VERSION}

	@echo "tag with latest"
	${DOCKER} tag ${IMAGE}:${DK_VERSION} ${IMAGE}:latest
	${DOCKER} push ${IMAGE}:latest

release-docker-%:
	@echo "building '${DK_TAG}' docker image"
	${DOCKER} build --pull -t ${IMAGE}:${DK_TAG} .
	${DOCKER} push ${IMAGE}:${DK_TAG}

release-docker-amd64: DK_TAG=${DK_VERSION}-amd64
release-docker-arm32v6: DK_TAG=${DK_VERSION}-arm32v6
release-docker-arm32v7: DK_TAG=${DK_VERSION}-arm32v7
release-docker-arm64v8: DK_TAG=${DK_VERSION}-arm64v8

.PHONY: release-manifest
release-manifest:  ## build and push all of docker images
	@echo "building docker manifest"
	${DOCKER} manifest create ${IMAGE}:${DK_VERSION} ${IMAGE}:${DK_VERSION}-amd64 ${IMAGE}:${DK_VERSION}-arm32v6 ${IMAGE}:${DK_VERSION}-arm32v7 ${IMAGE}:${DK_VERSION}-arm64v8
	${DOCKER} manifest annotate ${IMAGE}:${DK_VERSION} ${IMAGE}:${DK_VERSION}-arm32v6 --os linux --arch arm --variant v6
	${DOCKER} manifest annotate ${IMAGE}:${DK_VERSION} ${IMAGE}:${DK_VERSION}-arm32v7 --os linux --arch arm --variant v7
	${DOCKER} manifest annotate ${IMAGE}:${DK_VERSION} ${IMAGE}:${DK_VERSION}-arm64v8 --os linux --arch arm64 --variant v8
	${DOCKER} manifest push ${IMAGE}:${DK_VERSION}

	${DOCKER} manifest create ${IMAGE}:latest ${IMAGE}:${DK_VERSION}-amd64 ${IMAGE}:${DK_VERSION}-arm32v6 ${IMAGE}:${DK_VERSION}-arm32v7 ${IMAGE}:${DK_VERSION}-arm64v8
	${DOCKER} manifest annotate ${IMAGE}:${DK_VERSION} ${IMAGE}:${DK_VERSION}-arm32v6 --os linux --arch arm --variant v6
	${DOCKER} manifest annotate ${IMAGE}:${DK_VERSION} ${IMAGE}:${DK_VERSION}-arm32v7 --os linux --arch arm --variant v7
	${DOCKER} manifest annotate ${IMAGE}:${DK_VERSION} ${IMAGE}:${DK_VERSION}-arm64v8 --os linux --arch arm64 --variant v8
	${DOCKER} manifest push ${IMAGE}:latest
