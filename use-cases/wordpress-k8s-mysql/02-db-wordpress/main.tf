resource "local_file" "kubeconfig_file" {
  content  = data.terraform_remote_state.kube.outputs.kubeconfig_file
  filename = "kubeconfig_file"
}

# Create the DB service
resource "ovh_cloud_project_database" "database_service" {
  description = "wordpress_db_service"
  engine      = "mysql"
  version     = var.database.version
  plan        = var.database.plan
  nodes {
    region     = var.database.region
    network_id = data.terraform_remote_state.kube.outputs.network.id
    subnet_id  = data.terraform_remote_state.kube.outputs.subnet.id
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

# Fetch the openstack instances to get their id
data "openstack_compute_instance_v2" "instances" {
  for_each = {
    for vm in data.terraform_remote_state.kube.outputs.nodepool_nodes.nodes : vm.instance_id => vm
  }
  id = each.value.instance_id
}

# DB IP restrictions with the IPs of the nodes
resource "ovh_cloud_project_database_ip_restriction" "nodes_iprestriction" {
  depends_on = [
    ovh_cloud_project_database_database.wordpress_db
  ]
  engine     = ovh_cloud_project_database.database_service.engine
  cluster_id = ovh_cloud_project_database.database_service.id
  ip         = data.terraform_remote_state.kube.outputs.subnet.cidr
}

# Create the wordpress web site and connect it to the DB
resource "helm_release" "wordpress" {
  name       = "wordpress"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "wordpress"

  set {
    name  = "mariadb.enabled"
    value = "false"
  }
  set {
    name  = "externalDatabase.host"
    value = ovh_cloud_project_database.database_service.endpoints.0.domain
  }
  set {
    name  = "externalDatabase.port"
    value = ovh_cloud_project_database.database_service.endpoints.0.port
  }
  set {
    name  = "externalDatabase.user"
    value = ovh_cloud_project_database_user.wordpress_db_user.name
  }
  set {
    name  = "externalDatabase.password"
    value = ovh_cloud_project_database_user.wordpress_db_user.password
  }
  set {
    name  = "externalDatabase.database"
    value = ovh_cloud_project_database_database.wordpress_db.name
  }
}
