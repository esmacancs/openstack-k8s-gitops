#!/bin/bash

# Install ArgoCD
echo "Installing ArgoCD..."
kubectl apply -f argocd/argocd-install.yaml

# Wait for ArgoCD to be ready
echo "Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# Create OpenStack project
echo "Creating OpenStack project..."
kubectl apply -f argocd/openstack-project.yaml

# Deploy OpenStack applications
echo "Deploying OpenStack applications..."
kubectl apply -f applications/openstack-apps.yaml

echo "Deployment initiated. Monitor progress with:"
echo "kubectl get applications -n argocd"
echo "kubectl get pods -n openstack"
