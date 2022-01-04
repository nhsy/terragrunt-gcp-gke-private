#!/bin/bash

rm -rf resources/*/.terragrunt-cache
rm -rf resources/*/.terraform.lock.hcl
pkill -f 'gcloud.*start-iap-tunnel'
