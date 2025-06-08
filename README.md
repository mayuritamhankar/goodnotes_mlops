# goodnotes_mlops

This repository demonstrates a complete MLOps workflow using Kubernetes, KinD, and GitHub Actions. It provisions a multi-node KinD cluster, deploys echo services, configures ingress routing, performs load testing, and posts results to pull requests.

---

## Features

- CI workflow triggered on pull requests to the default branch (see `.github/workflows/ci.yml`)
- Multi-node Kubernetes cluster provisioned with KinD
- NGINX Ingress controller for HTTP routing
- Two http-echo deployments: one for "bar", one for "foo"
- Ingress routing for `foo.localhost` and `bar.localhost`
- Automated health checks for deployments and ingress
- Load testing with [oha](https://github.com/hatoo/oha) (or [hey](https://github.com/rakyll/hey))
- Load test results posted as a comment on the GitHub Pull Request
- Easy cleanup and reproducibility

---

## How to Run Locally

### Prerequisites

- Docker
- [KinD (Kubernetes in Docker)](https://kind.sigs.k8s.io/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- Python 3.10+
- (Optional) [oha](https://github.com/hatoo/oha) or [hey](https://github.com/rakyll/hey) for manual load testing

---

### 1. Clone the repository

```sh
git clone https://github.com/mayuritamhankar/goodnotes_mlops.git
cd goodnotes_mlops
```

---

### 2. Install Python dependencies

```sh
python -m pip install --upgrade pip
pip install -r requirements.txt
```

---

### 3. Provision the KinD Cluster

```sh
chmod +x scripts/provision_kind_cluster.sh
./scripts/provision_kind_cluster.sh
```

This will:
- Create a KinD cluster using `kind/cluster-config.yaml`
- Deploy the NGINX ingress controller
- Deploy the echo services and ingress
- Wait for all resources to become healthy

---

### 4. Run Load Test

```sh
chmod +x scripts/load_test.sh
./scripts/load_test.sh
```

Results will be saved to `load_test_results.txt`.

---

### 5. View Results

```sh
cat load_test_results.txt
```

---

### 6. Cleanup

```sh
kind delete cluster --name goodnotes-cluster
```

---

## Running in CI

- The GitHub Actions workflow (`.github/workflows/ci.yml`) will:
  - Set up Python and Docker
  - Provision the KinD cluster
  - Deploy echo services and ingress
  - Run load tests
  - Post results as a PR comment
  - Clean up the cluster

No manual steps are needed for CI; everything runs automatically on pull requests.

---

## Notes

- To test ingress routing locally, you may need to add entries to your `/etc/hosts` file:
  ```
  127.0.0.1 foo.localhost
  127.0.0.1 bar.localhost
  ```

---

## Directory Structure

```
goodnotes_mlops/
├── kind/
│   └── cluster-config.yaml
├── k8s/
│   ├── http-echo.yaml
│   └── http-ingress.yaml
├── scripts/
│   ├── provision_kind_cluster.sh
│   └── load_test.sh
├── .github/
│   └── workflows/
│       └── ci.yml
├── requirements.txt
├── README.md
└── ...
```

---

## Troubleshooting

- If the ingress controller pod is stuck in `Pending`, ensure the control-plane node is labeled with `ingress-ready=true` (the script does this automatically).
