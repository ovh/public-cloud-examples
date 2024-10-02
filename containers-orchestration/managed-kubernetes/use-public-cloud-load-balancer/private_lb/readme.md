# Private Load Balancer Demo

## Description
Here is a basic example of how to expose your application using a Service type LoadBalancer in a private way.

## Create a private Load Balancer:
You have to provide the following annotation:
`service.beta.kubernetes.io/openstack-internal-load-balancer: "true"`

## Specify the private IP
You need to provide a PortI

1. Create a OpenStack port and use this as LB Ip address

  Without specifying the IP\
  `$ openstack port create --network bdd4fc7c-6a27-43d6-940a-8ed51e1fd22c --fixed-ip subnet=187dc936-c4ea-49ca-aff5-0a5eb7062ed9 my-lb-app-port`\
  Where: --network = network name or ID, subnet= subnet name or ID

  Or with a specific IP of your subnet \
  `$ openstack port create --network bdd4fc7c-6a27-43d6-940a-8ed51e1fd22c --fixed-ip subnet=187dc936-c4ea-49ca-aff5-0a5eb7062ed9, ip-address=10.0.2.2 my-lb-app-port-2`

  Retrieve the portID :
  `$openstack port list --name my-lb-app-port-2`

2. Add the portID to your Kubernetes Service manifest (cf. [exemple](./lb_private_with_openstack_port.yaml))\
`loadbalancer.openstack.org/port-id: "4c758644-af77-4e60-9e24-bc5e67295ac0"`
