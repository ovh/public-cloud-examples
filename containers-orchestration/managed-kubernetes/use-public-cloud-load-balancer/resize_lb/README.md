# Resize your LoadBalancer

## Objective
There is no proper way to 'resize' your Load Balancer from one flavor to another yet (see the related [github issue](https://github.com/ovh/public-cloud-roadmap/issues/418) for more information). The best alternative to change the flavor of your load balancer is to recreate a new Kubernetes Service that will use the same public IP as an existing one.

OVHcloud Public Cloud LoadBalancer flavors: https://help.ovhcloud.com/csm/en-ie-public-cloud-network-octavia-use-lbaas-openstack?id=kb_article_view&sysparm_article=KB0050296

## Prerequisites for MKS standard plan

* Get a running MKS cluster with a MKS Standard plan,

* Prepare an authenticated OpenStack CLI for your Public Cloud project, make sure you consult the following guides:
  - [Prepare the environment to use the OpenStack API](https://help.ovhcloud.com/csm/en-ie-public-cloud-compute-prepare-openstack-api-environment?id=kb_article_view&sysparm_article=KB0051001) by installing python-openstackclient.
  - [Load the OpenStack environment variables](https://help.ovhcloud.com/csm/en-ie-public-cloud-compute-set-openstack-environment-variables?id=kb_article_view&sysparm_article=KB0050930).

* Select a flavor for your loadbalancer. [More information](https://www.ovhcloud.com/en/public-cloud/load-balancer/)

* Get the ID of the flavor your selected, using `openstack loadbalancer flavor list`

```console
+-----+--------+--------------------------------------+---------+
| id  | name   | flavor_profile_id                    | enabled |
+-----+--------+--------------------------------------+---------+
| zzz | large  | e23251e0-5ae0-4d03-824d-f3c3f5ab352c | True    |
| aaa | xl     | e5e1111e-23ff-4f4a-978b-ea720e8911b5 | True    |
| xxx | small  | 369f5329-86cb-40c8-b555-c8de09262966 | True    |
| yyy | medium | b3f09d32-9c2d-4835-b0f5-12ba58bd8339 | True    |
+-----+--------+--------------------------------------+---------+
```

* Replace the`yyy` pattern in the file `3_medium_service_deploy.yaml` before executing the following steps.

## Example of a Load Balancer resize

On this example, a Load Balancer will be created using the 'small' flavor (it is selected by default when no annotation is given). Then we will make sure that the Public IP will not be released from your project and finally we will create a new loadBalancer using a 'medium' flavor that will replace the old one and use the same Public IP.

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
octavia-small-to-upgrade   LoadBalancer   10.3.36.237   xx.xx.xx.xx  80:31146/TCP   38s
```

Add and Apply the `keep-floatingip` annotation (can be applied at the first step)
```shell
kubectl apply -f 2_small_service.yaml -n demo-resize
```

Get the public IP (EXTERNAL-IP) of your existing service
```shell
$ kubectl get service octavia-small-to-upgrade -n demo-resize
NAME                       TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)        AGE
octavia-small-to-upgrade   LoadBalancer   10.3.36.237   xx.xx.xx.xx    80:31146/TCP   2m15s
```

Create a new service with the new expected flavor. To do so edit the `3_medium_service_deploy.yaml` manifest file to change the 'loadBalancerIP' then apply:
```yaml
spec:
  loadBalancerIP: xx.xx.xx.xx # Public Floating IP address from the old service
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
