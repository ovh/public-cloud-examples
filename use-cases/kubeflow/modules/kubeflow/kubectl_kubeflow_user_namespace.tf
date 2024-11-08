resource "kubectl_manifest" "kubeflow-user-namespace-configmap-default-install-config" {
  yaml_body = <<YAML
apiVersion: v1
data:
  profile-name: kubeflow-user-default
  user: "${var.kubeflow_default_user_name}@${var.ovh_dns_domain}"
kind: ConfigMap
metadata:
  name: default-install-config-9h2h2b6hbk
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-user-namespace-profile-kubeflow-user" {
  yaml_body = <<YAML
apiVersion: kubeflow.org/v1beta1
kind: Profile
metadata:
  name: kubeflow-user-default
spec:
  owner:
    kind: User
    name: "${var.kubeflow_default_user_name}@${var.ovh_dns_domain}"
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-profiles-kfam-crd-profiles]
}
