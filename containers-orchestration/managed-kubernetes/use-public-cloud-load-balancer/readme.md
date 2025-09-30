## Use OVHcloud Public Load Balancer

### Examples

├── [basic_lb](./basic_lb) \
├── [basic_lb_keepip](./basic_lb_keepip) \
├── [basic_lb_udp_tcp](./basic_lb_udp_tcp) \
├── [basic_lb_with_flavor](./basic_lb_with_flavor) \
├── [nginx_basic](./nginx_basic) \
├── [nginx_ingress](./nginx_ingress) \
├── [private_lb](./private_lb) \
├── [resize_lb](./resize_lb) \
└── [tcp_tweak_lb](./tcp_tweak_lb)


### General Information
This set of example aim to help you to use OVHcloud Public Cloud Load Balancer to expose your app hosted on [Managed Kubernetes Service (MKS)](https://www.ovhcloud.com/en/public-cloud/kubernetes/).

If you're not comfortable with the different ways of exposing your applications in Kubernetes, or if you're not familiar with the notion of service type 'loadbalancer', we do recommend to start by reading the guide explaining how to [Expose your app deployed on an OVHcloud Managed Kubernetes Service](https://help.ovhcloud.com/csm/en-ie-public-cloud-kubernetes-using-lb?id=kb_article_view&sysparm_article=KB0050008), you can find the details on different methods to expose your containerized applications hosted in Managed Kubernetes Service.

Our Public Cloud Load Balancer is relying on Openstack Octavia project, this project provides a Cloud Controller Manager (CCM) allowing Kubernetes clusters to interact with Load Balancers. For Managed Kubernetes Service (MKS), this Cloud Controller is installed and configured by our team allowing you to easily create, use and configure our Public Cloud Load Balancers. You can find the CCM opensource project documentation [here](https://github.com/kubernetes/cloud-provider-openstack/blob/master/docs/openstack-cloud-controller-manager/expose-applications-using-loadbalancer-type-service.md)

This guide uses some concepts that are specific to our Public Cloud Load Balancer (listener, pool, health monitor, member, ...)  and to the OVHcloud Public Cloud Network (Gateway, Floating IP). You can find more informations regarding Public Cloud Network products concepts on our official documentation, for example [network concepts](https://help.ovhcloud.com/csm/worldeuro-documentation-public-cloud-network-concepts?id=kb_browse_cat&kb_id=574a8325551974502d4c6e78b7421938&kb_category=9a19a664ede06d102d4c139330b8ce8f) and [loadbalancer concept](https://help.ovhcloud.com/csm/en-ie-public-cloud-network-concepts?id=kb_article_view&sysparm_article=KB0050139)


### Prerequisites
To be able to deploy a [Public Cloud Load Balancer](https://www.ovhcloud.com/en-ie/public-cloud/load-balancer/), you should have a running Managed Kubernetes Service and it must run or have been upgraded to the following patch versions:

| Kubernetes versions |
|-------------|
| 1.24.13-3>= |   
| 1.25.9-3>=  |   
| 1.26.4-3>=  |   
| 1.27>=      |  


### Setup
- Deployment of a functional Managed Kubernetes (MKS) cluster using the [OVHcloud manager](https://help.ovhcloud.com/csm/en-ie-public-cloud-kubernetes-create-cluster?id=kb_article_view&sysparm_article=KB0037221), [Terraform](https://help.ovhcloud.com/csm/en-ie-public-cloud-kubernetes-create-cluster-with-terraform?id=kb_article_view&sysparm_article=KB0049684), [Pulumi](https://help.ovhcloud.com/csm/en-ie-public-cloud-kubernetes-create-cluster-with-pulumi?id=kb_article_view&sysparm_article=KB0059712) or [APIs](https://api.ovh.com/console-preview/?section=%2Fcloud&branch=v1#post-/cloud/project/-serviceName-/kube).
- Retrieve the kubeconfig file needed to use kubectl tool (via OVHcloud manager, Terraform, Pulumi or API). You can use [this guide](https://help.ovhcloud.com/csm/en-ie-public-cloud-kubernetes-configure-kubectl?id=kb_article_view&sysparm_article=KB0049658)

### Demo

Here's a simple example of how to use the Public Cloud Load Balancer

1. Create a Namespace and a Deployment resource using the following command:
```shell
kunectl create namespace test-lb-ns
kubectl create deployment test-lb --image=nginx -n=test-lb-ns
```
2. Copy/Paste the following code on a file named `test-lb-service.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: test-lb
  name: test-lb-service
  namespace: test-lb-ns
  annotations:
    loadbalancer.ovhcloud.com/flavor: "small"
spec:
  ports:
  - name: 80-80
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: test-lb
  type: LoadBalancer
```
3. Create a 'Service' using the following command:
```shell
kubectl apply -f test-lb-service.yaml
```
4. Retrieve Service IP address using the following command line:
```shell
$ kubectl get service test-lb-service -n=test-lb-ns
NAME                 TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)        AGE
test-lb-service      LoadBalancer   10.3.107.18   xx.xx.xx.xx   80:30172/TCP   12m
```
5. Open a web browser and access: http://141.94.215.240
