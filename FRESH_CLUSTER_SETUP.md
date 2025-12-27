# Prerequisites for Fresh Kubernetes Cluster

## Minimum Requirements
- Kubernetes 1.24+
- 3+ nodes (1 control plane, 2+ workers)
- 8GB+ RAM per node
- 50GB+ storage per node

## Required Components
```bash
# Install ingress controller (if not present)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml

# Install storage provisioner (example with local-path)
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.24/deploy/local-path-storage.yaml

# Label nodes for OpenStack scheduling
kubectl label nodes <control-node> openstack-control-plane=enabled
kubectl label nodes <compute-node> openstack-compute-node=enabled
kubectl label nodes <compute-node> openvswitch=enabled
```

## Quick Deployment
```bash
# Clone and deploy
git clone <your-repo-url> openstack-gitops
cd openstack-gitops
./deploy-fresh-cluster.sh
```
