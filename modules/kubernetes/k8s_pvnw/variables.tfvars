# Region

region = "GRA7"

# Managed Kubernetes Cluster

kube = {
  name            = "mykubernetesCluster"
  pv_network_name = "myNetwork"
  gateway_ip      = "192.168.20.1"
}

pool = {
  name          = "mypool"
  flavor        = "b2-7"
  desired_nodes = "3"
  max_nodes     = "6"
  min_nodes     = "3"
}
