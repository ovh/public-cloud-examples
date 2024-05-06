resource "local_file" "kubeconfig_file" {
  content  = data.terraform_remote_state.kube.outputs.kubeconfig_file
  filename = "kubeconfig.yml"
}

# Create the DB service
resource "ovh_cloud_project_database" "database_service" {
  description = "wordpress_db_service"
  engine      = "mysql"
  version     = var.database.version
  plan        = var.database.plan
  nodes {
    region     = var.database.region
    network_id = data.terraform_remote_state.kube.outputs.network_uid
    subnet_id  = data.terraform_remote_state.kube.outputs.subnet.id
  }
  ip_restrictions {
    description = "mks nodepool subnet CIDR"
    ip          = data.terraform_remote_state.kube.outputs.subnet.cidr
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

# Create the wordpress web site and connect it to the DB
# More details on parameter at https://github.com/bitnami/charts/tree/main/bitnami/wordpress
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
  depends_on = [
    local_file.kubeconfig_file
  ]
}
