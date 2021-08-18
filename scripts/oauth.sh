#!/bin/bash

export GOOGLE_OAUTH_ACCESS_TOKEN=$(gcloud auth print-access-token)
echo Environment variable set: GOOGLE_OAUTH_ACCESS_TOKEN