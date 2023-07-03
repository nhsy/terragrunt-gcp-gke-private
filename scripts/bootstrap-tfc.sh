#!/bin/bash
set -e

for d in 01-common 02-network 03-proxy 04-gke
do
  pushd resources/$d
  cp ../../scripts/empty.tfstate .
  terragrunt init
  terragrunt state push empty.tfstate --terragrunt-non-interactive
  popd
done
