resource "ovh_cloud_project_database" "m3db_engine" {
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
  engine     = ovh_cloud_project_database.m3db_engine.engine
  cluster_id = ovh_cloud_project_database.m3db_engine.id
  ip         = each.key
}

resource "ovh_cloud_project_database_m3db_namespace" "namespace" {
  cluster_id                = ovh_cloud_project_database.m3db_engine.id
  name                      = var.namespace.name
  resolution                = var.namespace.resolution
  retention_period_duration = var.namespace.retention_period_duration
}

resource "ovh_cloud_project_database_m3db_user" "user" {
  cluster_id     = ovh_cloud_project_database.m3db_engine.id
  group          = var.user.group
  name           = var.user.name
  password_reset = var.user.password_reset
}
