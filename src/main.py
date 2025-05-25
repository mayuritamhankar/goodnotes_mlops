# main.py

import os
import subprocess

def provision_k8s_cluster():
    """Provision a multi-node Kubernetes cluster using KinD."""
    CLUSTER_NAME = "goodnotes-cluster"
    try:
        # Delete existing cluster if it exists
        subprocess.run(["kind", "delete", "cluster", "--name", CLUSTER_NAME], check=False)
        # Create the cluster with the correct name
        subprocess.run(["kind", "create", "cluster", "--name", CLUSTER_NAME, "--config", "kind/cluster-config.yaml"], check=True)
        print("Kubernetes cluster provisioned successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error provisioning cluster: {e}")

def main():
    """Main application logic."""
    provision_k8s_cluster()
    # Additional logic for interacting with the Kubernetes cluster can be added here

if __name__ == "__main__":
    main()