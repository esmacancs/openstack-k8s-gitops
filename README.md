# OpenStack GitOps Deployment

This repository contains the GitOps configuration for deploying OpenStack on Kubernetes using ArgoCD.

## Structure

```
openstack-gitops/
├── argocd/                    # ArgoCD installation and configuration
├── applications/              # ArgoCD Application definitions
├── charts/                    # Helm chart configurations
└── environments/              # Environment-specific configurations
    └── production/            # Production environment
```

## Services Deployed

- Keystone (Identity Service)
- Nova (Compute Service)
- Neutron (Networking Service)
- Cinder (Block Storage Service)
- Glance (Image Service)
- Heat (Orchestration Service)
- Horizon (Dashboard)
- Barbican (Key Management)
- Magnum (Container Orchestration)
- Manila (Shared File Systems)
- Octavia (Load Balancing)
- Supporting services (RabbitMQ, Percona XtraDB, Memcached, etc.)

## Deployment

1. Install ArgoCD
2. Apply the ArgoCD applications
3. Monitor deployment status
