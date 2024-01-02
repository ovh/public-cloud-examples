resource "ovh_cloud_project_database" "grafana" {
  description = var.db_engine.description
  engine      = var.db_engine.engine
  version     = var.db_engine.version
  plan        = var.db_engine.plan
  nodes {
    region     = var.db_engine.region
    subnet_id  = data.openstack_networking_subnet_v2.subnet.id
    network_id = data.openstack_networking_network_v2.private_network.id
  }
  flavor = var.db_engine.flavor
}

resource "ovh_cloud_project_database_ip_restriction" "iprestriction" {
  for_each   = toset(var.db_engine.allowed_ip)
  engine     = ovh_cloud_project_database.grafana.engine
  cluster_id = ovh_cloud_project_database.grafana.id
  ip         = each.key
}
