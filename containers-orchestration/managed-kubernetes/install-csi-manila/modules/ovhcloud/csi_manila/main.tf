resource "helm_release" "csi-driver-nfs" {
  name      = "csi-driver-nfs"
  namespace = "kube-system"

  repository = "https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts"
  chart      = "csi-driver-nfs"
}

resource "helm_release" "openstack-manila-csi" {
  name      = "openstack-manila-csi"
  namespace = "kube-system"

  repository = "https://kubernetes.github.io/cloud-provider-openstack"
  chart      = "openstack-manila-csi"

  depends_on = [helm_release.csi-driver-nfs]
}

resource "ovh_cloud_project_user" "manila-user" {
  service_name = var.service_name
  description  = "User for the Manila CSI driver"
  role_name    = "share_operator"
}

resource "kubectl_manifest" "csi-manila-secrets" {
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: csi-manila-secrets
  namespace: default
stringData:
  # Mandatory
  os-authURL: "https://auth.cloud.ovh.net/v3"
  os-region: "${var.region}"
  os-userName: "${ovh_cloud_project_user.manila-user.username}"
  os-password: "${ovh_cloud_project_user.manila-user.password}"
  os-domainName: "default"
  os-projectID: "${var.service_name}"
  os-projectDomainID: "default"
YAML
}



resource "ovh_cloud_storage_file_share_network" "sharenetwork" {
  service_name      = var.service_name
  region       = var.region
  name              = var.share_network_name
  network_id        = var.network_id
  subnet_id         = var.subnet_id
}

resource "kubectl_manifest" "manila-runtime-configmap" {
  yaml_body = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: manila-csi-runtimeconf-cm
  namespace: default
  annotations:
    meta.helm.sh/release-name: manila-csi
    meta.helm.sh/release-namespace: default
  labels:
    app.kubernetes.io/managed-by: Helm
data:
  runtimeconfig.json: |
    {
      "nfs": {
        "matchExportLocationAddress": "${var.subnet_cidr}"
      }
    }
YAML
}

resource "kubectl_manifest" "storage-class" {
  yaml_body = <<YAML
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: csi-manila-nfs
provisioner: nfs.manila.csi.openstack.org
allowVolumeExpansion: true
parameters:
  type: standard-1az
  shareNetworkID: "${ovh_cloud_storage_file_share_network.sharenetwork.id}"
  nfs-shareClient: "${var.subnet_cidr}"
  csi.storage.k8s.io/provisioner-secret-name: csi-manila-secrets
  csi.storage.k8s.io/provisioner-secret-namespace: default
  csi.storage.k8s.io/controller-expand-secret-name: csi-manila-secrets
  csi.storage.k8s.io/controller-expand-secret-namespace: default
  csi.storage.k8s.io/node-stage-secret-name: csi-manila-secrets
  csi.storage.k8s.io/node-stage-secret-namespace: default
  csi.storage.k8s.io/node-publish-secret-name: csi-manila-secrets
  csi.storage.k8s.io/node-publish-secret-namespace: default
YAML
}

output "manila-user" {
  value = ovh_cloud_project_user.manila-user.username
}
