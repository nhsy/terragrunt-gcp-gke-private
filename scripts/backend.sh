#!/usr/bin/env bash

bucket=$(gsutil list | grep "${TG_BUCKET}")
if [ -z "$bucket" ]; then
  #echo Creating terraform state bucket: $TG_BUCKET
  gsutil mb -b on -l $TG_REGION gs://$TG_BUCKET
  gsutil versioning set on gs://$TG_BUCKET
else
  echo Skipping terraform state bucket creation: $TG_BUCKET
fi
echo