#!/usr/bin/env bash

PROXY_PORT=8080

GKE_CLUSTER=$(cd resources/04-gke && terragrunt output -raw name)
GKE_CLUSTER_TYPE=$(cd resources/04-gke && terragrunt output -raw type)
PROXY_NAME=$(cd resources/03-proxy && terragrunt output -raw proxy_name)
REGION=$(cd resources/01-common && terragrunt output -raw region)
ZONE=$(cd resources/01-common && terragrunt output -raw zone)

echo GKE_CLUSTER: $GKE_CLUSTER
echo GKE_CLUSTER_TYPE: $GKE_CLUSTER_TYPE
echo PROXY_NAME: $PROXY_NAME
echo ZONE: $ZONE
echo

if [ -z "$GKE_CLUSTER" ] || [ -z "$PROXY_NAME" ] ;then
  echo Error cannot find GKE or Proxy.
  exit 1
fi

pkill -f 'gcloud.*start-iap-tunnel'
echo Executing: gcloud compute start-iap-tunnel ${PROXY_NAME} --zone ${ZONE} $PROXY_PORT --local-host-port=localhost:$PROXY_PORT
gcloud compute start-iap-tunnel ${PROXY_NAME} --zone ${ZONE} $PROXY_PORT --local-host-port=localhost:$PROXY_PORT &
PID=$!
echo PID: $PID
echo Waiting 10s for IAP tunnel connection...
sleep 10
IP=$(curl -s --proxy localhost:$PROXY_PORT --connect-timeout 5 http://ifconfig.me)
echo PROXY NAT IP: $IP
echo

if [ -z "${IP}" ]; then
  echo "Error creating IAP tunnel."
  exit 1
fi

if [ "${GKE_CLUSTER_TYPE}" == "regional" ]; then
  gcloud container clusters get-credentials $GKE_CLUSTER --region $REGION
else
  gcloud container clusters get-credentials $GKE_CLUSTER --zone $ZONE
fi

HTTPS_PROXY=localhost:$PROXY_PORT kubectl cluster-info
HTTPS_PROXY=localhost:$PROXY_PORT kubectl get nodes
HTTPS_PROXY=localhost:$PROXY_PORT kubectl get all

echo
