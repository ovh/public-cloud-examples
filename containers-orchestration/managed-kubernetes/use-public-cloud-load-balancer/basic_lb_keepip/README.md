# Basic Public Cloud Load Balancer and Keep/Re-use IP demo

## Description
[lb_keepip.yaml](./lb_keepip.yaml) is an example of how to keep the Public Floating IP attached to your Public Cloud LoadBalancer even if you delete your Service/LoadBalancer. In case of Service and LoadBalancer deletion, the Floating IP will be unbound and will remains available on your OVHcloud Public Cloud project. 

Using [lb_keepip_reuse_or_already_existing_in_tenant.yaml](./lb_keepip_reuse_or_already_existing_in_tenant.yaml) you can use (or re-use) an existing Floating IP available on your OVHcloud Public Cloud project.
