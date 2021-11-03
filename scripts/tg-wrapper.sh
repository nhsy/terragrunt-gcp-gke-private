#!/bin/bash

if [ -z "$1" ]
  then
    echo "No argument supplied"
    exit 1
fi

cd resources
terragrunt run-all $1 --terragrunt-non-interactive