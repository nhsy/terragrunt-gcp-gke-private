#!/bin/bash

export TG_PROJECT=$(jq -r '.project_id' ./environment/common_vars.json)
export TG_REGION=$(jq -r '.region' ./environment/common_vars.json)

gcloud config set project $TG_PROJECT
gcloud config list

export TG_BUCKET=terraform-state-$(gcloud projects describe $TG_PROJECT --format="value(projectNumber)")

buckets=$(gsutil list | grep "${TG_BUCKET}")
if [ -z "$buckets" ]; then
  echo Creating terraform state bucket: $TG_BUCKET
  gsutil mb -b on -l $TG_REGION gs://$TG_BUCKET
  gsutil versioning set on gs://$TG_BUCKET
else
  echo Skipping terraform state bucket creation: $TG_BUCKET
fi
