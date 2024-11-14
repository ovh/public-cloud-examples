# Create the DB service
resource "ovh_cloud_project_database" "database_service" {
  description = "wordpress_db_service"
  engine      = "mysql"
  version     = var.database.version
  plan        = var.database.plan
  nodes {
    region     = var.database.region
    network_id = tolist(ovh_cloud_project_network_private.private_network.regions_attributes)[0].openstackid
    subnet_id  = ovh_cloud_project_network_private_subnet.subnet.id
  }
  ip_restrictions {
    description = "mks nodepool subnet CIDR"
    ip          = ovh_cloud_project_network_private_subnet.subnet.network
  }
  flavor = var.database.flavor
}

# Create the managed mySQL DB
resource "ovh_cloud_project_database_database" "wordpress_db" {
  engine     = "mysql"
  cluster_id = ovh_cloud_project_database.database_service.id
  name       = "wordpress_db"
}

# Create OVH user for the DB
resource "ovh_cloud_project_database_user" "wordpress_db_user" {
  depends_on = [
    ovh_cloud_project_database_database.wordpress_db
  ]
  engine     = ovh_cloud_project_database.database_service.engine
  cluster_id = ovh_cloud_project_database.database_service.id
  name       = "wordpress_db_user"
}