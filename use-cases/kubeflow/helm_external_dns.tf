resource "helm_release" "external-dns" {
  name              = "external-dns"
  namespace         = "external-dns"

  repository        = "https://kubernetes-sigs.github.io/external-dns"
  chart             = "external-dns"
  version           = "1.12.2"

  create_namespace  = true

  set {
    name            = "provider"
    value           = "ovh"
  }

  set {
    name            = "domainFilters[0]"
    value           = "${var.ovh_dns_domain}"
  }

  set {
    name            = "sources[0]"
    value           = "istio-gateway"
  }

  set {
    name            = "policy"
    value           = "sync"
  }

  set {
    name            = "rbac.additionalPermissions[0].apiGroups[0]"
    value           = "networking.istio.io"
  }

  set {
    name            = "rbac.additionalPermissions[0].resources[0]"
    value           = "gateways"
  }

  set {
    name            = "rbac.additionalPermissions[0].resources[1]"
    value           = "virtualservices"
  }

  set {
    name            = "rbac.additionalPermissions[0].verbs[0]"
    value           = "get"
  }

  set {
    name            = "rbac.additionalPermissions[0].verbs[1]"
    value           = "watch"
  }

  set {
    name            = "rbac.additionalPermissions[0].verbs[2]"
    value           = "list"
  }

  set {
    name            = "env[0].name"
    value           = "OVH_APPLICATION_KEY"
  }

  set {
    name            = "env[0].value"
    value           = "${var.ovh_api_dns_application_key}"
  }

   set {
    name            = "env[1].name"
    value           = "OVH_APPLICATION_SECRET"
  }

  set {
    name            = "env[1].value"
    value           = "${var.ovh_api_dns_application_secret}"
  }

   set {
    name            = "env[2].name"
    value           = "OVH_CONSUMER_KEY"
  }

  set {
    name            = "env[2].value"
    value           = "${var.ovh_api_dns_consumer_key}"
  }

  set {
    name            = "nodeSelector.kubeflow"
    value           = "control-plane"
  }

  set {
    name            = "tolerations[0].effect"
    value           = "NoSchedule"
  }

  set {
    name            = "tolerations[0].key"
    value           = "kubeflow"
  }

  set {
    name            = "tolerations[0].operator"
    value           = "Equal"
  }

  set {
    name            = "tolerations[0].value"
    value           = "control-plane"
  }

  depends_on        = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}