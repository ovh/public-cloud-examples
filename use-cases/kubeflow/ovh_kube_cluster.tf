resource "ovh_cloud_project_kube" "ovh_kube_cluster" {
   service_name = "${var.ovh_os_project_id}"
   name         = "${var.ovh_kube_cluster_name}"
   region       = "${var.ovh_os_region_name}"
   version      = "${var.ovh_kube_version}"

   private_network_id = tolist(ovh_cloud_project_network_private.private-net.regions_attributes[*].openstackid)[0]

   private_network_configuration {
      default_vrack_gateway              = ""
      private_network_routing_as_default = false
   }

   depends_on    = [ovh_cloud_project_network_private_subnet.private-subnet]
}

resource "ovh_cloud_project_kube_nodepool" "control_plane_pool" {
   service_name  = "${var.ovh_os_project_id}"
   kube_id       = ovh_cloud_project_kube.ovh_kube_cluster.id
   name          = "${var.ovh_kube_cluster_name}-control-plane"
   flavor_name   = "${var.kubeflow_control_plane_flavor}"
   autoscale     = "${var.kubeflow_control_plane_autoscale}"
   desired_nodes = var.kubeflow_control_plane_desired_nodes
   max_nodes     = var.kubeflow_control_plane_max_nodes
   min_nodes     = var.kubeflow_control_plane_min_nodes

   template {
    metadata {
      annotations = {}
      finalizers = []
      labels = {
        kubeflow = "control-plane"
      }
    }
    spec {
      unschedulable = false
      taints = [
        {
          effect = "NoSchedule"
          key    = "kubeflow"
          value  = "control-plane"
        }
      ]
    }
  }
}

resource "ovh_cloud_project_kube_nodepool" "worker_cpu_pool" {
   service_name  = "${var.ovh_os_project_id}"
   kube_id       = ovh_cloud_project_kube.ovh_kube_cluster.id
   name          = "${var.ovh_kube_cluster_name}-worker-cpu"
   flavor_name   = "${var.kubeflow_cpu_worker_flavor}"
   autoscale     = "${var.kubeflow_cpu_worker_autoscale}"
   desired_nodes = var.kubeflow_cpu_worker_desired_nodes
   max_nodes     = var.kubeflow_cpu_worker_max_nodes
   min_nodes     = var.kubeflow_cpu_worker_min_nodes
}

resource "ovh_cloud_project_kube_nodepool" "worker_gpu_pool" {
   service_name  = "${var.ovh_os_project_id}"
   kube_id       = ovh_cloud_project_kube.ovh_kube_cluster.id
   name          = "${var.ovh_kube_cluster_name}-worker-gpu"
   flavor_name   = "${var.kubeflow_gpu_worker_flavor}"
   autoscale     = "${var.kubeflow_gpu_worker_autoscale}"
   max_nodes     = var.kubeflow_gpu_worker_max_nodes
   min_nodes     = var.kubeflow_gpu_worker_min_nodes

   template {
    metadata {
      annotations = {}
      finalizers = []
      labels = {
        "node.k8s.ovh/type" = "gpu"
        "nvidia.com/gpu" = "ovh"
      }
    }
    spec {
      unschedulable = false
      taints = []
    }
  }
}