resource "ovh_cloud_project_database" "pgsql_engine" {
  description = var.db_engine.description
  engine      = var.db_engine.engine
  version     = var.db_engine.version
  plan        = var.db_engine.plan
  nodes {
    region     = var.db_engine.region
    subnet_id  = data.openstack_networking_subnet_v2.my_subnet.id
    network_id = data.openstack_networking_network_v2.my_private_network.id
  }
  nodes {
    region     = var.db_engine.region
    subnet_id  = data.openstack_networking_subnet_v2.my_subnet.id
    network_id = data.openstack_networking_network_v2.my_private_network.id
  }
  flavor = var.db_engine.flavor
}

resource "ovh_cloud_project_database_ip_restriction" "iprestriction" {
  for_each     = toset(var.db_engine.allowed_ip)
  service_name = ovh_cloud_project_database.pgsql_engine.service_name
  engine       = ovh_cloud_project_database.pgsql_engine.engine
  cluster_id   = ovh_cloud_project_database.pgsql_engine.id
  ip           = each.key
}

resource "ovh_cloud_project_database_postgresql_user" "user" {
  service_name    = ovh_cloud_project_database.pgsql_engine.service_name
  cluster_id      = ovh_cloud_project_database.pgsql_engine.id
  name            = var.user.name
  roles           = var.user.roles
  password_reset  = var.user.password_reset
}
