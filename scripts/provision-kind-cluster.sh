#!/bin/bash

# This script automates the process of provisioning a multi-node Kubernetes cluster using KinD.

# Set the name of the cluster
CLUSTER_NAME="goodnotes-cluster"
kubectl config use-context kind-goodnotes-cluster
# Create the KinD cluster using the configuration file
kind create cluster --name $CLUSTER_NAME --config ../kind/cluster-config.yaml

# Check if the cluster was created successfully
if [ $? -eq 0 ]; then
    echo "Cluster '$CLUSTER_NAME' created successfully."
else
    echo "Failed to create cluster '$CLUSTER_NAME'."
    exit 1
fi

# Set the current context to the new cluster
kubectl cluster-info --context kind-$CLUSTER_NAME

# Print the nodes in the cluster
kubectl get nodes

# Additional commands can be added here for further setup if needed.