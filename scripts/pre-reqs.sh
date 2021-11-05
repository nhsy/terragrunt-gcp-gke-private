#!/bin/bash
set -e

echo "Checking pre-reqs..."

gcloud --version
jq --version
terraform version
terragrunt -version
tfsec --version
