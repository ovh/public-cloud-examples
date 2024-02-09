# Resize your LoadBalancer

### Objective
There is no proper way to 'resize' your Load Balancer from one flavor to another yet (work in progress). The best alternative to change the flavor of your load balancer is to recreate a new Kubernetes Service that will use the same public IP as an existing one.

OVHcloud Public Cloud LoadBalancer flavors: https://help.ovhcloud.com/csm/en-ie-public-cloud-network-octavia-use-lbaas-openstack?id=kb_article_view&sysparm_article=KB0050296

### Example

On this example we will create a LoadBalancer using a 'small' flavor, then we will make sure that the Public IP will not be released from your project and finally we will create a new loadBalancer using a 'medium' flavor that will replace the old one and use the same Public IP.

Deploy a Load Balancer Service using a 'small' flavor
```shell
$ kubectl create namespace demo-resize
namespace/demo-resize created
$ kubectl apply -f 1_small_service.yaml -n demo-resize
```

Wait Load Balancer delivery
```shell
$ kubectl get service -n demo-resize
NAME                       TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
octavia-small-to-upgrade   LoadBalancer   10.3.36.237   57.128.57.47  80:31146/TCP   38s
```

Add and Apply the `keep-floatingip` annotation (can be applied at the first step)
```shell
kubectl apply -f 2_small_service.yaml -n demo-resize
```

Get the public IP (EXTERNAL-IP) of your existing service
```shell
$ kubectl get service octavia-small-to-upgrade -n demo-resize
NAME                       TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)        AGE
octavia-small-to-upgrade   LoadBalancer   10.3.36.237   57.128.57.47    80:31146/TCP   2m15s
```

Create a new service with the new expected flavor. To do so edit the 3_medium_service_deploy manifest to change the 'loadBalancerIP' then apply:
```yaml
spec:
  loadBalancerIP: 57.128.57.47 # Public Floating IP address from the previous service
```
```shell
$ kubectl apply -f 3_medium_service_deploy.yaml -n demo-resize
```

Until the deletion of the previous service, this Service will only deploy the LoadBalancer without a floating IP.
```shell
$ kubectl get service -n demo-resize
NAME                       TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)        AGE
octavia-medium-upgraded    LoadBalancer   10.3.182.241   <pending>       80:31619/TCP   88s
octavia-small-to-upgrade   LoadBalancer   10.3.36.237    xx.xx.xx.xx    80:31146/TCP   5m5s
```

Delete your old service to release the Floating IP so it can be assigned to the new one.
```shell
$ kubectl delete service octavia-small-to-upgrade -n demo-resize
service "octavia-small-to-upgrade" deleted
$ kubectl get service -n demo-resize
NAME                       TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)        AGE
octavia-medium-upgraded    LoadBalancer   10.3.182.241   <pending>       80:31619/TCP   2m3s
```

This may take a few minutes as your service will make several retry (as long as the FloatingIP is not detached) with a delay between each attempt.
```shell
$ kubectl get service -n demo-resize
NAME                       TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)        AGE
octavia-medium-upgraded    LoadBalancer   10.3.182.241   xx.xx.xx.xx    80:31619/TCP   5m3s
```
> [!warning]
>
> Changing the flavor will lead to a new LoadBalancer creation and old LoadBalancer deletion. During this changeover your applications may become inaccessible.
>
