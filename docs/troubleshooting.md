# Troubleshooting Guide

| Symptom | Likely cause | Commands / fix |
|---|---|---|
| Pod `Pending` | insufficient resources, taints, unbound PVC, affinity, quota | `k describe po` → Events; `k get pvc`; `k describe node` |
| `ImagePullBackOff` | typo/tag missing, private registry w/o secret, ECR perms, wrong arch | check image; `imagePullSecrets`; node role |
| `CrashLoopBackOff` | app exits, bad args/env, missing config, failing probe | `k logs --previous`; run image locally |
| `OOMKilled` (137) | memory limit too low / leak | raise limit; profile; VPA recommendation |
| `CreateContainerConfigError` | missing ConfigMap/Secret/key | `k describe po` |
| Running but `0/1 READY` | readiness probe failing | probe path/port; app logs |
| Service unreachable | selector ≠ labels, wrong targetPort, no Ready pods | `k get endpoints svc`; `k describe svc` |
| DNS fails | CoreDNS down, NetworkPolicy blocks 53 | `k get pods -n kube-system`; `nslookup` from netshoot |
| Ingress 404/502 | wrong path/host, backend port, no controller | `k describe ing`; controller logs |
| LB `<pending>` | no cloud controller / minikube needs tunnel / subnet tags | `minikube tunnel`; EKS subnet tags |
| PVC `Pending` | no StorageClass / no default / AZ mismatch | `k describe pvc`; `k get sc` |
| Node `NotReady` | kubelet down, disk/memory pressure, CNI | `k describe node`; `journalctl -u kubelet` |
| `Forbidden` | RBAC | `k auth can-i ... --as=...` |
| Rollout stuck | readiness failing / quota / bad image | `rollout status`; `rollout undo` |
| HPA `<unknown>` | metrics-server missing or no CPU requests | install metrics-server; set requests |
| KEDA not scaling | wrong trigger address/auth; check `k describe scaledobject` + keda-operator logs |
| Karpenter no nodes | NodePool requirements/limits, IAM, tags, EC2 quota — `k logs -n kube-system -l app.kubernetes.io/name=karpenter` |
| ArgoCD OutOfSync forever | HPA/controller mutating fields → `ignoreDifferences` |
| Namespace stuck `Terminating` | finalizers / unavailable API (CRDs) — `k get ns X -o yaml`, remove finalizer carefully |

## Universal 5-step method
1. `k get` (status) → 2. `k describe` (events) → 3. `k logs` (app) → 4. `k exec`/`debug` (inside) → 5. check the *neighbors*: Service, endpoints, DNS, policy, node.
