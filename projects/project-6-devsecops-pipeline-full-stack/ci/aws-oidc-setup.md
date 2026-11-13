# GitHub → AWS without static keys (OIDC)

1. Create the OIDC provider (once per account):
```bash
aws iam create-open-id-connect-provider --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com
```
2. Create role `github-ecr-push` with this **trust policy** (replace placeholders):
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"Federated": "arn:aws:iam::<account-id>:oidc-provider/token.actions.githubusercontent.com"},
    "Action": "sts:AssumeRoleWithWebIdentity",
    "Condition": {
      "StringEquals": {"token.actions.githubusercontent.com:aud": "sts.amazonaws.com"},
      "StringLike":   {"token.actions.githubusercontent.com:sub": "repo:<your-username>/k8s-mastery:ref:refs/heads/main"}
    }
  }]
}
```
3. Attach a policy allowing ECR push (`ecr:GetAuthorizationToken` on `*`, and `ecr:BatchCheckLayerAvailability, InitiateLayerUpload, UploadLayerPart, CompleteLayerUpload, PutImage` on your repository ARN).
4. In GitHub → Settings → Variables: `AWS_ROLE_ARN`, `AWS_REGION`, `ECR_REPOSITORY`.
