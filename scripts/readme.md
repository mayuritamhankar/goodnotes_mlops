# scripts/load_test.sh
This Bash script is designed to automate load testing for two local services, foo.localhost and bar.localhost. It begins by enabling the set -e option, which causes the script to exit immediately if any command fails, helping to catch errors early.

The script defines an array HOSTS containing the hostnames to test and sets the output file name as load_test_results.txt. It initializes this results file by overwriting it with an empty string, ensuring previous results are cleared.

For each host in the HOSTS array, the script prints a message indicating which host is being tested and appends this message to the results file. It then runs the oha load testing tool, targeting the host with 10 concurrent connections (-c 10) for a duration of 10 seconds (-z 10s). The --host flag sets the HTTP Host header, and the results of each test are appended to the results file. After each test, an empty line is added to the file for readability. This script provides a simple way to benchmark and compare the performance of multiple local HTTP services.


# scripts/provision_kind_cluster.sh

This Bash script automates the setup of a multi-node Kubernetes cluster using KinD (Kubernetes in Docker). It starts by defining the cluster name as goodnotes-cluster and deletes any existing cluster with that name to ensure a clean environment. It then creates a new KinD cluster using a configuration file that specifies the cluster's structure.

After cluster creation, the script checks if the operation was successful and prints a message accordingly. It sets the current kubectl context to the new cluster and lists the nodes to confirm the cluster is running. The script then labels the first node as ingress-ready, which is required for deploying the NGINX ingress controller.

Next, it deploys the ingress-nginx controller using a manifest from the official repository. The script waits for the ingress controller deployment to become available, and also waits for the admission webhook pod and patch job to be ready, using timeouts to avoid indefinite waits. A short sleep is added to allow Kubernetes endpoints to be created, followed by a loop that checks for the readiness of the admission webhook service endpoints.

Once the ingress controller is ready, the script applies the http-echo.yaml manifest to deploy sample echo services. It then attempts to apply the ingress configuration (http-ingress.yaml), retrying up to five times in case the webhook is not ready. Finally, it lists the pods in the ingress-nginx namespace, all pods in the cluster, and the configured ingresses, providing a summary of the cluster's state. The script ends with a confirmation message, indicating that all setup steps have been executed.
