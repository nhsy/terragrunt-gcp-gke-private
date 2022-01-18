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

HTTPS_PROXY=localhost:8080 flux install \
--namespace=flux-system \
--network-policy=false \
--components=source-controller,helm-controller

# Create demo namespace
HTTPS_PROXY=localhost:8080 kubectl create namespace demo || true # ignore errors

HTTPS_PROXY=localhost:8080 flux create source helm podinfo \
--namespace=default \
--url=https://stefanprodan.github.io/podinfo \
--interval=10m

HTTPS_PROXY=localhost:8080 flux create helmrelease podinfo \
--namespace=demo \
--source=HelmRepository/podinfo \
--release-name=podinfo \
--chart=podinfo \
--chart-version=">5.0.0" \
--values=flux/podinfo-values.yaml

HTTPS_PROXY=localhost:8080 flux get helmreleases -n demo

#HTTPS_PROXY=localhost:8080 flux -n demo delete source helm podinfo
#HTTPS_PROXY=localhost:8080 flux -n demo delete helmrelease podinfo