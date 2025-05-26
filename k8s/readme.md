# k8s/http-echo.yaml

This YAML file defines two separate Kubernetes Deployments and their corresponding Services for simple HTTP echo servers. Each Deployment manages a single replica (Pod) of the hashicorp/http-echo container, which is a lightweight HTTP server that responds with a fixed text message.

The first Deployment, named echo-bar, creates a Pod that runs the hashicorp/http-echo image with the argument -text=bar. This means any HTTP request to this Pod will receive the response "bar". The container listens on port 5678. The associated Service, also named echo-bar, exposes this Pod on port 80 within the cluster and forwards traffic to the container's port 5678. The Service uses a label selector (app: echo-bar) to route traffic to the correct Pod.

Similarly, the second Deployment, echo-foo, creates a Pod that responds with "foo" to any HTTP request, using the same image and port configuration. Its Service, echo-foo, also exposes the Pod on port 80 and forwards requests to port 5678, using the label selector app: echo-foo.

This setup is useful for testing Kubernetes networking, ingress controllers, or load balancing. By deploying two echo servers with different responses, you can easily verify routing and service discovery within your cluster. The use of Services ensures that each echo server can be accessed reliably, regardless of the underlying Pod's IP address, which may change over time.


# k8s/http-ingress.yaml

This YAML defines a Kubernetes Ingress resource named echo-ingress in the default namespace. An Ingress manages external access to services within a Kubernetes cluster, typically HTTP traffic, and provides routing rules based on hostnames and paths.

The annotations section includes nginx.ingress.kubernetes.io/rewrite-target: /, which tells the NGINX Ingress controller to rewrite the incoming request’s path to / before forwarding it to the backend service. This is useful for simplifying backend service routing.

Under spec, two rules are defined. The first rule matches requests with the host foo.localhost and routes all paths (/) to the echo-foo service on port 80. The second rule does the same for the host bar.localhost, routing to the echo-bar service on port 80. This setup allows you to direct traffic to different backend services based on the requested hostname, making it easy to test and verify hostname-based routing within your cluster