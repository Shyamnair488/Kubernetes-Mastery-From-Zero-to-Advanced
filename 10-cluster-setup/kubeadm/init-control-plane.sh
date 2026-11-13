#!/usr/bin/env bash
# Run on the control-plane node only.
set -euo pipefail
POD_CIDR="10.244.0.0/16"
kubeadm init --pod-network-cidr="${POD_CIDR}"
mkdir -p "$HOME/.kube" && cp /etc/kubernetes/admin.conf "$HOME/.kube/config" && chown "$(id -u):$(id -g)" "$HOME/.kube/config"
# CNI: Flannel (simple). For NetworkPolicy use Calico or Cilium instead.
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
echo "Join command for workers:"; kubeadm token create --print-join-command
