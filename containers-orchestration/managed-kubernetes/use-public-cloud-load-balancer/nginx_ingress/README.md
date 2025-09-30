# Install Nginx Ingress Controller on OVHcloud Managed Kubernetes Service

## Description

This documentation explains how to deploy the [Nginx Ingress Controller](https://kubernetes.github.io/ingress-nginx/) on **OVHcloud Managed Kubernetes Service**.  
The Ingress Controller enables you to expose your HTTP(S) applications running inside the cluster by defining Kubernetes Ingress resources.

---

## Prerequisites

- An existing **OVHcloud Managed Kubernetes cluster** (
- **kubectl** installed and configured with your cluster credentials.  
- **Helm** installed ([Installation guide](https://helm.sh/docs/intro/install/)).
- **Cert-Manager** installed for TLS certificate management ([Documentation](https://cert-manager.io/docs/)).

---

## Installation

1. **Add the Helm repository for ingress-nginx**:
   ```bash
   helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
   helm repo update
   ```

2. **Deploy Nginx Ingress Controller** in your cluster:
   ```bash
   helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace --values ./values.yaml
   ```
 3. **Deploy the ClusterIssuer for Cert-Manager**:  
    Deploy the ClusterIssuer as described on `acme-config.yml` :
    ```yaml
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: main
    spec:
      acme:
        # The ACME server URL
        server: https://acme-v02.api.letsencrypt.org/directory
        # Email address used for ACME registration
        email: email@example.com
        # Name of a secret used to store the ACME account private key
        privateKeySecretRef:
          name: letsencrypt-prod
        # Enable the HTTP-01 challenge provider
        solvers:
        - http01:
            ingress:
              class: nginx
    ```
    
    To do so, apply it using:
    ```bash
    kubectl apply -f acme-config.yml
    ```
---

## Verification

Check that the Ingress Controller pods are running:
```bash
kubectl get pods -n ingress-nginx
```

Retrieve the **external IP or hostname** automatically provisioned by OVHcloud LoadBalancer:
```bash
kubectl get svc ingress-nginx-controller -n ingress-nginx
```

⚠️ On OVHcloud Managed Kubernetes Service, the LoadBalancer service type automatically provisions an external IP from OVHcloud infrastructure. This IP/hostname must be configured in your DNS records.

---

## Next Steps

1. **Configure your DNS records**:  
   Point your application’s domain name (e.g. `myapp.example.com`) to the LoadBalancer external IP/hostname obtained in the previous step.

2. **Create an Ingress resource** to route traffic to your application.  
   Deploy your Ingress using the example `ingress_base.yaml` with TLS using Cert-Manager and Let’s Encrypt:
   ```yaml
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     annotations:
       cert-manager.io/cluster-issuer: "main"
     name: ngx-deploy-ingress
   spec:
     ingressClassName: nginx
     tls:
     - hosts:
       - myapp.example.com
       secretName: octavia-secret
     rules:
     - host: myapp.example.com
       http:
         paths:
         - path: /
           pathType: Prefix
           backend:
             service:
               name: nginx-deployment
               port:
                 number: 80
   ```

---

## Useful Links
- [Nginx Ingress Controller Documentation](https://kubernetes.github.io/ingress-nginx/)
- [Helm Documentation](https://helm.sh/docs/)
- [Cert-Manager Documentation](https://cert-manager.io/docs/)
