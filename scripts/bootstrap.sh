#!/bin/bash
set -e

if [ -z "$1" ]
  then
    echo "No argument supplied"
    exit 1
fi

cd bootstrap
terraform fmt

case $1 in
  init | i)
    terraform init
    ;;
  plan | p)
    terraform plan
    ;;
  apply | a)
    terraform apply -auto-approve
    ;;
  destroy | d)
    terraform destroy -auto-approve
    ;;
  validate | v)
    terraform validate
    ;;
esac
