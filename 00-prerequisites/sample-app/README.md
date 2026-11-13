# Sample App
Tiny Flask API returning pod name/version. Used throughout this repo.
```bash
docker build -t k8s-sample:1.0 .
docker run -p 8080:8080 k8s-sample:1.0
curl localhost:8080        # {"message":"Hello from Kubernetes!","pod":"<id>",...}
# Minikube: build inside minikube's docker daemon
eval $(minikube docker-env) && docker build -t k8s-sample:1.0 .
```
Endpoints: `/` info, `/healthz` health probe.
