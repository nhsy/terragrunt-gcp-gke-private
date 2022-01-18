#!/usr/bin/env bash
set -xe

PROXY_PORT=8080

GKE_CLUSTER=$(cd resources/04-gke && terragrunt output -raw name)
REGION=$(cd resources/01-common && terragrunt output -raw region)
ZONE=$(cd resources/01-common && terragrunt output -raw zone)

echo GKE_CLUSTER: $GKE_CLUSTER
echo ZONE: $ZONE
echo

if [[ -z "$GKE_CLUSTER" ]]; then
  echo Error cannot find GKE cluster.
  exit 1
fi

HTTPS_PROXY=localhost:8080 kubectl apply -f https://github.com/fluxcd/flux2/releases/latest/download/install.yaml

# Install flux cli
command -v flux || curl -s https://fluxcd.io/install.sh | sudo bash

# Create demo namespace
HTTPS_PROXY=localhost:8080 kubectl create namespace demo || true # ignore errors

# Synchronise git repo
HTTPS_PROXY=localhost:8080 flux create source git podinfo \
  --url=https://github.com/stefanprodan/podinfo \
  --tag-semver=">=4.0.0" \
  --interval=1m

HTTPS_PROXY=localhost:8080 flux create kustomization podinfo-default \
  --source=podinfo \
  --path="./kustomize" \
  --prune=true \
  --interval=10m \
  --target-namespace=demo



HTTPS_PROXY=localhost:8080 flux get kustomizations -n demo


#  --health-check="Deployment/podinfo.default" \
#  --health-check-timeout=2m \