resource "ovh_cloud_project_database" "mongodb" {
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
  nodes {
    region     = var.db_engine.region
    subnet_id  = data.openstack_networking_subnet_v2.my_subnet.id
    network_id = data.openstack_networking_network_v2.my_private_network.id
  }
  flavor = var.db_engine.flavor
}

resource "ovh_cloud_project_database_ip_restriction" "iprestriction" {
  for_each     = toset(var.db_engine.allowed_ip)
  service_name = ovh_cloud_project_database.mongodb.service_name
  engine       = ovh_cloud_project_database.mongodb.engine
  cluster_id   = ovh_cloud_project_database.mongodb.id
  ip           = each.key
}

resource "ovh_cloud_project_database_mongodb_user" "mongouser" {
  service_name   = ovh_cloud_project_database.mongodb.service_name
  cluster_id     = ovh_cloud_project_database.mongodb.id
  name           = var.db_engine.user_name
  roles          = var.db_engine.user_role
  password_reset = "changeMeToResetPassword"
}
