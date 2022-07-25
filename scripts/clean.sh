#!/bin/bash

rm -rf resources/*/.terragrunt-cache
rm -rf resources/*/.terraform.lock.hcl

# Kill IAP tunnel
if command -v pkill; then
  pkill -f 'gcloud.*start-iap-tunnel'
fi