# main.py

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


def run_load_test(hosts=None, duration="10s", concurrency=10, results_file="load_test_results.txt"):
    """
    Runs load tests using oha for the given hosts and writes results to a file.
    """
    if hosts is None:
        hosts = ["foo.localhost", "bar.localhost"]

    with open(results_file, "w") as f:
        for host in hosts:
            print(f"Testing {host}")
            f.write(f"Testing {host}\n")
            try:
                result = subprocess.run(
                    [
                        "oha",
                        "-z", duration,
                        "-c", str(concurrency),
                        "--host", host,
                        f"http://{host}/"
                    ],
                    capture_output=True,
                    text=True,
                    check=True
                )
                print(result.stdout)
                f.write(result.stdout)
            except subprocess.CalledProcessError as e:
                print(f"Error testing {host}: {e.stderr}")
                f.write(f"Error testing {host}: {e.stderr}\n")
            f.write("\n")


def main():
    """Main application logic."""
    provision_k8s_cluster()
    run_load_test()


if __name__ == "__main__":
    main()