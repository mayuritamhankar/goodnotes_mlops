#!/bin/bash

# This script automates the process of provisioning a multi-node Kubernetes cluster using KinD.

# Set the name of the cluster
CLUSTER_NAME="goodnotes-cluster"

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
echo "Additional commands added here."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx --for=condition=Ready pod --selector=app.kubernetes.io/component=controller --timeout=120s
kubectl apply -f k8s/http-echo.yaml
kubectl apply -f k8s/echo-ingress.yaml
kubectl get pods -n ingress-nginx
kubectl get pods
kubectl get ingress
echo "Additional commands executed successfully."
