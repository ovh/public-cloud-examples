# Create the wordpress web site and connect it to the DB
# More details on parameter at https://github.com/bitnami/charts/tree/main/bitnami/wordpress
resource "helm_release" "wordpress" {
  name       = "wordpress"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "wordpress"
  version    = "23.1.29"

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
    local_file.kubeconfig_file, ovh_cloud_project_kube_nodepool.wordpress_node_pool, ovh_cloud_project_gateway.gateway
  ]
}