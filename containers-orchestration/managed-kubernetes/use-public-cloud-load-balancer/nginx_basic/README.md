# Basic nginx Deployment

## Description
Here is a basic example a nginx Deployment that can be use for demo and test of Public Cloud Load Balancer.
Once the Deployment is created your nginx will be internally exposed on port 80 so you can use the ![Basic LB](./basic_lb/lb_base.yaml) in order to forward trafic from LB listener (port 80) to Kubernetes internal nginx (port 80).
