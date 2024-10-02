resource "helm_release" "kyverno" {
  name              = "kyverno"
  namespace         = "kyverno"

  repository        = "https://kyverno.github.io/kyverno/"
  chart             = "kyverno"
  version           = "3.1.4"

  create_namespace  = true

  set {
    name            = "admissionController.nodeSelector.kubeflow"
    value           = "control-plane"
  }

  set {
    name            = "admissionController.tolerations[0].effect"
    value           = "NoSchedule"
  }

  set {
    name            = "admissionController.tolerations[0].key"
    value           = "kubeflow"
  }

  set {
    name            = "admissionController.tolerations[0].operator"
    value           = "Equal"
  }

  set {
    name            = "admissionController.tolerations[0].value"
    value           = "control-plane"
  }

  set {
    name            = "webhooksCleanup.nodeSelector.kubeflow"
    value           = "control-plane"
  }

  set {
    name            = "webhooksCleanup.tolerations[0].effect"
    value           = "NoSchedule"
  }

  set {
    name            = "webhooksCleanup.tolerations[0].key"
    value           = "kubeflow"
  }

  set {
    name            = "webhooksCleanup.tolerations[0].operator"
    value           = "Equal"
  }

  set {
    name            = "webhooksCleanup.tolerations[0].value"
    value           = "control-plane"
  }

  set {
    name            = "policyReportsCleanup.nodeSelector.kubeflow"
    value           = "control-plane"
  }

  set {
    name            = "policyReportsCleanup.tolerations[0].effect"
    value           = "NoSchedule"
  }

  set {
    name            = "policyReportsCleanup.tolerations[0].key"
    value           = "kubeflow"
  }

  set {
    name            = "policyReportsCleanup.tolerations[0].operator"
    value           = "Equal"
  }

  set {
    name            = "policyReportsCleanup.tolerations[0].value"
    value           = "control-plane"
  }

  set {
    name            = "cleanupJobs.nodeSelector.kubeflow"
    value           = "control-plane"
  }

  set {
    name            = "cleanupJobs.tolerations[0].effect"
    value           = "NoSchedule"
  }

  set {
    name            = "cleanupJobs.tolerations[0].key"
    value           = "kubeflow"
  }

  set {
    name            = "cleanupJobs.tolerations[0].operator"
    value           = "Equal"
  }

  set {
    name            = "cleanupJobs.tolerations[0].value"
    value           = "control-plane"
  }

  set {
    name            = "clusterAdmissionReports.nodeSelector.kubeflow"
    value           = "control-plane"
  }

  set {
    name            = "clusterAdmissionReports.tolerations[0].effect"
    value           = "NoSchedule"
  }

  set {
    name            = "clusterAdmissionReports.tolerations[0].key"
    value           = "kubeflow"
  }

  set {
    name            = "clusterAdmissionReports.tolerations[0].operator"
    value           = "Equal"
  }

  set {
    name            = "clusterAdmissionReports.tolerations[0].value"
    value           = "control-plane"
  }

  set {
    name            = "backgroundController.nodeSelector.kubeflow"
    value           = "control-plane"
  }

  set {
    name            = "backgroundController.tolerations[0].effect"
    value           = "NoSchedule"
  }

  set {
    name            = "backgroundController.tolerations[0].key"
    value           = "kubeflow"
  }

  set {
    name            = "backgroundController.tolerations[0].operator"
    value           = "Equal"
  }

  set {
    name            = "backgroundController.tolerations[0].value"
    value           = "control-plane"
  }

  set {
    name            = "cleanupController.nodeSelector.kubeflow"
    value           = "control-plane"
  }

  set {
    name            = "cleanupController.tolerations[0].effect"
    value           = "NoSchedule"
  }

  set {
    name            = "cleanupController.tolerations[0].key"
    value           = "kubeflow"
  }

  set {
    name            = "cleanupController.tolerations[0].operator"
    value           = "Equal"
  }

  set {
    name            = "cleanupController.tolerations[0].value"
    value           = "control-plane"
  }

  set {
    name            = "reportsController.nodeSelector.kubeflow"
    value           = "control-plane"
  }

  set {
    name            = "reportsController.tolerations[0].effect"
    value           = "NoSchedule"
  }

  set {
    name            = "reportsController.tolerations[0].key"
    value           = "kubeflow"
  }

  set {
    name            = "reportsController.tolerations[0].operator"
    value           = "Equal"
  }

  set {
    name            = "reportsController.tolerations[0].value"
    value           = "control-plane"
  }

  set {
    name            = "cleanupJobs.admissionReports.nodeSelector.kubeflow"
    value           = "control-plane"
  }

  set {
    name            = "cleanupJobs.admissionReports.tolerations[0].effect"
    value           = "NoSchedule"
  }

  set {
    name            = "cleanupJobs.admissionReports.tolerations[0].key"
    value           = "kubeflow"
  }

  set {
    name            = "cleanupJobs.admissionReports.tolerations[0].operator"
    value           = "Equal"
  }

  set {
    name            = "cleanupJobs.admissionReports.tolerations[0].value"
    value           = "control-plane"
  }

  set {
    name            = "cleanupJobs.clusterAdmissionReports.nodeSelector.kubeflow"
    value           = "control-plane"
  }

  set {
    name            = "cleanupJobs.clusterAdmissionReports.tolerations[0].effect"
    value           = "NoSchedule"
  }

  set {
    name            = "cleanupJobs.clusterAdmissionReports.tolerations[0].key"
    value           = "kubeflow"
  }

  set {
    name            = "cleanupJobs.clusterAdmissionReports.tolerations[0].operator"
    value           = "Equal"
  }

  set {
    name            = "cleanupJobs.clusterAdmissionReports.tolerations[0].value"
    value           = "control-plane"
  }

  set {
    name            = "config.excludeKyvernoNamespace"
    value           = "false"
  }

  set {
    name            = "config.webhooks[0].namespaceSelector.matchExpressions[0].key"
    value           = "kubernetes.io/metadata.name"
  }

  set {
    name            = "config.webhooks[0].namespaceSelector.matchExpressions[0].operator"
    value           = "NotIn"
  }

  set {
    name            = "config.webhooks[0].namespaceSelector.matchExpressions[0].values[0]"
    value           = "kyverno"
  }

  set {
    name            = "config.webhooks[0].namespaceSelector.matchExpressions[0].values[1]"
    value           = "kube-system"
  }

  set {
    name            = "config.webhooks[0].namespaceSelector.matchExpressions[0].values[2]"
    value           = "kubeflow"
  }

  set {
    name            = "config.webhooks[0].namespaceSelector.matchExpressions[0].values[3]"
    value           = "istio-system"
  }

  set {
    name            = "config.webhooks[0].namespaceSelector.matchExpressions[0].values[4]"
    value           = "gpu-operator"
  }

  depends_on        = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}