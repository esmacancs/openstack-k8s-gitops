# Production Environment Configuration

This directory contains production-specific configurations for the OpenStack deployment.

## Configuration Files

- `kustomization.yaml` - Kustomize configuration for production
- `values/` - Environment-specific Helm values
- `secrets/` - Sealed secrets for production (not included in this example)

## Usage

The ArgoCD applications reference this environment configuration to deploy OpenStack with production settings.
