#!/usr/bin/env bash
# Deletes all lab namespaces created by this repo.
for ns in lab demo dev staging prod kubelab keda-demo; do
  kubectl delete ns "$ns" --ignore-not-found
done
