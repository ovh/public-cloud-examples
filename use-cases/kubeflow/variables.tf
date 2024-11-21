variable ovh_os_region_name {
  type        = string
  default     = "GRA11"
}

variable ovh_os_private_network_vlan_id {
  type        = string
  default     = "10"
}

variable ovh_kube_cluster_name {
  type        = string
  default     = "mks-kubeflow"
}

variable ovh_kube_version {
  type        = string
  default     = "1.29"
}

variable kubeflow_control_plane_flavor {
  type        = string
  default     = "b3-8"
}

variable kubeflow_control_plane_autoscale {
  type        = string
  default     = "false"
}

variable kubeflow_control_plane_desired_nodes {
  type        = number
  default     = 3
}

variable kubeflow_control_plane_max_nodes {
  type        = number
  default     = 10
}

variable kubeflow_control_plane_min_nodes {
  type        = number
  default     = 3
}

variable kubeflow_cpu_worker_flavor {
  type        = string
  default     = "c3-8"
}

variable kubeflow_cpu_worker_autoscale {
  type        = string
  default     = "false"
}

variable kubeflow_cpu_worker_desired_nodes {
  type        = number
  default     = 2
}

variable kubeflow_cpu_worker_max_nodes {
  type        = number
  default     = 10
}

variable kubeflow_cpu_worker_min_nodes {
  type        = number
  default     = 2
}

variable kubeflow_gpu_worker_flavor {
  type        = string
  default     = "t2-45"
}

variable kubeflow_gpu_worker_autoscale {
  type        = string
  default     = "true"
}

variable kubeflow_gpu_worker_max_nodes {
  type        = number
  default     = 5
}

variable kubeflow_gpu_worker_min_nodes {
  type        = number
  default     = 0
}

variable ovh_api_dns_application_key {
  type        = string
}

variable ovh_api_dns_application_secret {
  type        = string
}

variable ovh_api_dns_consumer_key {
  type        = string
}

variable ovh_dns_domain {
  type        = string
}

variable letsencrypt_issuer {
  type = string
  default = "letsencrypt-staging"
}

variable ovh_mysql_name {
  type        = string
  default     = "mks-kubeflow"
}

variable ovh_mysql_version {
  type        = string
  default     = "8"
}

variable ovh_mysql_region {
  type        = string
  default     = "GRA"
}

variable ovh_s3_bucket_name {
  type        = string
  default     = "mks-kubeflow"
}

variable ovh_s3_region_name {
  type        = string
  default     = "gra"
}

variable kubeflow_default_user_name {
  type        = string
  default     = "user"
}

# Use bcrypt to hash the password
# python3 -c 'from passlib.hash import bcrypt; import getpass; print(bcrypt.using(rounds=12, ident="2y").hash(getpass.getpass()))'
variable kubeflow_default_user_password_hash {
  type        = string
  default     = "$2y$12$DQDRh8mTqZeWSL4ZUm76.uBzmWmhuHH/IpyPw2cSy1ZUSjQSB7VFa"
}