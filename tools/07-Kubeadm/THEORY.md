# Kubeadm Theory

## What kubeadm does

`kubeadm` bootstraps a Kubernetes control plane and prepares nodes to join
the cluster. It does not create virtual machines, provide Pod networking, or
run application workloads. AWS, the operating system, `containerd`, and a CNI
plugin provide those surrounding responsibilities.

## Control-plane components

- **API server**: the authenticated front door for `kubectl` and controllers.
- **etcd**: the strongly consistent key-value store for cluster state.
- **Scheduler**: chooses a suitable node for each unscheduled Pod.
- **Controller manager**: reconciles desired resources with actual state.
- **kubelet**: runs on every node and keeps assigned Pods healthy.
- **kube-proxy**: installs Service traffic rules on nodes.

The API server is the only component clients should use directly. Protect
`/etc/kubernetes/admin.conf`, because it normally grants cluster-admin access.

## Runtime and networking

Kubernetes asks the Container Runtime Interface (CRI) to start containers.
This lab uses `containerd`; Docker is not required on the nodes.

The CNI plugin gives Pods IP addresses and routes Pod-to-Pod traffic. The Pod
CIDR passed to `kubeadm init` must match the CNI configuration and must not
overlap the VPC or Service CIDR. A node can have a running kubelet and still
be `NotReady` when no CNI is installed.

Services provide stable virtual access to changing Pod IPs. A NodePort makes a
Service reachable through a port on each node. A LoadBalancer requires an
external integration; kubeadm alone does not provision one.

## Bootstrap and trust

`kubeadm init` creates the control-plane certificates, static Pod manifests,
admin kubeconfig, and bootstrap information. A worker joins with a short-lived
token and a discovery hash. The token is a credential: do not commit it or
paste it into public logs.

`kubeadm token create --print-join-command` creates a replacement join command
when the original token expires. Rotate or revoke credentials when a node or
key is compromised.

## Scheduling behavior

Control-plane nodes are normally tainted so ordinary workloads run on workers.
A single-node training cluster can remove that taint, but doing so is a
deliberate lab exception. `cordon` prevents new scheduling, `drain` evicts
workloads safely where possible, and `uncordon` permits scheduling again.

## Availability and production differences

The three-node lab described here has one control plane and is therefore not
highly available. Losing that node can make the API unavailable even if worker
Pods continue running. Production designs generally use multiple control
planes, replicated etcd, private networking, restricted access, backups,
monitoring, upgrades, and a tested disaster-recovery plan.

## Reconciliation model

Kubernetes is declarative. A manifest expresses the desired state; controllers
continuously compare it with observed state and take corrective action. This
is why a Deployment recreates a deleted Pod and why scaling changes the
replica count rather than directly creating individual Pods.

## Learning checklist

- Explain the path from `kubectl apply` to a running Pod.
- Identify which component stores state and which component schedules Pods.
- Explain why kubeadm needs a CNI after initialization.
- Distinguish a Pod IP, Service ClusterIP, NodePort, and external address.
- Explain why a single control plane is not highly available.
- Rotate a join token and protect kubeconfig credentials.
