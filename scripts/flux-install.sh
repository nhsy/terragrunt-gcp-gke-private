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

#HTTPS_PROXY=localhost:8080 kubectl apply -f https://github.com/fluxcd/flux2/releases/latest/download/install.yaml

# Install flux cli
command -v flux || curl -s https://fluxcd.io/install.sh | sudo bash

HTTPS_PROXY=localhost:8080 flux check --pre

HTTPS_PROXY=localhost:8080 flux install
#--namespace=flux-system \
#--network-policy=false \
#--components=source-controller,helm-controller

# Create demo namespace
HTTPS_PROXY=localhost:8080 kubectl create namespace demo || true # ignore errors, if ns already exists

HTTPS_PROXY=localhost:8080 flux create source git podinfo \
  --url=https://github.com/nhsy/podinfo \
  --branch=demo \
  --interval=30s

HTTPS_PROXY=localhost:8080 flux create kustomization podinfo \
  --source=podinfo \
  --path="./kustomize" \
  --prune=true \
  --interval=5m \
  --target-namespace=demo

HTTPS_PROXY=localhost:8080 kubectl get pods -n flux-system
HTTPS_PROXY=localhost:8080 flux get sources git
HTTPS_PROXY=localhost:8080 flux get kustomizations
HTTPS_PROXY=localhost:8080 kubectl -n demo get deployments,services

#HTTPS_PROXY=localhost:8080 flux delete source git podinfo --silent
#HTTPS_PROXY=localhost:8080 flux delete kustomization podinfo --silent
