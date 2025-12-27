#!/bin/bash

# Fresh Kubernetes Cluster Deployment Script

set -e

echo "=== OpenStack GitOps Deployment on Fresh K8s Cluster ==="

# Check prerequisites
echo "Checking prerequisites..."
kubectl cluster-info || { echo "kubectl not configured or cluster not accessible"; exit 1; }
helm version || { echo "Helm not installed"; exit 1; }

# Install ArgoCD CRDs and operator
echo "Installing ArgoCD..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
echo "Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=available --timeout=600s deployment/argocd-server -n argocd

# Create OpenStack namespace
echo "Creating OpenStack namespace..."
kubectl create namespace openstack --dry-run=client -o yaml | kubectl apply -f -

# Apply OpenStack project and applications
echo "Deploying OpenStack applications..."
kubectl apply -f argocd/openstack-project.yaml
kubectl apply -f applications/

echo "=== Deployment Complete ==="
echo "ArgoCD UI: kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "Initial admin password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
echo "Monitor: kubectl get applications -n argocd"
