# EC2 Kubeadm Quick Checklist

Use this checklist with [README.md](README.md). It is intentionally free of
real instance IDs, IP addresses, tokens, keys, or external personal links.

1. Create one control-plane EC2 instance and two worker instances.
2. Place all nodes in the same VPC, subnet, and dedicated security group.
3. Allow SSH only from your workstation IP. Allow required Kubernetes traffic
   only between members of the cluster security group.
4. Use the same supported Amazon Linux release, instance architecture, and
   Kubernetes minor version on every node.
5. Configure hostnames, swap, kernel modules, sysctl values, and containerd on
   all nodes.
6. Install `kubeadm`, `kubelet`, and `kubectl` on all nodes.
7. Run `kubeadm init` on the control plane with a non-overlapping Pod CIDR.
8. Configure `kubectl` from `/etc/kubernetes/admin.conf`.
9. Install exactly one CNI plugin.
10. Generate a fresh join command on the control plane:

    ```bash
    sudo kubeadm token create --print-join-command
    ```

11. Run the generated command on each worker.
12. Verify the cluster:

    ```bash
    kubectl get nodes -o wide
    kubectl get pods -n kube-system
    ```

Never commit PEM files, kubeconfig files, join tokens, AWS credentials,
instance IDs, or public IP addresses.
