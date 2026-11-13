#!/usr/bin/env bash
set -euo pipefail
AWS_REGION="${AWS_REGION:-ap-south-1}"
REPO="${REPO:-k8s-sample}"
VERSION="${VERSION:-1.0}"
ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
REGISTRY="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
IMAGE_URI="${REGISTRY}/${REPO}:${VERSION}"

aws ecr describe-repositories --repository-names "$REPO" --region "$AWS_REGION" >/dev/null 2>&1 || \
  aws ecr create-repository --repository-name "$REPO" --region "$AWS_REGION" \
    --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=AES256

aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$REGISTRY"
docker buildx build --platform linux/amd64 -t "$IMAGE_URI" --push "$(dirname "$0")/../app"
echo "$IMAGE_URI" > "$(dirname "$0")/../.image-uri"
echo "✅ pushed $IMAGE_URI"
