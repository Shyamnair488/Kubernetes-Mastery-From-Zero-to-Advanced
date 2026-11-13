#!/usr/bin/env bash
# Run on EVERY node (Ubuntu). Uses the pkgs.k8s.io repo for the minor version below.
set -euo pipefail
K8S_MINOR="v1.31"
swapoff -a && sed -i '/ swap / s/^/#/' /etc/fstab
cat >/etc/modules-load.d/k8s.conf <<EOM
overlay
br_netfilter
EOM
modprobe overlay; modprobe br_netfilter
cat >/etc/sysctl.d/k8s.conf <<EOM
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOM
sysctl --system
apt-get update && apt-get install -y apt-transport-https ca-certificates curl gpg containerd
mkdir -p /etc/containerd && containerd config default >/etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd && systemctl enable containerd
mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/${K8S_MINOR}/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${K8S_MINOR}/deb/ /" >/etc/apt/sources.list.d/kubernetes.list
apt-get update && apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
systemctl enable --now kubelet
echo "node prepared"
