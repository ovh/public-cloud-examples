## Use image from a MRS with OVHcloud Managed Kubernetes

### Setup

  - Deploy a MKS cluster
  - Install the kubectl CLI
  - Install the kustomize CLI

### Demo

  - set the environment variables:

```bash
# OVHcloud provider needed keys
export PRIVATE_REGISTRY_URL="xxx"
export PRIVATE_REGISTRY_USER="xxx"
export PRIVATE_REGISTRY_PASSWORD="xxx"
export PRIVATE_REGISTRY_PROJECT="xxx"
export PRIVATE_REGISTRY_URL_WITHOUT_SCHEME=${PRIVATE_REGISTRY_URL#*//}

export KUBE_CLUSTER="xxx"
```

  - Create the Secret

```bash
kubectl --kubeconfig=$KUBE_CLUSTER create secret docker-registry ovhregistrycred \
    --docker-server=$PRIVATE_REGISTRY_URL \
    --docker-username=$PRIVATE_REGISTRY_USER \
    --docker-password=$PRIVATE_REGISTRY_PASSWORD
```

  - Check the secret has been correctly deployed in your Kubernetes cluster:

```bash
kubectl --kubeconfig=$KUBE_CLUSTER get secret ovhregistrycred -o jsonpath="{.data.\.dockerconfigjson}"
```

  - Edit the app's image with the created registry and project

```bash
cd overlays/wescale

kustomize edit set image hello-ovh="${PRIVATE_REGISTRY_URL_WITHOUT_SCHEME}/${PRIVATE_REGISTRY_PROJECT}/hello-ovh:1.0.0-linuxamd64"
```

 - Deploy an app (linked to the created private registry)

```bash
kustomize build . | kubectl --kubeconfig=$KUBE_CLUSTER apply -f -
```

  - Check the app is running correctly (and image have been pulled successfully)

```bash
kubectl --kubeconfig=$KUBE_CLUSTER get po -l app=hello-ovh
kubectl --kubeconfig=$KUBE_CLUSTER describe po -l app=hello-ovh 
```

  - Display the result

```bash
export SERVICE_URL=$(kubectl --kubeconfig=$KUBE_CLUSTER get svc hello-ovh -o jsonpath='{.status.loadBalancer.ingress[].ip}')

curl $SERVICE_URL
```