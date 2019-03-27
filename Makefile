.PHONY: help
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: ## Runs pub get to get dependencies
	@pub get

serve: install dart-serve ## Serves the frontend app with the Dev Compiler

firebase-serve: install build-js ## Serves built JS files locally using Firebase Local
	@firebase serve

format: ## Format the dart files
	@pub run dart_dev format

analyze: ## Look for errors in the dart files
	@pub run dart_dev analyze

dart-serve:
	@webdev serve --no-release

build-js:
	@webdev build --release

test: ## Run Unit tests
	@pub run test -p chrome