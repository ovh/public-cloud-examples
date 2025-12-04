resource "ovh_cloud_project_network_private" "priv" {
  service_name  = var.service_name
  vlan_id       = "007"
  name          = "my_priv_nw"
  regions       = [var.region]
}

resource "ovh_cloud_project_network_private_subnet" "privsub" {
  service_name  = ovh_cloud_project_network_private.priv.service_name
  network_id    = ovh_cloud_project_network_private.priv.id
  region        = var.region
  start         = "10.0.0.2"
  end           = "10.0.255.254"
  network       = "10.0.0.0/16"
  dhcp          = true
}

resource "ovh_cloud_project_gateway" "gateway" {
  service_name = ovh_cloud_project_network_private.priv.service_name
  name         = "my-gateway"
  model        = "s"
  region       = ovh_cloud_project_network_private_subnet.privsub.region
  network_id   = tolist(ovh_cloud_project_network_private.priv.regions_attributes[*].openstackid)[0]
  subnet_id    = ovh_cloud_project_network_private_subnet.privsub.id
}

resource "ovh_cloud_project_loadbalancer" "lb" {
  service_name = ovh_cloud_project_network_private_subnet.privsub.service_name
  region_name = ovh_cloud_project_network_private_subnet.privsub.region
  //flavor_id = "31990104-8a7b-4d8f-a728-9c4cfd14fe72" # small flavor on GRA11 region
  flavor_id = element([for name in data.ovh_cloud_project_loadbalancer_flavors.flavors.flavors: name if "${name.name}" == "small"], 0).id
  name = "my_new_lb_for_kube"
  network = {
    private = {
      gateway = {
        id = ovh_cloud_project_gateway.gateway.id
      }
      floating_ip_create = {
        description = "Floating IP for my new LB for Kube"
      }
      network = {
        id = element([for region in ovh_cloud_project_network_private.priv.regions_attributes: region if "${region.region}" == var.region], 0).openstackid
        subnet_id = ovh_cloud_project_network_private_subnet.privsub.id
      }
    }
  }
  description = "My new LB for Kube"
  listeners = [
    {
      port = "34568"
      protocol = "tcp"
    },
    {
      port = "34569"
      protocol = "udp"
    }
  ]
}