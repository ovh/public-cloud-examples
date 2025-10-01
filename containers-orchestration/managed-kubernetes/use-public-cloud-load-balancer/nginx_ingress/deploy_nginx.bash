#!/bin/bash
cd "$(dirname "$0")"
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace --values ./value.yaml
