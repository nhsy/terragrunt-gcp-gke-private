#!/bin/bash

set -euo pipefail

TERRAFORM_VERSION=1.1.2
TERRAGRUNT_VERSION=0.35.16
TFSEC_VERSION=0.63.1

if [ "$(uname)" == "Darwin" ]; then
    OSTYPE=darwin
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    OSTYPE=linux
fi

# Install terragrunt
wget -O /tmp/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_${OSTYPE}_amd64
chmod +x /tmp/terragrunt
mv /tmp/terragrunt /usr/local/bin

# Install terraform
wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${OSTYPE}_amd64.zip
unzip -q /tmp/terraform.zip -d /tmp
chmod +x /tmp/terraform
mv /tmp/terraform /usr/local/bin
rm /tmp/terraform.zip

# Install tfsec
wget -O /tmp/tfsec https://github.com/aquasecurity/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-${OSTYPE}-amd64
chmod +x /tmp/tfsec
chown root.root /tmp/tfsec
mv /tmp/tfsec /usr/local/bin

terraform version
terragrunt -version
tfsec --version
