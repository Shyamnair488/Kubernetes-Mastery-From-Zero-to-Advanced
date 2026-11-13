#!/usr/bin/env bash
# Schema-validate all plain Kubernetes manifests with kubeconform.
set -e
command -v kubeconform >/dev/null || { echo "Install kubeconform: https://github.com/yannh/kubeconform"; exit 1; }
find . -path ./projects -prune -o -path "*/manifests/*.yaml" -print | xargs kubeconform -strict -ignore-missing-schemas -summary
find projects -path "*/k8s/*.yaml" -print | xargs kubeconform -strict -ignore-missing-schemas -summary
