# .github/workflows/ci.yml
This GitHub Actions workflow automates continuous integration (CI) for the project whenever a pull request is opened or updated against the main branch. It is named "CI" and grants permission to write pull request comments, which is useful for posting automated feedback.

The workflow runs on an Ubuntu runner and consists of several steps. It first checks out the repository code. Then, it sets up Python 3.10 and installs project dependencies using pip and a requirements.txt file, which is typical for Python projects.

Next, it sets up Docker Buildx, a tool for building Docker images, and provisions a KinD (Kubernetes in Docker) cluster by running a shell script (provision_kind_cluster.sh). This allows to test Kubernetes deployments in a local cluster environment during CI.

The workflow then installs oha, a command-line HTTP load testing tool, by downloading its binary and moving it to the system path. After that, it runs a load test using another script (load_test.sh). The results of this load test are posted as a comment on the pull request using the marocchino/sticky-pull-request-comment action, providing immediate feedback to contributors.

Finally, the workflow cleans up by deleting the KinD cluster, ensuring that resources are not left running after the CI job completes. This setup helps automate testing, performance checks, and feedback for every pull request, improving code quality and reliability.
