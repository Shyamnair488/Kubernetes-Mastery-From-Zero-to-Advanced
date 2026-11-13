# Glossary (A–Z)
| Term | Meaning |
|---|---|
| **Admission controller** | API-server plugin that validates/mutates requests before persistence |
| **Annotation** | non-identifying key/value metadata |
| **ArgoCD** | GitOps controller syncing Git → cluster |
| **CNI / CSI / CRI** | Container Network / Storage / Runtime Interface plugins |
| **ConfigMap** | non-secret config object |
| **Control plane** | apiserver, etcd, scheduler, controller-manager |
| **CRD** | CustomResourceDefinition – extends the API with new kinds |
| **DaemonSet** | one Pod per node |
| **Deployment** | declarative stateless workload with rolling updates |
| **Drain/Cordon** | evict Pods from / stop scheduling onto a node |
| **EndpointSlice** | list of Pod IPs behind a Service |
| **etcd** | key-value store holding all cluster state |
| **GitOps** | Git as source of truth; agents reconcile cluster to Git |
| **HPA/VPA** | Horizontal / Vertical Pod Autoscaler |
| **Helm** | package manager for Kubernetes |
| **Ingress** | L7 HTTP routing rules (needs a controller) |
| **Init container** | runs to completion before app containers |
| **IRSA** | IAM Roles for Service Accounts (EKS) |
| **Job/CronJob** | run-to-completion / scheduled workloads |
| **KEDA** | event-driven autoscaler (scale to zero) |
| **Karpenter** | node provisioner that launches right-sized nodes for Pending pods |
| **kubelet** | node agent running Pods |
| **kube-proxy** | implements Service virtual IPs |
| **Label / Selector** | key-values for grouping / queries over them |
| **Namespace** | virtual cluster partition |
| **NetworkPolicy** | Pod-level firewall rules |
| **Node** | worker machine |
| **NodePool / NodeClaim** | Karpenter constraints / actual node request |
| **Operator** | CRD + controller encoding operational logic |
| **PDB** | PodDisruptionBudget – limit voluntary evictions |
| **Pod** | smallest deployable unit; 1+ containers sharing network/storage |
| **PV / PVC / StorageClass** | storage resource / request / provisioning template |
| **QoS class** | Guaranteed, Burstable, BestEffort |
| **RBAC** | Role-based access control |
| **ReplicaSet** | keeps N Pod replicas running |
| **Reconciliation** | loop making actual state match desired state |
| **Secret** | sensitive data object (base64, not encrypted by default) |
| **SecurityContext** | per-Pod/container privilege settings |
| **Service** | stable virtual IP + DNS name for Pods |
| **ServiceAccount** | identity for Pods |
| **Sidecar** | helper container in same Pod |
| **StatefulSet** | stateful workload with stable identity & storage |
| **Taint / Toleration** | node repels Pods / Pod accepts the repel |
| **Trivy** | vulnerability & misconfiguration scanner |
