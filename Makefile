# Use bash instead of sh
#SHELL := /usr/bin/env bash

.PHONY: lint
lint:
	./scripts/lint.sh

.PHONY: setup
setup:
	@scripts/setup.sh

.PHONY: init
init:
	@scripts/tg-wrapper.sh init

.PHONY: validate
validate:
	@scripts/tg-wrapper.sh validate

.PHONY: refresh
refresh:
	@scripts/tg-wrapper.sh refresh

.PHONY: plan
plan:
	@scripts/tg-wrapper.sh plan

.PHONY: apply
apply:
	@scripts/tg-wrapper.sh apply

.PHONY: destroy
destroy:
	@scripts/tg-wrapper.sh destroy

.PHONY: clean
clean:
	@scripts/clean.sh
