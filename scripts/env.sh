#!/bin/bash

export TG_PROJECT=$(jq -r '.project_id' ./environment/common_vars.json)
export TG_REGION=$(jq -r '.region' ./environment/common_vars.json)

gcloud config set project $TG_PROJECT
gcloud config list

export TG_BUCKET=terraform-state-$(gcloud projects describe $TG_PROJECT --format="value(projectNumber)")
