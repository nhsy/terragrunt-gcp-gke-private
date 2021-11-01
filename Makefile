#SHELL := /usr/bin/env bash

.PHONY: lint
lint:
	@./scripts/lint.sh

.PHONY: setup
setup:
	@scripts/setup.sh

.PHONY: init
init:
	@scripts/backend.sh init
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
destroy:  init
	@scripts/tg-wrapper.sh destroy

.PHONY: clean
clean:

.PHONY: tunnel
tunnel: tunnel-iap

.PHONY: tunnel-iap
tunnel-iap:
	@scripts/tunnel-iap.sh

.PHONY: tunnel-ssh
tunnel-ssh:
	@scripts/tunnel-ssh.sh

.PHONY: all
all: init validate apply
