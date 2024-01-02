#!/bin/bash

# Stop on error and display executed commands
set -eo xtrace

terraform init

terraform apply -auto-approve

terraform output -raw kubeconfig > my_kube_cluster.yml

export KUBE_CLUSTER=$(pwd)/my_kube_cluster.yml

kubectl --kubeconfig=$KUBE_CLUSTER cluster-info

kubectl --kubeconfig=$KUBE_CLUSTER get np

#echo "cd ../../managed-private-registry/create-registry-with-pulumi/ovhcloud-registry-go"