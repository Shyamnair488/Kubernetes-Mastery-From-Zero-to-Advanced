.PHONY: cluster cluster-delete validate lint clean prereqs
prereqs:
	./scripts/check-prereqs.sh
cluster:
	minikube start --cpus=4 --memory=6g --driver=docker
	minikube addons enable ingress
	minikube addons enable metrics-server
cluster-delete:
	minikube delete
lint:
	yamllint -d "{extends: relaxed, rules: {line-length: disable}}" 0*/manifests 1*/ tools projects || true
validate:
	./scripts/validate-manifests.sh
clean:
	./scripts/cleanup-labs.sh
