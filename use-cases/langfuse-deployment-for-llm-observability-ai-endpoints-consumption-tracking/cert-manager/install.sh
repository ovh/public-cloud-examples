#!/usr/bin/env bash
set -euo pipefail

CERT_MANAGER_VERSION="v1.20.3"

helm upgrade --install cert-manager \
  oci://quay.io/jetstack/charts/cert-manager \
  --version "$CERT_MANAGER_VERSION" \
  -n cert-manager \
  --create-namespace \
  --set crds.enabled=true
