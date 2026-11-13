#!/usr/bin/env bash
# Installs AWS Load Balancer Controller on an EKS cluster with OIDC enabled.
set -euo pipefail
CLUSTER_NAME="${CLUSTER_NAME:-k8s-lab}"
AWS_REGION="${AWS_REGION:-ap-south-1}"
ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"

curl -fsSLo /tmp/iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file:///tmp/iam_policy.json 2>/dev/null || true

eksctl create iamserviceaccount --cluster "$CLUSTER_NAME" --region "$AWS_REGION" \
  --namespace kube-system --name aws-load-balancer-controller \
  --attach-policy-arn "arn:aws:iam::${ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy" \
  --override-existing-serviceaccounts --approve

helm repo add eks https://aws.github.io/eks-charts && helm repo update
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system \
  --set clusterName="$CLUSTER_NAME" --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller
kubectl rollout status deploy/aws-load-balancer-controller -n kube-system
