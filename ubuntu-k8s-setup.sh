#!/bin/bash

# Ubuntu 24.04 Kubernetes Setup for OpenStack GitOps

set -e

echo "=== Setting up Kubernetes on Ubuntu 24.04 ==="

# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install k3s (lightweight Kubernetes)
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

# Setup kubeconfig
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config

# Label node for OpenStack
kubectl label nodes $(hostname) openstack-control-plane=enabled openstack-compute-node=enabled openvswitch=enabled

echo "=== Kubernetes ready! ==="
echo "Deploy OpenStack: git clone https://github.com/esmacancs/openstack-k8s-gitops.git && cd openstack-k8s-gitops && ./deploy-fresh-cluster.sh"
