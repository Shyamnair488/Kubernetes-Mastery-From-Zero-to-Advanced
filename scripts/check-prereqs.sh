#!/usr/bin/env bash
# Verifies required tools are installed.
for t in docker kubectl minikube helm git; do
  if command -v "$t" >/dev/null 2>&1; then echo "✅ $t: $($t version --client 2>/dev/null | head -1 || true)"; else echo "❌ $t not found"; fi
done
for t in trivy eksctl aws terraform kubeconform yamllint; do
  command -v "$t" >/dev/null 2>&1 && echo "✅ (optional) $t" || echo "⚪ (optional) $t not installed"
done
