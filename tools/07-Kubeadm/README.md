# Kubeadm Kubernetes Lab on AWS

This lab builds a self-managed Kubernetes cluster with `kubeadm` on Amazon
Linux 2023 EC2 instances. It is intentionally an educational setup, not a
production high-availability design.

## What this lab teaches

- How AWS networking and security groups allow Kubernetes nodes to communicate.
- How `containerd`, `kubelet`, `kubeadm`, and `kubectl` fit together.
- How the control plane is initialized and workers join with a bootstrap token.
- Why a CNI plugin is required before nodes become `Ready`.
- How Services, scheduling, scaling, draining, and cleanup work on a
  self-managed cluster.

Read [THEORY.md](THEORY.md) before provisioning resources. Use
[single-node.md](single-node.md) for a lower-cost practice run, or follow the
multi-node outline below.

## Architecture

```text
AWS VPC 10.0.0.0/16
|
+-- Public subnet 10.0.1.0/24
    |
    +-- master  10.0.1.10  control plane + etcd
    +-- worker1 10.0.1.11  workloads
    +-- worker2 10.0.1.12  workloads
```

Each node runs Amazon Linux 2023, `containerd`, and the Kubernetes node
components. Calico supplies Pod networking. The control plane API listens on
TCP 6443, while the kubelet listens on TCP 10250.

## Lab configuration

| Resource | Recommended value |
|---|---|
| AWS region | `us-east-1` or an available region in your account |
| Availability zone | One available AZ in that region |
| VPC | `kubeadm-vpc`, `10.0.0.0/16` |
| Subnet | `kubeadm-public-subnet`, `10.0.1.0/24` |
| Security group | `kubeadm-sg` |
| Instances | Three `t3.medium` instances |
| Operating system | Amazon Linux 2023 x86_64 |
| SSH key | `kubeadm-lab.pem` |
| Pod CIDR | `192.168.0.0/16` |
| Runtime | `containerd` |
| CNI | Calico |

Use your own AWS account, region, key pair, and private IPs where needed.
Never commit `*.pem` files, tokens, kubeconfig files, or AWS credentials.

## 1. Create AWS networking

Create a VPC, public subnet, Internet Gateway, route table, and security
group. Enable public IPv4 addresses only for this disposable learning lab.

The security group should allow:

- SSH TCP 22 from your IP only.
- All traffic from the same security group for node-to-node communication.
- NodePort TCP `30000-32767` from your IP only when testing an application.

Do not expose SSH, the Kubernetes API, or the full node range to
`0.0.0.0/0`.

## 2. Launch and name the nodes

Launch one control-plane instance and two worker instances. Assign stable
private addresses if possible:

```text
master   10.0.1.10
worker1  10.0.1.11
worker2  10.0.1.12
```

On each node, set a unique hostname and add the private address mappings to
`/etc/hosts`. Substitute your actual addresses:

```bash
sudo hostnamectl set-hostname master
sudo tee -a /etc/hosts <<'EOF'
10.0.1.10 master
10.0.1.11 worker1
10.0.1.12 worker2
EOF
```

Use the matching hostname command on each worker. Confirm with:

```bash
hostname
hostname -I
getent hosts master worker1 worker2
```

## 3. Prepare every node

Run the following on all three nodes:

```bash
sudo dnf update -y
sudo dnf install -y curl wget tar conntrack-tools socat iproute-tc
sudo swapoff -a
sudo sed -i '/\sswap\s/s/^/#/' /etc/fstab
sudo modprobe overlay
sudo modprobe br_netfilter
sudo tee /etc/sysctl.d/k8s.conf <<'EOF'
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system
```

Install and configure `containerd` with systemd cgroups:

```bash
sudo dnf install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl enable --now containerd
sudo systemctl restart containerd
```

If SELinux is enforcing, follow the lab guidance in
[single-node.md](single-node.md) and treat any permissive configuration as
temporary and lab-only.

## 4. Install Kubernetes packages

Install the same supported Kubernetes minor version on every node. The
repository URL below is an example; check the current Kubernetes packaging
instructions before starting a new lab:

```bash
cat <<'EOF' | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.34/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.34/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
sudo dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet
```

Verify:

```bash
kubeadm version
kubelet --version
kubectl version --client
```

## 5. Initialize the control plane

Run on `master` only:

```bash
sudo kubeadm init \
  --apiserver-advertise-address=10.0.1.10 \
  --pod-network-cidr=192.168.0.0/16 \
  --cri-socket=unix:///run/containerd/containerd.sock
```

Save the `kubeadm join` command printed at the end. Configure kubectl:

```bash
mkdir -p "$HOME/.kube"
sudo cp /etc/kubernetes/admin.conf "$HOME/.kube/config"
sudo chown "$(id -u):$(id -g)" "$HOME/.kube/config"
chmod 600 "$HOME/.kube/config"
```

The control-plane node may remain `NotReady` until a CNI is installed.

## 6. Install the CNI and join workers

On `master`, install Calico using its current official instructions. Then
run the saved `kubeadm join` command on `worker1` and `worker2`.

```bash
kubectl get nodes
kubectl get pods -A
```

All nodes should eventually report `Ready`. Never publish the join token; if
it expires, generate a new command:

```bash
kubeadm token create --print-join-command
```

## 7. Verify and practice

```bash
kubectl get nodes -o wide
kubectl get pods -A
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --type=NodePort --port=80
kubectl get svc nginx
kubectl scale deployment nginx --replicas=3
kubectl rollout status deployment/nginx
```

Test the assigned NodePort through a node's reachable address. Practice
`kubectl describe`, logs, rollout history, node cordoning, draining, and
uncordon before deleting the application.

## 8. Cleanup

On workers and then the control plane:

```bash
sudo kubeadm reset -f
sudo systemctl disable --now kubelet
```

Terminate all EC2 instances and delete the security group, route table,
Internet Gateway, subnet, and VPC. Confirm that no public IPv4 or other
billable AWS resources remain.

## Related material

- [Kubeadm theory](THEORY.md)
- [Single-node guide](single-node.md)
- [EC2 Kubeadm procedure](ec2-kubeadm/README.md)
- [Command reference](examples/01-basic-commands.md)
- [Multi-node guide](examples/03-multi-node.md)
- [Networking exercises](examples/04-networking.md)
- [Kubeadm vs EKS vs Minikube](difference.md)
