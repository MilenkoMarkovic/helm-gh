TAG := $(shell git rev-parse --short HEAD)
 
.PHONY: help
help: ## Display available commands.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
 
# LOCAL ------------------------------------------------------------------------
 
.PHONY: build
build: ## Build service binary
	go build -race -ldflags "-s -w -X main.ver=${TAG}" -o rest main.go
 
.PHONY: run
run: ## Run service
	HTTP_ADDR=:8080 ./rest
 
# DOCKER -----------------------------------------------------------------------
 
.PHONY: docker-push
docker-push: ## Build, tag and push service image to registry then clean up local environment
	docker build --build-arg VER=${TAG} -t you/rest:${TAG} -f infra/docker/Dockerfile .
	docker push you/rest:${TAG}
	docker rmi you/rest:${TAG}
	docker system prune --volumes --force
 
# DEPLOY -----------------------------------------------------------------------
 
.PHONY: helm-deploy
helm-deploy: ## Deploy go applications.
	helm upgrade --install --atomic --timeout 1m rest infra/helm/ -f infra/helm/values.yaml \
		--kube-context minikube --namespace develop --create-namespace \
		--set image.tag=${TAG}

