resource "ovh_cloud_project_database" "service_pg" {
  description  = "PostgreSQL with Terraform"
  engine       = "postgresql"
  version      = var.pg_type.version
  plan         = var.pg_type.plan
  nodes {
    region = var.pg_type.region
  }
  flavor = var.pg_type.flavor
}

resource "ovh_cloud_project_database_ip_restriction" "iprestriction" {
  service_name = ovh_cloud_project_database.service_pg.service_name
  engine       = ovh_cloud_project_database.service_pg.engine
  cluster_id   = ovh_cloud_project_database.service_pg.id
  ip           = "${var.local_authorised_ip}"
}

resource "ovh_cloud_project_database_postgresql_user" "user" {
  service_name = ovh_cloud_project_database.service_pg.service_name
  cluster_id   = ovh_cloud_project_database.service_pg.id
  name         = "avnadmin"
  password_reset  = "reset"
}