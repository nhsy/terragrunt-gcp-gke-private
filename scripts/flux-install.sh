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

# check cluster connectivity
kubectl version
HTTPS_PROXY=localhost:8080 kubectl cluster-info

# Install flux cli
command -v flux || curl -s https://fluxcd.io/install.sh | bash

HTTPS_PROXY=localhost:8080 flux check --pre

HTTPS_PROXY=localhost:8080 flux install

# Create demo namespace
HTTPS_PROXY=localhost:8080 kubectl create namespace demo || true # ignore errors, if ns already exists

# Configure sync repos
HTTPS_PROXY=localhost:8080 flux create source git wordpress \
  --url=https://github.com/kubernetes-sigs/kustomize \
  --branch=master \
  --interval=30s

HTTPS_PROXY=localhost:8080 flux create kustomization wordpress \
  --source=wordpress \
  --path="./examples/wordpress" \
  --prune=true \
  --interval=5m \
  --target-namespace=demo

HTTPS_PROXY=localhost:8080 kubectl get pods -n flux-system
HTTPS_PROXY=localhost:8080 flux get sources git
HTTPS_PROXY=localhost:8080 flux get kustomizations
HTTPS_PROXY=localhost:8080 kubectl -n demo get deployments,services

#HTTPS_PROXY=localhost:8080 flux delete source git wordpress --silent
#HTTPS_PROXY=localhost:8080 flux delete kustomization wordpress --silent
