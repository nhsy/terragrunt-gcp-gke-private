#!/bin/bash

export TG_PROJECT=$(jq -r '.project_id' ./resources/common_vars.json)
export TG_REGION=$(jq -r '.region' ./resources/common_vars.json)

gcloud config set project $TG_PROJECT
gcloud config list

export TG_BUCKET=terraform-state-$(gcloud projects describe $TG_PROJECT --format="value(projectNumber)")

echo "TG environment variables:"
env | grep "TG_"

alias kp='HTTPS_PROXY=localhost:8080 kubectl $*'
alias np='HTTPS_PROXY=localhost:8080 nomos $*'