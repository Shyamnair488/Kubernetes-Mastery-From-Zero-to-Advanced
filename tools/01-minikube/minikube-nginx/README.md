# Minikube NGINX Practice Lab

This self-contained lab builds the included NGINX page, deploys three replicas to
Minikube, exposes them through a `LoadBalancer` Service, and verifies access.

## Prerequisites

- Docker Desktop is installed and running.
- Minikube and kubectl are installed.
- CPU virtualization is enabled.

On Windows, install the command-line tools with Chocolatey:

```powershell
choco install minikube kubernetes-cli -y
```

Verify the tools:

```powershell
docker version
minikube version
kubectl version --client
```

## Start Minikube

```powershell
minikube start --driver=docker
minikube status
kubectl cluster-info
kubectl get nodes
```

Optional add-ons:

```powershell
minikube addons enable metrics-server
minikube addons enable ingress
```

## Build and deploy

Run these commands from this directory:

```powershell
minikube image build -t minikube-nginx:1.0 .
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl rollout status deployment/mydeployment
```

The deployment uses `imagePullPolicy: IfNotPresent`, so Minikube uses the
locally built image instead of requiring a public registry.

Verify the resources:

```powershell
kubectl get deployments
kubectl get pods -o wide
kubectl get svc myservice
kubectl get endpoints myservice
```

## Access the page

The simplest option with the Docker driver is:

```powershell
minikube service myservice
```

To use a local port instead:

```powershell
kubectl port-forward service/myservice 8080:80
```

Open <http://localhost:8080> while the port-forward command is running.

For a LoadBalancer address, run `minikube tunnel` in a separate PowerShell
window and then inspect the Service:

```powershell
minikube tunnel
kubectl get svc myservice
```

## Troubleshooting

| Problem | Check |
|---|---|
| Docker driver fails | Start Docker Desktop and run `docker version`. |
| Pods are not ready | Run `kubectl describe pods` and `kubectl logs deployment/mydeployment`. |
| Service has no endpoints | Confirm the Pods have the `app: myapp` label. |
| LoadBalancer remains pending | Run `minikube tunnel` or use `minikube service myservice`. |
| Metrics are unavailable | Wait for metrics-server to become ready with `kubectl get pods -n kube-system`. |

Useful diagnostics:

```powershell
kubectl config current-context
kubectl get all
kubectl get events --sort-by=.metadata.creationTimestamp
```

## Cleanup

```powershell
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
minikube stop
```

To remove the entire local Minikube cluster:

```powershell
minikube delete
```

## Files

- `Dockerfile` - NGINX image definition.
- `index.html` - Page served by NGINX.
- `deployment.yaml` - Three-replica Deployment.
- `service.yaml` - LoadBalancer Service.
