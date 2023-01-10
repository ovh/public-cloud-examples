resource "ovh_cloud_project_database" "mysql_engine" {
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
  service_name = ovh_cloud_project_database.mysql_engine.service_name
  engine       = ovh_cloud_project_database.mysql_engine.engine
  cluster_id   = ovh_cloud_project_database.mysql_engine.id
  ip           = each.key
}

resource "ovh_cloud_project_database_user" "mysqluser" {
  cluster_id     = ovh_cloud_project_database.mysql_engine.id
  engine         = var.db_engine.engine
  name           = var.db_engine.user_name
  password_reset = "changeMeToResetPassword"
}

resource "ovh_cloud_project_database_database" "database" {
  engine     = var.db_engine.engine
  cluster_id = ovh_cloud_project_database.mysql_engine.id
  name       = var.db.name
}
