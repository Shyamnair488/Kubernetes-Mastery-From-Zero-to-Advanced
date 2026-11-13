#!/usr/bin/env bash
# Usage: ./produce.sh [N]  -> pushes N jobs to the Redis list
N="${1:-100}"
kubectl exec -n autoscale-lab deploy/redis -- sh -c "i=1; while [ \$i -le $N ]; do redis-cli RPUSH jobs task-\$i >/dev/null; i=\$((i+1)); done; redis-cli LLEN jobs"
