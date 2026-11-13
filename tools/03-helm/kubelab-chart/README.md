# kubelab chart
Production-style chart: Deployment, Service, optional Ingress/HPA/PDB, ConfigMap with checksum rollout, ServiceAccount (IRSA-ready), security defaults, `helm test`, values schema.
```bash
helm lint .
helm template demo . -f values-prod.yaml | less
helm upgrade --install demo . -n demo --create-namespace -f values-dev.yaml
```
See [../README.md](../README.md) for the full Helm guide.
