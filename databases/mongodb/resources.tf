resource "ovh_cloud_project_database" "mongodb" {
  service_name  = var.serviceName
  description   = var.dbDescription
  engine        = var.dbEngine
  version       = var.dbVersion
  plan          = var.dbPlan
//  disk_size 	= var.dbDiskSize
  nodes {
    region      = var.dbRegion
    subnet_id   = data.openstack_networking_subnet_v2.mySubnet.id
    network_id  = data.openstack_networking_network_v2.myPrivateNetwork.id
  }
  nodes {
    region      = var.dbRegion
    subnet_id   = data.openstack_networking_subnet_v2.mySubnet.id
    network_id  = data.openstack_networking_network_v2.myPrivateNetwork.id
  }
  nodes {
    region      = var.dbRegion
    subnet_id   = data.openstack_networking_subnet_v2.mySubnet.id
    network_id  = data.openstack_networking_network_v2.myPrivateNetwork.id
  }
  flavor        = var.dbFlavor
}

resource "ovh_cloud_project_database_ip_restriction" "iprestriction" {
  service_name = ovh_cloud_project_database.mongodb.service_name
  engine       = ovh_cloud_project_database.mongodb.engine
  cluster_id   = ovh_cloud_project_database.mongodb.id
  ip           = var.dbAllowedIp
}

resource "ovh_cloud_project_database_mongodb_user" "mongouser" {
  service_name  = ovh_cloud_project_database.mongodb.service_name
  cluster_id    = ovh_cloud_project_database.mongodb.id
  name          = var.dbUserName
  roles         = var.dbUserRole
  password_reset = "changeMeToResetPassword1"
}
