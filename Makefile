.DEFAULT_GOAL := help

export ANSIBLE_COLLECTIONS_PATH := $(shell pwd)/vendor/collections
export ANSIBLE_ROLES_PATH := $(shell pwd)/vendor/roles

.PHONY: venv
venv: ## Create .venv with the locked development tools
	uv sync --locked

.PHONY: requirements
requirements: venv ## Install Ansible requirements (roles and collections)
	uv run ansible-galaxy install --role-file molecule/requirements.yml --force

.PHONY: setup
setup: requirements ## Setup project
	uv run pre-commit install --overwrite

.PHONY: clean
clean: ## Remove all git hooks and remove venv
	uv run pre-commit uninstall
	rm -rf .venv

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
