.DEFAULT_GOAL := help

export ANSIBLE_COLLECTIONS_PATHS := $(shell pwd)/vendor/collections
export ANSIBLE_ROLES_PATH := $(shell pwd)/vendor/roles

.PHONY: requirements
requirements: venv ## Install Ansible requirements (roles and collections)
	$(VENV)/ansible-galaxy install --role-file molecule/requirements.yml --force

.PHONY: setup
setup: requirements venv ## Setup project
	$(VENV)/pre-commit install --overwrite

.PHONY: clean
clean: venv ## Remove all git hooks and remove venv
	$(VENV)/pre-commit uninstall
	$(MAKE) clean-venv

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

include Makefile.venv
Makefile.venv:
	curl \
		-o Makefile.fetched \
		-L "https://github.com/sio/Makefile.venv/raw/v2023.04.17/Makefile.venv"
	echo "fb48375ed1fd19e41e0cdcf51a4a0c6d1010dfe03b672ffc4c26a91878544f82 *Makefile.fetched" \
		| sha256sum --check - \
		&& mv Makefile.fetched Makefile.venv
