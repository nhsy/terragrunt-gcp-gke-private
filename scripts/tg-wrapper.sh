#!/bin/bash

if [ -z "$1" ]
  then
    echo "No argument supplied"
    exit 1
fi

cd resources
if [ -n "$TG_DEBUG" ]
  then
    terragrunt run-all $1 --terragrunt-non-interactive --terragrunt-log-level debug
else
    terragrunt run-all $1 --terragrunt-non-interactive
fi
