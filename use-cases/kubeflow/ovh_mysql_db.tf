resource "ovh_cloud_project_database" "mysql" {
  description   = "${var.ovh_mysql_name}-mysql"
  engine        = "mysql"
  version       = "${var.ovh_mysql_version}"
  plan          = "business"
  
  nodes {
    region  = "${var.ovh_mysql_region}"
    network_id = tolist(ovh_cloud_project_network_private.private-net.regions_attributes[*].openstackid)[0]
    subnet_id = ovh_cloud_project_network_private_subnet.private-subnet.id
  }

  nodes {
    region  = "${var.ovh_mysql_region}"
    network_id = tolist(ovh_cloud_project_network_private.private-net.regions_attributes[*].openstackid)[0]
    subnet_id = ovh_cloud_project_network_private_subnet.private-subnet.id
  }
  
  flavor        = "db1-4"

  advanced_configuration = {
    "mysql.sql_mode": "ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,STRICT_ALL_TABLES",
    "mysql.sql_require_primary_key": "false"
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

resource "ovh_cloud_project_database_ip_restriction" "iprestriction-mysql" {
  engine       = "mysql"
  cluster_id   = ovh_cloud_project_database.mysql.id
  ip           = ovh_cloud_project_network_private_subnet.private-subnet.network
}

resource "ovh_cloud_project_database_user" "kubeflow-mysql-user" {
  service_name  = ovh_cloud_project_database.mysql.service_name
  engine        = ovh_cloud_project_database.mysql.engine
  cluster_id    = ovh_cloud_project_database.mysql.id
  name          = "kubeflow"
}

resource "ovh_cloud_project_database_user" "katib-mysql-user" {
  service_name  = ovh_cloud_project_database.mysql.service_name
  engine        = ovh_cloud_project_database.mysql.engine
  cluster_id    = ovh_cloud_project_database.mysql.id
  name          = "katib"
}

resource "ovh_cloud_project_database_database" "katib-database" {
  service_name  = ovh_cloud_project_database.mysql.service_name
  engine        = ovh_cloud_project_database.mysql.engine
  cluster_id    = ovh_cloud_project_database.mysql.id
  name          = "katib"
}