# OpenStack GitOps Deployment Guide

## Prerequisites

1. Kubernetes cluster (v1.24+)
2. kubectl configured
3. Helm 3.x installed
4. Git repository for storing configurations

## Current OpenStack Deployment Analysis

Your current OpenStack deployment includes:

### Core Services
- **Keystone** (Identity) - 1 replica
- **Nova** (Compute) - API, Conductor, Scheduler
- **Neutron** (Networking) - Server, Agents
- **Cinder** (Block Storage) - API, Scheduler, Volume
- **Glance** (Image) - API service
- **Placement** (Resource Placement) - API service

### Additional Services
- **Heat** (Orchestration)
- **Horizon** (Dashboard)
- **Barbican** (Key Management)
- **Magnum** (Container Orchestration)
- **Manila** (Shared File Systems)
- **Octavia** (Load Balancing)

### Infrastructure
- **Percona XtraDB** (Database)
- **RabbitMQ** (Message Queue)
- **Memcached** (Caching)
- **Valkey** (Redis-compatible)
- **Rook Ceph** (Storage)

## GitOps Migration Steps

### 1. Install ArgoCD

```bash
# Install ArgoCD CRDs first
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Or use the provided installation
kubectl apply -f argocd/argocd-install.yaml
```

### 2. Access ArgoCD UI

```bash
# Get initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Port forward to access UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### 3. Deploy OpenStack via GitOps

```bash
# Run the deployment script
./deploy.sh

# Or manually apply
kubectl apply -f argocd/openstack-project.yaml
kubectl apply -f applications/openstack-apps.yaml
```

### 4. Monitor Deployment

```bash
# Check ArgoCD applications
kubectl get applications -n argocd

# Monitor OpenStack pods
kubectl get pods -n openstack

# Check service status
kubectl get svc -n openstack
```

## Configuration Management

### Helm Values Override

Each service can be configured through Helm values in the respective chart directories:

- `charts/operators/values.yaml` - Operators configuration
- `charts/infrastructure/values.yaml` - Infrastructure services
- `charts/core-services/values.yaml` - Core OpenStack services
- `charts/compute-services/values.yaml` - Compute and additional services

### Environment-Specific Configuration

Production overrides are in `environments/production/values/production-overrides.yaml`

### Secrets Management

For production deployments, use sealed-secrets or external secret operators:

```bash
# Example with sealed-secrets
kubectl create secret generic keystone-db-password \
  --from-literal=password=your-secure-password \
  --dry-run=client -o yaml | \
  kubeseal -o yaml > sealed-keystone-db-password.yaml
```

## Monitoring and Observability

The deployment includes:
- OpenStack Exporter for Prometheus metrics
- ServiceMonitor for automatic scraping
- Database exporter for MySQL metrics

## Backup and Disaster Recovery

1. **Database Backups**: Configure Percona XtraDB backup
2. **Configuration Backup**: Git repository serves as configuration backup
3. **Persistent Volume Snapshots**: Use storage class snapshot capabilities

## Troubleshooting

### Common Issues

1. **Pod Stuck in Pending**: Check resource constraints and node selectors
2. **Database Connection Issues**: Verify database credentials and connectivity
3. **Service Discovery**: Ensure DNS resolution works between services

### Useful Commands

```bash
# Check ArgoCD sync status
argocd app list

# Force sync an application
argocd app sync openstack-core-services

# Check pod logs
kubectl logs -f deployment/keystone-api -n openstack

# Describe failing pods
kubectl describe pod <pod-name> -n openstack
```

## Security Considerations

1. **RBAC**: Implement proper role-based access control
2. **Network Policies**: Restrict inter-pod communication
3. **Secret Management**: Use external secret management systems
4. **Image Security**: Scan container images for vulnerabilities
5. **TLS**: Enable TLS for all service communications

## Scaling and Performance

### Horizontal Scaling
Adjust replica counts in values files:

```yaml
keystone:
  pod:
    replicas:
      api: 3
```

### Vertical Scaling
Configure resource limits:

```yaml
resources:
  limits:
    memory: "2Gi"
    cpu: "1000m"
  requests:
    memory: "1Gi"
    cpu: "500m"
```

## Maintenance

### Updates
1. Update Helm chart versions in Chart.yaml files
2. Commit changes to Git repository
3. ArgoCD will automatically sync changes

### Rollbacks
```bash
# Rollback via ArgoCD
argocd app rollback openstack-core-services

# Or via kubectl
kubectl rollout undo deployment/keystone-api -n openstack
```
