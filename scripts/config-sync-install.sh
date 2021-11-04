#!/bin/bash
set -xeuo pipefail

gsutil cp gs://config-management-release/released/latest/config-sync-operator.yaml ./config-sync-operator.yaml
HTTPS_PROXY=localhost:8080 kubectl apply -f config-sync-operator.yaml

command -v nomos || gcloud components install nomos --quiet

HTTPS_PROXY=localhost:8080 nomos status
