#!/bin/bash

set -xeuo pipefail

cd ./resources
terragrunt hclfmt
terraform fmt -recursive

cd ../modules
terraform fmt -recursive
