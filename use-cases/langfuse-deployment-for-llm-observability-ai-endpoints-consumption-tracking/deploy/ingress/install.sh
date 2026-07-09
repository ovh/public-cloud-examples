#!/usr/bin/env bash
set -euo pipefail

helm repo add traefik https://traefik.github.io/charts
helm repo update traefik

TRAEFIK_CHART_VERSION="41.0.1"

helm upgrade --install traefik \
  traefik/traefik \
  --version "$TRAEFIK_CHART_VERSION" \
  -n traefik \
  --create-namespace \
  --wait --timeout 3m
