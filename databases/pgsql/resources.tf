resource "ovh_cloud_project_database" "pgsqldb" {
  service_name = var.serviceName
  description  = var.dbDescription
  engine       = var.dbEngine
  version      = var.dbVersion
  plan         = var.dbPlan
  nodes {
    region     = var.dbRegion
    subnet_id  = data.openstack_networking_subnet_v2.mySubnet.id
    network_id = data.openstack_networking_network_v2.myPrivateNetwork.id
  }
  nodes {
    region     = var.dbRegion
    subnet_id  = data.openstack_networking_subnet_v2.mySubnet.id
    network_id = data.openstack_networking_network_v2.myPrivateNetwork.id
  }
  flavor = var.dbFlavor
}

resource "ovh_cloud_project_database_ip_restriction" "iprestriction" {
  service_name = ovh_cloud_project_database.pgsqldb.service_name
  engine       = ovh_cloud_project_database.pgsqldb.engine
  cluster_id   = ovh_cloud_project_database.pgsqldb.id
  ip           = var.dbAllowedIp
}

resource "ovh_cloud_project_database_postgresql_user" "pgsqluser" {
  service_name   = ovh_cloud_project_database.pgsqldb.service_name
  cluster_id     = ovh_cloud_project_database.pgsqldb.id
  name           = var.dbUserName
  roles          = var.dbUserRole
  password_reset = "changeMeToResetPassword"
}
