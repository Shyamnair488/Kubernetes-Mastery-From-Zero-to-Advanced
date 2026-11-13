# Kubernetes Interview Q&A (by level)

## Basic
1. **What is Kubernetes?** Open-source container orchestrator: scheduling, self-healing, scaling, service discovery, rollouts.
2. **Pod vs container?** Pod = wrapper with shared network/storage around 1+ containers.
3. **ReplicaSet vs Deployment?** RS keeps N pods; Deployment manages RS versions → rolling updates/rollback.
4. **Service types?** ClusterIP, NodePort, LoadBalancer, ExternalName (+ headless).
5. **ConfigMap vs Secret?** non-sensitive vs sensitive (base64; enable etcd encryption).
6. **Namespaces?** logical isolation of names/quotas/RBAC.
7. **Labels/selectors?** how Services/controllers find Pods.

## Intermediate
8. **Explain rolling updates & how to roll back.** maxSurge/maxUnavailable; `rollout undo`.
9. **Liveness vs readiness vs startup probe?** restart / remove from LB / protect slow start.
10. **requests vs limits; QoS classes?** scheduling vs ceiling; Guaranteed/Burstable/BestEffort.
11. **StatefulSet vs Deployment?** identity, ordered, per-pod PVC.
12. **How does a Service route traffic?** selector → EndpointSlices → kube-proxy (iptables/IPVS) → Pod.
13. **Ingress vs LoadBalancer?** L7 many-services-one-LB vs L4 one-LB-per-service.
14. **PV/PVC/StorageClass flow?** claim → binds/provisions PV via class.
15. **Taints vs affinity?** repel vs attract.
16. **How does HPA compute replicas?** `ceil(cur × currentMetric/target)`.
17. **Job vs CronJob?** once vs scheduled.

## Advanced
18. **Pod stuck Pending/CrashLoop—how debug?** describe → events → logs --previous → exec/debug.
19. **Describe what happens on `kubectl apply`.** authN → authZ → admission → etcd → controllers → scheduler → kubelet.
20. **RBAC design for least privilege?** Roles per namespace, SA per app, no wildcards, audit with `can-i`.
21. **Securing a cluster?** PSA restricted, NetworkPolicy default-deny, image scanning (Trivy), signed images, secrets mgmt, private endpoint, audit logs.
22. **What is an Operator/CRD?** Extend API + reconcile loop.
23. **Zero-downtime deploys?** readiness probes, maxUnavailable 0, PDB, preStop + graceful shutdown, enough replicas.
24. **HPA vs KEDA vs Cluster Autoscaler vs Karpenter?** pods(metrics) / pods(events, 0) / nodes(ASG) / nodes(just-in-time).
25. **GitOps vs traditional CI/CD?** pull-based reconciliation, drift detection, Git audit trail.
26. **Helm vs Kustomize?** templating+packaging+releases vs overlay patches.
27. **etcd backup & restore?** `etcdctl snapshot save/restore`; Velero for objects+volumes.
28. **Upgrade strategy?** one minor at a time, control plane → nodes, PDBs, test in staging, drain/cordon.
29. **Multi-AZ HA?** topology spread, anti-affinity, PDB, zonal PV awareness (WaitForFirstConsumer).
30. **Cost optimization on EKS?** right-size requests, Spot + Karpenter consolidation, scale-to-zero (KEDA), Graviton, cleanup LBs/PVs.
