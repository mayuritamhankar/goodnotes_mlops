#!/bin/bash

# This script automates the process of provisioning a multi-node Kubernetes cluster using KinD.

# Set the name of the cluster
CLUSTER_NAME="goodnotes-cluster"

# Create the KinD cluster using the configuration file
kind create cluster --name $CLUSTER_NAME --config kind/cluster-config.yaml

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

# Wait for ingress controller deployment to be available
kubectl wait --namespace ingress-nginx \
  --for=condition=available deployment/ingress-nginx-controller \
  --timeout=300s

# Wait for the admission webhook pod to be ready (optional, may not always match selector)
kubectl wait --namespace ingress-nginx \
  --for=condition=Ready pod \
  --selector=app.kubernetes.io/component=admission-webhook \
  --timeout=120s || true

# Wait for the admission webhook service endpoints to be created
for i in {1..30}; do
  ENDPOINTS=$(kubectl get endpoints -n ingress-nginx ingress-nginx-controller-admission -o jsonpath='{.subsets}')
  if [[ "$ENDPOINTS" != "" && "$ENDPOINTS" != "null" ]]; then
    echo "Admission webhook endpoints are ready."
    break
  fi
  echo "Waiting for admission webhook endpoints to be ready..."
  sleep 5
done

kubectl apply -f k8s/http-echo.yaml

# Retry applying ingress in case webhook is not ready yet
for i in {1..5}; do
  kubectl apply -f k8s/http-ingress.yaml && break
  echo "Retrying ingress apply in 10s..."
  sleep 10
done

kubectl get pods -n ingress-nginx
kubectl get pods
kubectl get ingress
echo "Additional commands executed successfully."
