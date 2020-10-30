#!/usr/bin/env bash

set -xe


CLUSTER_NAME=$(gcloud container clusters list | grep 'gke-test' | awk '{print $1}')
REGION=$(gcloud container clusters list | grep 'gke-test' | awk '{print $2}')

gcloud container clusters get-credentials $CLUSTER_NAME --region $REGION

kubectl apply -f ../kube-manifests/