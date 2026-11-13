# 00 — Prerequisites

Before Kubernetes you need 4 things: **containers, Linux basics, YAML, and the tools installed.**

## 1. What is a container?
A container is a **process isolated by the Linux kernel** (namespaces + cgroups) packaged with its
dependencies. It is *not* a VM — it shares the host kernel.

```
 VM                                   Container
 ┌────────┐ ┌────────┐               ┌────────┐ ┌────────┐
 │ App A  │ │ App B  │               │ App A  │ │ App B  │
 │ Guest  │ │ Guest  │               │ libs   │ │ libs   │
 │  OS    │ │  OS    │               └────────┴─┴────────┘
 ├────────┴─┴────────┤               │  Container runtime │
 │    Hypervisor     │               │  Host OS (kernel)  │
 │    Host OS        │               │  Hardware          │
 └───────────────────┘               └────────────────────┘
```

### Docker in 10 commands
```bash
docker build -t myapp:1.0 .
docker run -d -p 8080:80 --name web nginx:1.27
docker ps
docker logs web
docker exec -it web sh
docker stop web && docker rm web
docker tag myapp:1.0 <registry>/myapp:1.0
docker push <registry>/myapp:1.0
docker images
docker system prune -a
```

A sample app + Dockerfile is in [`sample-app/`](sample-app) — used across the repo.

## 2. Why Kubernetes?
| Problem with plain Docker | Kubernetes answer |
|---|---|
| Container crashes | Self-healing (restarts/reschedules) |
| Need many copies | Replicas + load balancing |
| Deploy new version without downtime | Rolling updates / rollbacks |
| Traffic spikes | Autoscaling (HPA, KEDA, Karpenter) |
| Many machines | Scheduler places containers on nodes |
| Config & secrets | ConfigMap / Secret |
| Service discovery | Services + DNS |

## 3. YAML in 2 minutes
```yaml
key: value            # string/number
list:                 # list
  - a
  - b
map:                  # nested map
  nested: true
multi: |              # multi-line block
  line1
  line2
---                   # document separator (multiple objects in one file)
```
Rules: **spaces only (no tabs)**, indentation = structure.

Every Kubernetes object has 4 top-level fields:
```yaml
apiVersion: apps/v1     # which API group/version
kind: Deployment        # type of object
metadata:               # name, namespace, labels, annotations
  name: web
spec:                   # DESIRED state (you write this)
  ...
# status:               # ACTUAL state (Kubernetes writes this)
```

## 4. Install tools
| Tool | Linux/macOS | Windows |
|---|---|---|
| Docker | https://docs.docker.com/get-docker/ | Docker Desktop |
| kubectl | `curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl && sudo install kubectl /usr/local/bin/` | `choco install kubernetes-cli` |
| Minikube | `curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && sudo install minikube-linux-amd64 /usr/local/bin/minikube` | `choco install minikube` |
| Helm | `curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \| bash` | `choco install kubernetes-helm` |
| kind (optional) | `go install sigs.k8s.io/kind@latest` or brew | `choco install kind` |
| k9s (nice TUI) | `brew install k9s` | `choco install k9s` |

Run `../scripts/check-prereqs.sh` to confirm.

## 5. Essential Linux commands
`ls cd cat grep curl wget ps top df free chmod chown systemctl journalctl ssh scp tar sed awk` — know these.

## ✅ Lab
1. Build and run the sample app with Docker.
2. `curl localhost:8080` → see the response.
3. Push it to Docker Hub.

## 📝 Quiz
1. Does a container have its own kernel? *(No — shares the host kernel.)*
2. What does `spec` vs `status` mean? *(desired vs actual state.)*
