# kubectl & Kubernetes Cheatsheet

## Setup
```bash
alias k=kubectl; source <(kubectl completion bash); complete -o default -F __start_kubectl k
export do="--dry-run=client -o yaml"     # k run x --image=nginx $do
```
## Contexts
`k config get-contexts` · `k config use-context X` · `k config set-context --current --namespace=lab`

## Create / generate YAML fast
```bash
k run web --image=nginx:1.27 --port=80 $do
k create deploy web --image=nginx:1.27 --replicas=3 $do
k expose deploy web --port=80 --target-port=80 --type=ClusterIP $do
k create cm app --from-literal=k=v $do
k create secret generic s --from-literal=p=x $do
k create job j --image=busybox -- echo hi $do
k create cronjob c --image=busybox --schedule="*/5 * * * *" -- date $do
k create sa dev-sa ; k create role r --verb=get,list --resource=pods $do
k create rolebinding rb --role=r --serviceaccount=lab:dev-sa $do
k create ingress i --rule="host/path=svc:80" $do
k autoscale deploy web --min=2 --max=10 --cpu-percent=60
```
## Inspect
```bash
k get all -n lab            k get po -A -o wide         k get po --show-labels
k get po -l app=web         k get po --field-selector status.phase=Running
k get po -o custom-columns=NAME:.metadata.name,NODE:.spec.nodeName
k get po -o jsonpath='{.items[*].metadata.name}'
k get po --sort-by=.metadata.creationTimestamp
k describe X                k explain pod.spec.containers --recursive
k get events --sort-by=.lastTimestamp
k top nodes / pods          k api-resources             k api-versions
```
## Change
```bash
k apply -f f.yaml | k apply -k dir/ | k apply -f dir/ -R
k edit deploy web           k patch deploy web -p '{"spec":{"replicas":5}}'
k set image deploy/web nginx=nginx:1.27.1
k set resources deploy/web --limits=cpu=200m,memory=128Mi
k scale deploy web --replicas=5
k label po x a=b            k annotate po x a=b
k delete po x --force --grace-period=0
k replace --force -f f.yaml
```
## Rollouts
`k rollout status|history|undo|restart|pause|resume deploy/web`

## Debug
```bash
k logs po -c c --previous -f --tail=100 --since=10m
k exec -it po -- sh         k cp po:/path ./local
k port-forward svc/web 8080:80
k debug -it po --image=busybox --target=c
k run t --rm -it --image=nicolaka/netshoot -- bash
k auth can-i create pods --as=system:serviceaccount:lab:dev-sa
```
## Nodes
`k cordon|uncordon|drain NODE` · `k taint nodes N k=v:NoSchedule` · `k label nodes N k=v`

## Resource shortnames
po pods · svc services · deploy deployments · rs replicasets · sts statefulsets · ds daemonsets · cm configmaps · pv/pvc · sa serviceaccounts · ns namespaces · ing ingresses · netpol networkpolicies · hpa · pdb · sc storageclasses · crd

## Manifest skeletons
```yaml
# Pod resources/probes/securityContext: see 06 and 07
# Deployment selector.matchLabels MUST match template.metadata.labels
```
## Helm quick
`helm repo add/update` · `helm install/upgrade --install` · `helm list -A` · `helm rollback` · `helm template` · `helm lint`

## Ports to remember
API 6443 · etcd 2379-2380 · kubelet 10250 · scheduler 10259 · controller 10257 · NodePort 30000-32767 · CoreDNS 53
