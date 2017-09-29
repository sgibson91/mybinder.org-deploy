#!/bin/bash
set -euo pipefail
# Used by travis to trigger deployments
# Keeping this here rather than make travis.yml too complex

echo "Starting deploy..."


openssl aes-256-cbc -K $encrypted_510e3970077d_key -iv $encrypted_510e3970077d_iv -in travis/deploy-secrets.tar.gz.enc -out travis/deploy-secrets.tar.gz -d
tar xvf travis/deploy-secrets.tar.gz

# Set up the gcloud SDK for use!
export PATH=${HOME}/google-cloud-sdk/bin:${PATH}

gcloud auth activate-service-account --key-file=deploy-secrets/google-auth-key.json
gcloud container clusters get-credentials binder-hub --zone=us-central1-a --project=binder-testing

kubectl version
kubectl --namespace=kube-system get pod
helm init --client-only
helm version

echo "Done!"
