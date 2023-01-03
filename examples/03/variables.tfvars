# Region

region = "GRA7"

# Network - Private Network

network = {
  name = "myNetwork"
}

# Network - Subnet

subnet = {
  name       = "mySubnet"
  cidr       = "192.168.12.0/24"
  dhcp_start = "192.168.12.100"
  dhcp_end   = "192.168.12.254"
}

# Network - Router

router = {
  name = "myRouter"
}

# Managed Kubernetes Cluster

kube  = {
    name            = "mykubernetesCluster"
    pv_network_name = "myNetwork"
    gateway_ip      = "192.168.12.1"
}

pool = {
    name          = "mypool"
    flavor        = "b2-7"
    desired_nodes = "3"
    max_nodes     = "6"
    min_nodes     = "3"
}
