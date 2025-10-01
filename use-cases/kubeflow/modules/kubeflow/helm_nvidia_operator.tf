resource "helm_release" "gpu-operator" {
  name              = "gpu-operator"
  namespace         = "gpu-operator"

  repository        = "https://helm.ngc.nvidia.com/nvidia"
  chart             = "gpu-operator"
  version           = "v23.9.2"

  create_namespace  = true

  set {
    name            = "operator.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key"
    value           = "kubeflow"
  }

  set {
    name            = "operator.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator"
    value           = "In"
  }

  set {
    name            = "operator.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[0]"
    value           = "control-plane"
  }

  set {
    name            = "operator.tolerations[0].effect"
    value           = "NoSchedule"
  }

  set {
    name            = "operator.tolerations[0].key"
    value           = "kubeflow"
  }

  set {
    name            = "operator.tolerations[0].operator"
    value           = "Equal"
  }

    set {
    name            = "operator.tolerations[0].value"
    value           = "control-plane"
  }

  set {
    name            = "node-feature-discovery.gc.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key"
    value           = "kubeflow"
  }

  set {
    name            = "node-feature-discovery.gc.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator"
    value           = "In"
  }

  set {
    name            = "node-feature-discovery.gc.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[0]"
    value           = "control-plane"
  }

  set {
    name            = "node-feature-discovery.gc.tolerations[0].effect"
    value           = "NoSchedule"
  }

  set {
    name            = "node-feature-discovery.gc.tolerations[0].key"
    value           = "kubeflow"
  }

  set {
    name            = "node-feature-discovery.gc.tolerations[0].operator"
    value           = "Equal"
  }

    set {
    name            = "node-feature-discovery.gc.tolerations[0].value"
    value           = "control-plane"
  }

  set {
    name            = "node-feature-discovery.master.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key"
    value           = "kubeflow"
  }

  set {
    name            = "node-feature-discovery.master.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator"
    value           = "In"
  }

  set {
    name            = "node-feature-discovery.master.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[0]"
    value           = "control-plane"
  }

  set {
    name            = "node-feature-discovery.master.tolerations[0].effect"
    value           = "NoSchedule"
  }

  set {
    name            = "node-feature-discovery.master.tolerations[0].key"
    value           = "kubeflow"
  }

  set {
    name            = "node-feature-discovery.master.tolerations[0].operator"
    value           = "Equal"
  }

  set {
    name            = "node-feature-discovery.master.tolerations[0].value"
    value           = "control-plane"
  }

  set {
    name            = "node-feature-discovery.worker.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key"
    value           = "node.k8s.ovh/type"
  }

  set {
    name            = "node-feature-discovery.worker.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator"
    value           = "In"
  }

  set {
    name            = "node-feature-discovery.worker.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[0]"
    value           = "gpu"
  }

  depends_on        = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}