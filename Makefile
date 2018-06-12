.PHONY: help deploy build webserver

.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

deploy: ## Deploy on Surge.sh
	surge -p ./dist/ -d vue-here-map.surge.sh

build: ## Build assets into dist/ directory
	npm run build

webserver: ## Run internal webserver
	npm run serve


world: build deploy ## Build files and deploy them
