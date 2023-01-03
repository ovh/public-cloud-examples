resource "ovh_cloud_project_database" "pgsqldb" {
  service_name = var.service_name
  description  = var.db_description
  engine       = var.db_engine
  version      = var.db_version
  plan         = var.db_plan
  nodes {
    region     = var.db_egion
    subnet_id  = data.openstack_networking_subnet_v2.my_subnet.id
    network_id = data.openstack_networking_network_v2.my_private_network.id
  }
  nodes {
    region     = var.db_egion
    subnet_id  = data.openstack_networking_subnet_v2.my_subnet.id
    network_id = data.openstack_networking_network_v2.my_private_network.id
  }
  flavor = var.db_flavor
}

resource "ovh_cloud_project_database_ip_restriction" "iprestriction" {
  service_name = ovh_cloud_project_database.pgsqldb.service_name
  engine       = ovh_cloud_project_database.pgsqldb.engine
  cluster_id   = ovh_cloud_project_database.pgsqldb.id
  ip           = var.db_allowed_ip
}

resource "ovh_cloud_project_database_postgresql_user" "pgsqluser" {
  service_name   = ovh_cloud_project_database.pgsqldb.service_name
  cluster_id     = ovh_cloud_project_database.pgsqldb.id
  name           = var.db_user_name
  roles          = var.db_user_role
  password_reset = "changeMeToResetPassword"
}
