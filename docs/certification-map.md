# Certification Map (CKA · CKAD · CKS)

Check the official CNCF curriculum for current weights. Where each domain lives in this repo:

| Exam domain | Folder |
|---|---|
| Cluster architecture, install, config (CKA) | `01`, `10-cluster-setup` |
| Workloads & scheduling | `02`, `05` |
| Services & networking | `03` |
| Storage | `04` |
| Troubleshooting | `08` |
| App design & build (CKAD) – Jobs, multi-container, probes | `02`, `06`, `09` |
| App deployment – rollouts, Helm, Kustomize | `02`, `09`, `tools/03-helm` |
| Observability & maintenance | `06`, `08` |
| Environment, config & security (CKAD) | `04`, `07` |
| Cluster hardening, supply chain, runtime security (CKS) | `07`, `tools/04-trivy` |

## Exam speed tips
- `alias k=kubectl`, `export do="--dry-run=client -o yaml"`, vim: `set expandtab tabstop=2 shiftwidth=2`.
- Generate YAML imperatively, edit, apply. Use `k explain` and the allowed docs (kubernetes.io).
- Always check **context/namespace** from the question header.
