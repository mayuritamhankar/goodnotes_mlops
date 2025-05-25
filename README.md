# goodnotes_mlops


- For each pull request to the default branch, trigger the CI workflow (e.g., with GitHub Actions).
- Provision a multi-node (at least 2 nodes) Kubernetes cluster. You may use KinD to provision this cluster on the CI runner (localhost).
- Deploy an Ingress controller to handle incoming HTTP requests.
- Create two http-echo deployments: one serving a response of “bar” and another serving a response of “foo”.
- Configure cluster/ingress routing to send traffic for the “bar” hostname to the bar deployment and the “foo” hostname to the foo deployment on the local cluster (i.e., route both http://foo.localhost and http://bar.localhost).
- Ensure the ingress and deployments are healthy before proceeding to the next step.
- Generate randomized traffic for the bar and foo hosts and capture the load testing results.
- Post the output of the load testing results as a comment on the GitHub Pull Request (automate this in the CI job). Ideally, include stats such as HTTP request duration (avg, p90, p95, etc.), percentage of HTTP requests failed, and requests per second handled.
- Upload the zip file in the link at the end of this email. Make sure it contains everything: code, tests, and documentation.