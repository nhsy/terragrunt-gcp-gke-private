# gcp-terraform-gke-private

## Overview
This example deploys an opinionated GKE Private cluster and demonstrates how to connect to the GKE Private Endpoint using IAP tunneling.

The following resources are deployed:

* GKE Regional / Zonal Cluster
* Network
* Google Compute Engine - Proxy

Preemptible VMs are deployed to reduce costs.

The Terraform IaC leverages the Google Terraform registry modules and uses Terragrunt to orchestrate the deployment.

No public IP addresses are assigned to the Proxy VM and identity aware proxy provides a secure connection. 

## Pre-Requisites
### Development Environment
Google Cloud Shell is the preferred development environment for deploying this example.

The following tools are required:
- Bash Shell
- Google Cloud SDK v330+
- Google Cloud Shell
- jq
- kubectl
- Terraform v1.04+
- Terragrunt v0.30.0+

All the tools above a pre-installed with Google Cloud Shell, except Terraform and Terragrunt.

### IAM
A GCP project with the following permissions are required:

- roles/container.admin
- roles/compute.admin
- roles/serviceusage.serviceUsageAdmin
- roles/storage.admin
- roles/iap.tunnelResourceAccessor

## Setup
Create the file environment/common_vars.json as follows:
```json
{
  "project_id": "_project_",
  "region": "_region_",
}
```
_Optional:_ The command `make setup` will download and install terraform and terragrunt.

## Usage
### Deployment
Setup the environment variables:
```bash
source ./scripts/env.sh
```

For a quick deployment execute:
```bash

make all
make tunnel
```

For a step by step deployment execute to troubleshoot any errors:
```bash
make init
make validate
make plan
make apply
make tunnel
```

### Destroy
To delete everything created execute:
```bash
make destroy
```

## Additional Info
### Private GKE Control Plane Endpoint Access
kubectl commands need to be prefixed with `HTTPS_PROXY=localhost:8080` as follows: 
```bash
HTTPS_PROXY=localhost:8080 kubectl get all
```

Setting the bash alias below is useful:
```bash
alias kp='HTTPS_PROXY=localhost:8080 kubectl $*'

kp get all
```

### Customisations

The common_vars.json file can be customised as follows:
```json
{
  "project_id": "_project_",
  "region": "_region_",

  "preemptible": "true",
 
  "gke_nodes_min": 3,
  "gke_nodes_max": 10,
  "gke_regional": false,

  "skip_proxy": false,
  "skip_gke": false
}
```

## Known issues
* If you set the environment variable `export HTTPS_PROXY=localhost:8080`, remember to unset prior to destroying!
