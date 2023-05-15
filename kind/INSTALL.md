# Kind Install Instructions

- Download & Install [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installing-from-release-binaries)
- Create a new cluster with `kind create cluster --name k8s-experiments --config kind-config.yaml`
- Verify the cluster is running with `kubectl cluster-info --context kind-k8s-experiments`
- (optional) Verify the nodes are running with `kubectl get nodes --context kind-k8s-experiments`
- (optional) Get KubeConfig with `kind get kubeconfig --name k8s-experiments > ~/.kube/config`