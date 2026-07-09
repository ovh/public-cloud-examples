#!/usr/bin/env bash
set -euo pipefail

helm repo add langfuse https://langfuse.github.io/langfuse-k8s
helm repo update langfuse

LANGFUSE_CHART_VERSION="1.5.36"

helm upgrade --install langfuse \
  langfuse/langfuse \
  --version "$LANGFUSE_CHART_VERSION" \
  -n langfuse \
  -f "$(dirname "$0")/values.yaml" \
  --wait --timeout 5m
