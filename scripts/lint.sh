#!/bin/bash

set -euo pipefail

cd ./environment
terragrunt hclfmt
terraform fmt -recursive

cd ../modules
terraform fmt -recursive
