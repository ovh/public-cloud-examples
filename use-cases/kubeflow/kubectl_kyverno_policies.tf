resource "kubectl_manifest" "kyverno-disallow-privileged-containers-cluster-policy" {
  yaml_body = <<YAML
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: disallow-privileged-containers
  annotations:
    policies.kyverno.io/title: Disallow Privileged Containers
    policies.kyverno.io/category: Pod Security Standards (Baseline)
    policies.kyverno.io/severity: medium
    policies.kyverno.io/subject: Pod
    kyverno.io/kyverno-version: 1.11.4
    kyverno.io/kubernetes-version: "1.26-1.29"
    policies.kyverno.io/description: >-
      Privileged mode disables most security mechanisms and must not be allowed. This policy
      ensures Pods do not call for privileged mode.      
spec:
  validationFailureAction: enforce
  background: true
  rules:
    - name: privileged-containers
      match:
        any:
        - resources:
            kinds:
              - Pod
      validate:
        message: >-
          Privileged mode is disallowed. The fields spec.containers[*].securityContext.privileged,
          spec.containers[*].securityContext.allowPrivilegeEscalation, spec.initContainers[*].securityContext.privileged,
          spec.initContainers[*].securityContext.allowPrivilegeEscalation and  must be unset or set to `false`.          
        pattern:
          spec:
            =(ephemeralContainers):
              - =(securityContext):
                  =(privileged): "false"
            =(initContainers):
              - =(securityContext):
                  =(privileged): "false"
            containers:
              - =(securityContext):
                  =(privileged): "false"
            =(ephemeralContainers):
              - =(securityContext):
                  =(allowPrivilegeEscalation): "false"
            =(initContainers):
              - =(securityContext):
                  =(allowPrivilegeEscalation): "false"
            containers:
              - =(securityContext):
                  =(allowPrivilegeEscalation): "false"
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, helm_release.kyverno]
}

resource "kubectl_manifest" "kyverno-disallow-host-path-cluster-policy" {
  yaml_body = <<YAML
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: disallow-host-path
  annotations:
    policies.kyverno.io/title: Disallow hostPath
    policies.kyverno.io/category: Pod Security Standards (Baseline)
    policies.kyverno.io/severity: medium
    policies.kyverno.io/subject: Pod,Volume
    kyverno.io/kyverno-version: 1.11.4
    kyverno.io/kubernetes-version: "1.26-1.29"
    policies.kyverno.io/description: >-
      HostPath volumes let Pods use host directories and volumes in containers.
      Using host resources can be used to access shared data or escalate privileges
      and should not be allowed. This policy ensures no hostPath volumes are in use.      
spec:
  validationFailureAction: enforce
  background: true
  rules:
    - name: host-path
      match:
        any:
        - resources:
            kinds:
              - Pod
      validate:
        message: >-
          HostPath volumes are forbidden. The field spec.volumes[*].hostPath must be unset.          
        pattern:
          spec:
            =(volumes):
              - X(hostPath): "null"
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, helm_release.kyverno]
}