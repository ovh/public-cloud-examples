resource "kubectl_manifest" "kubeflow-kubeflow-namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  labels:
    control-plane: kubeflow
    istio-injection: enabled
  name: kubeflow
  YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-kubeflow-admin" {
  yaml_body = <<YAML
aggregationRule:
  clusterRoleSelectors:
  - matchLabels:
      rbac.authorization.kubeflow.org/aggregate-to-kubeflow-admin: "true"
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: kubeflow-admin
rules: []
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-kubeflow-edit" {
  yaml_body = <<YAML
aggregationRule:
  clusterRoleSelectors:
  - matchLabels:
      rbac.authorization.kubeflow.org/aggregate-to-kubeflow-edit: "true"
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-admin: "true"
  name: kubeflow-edit
rules: []
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-kubeflow-kubernetes-admin" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-admin: "true"
  name: kubeflow-kubernetes-admin
rules:
- apiGroups:
  - authorization.k8s.io
  resources:
  - localsubjectaccessreviews
  verbs:
  - create
- apiGroups:
  - rbac.authorization.k8s.io
  resources:
  - rolebindings
  - roles
  verbs:
  - create
  - delete
  - deletecollection
  - get
  - list
  - patch
  - update
  - watch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-kubeflow-kubernetes-edit" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-edit: "true"
  name: kubeflow-kubernetes-edit
rules:
- apiGroups:
  - ""
  resources:
  - pods/attach
  - pods/exec
  - pods/portforward
  - pods/proxy
  - secrets
  - services/proxy
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - serviceaccounts
  verbs:
  - impersonate
- apiGroups:
  - ""
  resources:
  - pods
  - pods/attach
  - pods/exec
  - pods/portforward
  - pods/proxy
  verbs:
  - create
  - delete
  - deletecollection
  - patch
  - update
- apiGroups:
  - ""
  resources:
  - configmaps
  - endpoints
  - persistentvolumeclaims
  - replicationcontrollers
  - replicationcontrollers/scale
  - secrets
  - serviceaccounts
  - services
  - services/proxy
  verbs:
  - create
  - delete
  - deletecollection
  - patch
  - update
- apiGroups:
  - apps
  resources:
  - daemonsets
  - deployments
  - deployments/rollback
  - deployments/scale
  - replicasets
  - replicasets/scale
  - statefulsets
  - statefulsets/scale
  verbs:
  - create
  - delete
  - deletecollection
  - patch
  - update
- apiGroups:
  - autoscaling
  resources:
  - horizontalpodautoscalers
  verbs:
  - create
  - delete
  - deletecollection
  - patch
  - update
- apiGroups:
  - batch
  resources:
  - cronjobs
  - jobs
  verbs:
  - create
  - delete
  - deletecollection
  - patch
  - update
- apiGroups:
  - extensions
  resources:
  - daemonsets
  - deployments
  - deployments/rollback
  - deployments/scale
  - ingresses
  - networkpolicies
  - replicasets
  - replicasets/scale
  - replicationcontrollers/scale
  verbs:
  - create
  - delete
  - deletecollection
  - patch
  - update
- apiGroups:
  - policy
  resources:
  - poddisruptionbudgets
  verbs:
  - create
  - delete
  - deletecollection
  - patch
  - update
- apiGroups:
  - networking.k8s.io
  resources:
  - ingresses
  - networkpolicies
  verbs:
  - create
  - delete
  - deletecollection
  - patch
  - update
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-kubeflow-kubernetes-view" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-view: "true"
  name: kubeflow-kubernetes-view
rules:
- apiGroups:
  - ""
  resources:
  - configmaps
  - endpoints
  - persistentvolumeclaims
  - persistentvolumeclaims/status
  - pods
  - replicationcontrollers
  - replicationcontrollers/scale
  - serviceaccounts
  - services
  - services/status
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - bindings
  - events
  - limitranges
  - namespaces/status
  - pods/log
  - pods/status
  - replicationcontrollers/status
  - resourcequotas
  - resourcequotas/status
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - namespaces
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - apps
  resources:
  - controllerrevisions
  - daemonsets
  - daemonsets/status
  - deployments
  - deployments/scale
  - deployments/status
  - replicasets
  - replicasets/scale
  - replicasets/status
  - statefulsets
  - statefulsets/scale
  - statefulsets/status
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - autoscaling
  resources:
  - horizontalpodautoscalers
  - horizontalpodautoscalers/status
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - batch
  resources:
  - cronjobs
  - cronjobs/status
  - jobs
  - jobs/status
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - extensions
  resources:
  - daemonsets
  - daemonsets/status
  - deployments
  - deployments/scale
  - deployments/status
  - ingresses
  - ingresses/status
  - networkpolicies
  - replicasets
  - replicasets/scale
  - replicasets/status
  - replicationcontrollers/scale
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - policy
  resources:
  - poddisruptionbudgets
  - poddisruptionbudgets/status
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - networking.k8s.io
  resources:
  - ingresses
  - ingresses/status
  - networkpolicies
  verbs:
  - get
  - list
  - watch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-kubeflow-view" {
  yaml_body = <<YAML
aggregationRule:
  clusterRoleSelectors:
  - matchLabels:
      rbac.authorization.kubeflow.org/aggregate-to-kubeflow-view: "true"
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-edit: "true"
  name: kubeflow-view
rules: []
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-kubeflow-istio-admin" {
  yaml_body = <<YAML
aggregationRule:
  clusterRoleSelectors:
  - matchLabels:
      rbac.authorization.kubeflow.org/aggregate-to-kubeflow-istio-admin: "true"
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-admin: "true"
  name: kubeflow-istio-admin
rules: []
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-kubeflow-istio-edit" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-edit: "true"
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-istio-admin: "true"
  name: kubeflow-istio-edit
rules:
- apiGroups:
  - istio.io
  - networking.istio.io
  resources:
  - '*'
  verbs:
  - get
  - list
  - watch
  - create
  - delete
  - deletecollection
  - patch
  - update
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-kubeflow-istio-view" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-view: "true"
  name: kubeflow-istio-view
rules:
- apiGroups:
  - istio.io
  - networking.istio.io
  resources:
  - '*'
  verbs:
  - get
  - list
  - watch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-certificate" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: kubeflow-cert
  namespace: istio-system
spec:
  secretName: kubeflow-cert
  duration: 2160h # 90d
  renewBefore: 360h # 15d
  isCA: false
  privateKey:
    algorithm: RSA
    encoding: PKCS1
    size: 2048
  usages:
    - server auth
    - client auth
  dnsNames:
    - "kubeflow.${var.ovh_dns_domain}"
  issuerRef:
    name: "${var.letsencrypt_issuer}"
    kind: ClusterIssuer
    group: cert-manager.io
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace, kubectl_manifest.kubeflow-cert-manager-crd-certificates, kubectl_manifest.kubeflow-cert-manager-deployment-webhook, kubectl_manifest.kubeflow-istio-gateway-ingressgateway, helm_release.external-dns]
}

resource "kubectl_manifest" "kubeflow-kubeflow-gateway-kubeflow-gateway" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: kubeflow-gateway
  namespace: kubeflow
spec:
  selector:
    istio: ingressgateway
  servers:
  - hosts:
    - "kubeflow.${var.ovh_dns_domain}"
    port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: kubeflow-cert
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-istio-crd-gateways]
}


resource "kubectl_manifest" "kubeflow-kubeflow-crd-clusterworkflowtemplates" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: clusterworkflowtemplates.argoproj.io
spec:
  group: argoproj.io
  names:
    kind: ClusterWorkflowTemplate
    listKind: ClusterWorkflowTemplateList
    plural: clusterworkflowtemplates
    shortNames:
    - clusterwftmpl
    - cwft
    singular: clusterworkflowtemplate
  scope: Cluster
  versions:
  - name: v1alpha1
    schema:
      openAPIV3Schema:
        properties:
          apiVersion:
            type: string
          kind:
            type: string
          metadata:
            type: object
          spec:
            type: object
            x-kubernetes-map-type: atomic
            x-kubernetes-preserve-unknown-fields: true
        required:
        - metadata
        - spec
        type: object
    served: true
    storage: true
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-crd-compositecontrollers" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    api-approved.kubernetes.io: unapproved, request not yet submitted
  labels:
    application-crd-id: kubeflow-pipelines
    kustomize.component: metacontroller
  name: compositecontrollers.metacontroller.k8s.io
spec:
  group: metacontroller.k8s.io
  names:
    kind: CompositeController
    listKind: CompositeControllerList
    plural: compositecontrollers
    shortNames:
    - cc
    - cctl
    singular: compositecontroller
  scope: Cluster
  versions:
  - name: v1alpha1
    schema:
      openAPIV3Schema:
        properties:
          apiVersion:
            description: 'APIVersion defines the versioned schema of this representation
              of an object. Servers should convert recognized schemas to the latest
              internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources'
            type: string
          kind:
            description: 'Kind is a string value representing the REST resource this
              object represents. Servers may infer this from the endpoint the client
              submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds'
            type: string
          metadata:
            type: object
          spec:
            properties:
              childResources:
                items:
                  properties:
                    apiVersion:
                      type: string
                    resource:
                      type: string
                    updateStrategy:
                      properties:
                        method:
                          type: string
                        statusChecks:
                          properties:
                            conditions:
                              items:
                                properties:
                                  reason:
                                    type: string
                                  status:
                                    type: string
                                  type:
                                    type: string
                                required:
                                - type
                                type: object
                              type: array
                          type: object
                      type: object
                  required:
                  - apiVersion
                  - resource
                  type: object
                type: array
              generateSelector:
                type: boolean
              hooks:
                properties:
                  customize:
                    properties:
                      webhook:
                        properties:
                          path:
                            type: string
                          service:
                            properties:
                              name:
                                type: string
                              namespace:
                                type: string
                              port:
                                format: int32
                                type: integer
                              protocol:
                                type: string
                            required:
                            - name
                            - namespace
                            type: object
                          timeout:
                            type: string
                          url:
                            type: string
                        type: object
                    type: object
                  finalize:
                    properties:
                      webhook:
                        properties:
                          path:
                            type: string
                          service:
                            properties:
                              name:
                                type: string
                              namespace:
                                type: string
                              port:
                                format: int32
                                type: integer
                              protocol:
                                type: string
                            required:
                            - name
                            - namespace
                            type: object
                          timeout:
                            type: string
                          url:
                            type: string
                        type: object
                    type: object
                  postUpdateChild:
                    properties:
                      webhook:
                        properties:
                          path:
                            type: string
                          service:
                            properties:
                              name:
                                type: string
                              namespace:
                                type: string
                              port:
                                format: int32
                                type: integer
                              protocol:
                                type: string
                            required:
                            - name
                            - namespace
                            type: object
                          timeout:
                            type: string
                          url:
                            type: string
                        type: object
                    type: object
                  preUpdateChild:
                    properties:
                      webhook:
                        properties:
                          path:
                            type: string
                          service:
                            properties:
                              name:
                                type: string
                              namespace:
                                type: string
                              port:
                                format: int32
                                type: integer
                              protocol:
                                type: string
                            required:
                            - name
                            - namespace
                            type: object
                          timeout:
                            type: string
                          url:
                            type: string
                        type: object
                    type: object
                  sync:
                    properties:
                      webhook:
                        properties:
                          path:
                            type: string
                          service:
                            properties:
                              name:
                                type: string
                              namespace:
                                type: string
                              port:
                                format: int32
                                type: integer
                              protocol:
                                type: string
                            required:
                            - name
                            - namespace
                            type: object
                          timeout:
                            type: string
                          url:
                            type: string
                        type: object
                    type: object
                type: object
              parentResource:
                properties:
                  apiVersion:
                    type: string
                  resource:
                    type: string
                  revisionHistory:
                    properties:
                      fieldPaths:
                        items:
                          type: string
                        type: array
                    type: object
                required:
                - apiVersion
                - resource
                type: object
              resyncPeriodSeconds:
                format: int32
                type: integer
            required:
            - parentResource
            type: object
          status:
            type: object
        required:
        - metadata
        - spec
        type: object
    served: true
    storage: true
    subresources:
      status: {}
status:
  acceptedNames:
    kind: ""
    plural: ""
  conditions: []
  storedVersions: []
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-crd-controllerrevisions" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    api-approved.kubernetes.io: unapproved, request not yet submitted
  labels:
    application-crd-id: kubeflow-pipelines
    kustomize.component: metacontroller
  name: controllerrevisions.metacontroller.k8s.io
spec:
  group: metacontroller.k8s.io
  names:
    kind: ControllerRevision
    listKind: ControllerRevisionList
    plural: controllerrevisions
    singular: controllerrevision
  scope: Namespaced
  versions:
  - name: v1alpha1
    schema:
      openAPIV3Schema:
        properties:
          apiVersion:
            description: 'APIVersion defines the versioned schema of this representation
              of an object. Servers should convert recognized schemas to the latest
              internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources'
            type: string
          children:
            items:
              properties:
                apiGroup:
                  type: string
                kind:
                  type: string
                names:
                  items:
                    type: string
                  type: array
              required:
              - apiGroup
              - kind
              - names
              type: object
            type: array
          kind:
            description: 'Kind is a string value representing the REST resource this
              object represents. Servers may infer this from the endpoint the client
              submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds'
            type: string
          metadata:
            type: object
          parentPatch:
            type: object
        required:
        - metadata
        - parentPatch
        type: object
    served: true
    storage: true
    subresources:
      status: {}
status:
  acceptedNames:
    kind: ""
    plural: ""
  conditions: []
  storedVersions: []
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-crd-cronworkflows" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: cronworkflows.argoproj.io
spec:
  group: argoproj.io
  names:
    kind: CronWorkflow
    listKind: CronWorkflowList
    plural: cronworkflows
    shortNames:
    - cwf
    - cronwf
    singular: cronworkflow
  scope: Namespaced
  versions:
  - name: v1alpha1
    schema:
      openAPIV3Schema:
        properties:
          apiVersion:
            type: string
          kind:
            type: string
          metadata:
            type: object
          spec:
            type: object
            x-kubernetes-map-type: atomic
            x-kubernetes-preserve-unknown-fields: true
          status:
            type: object
            x-kubernetes-map-type: atomic
            x-kubernetes-preserve-unknown-fields: true
        required:
        - metadata
        - spec
        type: object
    served: true
    storage: true
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-crd-decoratorcontrollers" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    api-approved.kubernetes.io: unapproved, request not yet submitted
  labels:
    application-crd-id: kubeflow-pipelines
    kustomize.component: metacontroller
  name: decoratorcontrollers.metacontroller.k8s.io
spec:
  group: metacontroller.k8s.io
  names:
    kind: DecoratorController
    listKind: DecoratorControllerList
    plural: decoratorcontrollers
    shortNames:
    - dec
    - decorators
    singular: decoratorcontroller
  scope: Cluster
  versions:
  - name: v1alpha1
    schema:
      openAPIV3Schema:
        properties:
          apiVersion:
            description: 'APIVersion defines the versioned schema of this representation
              of an object. Servers should convert recognized schemas to the latest
              internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources'
            type: string
          kind:
            description: 'Kind is a string value representing the REST resource this
              object represents. Servers may infer this from the endpoint the client
              submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds'
            type: string
          metadata:
            type: object
          spec:
            properties:
              attachments:
                items:
                  properties:
                    apiVersion:
                      type: string
                    resource:
                      type: string
                    updateStrategy:
                      properties:
                        method:
                          type: string
                      type: object
                  required:
                  - apiVersion
                  - resource
                  type: object
                type: array
              hooks:
                properties:
                  customize:
                    properties:
                      webhook:
                        properties:
                          path:
                            type: string
                          service:
                            properties:
                              name:
                                type: string
                              namespace:
                                type: string
                              port:
                                format: int32
                                type: integer
                              protocol:
                                type: string
                            required:
                            - name
                            - namespace
                            type: object
                          timeout:
                            type: string
                          url:
                            type: string
                        type: object
                    type: object
                  finalize:
                    properties:
                      webhook:
                        properties:
                          path:
                            type: string
                          service:
                            properties:
                              name:
                                type: string
                              namespace:
                                type: string
                              port:
                                format: int32
                                type: integer
                              protocol:
                                type: string
                            required:
                            - name
                            - namespace
                            type: object
                          timeout:
                            type: string
                          url:
                            type: string
                        type: object
                    type: object
                  sync:
                    properties:
                      webhook:
                        properties:
                          path:
                            type: string
                          service:
                            properties:
                              name:
                                type: string
                              namespace:
                                type: string
                              port:
                                format: int32
                                type: integer
                              protocol:
                                type: string
                            required:
                            - name
                            - namespace
                            type: object
                          timeout:
                            type: string
                          url:
                            type: string
                        type: object
                    type: object
                type: object
              resources:
                items:
                  properties:
                    annotationSelector:
                      properties:
                        matchAnnotations:
                          additionalProperties:
                            type: string
                          type: object
                        matchExpressions:
                          items:
                            description: A label selector requirement is a selector
                              that contains values, a key, and an operator that relates
                              the key and values.
                            properties:
                              key:
                                description: key is the label key that the selector
                                  applies to.
                                type: string
                              operator:
                                description: operator represents a key's relationship
                                  to a set of values. Valid operators are In, NotIn,
                                  Exists and DoesNotExist.
                                type: string
                              values:
                                description: values is an array of string values.
                                  If the operator is In or NotIn, the values array
                                  must be non-empty. If the operator is Exists or
                                  DoesNotExist, the values array must be empty. This
                                  array is replaced during a strategic merge patch.
                                items:
                                  type: string
                                type: array
                            required:
                            - key
                            - operator
                            type: object
                          type: array
                      type: object
                    apiVersion:
                      type: string
                    labelSelector:
                      description: A label selector is a label query over a set of
                        resources. The result of matchLabels and matchExpressions
                        are ANDed. An empty label selector matches all objects. A
                        null label selector matches no objects.
                      properties:
                        matchExpressions:
                          description: matchExpressions is a list of label selector
                            requirements. The requirements are ANDed.
                          items:
                            description: A label selector requirement is a selector
                              that contains values, a key, and an operator that relates
                              the key and values.
                            properties:
                              key:
                                description: key is the label key that the selector
                                  applies to.
                                type: string
                              operator:
                                description: operator represents a key's relationship
                                  to a set of values. Valid operators are In, NotIn,
                                  Exists and DoesNotExist.
                                type: string
                              values:
                                description: values is an array of string values.
                                  If the operator is In or NotIn, the values array
                                  must be non-empty. If the operator is Exists or
                                  DoesNotExist, the values array must be empty. This
                                  array is replaced during a strategic merge patch.
                                items:
                                  type: string
                                type: array
                            required:
                            - key
                            - operator
                            type: object
                          type: array
                        matchLabels:
                          additionalProperties:
                            type: string
                          description: matchLabels is a map of {key,value} pairs.
                            A single {key,value} in the matchLabels map is equivalent
                            to an element of matchExpressions, whose key field is
                            "key", the operator is "In", and the values array contains
                            only "value". The requirements are ANDed.
                          type: object
                      type: object
                    resource:
                      type: string
                  required:
                  - apiVersion
                  - resource
                  type: object
                type: array
              resyncPeriodSeconds:
                format: int32
                type: integer
            required:
            - resources
            type: object
          status:
            type: object
        required:
        - metadata
        - spec
        type: object
    served: true
    storage: true
    subresources:
      status: {}
status:
  acceptedNames:
    kind: ""
    plural: ""
  conditions: []
  storedVersions: []
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-crd-scheduledworkflows" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: scheduledworkflows.kubeflow.org
spec:
  group: kubeflow.org
  names:
    kind: ScheduledWorkflow
    listKind: ScheduledWorkflowList
    plural: scheduledworkflows
    shortNames:
    - swf
    singular: scheduledworkflow
  scope: Namespaced
  versions:
  - name: v1beta1
    schema:
      openAPIV3Schema:
        properties:
          apiVersion:
            type: string
          kind:
            type: string
          metadata:
            type: object
          spec:
            type: object
            x-kubernetes-map-type: atomic
            x-kubernetes-preserve-unknown-fields: true
          status:
            type: object
            x-kubernetes-map-type: atomic
            x-kubernetes-preserve-unknown-fields: true
        required:
        - spec
        - status
        type: object
    served: true
    storage: true
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-crd-viewers" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: viewers.kubeflow.org
spec:
  group: kubeflow.org
  names:
    kind: Viewer
    listKind: ViewerList
    plural: viewers
    shortNames:
    - vi
    singular: viewer
  scope: Namespaced
  versions:
  - name: v1beta1
    schema:
      openAPIV3Schema:
        properties:
          apiVersion:
            type: string
          kind:
            type: string
          metadata:
            type: object
          spec:
            type: object
            x-kubernetes-map-type: atomic
            x-kubernetes-preserve-unknown-fields: true
        required:
        - spec
        type: object
    served: true
    storage: true
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-crd-workfloweventbindings" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: workfloweventbindings.argoproj.io
spec:
  group: argoproj.io
  names:
    kind: WorkflowEventBinding
    listKind: WorkflowEventBindingList
    plural: workfloweventbindings
    shortNames:
    - wfeb
    singular: workfloweventbinding
  scope: Namespaced
  versions:
  - name: v1alpha1
    schema:
      openAPIV3Schema:
        properties:
          apiVersion:
            type: string
          kind:
            type: string
          metadata:
            type: object
          spec:
            type: object
            x-kubernetes-map-type: atomic
            x-kubernetes-preserve-unknown-fields: true
        required:
        - metadata
        - spec
        type: object
    served: true
    storage: true
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-crd-workflows" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: workflows.argoproj.io
spec:
  group: argoproj.io
  names:
    kind: Workflow
    listKind: WorkflowList
    plural: workflows
    shortNames:
    - wf
    singular: workflow
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - description: Status of the workflow
      jsonPath: .status.phase
      name: Status
      type: string
    - description: When the workflow was started
      format: date-time
      jsonPath: .status.startedAt
      name: Age
      type: date
    name: v1alpha1
    schema:
      openAPIV3Schema:
        properties:
          apiVersion:
            type: string
          kind:
            type: string
          metadata:
            type: object
          spec:
            type: object
            x-kubernetes-map-type: atomic
            x-kubernetes-preserve-unknown-fields: true
          status:
            type: object
            x-kubernetes-map-type: atomic
            x-kubernetes-preserve-unknown-fields: true
        required:
        - metadata
        - spec
        type: object
    served: true
    storage: true
    subresources: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-crd-workflowtaskresults" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: workflowtaskresults.argoproj.io
spec:
  group: argoproj.io
  names:
    kind: WorkflowTaskResult
    listKind: WorkflowTaskResultList
    plural: workflowtaskresults
    singular: workflowtaskresult
  scope: Namespaced
  versions:
  - name: v1alpha1
    schema:
      openAPIV3Schema:
        properties:
          apiVersion:
            type: string
          kind:
            type: string
          message:
            type: string
          metadata:
            type: object
          outputs:
            properties:
              artifacts:
                items:
                  properties:
                    archive:
                      properties:
                        none:
                          type: object
                        tar:
                          properties:
                            compressionLevel:
                              format: int32
                              type: integer
                          type: object
                        zip:
                          type: object
                      type: object
                    archiveLogs:
                      type: boolean
                    artifactory:
                      properties:
                        passwordSecret:
                          properties:
                            key:
                              type: string
                            name:
                              type: string
                            optional:
                              type: boolean
                          required:
                          - key
                          type: object
                        url:
                          type: string
                        usernameSecret:
                          properties:
                            key:
                              type: string
                            name:
                              type: string
                            optional:
                              type: boolean
                          required:
                          - key
                          type: object
                      required:
                      - url
                      type: object
                    from:
                      type: string
                    fromExpression:
                      type: string
                    gcs:
                      properties:
                        bucket:
                          type: string
                        key:
                          type: string
                        serviceAccountKeySecret:
                          properties:
                            key:
                              type: string
                            name:
                              type: string
                            optional:
                              type: boolean
                          required:
                          - key
                          type: object
                      required:
                      - key
                      type: object
                    git:
                      properties:
                        depth:
                          format: int64
                          type: integer
                        disableSubmodules:
                          type: boolean
                        fetch:
                          items:
                            type: string
                          type: array
                        insecureIgnoreHostKey:
                          type: boolean
                        passwordSecret:
                          properties:
                            key:
                              type: string
                            name:
                              type: string
                            optional:
                              type: boolean
                          required:
                          - key
                          type: object
                        repo:
                          type: string
                        revision:
                          type: string
                        sshPrivateKeySecret:
                          properties:
                            key:
                              type: string
                            name:
                              type: string
                            optional:
                              type: boolean
                          required:
                          - key
                          type: object
                        usernameSecret:
                          properties:
                            key:
                              type: string
                            name:
                              type: string
                            optional:
                              type: boolean
                          required:
                          - key
                          type: object
                      required:
                      - repo
                      type: object
                    globalName:
                      type: string
                    hdfs:
                      properties:
                        addresses:
                          items:
                            type: string
                          type: array
                        force:
                          type: boolean
                        hdfsUser:
                          type: string
                        krbCCacheSecret:
                          properties:
                            key:
                              type: string
                            name:
                              type: string
                            optional:
                              type: boolean
                          required:
                          - key
                          type: object
                        krbConfigConfigMap:
                          properties:
                            key:
                              type: string
                            name:
                              type: string
                            optional:
                              type: boolean
                          required:
                          - key
                          type: object
                        krbKeytabSecret:
                          properties:
                            key:
                              type: string
                            name:
                              type: string
                            optional:
                              type: boolean
                          required:
                          - key
                          type: object
                        krbRealm:
                          type: string
                        krbServicePrincipalName:
                          type: string
                        krbUsername:
                          type: string
                        path:
                          type: string
                      required:
                      - path
                      type: object
                    http:
                      properties:
                        headers:
                          items:
                            properties:
                              name:
                                type: string
                              value:
                                type: string
                            required:
                            - name
                            - value
                            type: object
                          type: array
                        url:
                          type: string
                      required:
                      - url
                      type: object
                    mode:
                      format: int32
                      type: integer
                    name:
                      type: string
                    optional:
                      type: boolean
                    oss:
                      properties:
                        accessKeySecret:
                          properties:
                            key:
                              type: string
                            name:
                              type: string
                            optional:
                              type: boolean
                          required:
                          - key
                          type: object
                        bucket:
                          type: string
                        createBucketIfNotPresent:
                          type: boolean
                        endpoint:
                          type: string
                        key:
                          type: string
                        lifecycleRule:
                          properties:
                            markDeletionAfterDays:
                              format: int32
                              type: integer
                            markInfrequentAccessAfterDays:
                              format: int32
                              type: integer
                          type: object
                        secretKeySecret:
                          properties:
                            key:
                              type: string
                            name:
                              type: string
                            optional:
                              type: boolean
                          required:
                          - key
                          type: object
                        securityToken:
                          type: string
                      required:
                      - key
                      type: object
                    path:
                      type: string
                    raw:
                      properties:
                        data:
                          type: string
                      required:
                      - data
                      type: object
                    recurseMode:
                      type: boolean
                    s3:
                      properties:
                        accessKeySecret:
                          properties:
                            key:
                              type: string
                            name:
                              type: string
                            optional:
                              type: boolean
                          required:
                          - key
                          type: object
                        bucket:
                          type: string
                        createBucketIfNotPresent:
                          properties:
                            objectLocking:
                              type: boolean
                          type: object
                        encryptionOptions:
                          properties:
                            enableEncryption:
                              type: boolean
                            kmsEncryptionContext:
                              type: string
                            kmsKeyId:
                              type: string
                            serverSideCustomerKeySecret:
                              properties:
                                key:
                                  type: string
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              required:
                              - key
                              type: object
                          type: object
                        endpoint:
                          type: string
                        insecure:
                          type: boolean
                        key:
                          type: string
                        region:
                          type: string
                        roleARN:
                          type: string
                        secretKeySecret:
                          properties:
                            key:
                              type: string
                            name:
                              type: string
                            optional:
                              type: boolean
                          required:
                          - key
                          type: object
                        useSDKCreds:
                          type: boolean
                      type: object
                    subPath:
                      type: string
                  required:
                  - name
                  type: object
                type: array
              exitCode:
                type: string
              parameters:
                items:
                  properties:
                    default:
                      type: string
                    description:
                      type: string
                    enum:
                      items:
                        type: string
                      type: array
                    globalName:
                      type: string
                    name:
                      type: string
                    value:
                      type: string
                    valueFrom:
                      properties:
                        configMapKeyRef:
                          properties:
                            key:
                              type: string
                            name:
                              type: string
                            optional:
                              type: boolean
                          required:
                          - key
                          type: object
                        default:
                          type: string
                        event:
                          type: string
                        expression:
                          type: string
                        jqFilter:
                          type: string
                        jsonPath:
                          type: string
                        parameter:
                          type: string
                        path:
                          type: string
                        supplied:
                          type: object
                      type: object
                  required:
                  - name
                  type: object
                type: array
              result:
                type: string
            type: object
          phase:
            type: string
          progress:
            type: string
        required:
        - metadata
        type: object
    served: true
    storage: true
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-crd-workflowtasksets" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: workflowtasksets.argoproj.io
spec:
  group: argoproj.io
  names:
    kind: WorkflowTaskSet
    listKind: WorkflowTaskSetList
    plural: workflowtasksets
    shortNames:
    - wfts
    singular: workflowtaskset
  scope: Namespaced
  versions:
  - name: v1alpha1
    schema:
      openAPIV3Schema:
        properties:
          apiVersion:
            type: string
          kind:
            type: string
          metadata:
            type: object
          spec:
            type: object
            x-kubernetes-map-type: atomic
            x-kubernetes-preserve-unknown-fields: true
          status:
            type: object
            x-kubernetes-map-type: atomic
            x-kubernetes-preserve-unknown-fields: true
        required:
        - metadata
        - spec
        type: object
    served: true
    storage: true
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-crd-workflowtemplates" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: workflowtemplates.argoproj.io
spec:
  group: argoproj.io
  names:
    kind: WorkflowTemplate
    listKind: WorkflowTemplateList
    plural: workflowtemplates
    shortNames:
    - wftmpl
    singular: workflowtemplate
  scope: Namespaced
  versions:
  - name: v1alpha1
    schema:
      openAPIV3Schema:
        properties:
          apiVersion:
            type: string
          kind:
            type: string
          metadata:
            type: object
          spec:
            type: object
            x-kubernetes-map-type: atomic
            x-kubernetes-preserve-unknown-fields: true
        required:
        - metadata
        - spec
        type: object
    served: true
    storage: true
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kubeflow-serviceaccount-argo" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: argo
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-serviceaccount-kubeflow-pipelines-cache" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app: cache-server
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: kubeflow-pipelines-cache
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-serviceaccount-kubeflow-pipelines-container-builder" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: kubeflow-pipelines-container-builder
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-serviceaccount-kubeflow-pipelines-metadata-writer" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: kubeflow-pipelines-metadata-writer
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-serviceaccount-kubeflow-pipelines-viewer" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: kubeflow-pipelines-viewer
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-serviceaccount-meta-controller-service" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
    kustomize.component: metacontroller
  name: meta-controller-service
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-serviceaccount-meta-grpc-server" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: metadata-grpc-server
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-serviceaccount-ml-pipeline" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-serviceaccount-ml-pipeline-persistenceagent" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-persistenceagent
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-serviceaccount-ml-pipeline-scheduledworkflow" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-scheduledworkflow
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-serviceaccount-ml-pipeline-ui" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-ui
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-serviceaccount-ml-pipeline-viewer-crd-service-account" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-viewer-crd-service-account
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-serviceaccount-ml-pipeline-visualizationserver" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-visualizationserver
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-serviceaccount-pipeline-runner" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: pipeline-runner
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-role-argo-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: argo-role
  namespace: kubeflow
rules:
- apiGroups:
  - coordination.k8s.io
  resources:
  - leases
  verbs:
  - create
  - get
  - update
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - get
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-role-kubeflow-pipelines-cache-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  labels:
    app: cache-server
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: kubeflow-pipelines-cache-role
  namespace: kubeflow
rules:
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - get
  - list
  - watch
  - update
  - patch
- apiGroups:
  - ""
  resources:
  - configmaps
  verbs:
  - get
- apiGroups:
  - argoproj.io
  resources:
  - workflows
  verbs:
  - get
  - list
  - watch
  - update
  - patch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-role-kubeflow-pipelines-metadata-writer-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  labels:
    app: kubeflow-pipelines-metadata-writer-role
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: kubeflow-pipelines-metadata-writer-role
  namespace: kubeflow
rules:
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - get
  - list
  - watch
  - update
  - patch
- apiGroups:
  - ""
  resources:
  - configmaps
  verbs:
  - get
- apiGroups:
  - argoproj.io
  resources:
  - workflows
  verbs:
  - get
  - list
  - watch
  - update
  - patch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-role-ml-pipeline" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  labels:
    app: ml-pipeline
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline
  namespace: kubeflow
rules:
- apiGroups:
  - ""
  resources:
  - pods
  - pods/log
  verbs:
  - get
  - list
  - delete
- apiGroups:
  - argoproj.io
  resources:
  - workflows
  verbs:
  - create
  - get
  - list
  - watch
  - update
  - patch
  - delete
- apiGroups:
  - kubeflow.org
  resources:
  - scheduledworkflows
  verbs:
  - create
  - get
  - list
  - update
  - patch
  - delete
- apiGroups:
  - authorization.k8s.io
  resources:
  - subjectaccessreviews
  verbs:
  - create
- apiGroups:
  - authentication.k8s.io
  resources:
  - tokenreviews
  verbs:
  - create
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-role-ml-pipeline-persistenceagent-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-persistenceagent-role
  namespace: kubeflow
rules:
- apiGroups:
  - argoproj.io
  resources:
  - workflows
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - kubeflow.org
  resources:
  - scheduledworkflows
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - namespaces
  verbs:
  - get
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-role-ml-pipeline-scheduledworkflow-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  labels:
    app: ml-pipeline-scheduledworkflow-role
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-scheduledworkflow-role
  namespace: kubeflow
rules:
- apiGroups:
  - argoproj.io
  resources:
  - workflows
  verbs:
  - create
  - get
  - list
  - watch
  - update
  - patch
  - delete
- apiGroups:
  - kubeflow.org
  resources:
  - scheduledworkflows
  - scheduledworkflows/finalizers
  verbs:
  - create
  - get
  - list
  - watch
  - update
  - patch
  - delete
- apiGroups:
  - ""
  resources:
  - events
  verbs:
  - create
  - patch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-role-ml-pipeline-ui" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  labels:
    app: ml-pipeline-ui
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-ui
  namespace: kubeflow
rules:
- apiGroups:
  - ""
  resources:
  - pods
  - pods/log
  verbs:
  - get
- apiGroups:
  - ""
  resources:
  - events
  verbs:
  - list
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - get
  - list
- apiGroups:
  - kubeflow.org
  resources:
  - viewers
  verbs:
  - create
  - get
  - list
  - watch
  - delete
- apiGroups:
  - argoproj.io
  resources:
  - workflows
  verbs:
  - get
  - list
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-role-ml-pipeline-viewer-controller-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-viewer-controller-role
  namespace: kubeflow
rules:
- apiGroups:
  - '*'
  resources:
  - deployments
  - services
  verbs:
  - create
  - get
  - list
  - watch
  - update
  - patch
  - delete
- apiGroups:
  - kubeflow.org
  resources:
  - viewers
  - viewers/finalizers
  verbs:
  - create
  - get
  - list
  - watch
  - update
  - patch
  - delete
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-role-pipeline-runner" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: pipeline-runner
  namespace: kubeflow
rules:
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - get
- apiGroups:
  - ""
  resources:
  - configmaps
  verbs:
  - get
  - watch
  - list
- apiGroups:
  - ""
  resources:
  - persistentvolumes
  - persistentvolumeclaims
  verbs:
  - '*'
- apiGroups:
  - snapshot.storage.k8s.io
  resources:
  - volumesnapshots
  verbs:
  - create
  - delete
  - get
- apiGroups:
  - argoproj.io
  resources:
  - workflows
  verbs:
  - get
  - list
  - watch
  - update
  - patch
- apiGroups:
  - ""
  resources:
  - pods
  - pods/exec
  - pods/log
  - services
  verbs:
  - '*'
- apiGroups:
  - ""
  - apps
  - extensions
  resources:
  - deployments
  - replicasets
  verbs:
  - '*'
- apiGroups:
  - kubeflow.org
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - batch
  resources:
  - jobs
  verbs:
  - '*'
- apiGroups:
  - machinelearning.seldon.io
  resources:
  - seldondeployments
  verbs:
  - '*'
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-aggregate-to-kubeflow-pipelines-edit" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-pipelines-edit: "true"
  name: aggregate-to-kubeflow-pipelines-edit
rules:
- apiGroups:
  - pipelines.kubeflow.org
  resources:
  - pipelines
  - pipelines/versions
  verbs:
  - create
  - delete
  - update
- apiGroups:
  - pipelines.kubeflow.org
  resources:
  - experiments
  verbs:
  - archive
  - create
  - delete
  - unarchive
- apiGroups:
  - pipelines.kubeflow.org
  resources:
  - runs
  verbs:
  - archive
  - create
  - delete
  - retry
  - terminate
  - unarchive
  - reportMetrics
  - readArtifact
- apiGroups:
  - pipelines.kubeflow.org
  resources:
  - jobs
  verbs:
  - create
  - delete
  - disable
  - enable
- apiGroups:
  - kubeflow.org
  resources:
  - scheduledworkflows
  verbs:
  - '*'
- apiGroups:
  - argoproj.io
  resources:
  - cronworkflows
  - cronworkflows/finalizers
  - workflows
  - workflows/finalizers
  - workfloweventbindings
  - workflowtemplates
  verbs:
  - '*'
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-pipelines-view: "true"
  name: aggregate-to-kubeflow-pipelines-view
rules:
- apiGroups:
  - pipelines.kubeflow.org
  resources:
  - pipelines
  - pipelines/versions
  - experiments
  - jobs
  verbs:
  - get
  - list
- apiGroups:
  - pipelines.kubeflow.org
  resources:
  - runs
  verbs:
  - get
  - list
  - readArtifact
- apiGroups:
  - kubeflow.org
  resources:
  - viewers
  verbs:
  - create
  - get
  - delete
- apiGroups:
  - pipelines.kubeflow.org
  resources:
  - visualizations
  verbs:
  - create
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-argo-aggregate-to-admin" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
    rbac.authorization.k8s.io/aggregate-to-admin: "true"
  name: argo-aggregate-to-admin
rules:
- apiGroups:
  - argoproj.io
  resources:
  - workflows
  - workflows/finalizers
  - workfloweventbindings
  - workfloweventbindings/finalizers
  - workflowtemplates
  - workflowtemplates/finalizers
  - cronworkflows
  - cronworkflows/finalizers
  - clusterworkflowtemplates
  - clusterworkflowtemplates/finalizers
  - workflowtasksets
  - workflowtasksets/finalizers
  verbs:
  - create
  - delete
  - deletecollection
  - get
  - list
  - patch
  - update
  - watch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-argo-aggregate-to-edit" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
    rbac.authorization.k8s.io/aggregate-to-edit: "true"
  name: argo-aggregate-to-edit
rules:
- apiGroups:
  - argoproj.io
  resources:
  - workflows
  - workflows/finalizers
  - workfloweventbindings
  - workfloweventbindings/finalizers
  - workflowtemplates
  - workflowtemplates/finalizers
  - cronworkflows
  - cronworkflows/finalizers
  - clusterworkflowtemplates
  - clusterworkflowtemplates/finalizers
  verbs:
  - create
  - delete
  - deletecollection
  - get
  - list
  - patch
  - update
  - watch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-argo-aggregate-to-view" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
    rbac.authorization.k8s.io/aggregate-to-view: "true"
  name: argo-aggregate-to-view
rules:
- apiGroups:
  - argoproj.io
  resources:
  - workflows
  - workflows/finalizers
  - workfloweventbindings
  - workfloweventbindings/finalizers
  - workflowtemplates
  - workflowtemplates/finalizers
  - cronworkflows
  - cronworkflows/finalizers
  - clusterworkflowtemplates
  - clusterworkflowtemplates/finalizers
  verbs:
  - get
  - list
  - watch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-argo-cluster-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: argo-cluster-role
rules:
- apiGroups:
  - ""
  resources:
  - pods
  - pods/exec
  verbs:
  - create
  - get
  - list
  - watch
  - update
  - patch
  - delete
- apiGroups:
  - ""
  resources:
  - configmaps
  verbs:
  - get
  - watch
  - list
- apiGroups:
  - ""
  resources:
  - persistentvolumeclaims
  - persistentvolumeclaims/finalizers
  verbs:
  - create
  - update
  - delete
  - get
- apiGroups:
  - argoproj.io
  resources:
  - workflows
  - workflows/finalizers
  - workflowtasksets
  - workflowtasksets/finalizers
  verbs:
  - get
  - list
  - watch
  - update
  - patch
  - delete
  - create
- apiGroups:
  - argoproj.io
  resources:
  - workflowtemplates
  - workflowtemplates/finalizers
  - clusterworkflowtemplates
  - clusterworkflowtemplates/finalizers
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - argoproj.io
  resources:
  - workflowtaskresults
  verbs:
  - list
  - watch
  - deletecollection
- apiGroups:
  - ""
  resources:
  - serviceaccounts
  verbs:
  - get
  - list
- apiGroups:
  - argoproj.io
  resources:
  - cronworkflows
  - cronworkflows/finalizers
  verbs:
  - get
  - list
  - watch
  - update
  - patch
  - delete
- apiGroups:
  - ""
  resources:
  - events
  verbs:
  - create
  - patch
- apiGroups:
  - policy
  resources:
  - poddisruptionbudgets
  verbs:
  - create
  - get
  - delete
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-kubeflow-pipelines-cache-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: cache-server
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: kubeflow-pipelines-cache-role
rules:
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - get
  - list
  - watch
  - update
  - patch
- apiGroups:
  - ""
  resources:
  - configmaps
  verbs:
  - get
- apiGroups:
  - argoproj.io
  resources:
  - workflows
  verbs:
  - get
  - list
  - watch
  - update
  - patch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-kubeflow-pipelines-edit" {
  yaml_body = <<YAML
aggregationRule:
  clusterRoleSelectors:
  - matchLabels:
      rbac.authorization.kubeflow.org/aggregate-to-kubeflow-pipelines-edit: "true"
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-edit: "true"
  name: kubeflow-pipelines-edit
rules: []
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-kubeflow-pipelines-metadata-writer-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: kubeflow-pipelines-metadata-writer-role
rules:
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - get
  - list
  - watch
  - update
  - patch
- apiGroups:
  - ""
  resources:
  - configmaps
  verbs:
  - get
- apiGroups:
  - argoproj.io
  resources:
  - workflows
  verbs:
  - get
  - list
  - watch
  - update
  - patch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-kubeflow-pipelines-view" {
  yaml_body = <<YAML
aggregationRule:
  clusterRoleSelectors:
  - matchLabels:
      rbac.authorization.kubeflow.org/aggregate-to-kubeflow-pipelines-view: "true"
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-pipelines-edit: "true"
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-view: "true"
  name: kubeflow-pipelines-view
rules: []
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-ml-pipeline" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline
rules:
- apiGroups:
  - ""
  resources:
  - pods
  - pods/log
  verbs:
  - get
  - list
  - delete
- apiGroups:
  - argoproj.io
  resources:
  - workflows
  verbs:
  - create
  - get
  - list
  - watch
  - update
  - patch
  - delete
- apiGroups:
  - kubeflow.org
  resources:
  - scheduledworkflows
  verbs:
  - create
  - get
  - list
  - update
  - patch
  - delete
- apiGroups:
  - authorization.k8s.io
  resources:
  - subjectaccessreviews
  verbs:
  - create
- apiGroups:
  - authentication.k8s.io
  resources:
  - tokenreviews
  verbs:
  - create
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-ml-pipeline-persistenceagent-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-persistenceagent-role
rules:
- apiGroups:
  - argoproj.io
  resources:
  - workflows
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - kubeflow.org
  resources:
  - scheduledworkflows
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - namespaces
  verbs:
  - get
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-ml-pipeline-scheduledworkflow-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-scheduledworkflow-role
rules:
- apiGroups:
  - argoproj.io
  resources:
  - workflows
  verbs:
  - create
  - get
  - list
  - watch
  - update
  - patch
  - delete
- apiGroups:
  - kubeflow.org
  resources:
  - scheduledworkflows
  - scheduledworkflows/finalizers
  verbs:
  - create
  - get
  - list
  - watch
  - update
  - patch
  - delete
- apiGroups:
  - ""
  resources:
  - events
  verbs:
  - create
  - patch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-ml-pipeline-ui" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: ml-pipeline-ui
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-ui
rules:
- apiGroups:
  - ""
  resources:
  - pods
  - pods/log
  verbs:
  - get
- apiGroups:
  - ""
  resources:
  - events
  verbs:
  - list
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - get
  - list
- apiGroups:
  - kubeflow.org
  resources:
  - viewers
  verbs:
  - create
  - get
  - list
  - watch
  - delete
- apiGroups:
  - argoproj.io
  resources:
  - workflows
  verbs:
  - get
  - list
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrole-ml-pipeline-viewer-controller-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-viewer-controller-role
rules:
- apiGroups:
  - '*'
  resources:
  - deployments
  - services
  verbs:
  - create
  - get
  - list
  - watch
  - update
  - patch
  - delete
- apiGroups:
  - kubeflow.org
  resources:
  - viewers
  - viewers/finalizers
  verbs:
  - create
  - get
  - list
  - watch
  - update
  - patch
  - delete
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-rolebinding-argobinding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: argo-binding
  namespace: kubeflow
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: argo-role
subjects:
- kind: ServiceAccount
  name: argo
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-rolebinding-kubeflow-pipelines-cache-binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    app: cache-server
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: kubeflow-pipelines-cache-binding
  namespace: kubeflow
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: kubeflow-pipelines-cache-role
subjects:
- kind: ServiceAccount
  name: kubeflow-pipelines-cache
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-rolebinding-kubeflow-pipelines-metadata-writer-binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: kubeflow-pipelines-metadata-writer-binding
  namespace: kubeflow
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: kubeflow-pipelines-metadata-writer-role
subjects:
- kind: ServiceAccount
  name: kubeflow-pipelines-metadata-writer
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-rolebinding-ml-pipeline" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    app: ml-pipeline
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline
  namespace: kubeflow
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: ml-pipeline
subjects:
- kind: ServiceAccount
  name: ml-pipeline
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-rolebinding-ml-pipeline-persistenceagent-binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-persistenceagent-binding
  namespace: kubeflow
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: ml-pipeline-persistenceagent-role
subjects:
- kind: ServiceAccount
  name: ml-pipeline-persistenceagent
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-rolebinding-ml-pipeline-scheduledworkflow-binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-scheduledworkflow-binding
  namespace: kubeflow
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: ml-pipeline-scheduledworkflow-role
subjects:
- kind: ServiceAccount
  name: ml-pipeline-scheduledworkflow
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-rolebinding-ml-pipeline-ui" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    app: ml-pipeline-ui
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-ui
  namespace: kubeflow
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: ml-pipeline-ui
subjects:
- kind: ServiceAccount
  name: ml-pipeline-ui
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-rolebinding-ml-pipeline-viewer-crd-binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-viewer-crd-binding
  namespace: kubeflow
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: ml-pipeline-viewer-controller-role
subjects:
- kind: ServiceAccount
  name: ml-pipeline-viewer-crd-service-account
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-rolebinding-pipeline-runner-binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: pipeline-runner-binding
  namespace: kubeflow
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: pipeline-runner
subjects:
- kind: ServiceAccount
  name: pipeline-runner
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrolebinding-argo-binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: argo-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: argo-cluster-role
subjects:
- kind: ServiceAccount
  name: argo
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrolebinding-kubeflow-pipelines-cache-binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app: cache-server
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: kubeflow-pipelines-cache-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: kubeflow-pipelines-cache-role
subjects:
- kind: ServiceAccount
  name: kubeflow-pipelines-cache
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrolebinding-kubeflow-pipelines-metadata-writer-binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: kubeflow-pipelines-metadata-writer-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: kubeflow-pipelines-metadata-writer-role
subjects:
- kind: ServiceAccount
  name: kubeflow-pipelines-metadata-writer
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrolebinding-meta-controller-cluster-role-binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
    kustomize.component: metacontroller
  name: meta-controller-cluster-role-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: meta-controller-service
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrolebinding-ml-binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ml-pipeline
subjects:
- kind: ServiceAccount
  name: ml-pipeline
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrolebinding-ml-pipeline-persistenceagent-binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-persistenceagent-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ml-pipeline-persistenceagent-role
subjects:
- kind: ServiceAccount
  name: ml-pipeline-persistenceagent
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrolebinding-ml-pipeline-scheduledworkflow-binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-scheduledworkflow-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ml-pipeline-scheduledworkflow-role
subjects:
- kind: ServiceAccount
  name: ml-pipeline-scheduledworkflow
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrolebinding-ml-pipeline-ui" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app: ml-pipeline-ui
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-ui
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ml-pipeline-ui
subjects:
- kind: ServiceAccount
  name: ml-pipeline-ui
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-clusterrolebinding-ml-pipeline-viewer-crd-binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-viewer-crd-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ml-pipeline-viewer-controller-role
subjects:
- kind: ServiceAccount
  name: ml-pipeline-viewer-crd-service-account
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-configmap-kfp-launcher" {
  yaml_body = <<YAML
apiVersion: v1
data:
  defaultPipelineRoot: ""
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: kfp-launcher
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-configmap-kubeflow-pipelines-profile-controller-code-hdk828hd6c" {
  yaml_body = <<YAML
apiVersion: v1
data:
  sync.py: |
    # Copyright 2020-2021 The Kubeflow Authors
    #
    # Licensed under the Apache License, Version 2.0 (the "License");
    # you may not use this file except in compliance with the License.
    # You may obtain a copy of the License at
    #
    #      http://www.apache.org/licenses/LICENSE-2.0
    #
    # Unless required by applicable law or agreed to in writing, software
    # distributed under the License is distributed on an "AS IS" BASIS,
    # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    # See the License for the specific language governing permissions and
    # limitations under the License.

    from http.server import BaseHTTPRequestHandler, HTTPServer
    import json
    import os
    import base64


    def main():
        settings = get_settings_from_env()
        server = server_factory(**settings)
        server.serve_forever()


    def get_settings_from_env(controller_port=None,
                              visualization_server_image=None, frontend_image=None,
                              visualization_server_tag=None, frontend_tag=None, disable_istio_sidecar=None,
                              minio_access_key=None, minio_secret_key=None, kfp_default_pipeline_root=None):
        """
        Returns a dict of settings from environment variables relevant to the controller

        Environment settings can be overridden by passing them here as arguments.

        Settings are pulled from the all-caps version of the setting name.  The
        following defaults are used if those environment variables are not set
        to enable backwards compatibility with previous versions of this script:
            visualization_server_image: gcr.io/ml-pipeline/visualization-server
            visualization_server_tag: value of KFP_VERSION environment variable
            frontend_image: gcr.io/ml-pipeline/frontend
            frontend_tag: value of KFP_VERSION environment variable
            disable_istio_sidecar: Required (no default)
            minio_access_key: Required (no default)
            minio_secret_key: Required (no default)
        """
        settings = dict()
        settings["controller_port"] = \
            controller_port or \
            os.environ.get("CONTROLLER_PORT", "8080")

        settings["visualization_server_image"] = \
            visualization_server_image or \
            os.environ.get("VISUALIZATION_SERVER_IMAGE", "gcr.io/ml-pipeline/visualization-server")

        settings["frontend_image"] = \
            frontend_image or \
            os.environ.get("FRONTEND_IMAGE", "gcr.io/ml-pipeline/frontend")

        # Look for specific tags for each image first, falling back to
        # previously used KFP_VERSION environment variable for backwards
        # compatibility
        settings["visualization_server_tag"] = \
            visualization_server_tag or \
            os.environ.get("VISUALIZATION_SERVER_TAG") or \
            os.environ["KFP_VERSION"]

        settings["frontend_tag"] = \
            frontend_tag or \
            os.environ.get("FRONTEND_TAG") or \
            os.environ["KFP_VERSION"]

        settings["disable_istio_sidecar"] = \
            disable_istio_sidecar if disable_istio_sidecar is not None \
                else os.environ.get("DISABLE_ISTIO_SIDECAR") == "true"

        settings["minio_access_key"] = \
            minio_access_key or \
            base64.b64encode(bytes(os.environ.get("MINIO_ACCESS_KEY"), 'utf-8')).decode('utf-8')

        settings["minio_secret_key"] = \
            minio_secret_key or \
            base64.b64encode(bytes(os.environ.get("MINIO_SECRET_KEY"), 'utf-8')).decode('utf-8')

        # KFP_DEFAULT_PIPELINE_ROOT is optional
        settings["kfp_default_pipeline_root"] = \
            kfp_default_pipeline_root or \
            os.environ.get("KFP_DEFAULT_PIPELINE_ROOT")

        return settings


    def server_factory(visualization_server_image,
                       visualization_server_tag, frontend_image, frontend_tag,
                       disable_istio_sidecar, minio_access_key,
                       minio_secret_key, kfp_default_pipeline_root=None,
                       url="", controller_port=8080):
        """
        Returns an HTTPServer populated with Handler with customized settings
        """
        class Controller(BaseHTTPRequestHandler):
            def sync(self, parent, children):
                # parent is a namespace
                namespace = parent.get("metadata", {}).get("name")

                pipeline_enabled = parent.get("metadata", {}).get(
                    "labels", {}).get("pipelines.kubeflow.org/enabled")

                if pipeline_enabled != "true":
                    return {"status": {}, "children": []}

                desired_configmap_count = 1
                desired_resources = []
                if kfp_default_pipeline_root:
                    desired_configmap_count = 2
                    desired_resources += [{
                        "apiVersion": "v1",
                        "kind": "ConfigMap",
                        "metadata": {
                            "name": "kfp-launcher",
                            "namespace": namespace,
                        },
                        "data": {
                            "defaultPipelineRoot": kfp_default_pipeline_root,
                        },
                    }]


                # Compute status based on observed state.
                desired_status = {
                    "kubeflow-pipelines-ready":
                        len(children["Secret.v1"]) == 1 and
                        len(children["ConfigMap.v1"]) == desired_configmap_count and
                        len(children["Deployment.apps/v1"]) == 2 and
                        len(children["Service.v1"]) == 2 and
                        len(children["DestinationRule.networking.istio.io/v1alpha3"]) == 1 and
                        len(children["AuthorizationPolicy.security.istio.io/v1beta1"]) == 1 and
                        "True" or "False"
                }

                # Generate the desired child object(s).
                desired_resources += [
                    {
                        "apiVersion": "v1",
                        "kind": "ConfigMap",
                        "metadata": {
                            "name": "metadata-grpc-configmap",
                            "namespace": namespace,
                        },
                        "data": {
                            "METADATA_GRPC_SERVICE_HOST":
                                "metadata-grpc-service.kubeflow",
                            "METADATA_GRPC_SERVICE_PORT": "8080",
                        },
                    },
                    # Visualization server related manifests below
                    {
                        "apiVersion": "apps/v1",
                        "kind": "Deployment",
                        "metadata": {
                            "labels": {
                                "app": "ml-pipeline-visualizationserver"
                            },
                            "name": "ml-pipeline-visualizationserver",
                            "namespace": namespace,
                        },
                        "spec": {
                            "selector": {
                                "matchLabels": {
                                    "app": "ml-pipeline-visualizationserver"
                                },
                            },
                            "template": {
                                "metadata": {
                                    "labels": {
                                        "app": "ml-pipeline-visualizationserver"
                                    },
                                    "annotations": disable_istio_sidecar and {
                                        "sidecar.istio.io/inject": "false"
                                    } or {},
                                },
                                "spec": {
                                    "containers": [{
                                        "image": f"{visualization_server_image}:{visualization_server_tag}",
                                        "imagePullPolicy":
                                            "IfNotPresent",
                                        "name":
                                            "ml-pipeline-visualizationserver",
                                        "ports": [{
                                            "containerPort": 8888
                                        }],
                                        "resources": {
                                            "requests": {
                                                "cpu": "50m",
                                                "memory": "200Mi"
                                            },
                                            "limits": {
                                                "cpu": "500m",
                                                "memory": "1Gi"
                                            },
                                        }
                                    }],
                                    "nodeSelector": {
                                      "kubeflow": "control-plane"
                                    },
                                    "tolerations": [{
                                      "effect": "NoSchedule",
                                      "key": "kubeflow",
                                      "operator": "Equal",
                                      "value": "control-plane"
                                    }],
                                    "serviceAccountName":
                                        "default-editor",
                                },
                            },
                        },
                    },
                    {
                        "apiVersion": "networking.istio.io/v1alpha3",
                        "kind": "DestinationRule",
                        "metadata": {
                            "name": "ml-pipeline-visualizationserver",
                            "namespace": namespace,
                        },
                        "spec": {
                            "host": "ml-pipeline-visualizationserver",
                            "trafficPolicy": {
                                "tls": {
                                    "mode": "ISTIO_MUTUAL"
                                }
                            }
                        }
                    },
                    {
                        "apiVersion": "security.istio.io/v1beta1",
                        "kind": "AuthorizationPolicy",
                        "metadata": {
                            "name": "ml-pipeline-visualizationserver",
                            "namespace": namespace,
                        },
                        "spec": {
                            "selector": {
                                "matchLabels": {
                                    "app": "ml-pipeline-visualizationserver"
                                }
                            },
                            "rules": [{
                                "from": [{
                                    "source": {
                                        "principals": ["cluster.local/ns/kubeflow/sa/ml-pipeline"]
                                    }
                                }]
                            }]
                        }
                    },
                    {
                        "apiVersion": "v1",
                        "kind": "Service",
                        "metadata": {
                            "name": "ml-pipeline-visualizationserver",
                            "namespace": namespace,
                        },
                        "spec": {
                            "ports": [{
                                "name": "http",
                                "port": 8888,
                                "protocol": "TCP",
                                "targetPort": 8888,
                            }],
                            "selector": {
                                "app": "ml-pipeline-visualizationserver",
                            },
                        },
                    },
                    # Artifact fetcher related resources below.
                    {
                        "apiVersion": "apps/v1",
                        "kind": "Deployment",
                        "metadata": {
                            "labels": {
                                "app": "ml-pipeline-ui-artifact"
                            },
                            "name": "ml-pipeline-ui-artifact",
                            "namespace": namespace,
                        },
                        "spec": {
                            "selector": {
                                "matchLabels": {
                                    "app": "ml-pipeline-ui-artifact"
                                }
                            },
                            "template": {
                                "metadata": {
                                    "labels": {
                                        "app": "ml-pipeline-ui-artifact"
                                    },
                                    "annotations": disable_istio_sidecar and {
                                        "sidecar.istio.io/inject": "false"
                                    } or {},
                                },
                                "spec": {
                                    "containers": [{
                                        "name":
                                            "ml-pipeline-ui-artifact",
                                        "image": f"{frontend_image}:{frontend_tag}",
                                        "imagePullPolicy":
                                            "IfNotPresent",
                                        "ports": [{
                                            "containerPort": 3000
                                        }],
                                        "env": [
                                            {
                                                "name": "MINIO_HOST",
                                                "value": "s3.${var.ovh_s3_region_name}.io.cloud.ovh.net"
                                            },
                                            {
                                                "name": "MINIO_PORT",
                                                "value": "443"
                                            },
                                            {
                                                "name": "MINIO_SECURE",
                                                "value": "true"
                                            },
                                            {
                                                "name": "MINIO_NAMESPACE",
                                                "value": ""
                                            },
                                            {
                                                "name": "MINIO_ACCESS_KEY",
                                                "valueFrom": {
                                                    "secretKeyRef": {
                                                        "key": "accesskey",
                                                        "name": "mlpipeline-minio-artifact"
                                                    }
                                                }
                                            },
                                            {
                                                "name": "MINIO_SECRET_KEY",
                                                "valueFrom": {
                                                    "secretKeyRef": {
                                                        "key": "secretkey",
                                                        "name": "mlpipeline-minio-artifact"
                                                    }
                                                }
                                            },
                                            {
                                              "name": "AWS_S3_ENDPOINT",
                                              "value": "s3.${var.ovh_s3_region_name}.io.cloud.ovh.net"
                                            },
                                            {
                                              "name": "AWS_REGION",
                                              "value": "${var.ovh_s3_region_name}"
                                            },
                                            {
                                                "name": "AWS_SSL",
                                                "value": "true"
                                            },
                                            {
                                                "name": "AWS_ACCESS_KEY_ID",
                                                "valueFrom": {
                                                    "secretKeyRef": {
                                                        "key": "accesskey",
                                                        "name": "mlpipeline-minio-artifact"
                                                    }
                                                }
                                            },
                                            {
                                                "name": "AWS_SECRET_ACCESS_KEY",
                                                "valueFrom": {
                                                    "secretKeyRef": {
                                                        "key": "secretkey",
                                                        "name": "mlpipeline-minio-artifact"
                                                    }
                                                }
                                            }
                                        ],
                                        "resources": {
                                            "requests": {
                                                "cpu": "10m",
                                                "memory": "70Mi"
                                            },
                                            "limits": {
                                                "cpu": "100m",
                                                "memory": "500Mi"
                                            },
                                        }
                                    }],
                                    "nodeSelector": {
                                      "kubeflow": "control-plane"
                                    },
                                    "tolerations": [{
                                      "effect": "NoSchedule",
                                      "key": "kubeflow",
                                      "operator": "Equal",
                                      "value": "control-plane"
                                    }],
                                    "serviceAccountName":
                                        "default-editor"
                                }
                            }
                        }
                    },
                    {
                        "apiVersion": "v1",
                        "kind": "Service",
                        "metadata": {
                            "name": "ml-pipeline-ui-artifact",
                            "namespace": namespace,
                            "labels": {
                                "app": "ml-pipeline-ui-artifact"
                            }
                        },
                        "spec": {
                            "ports": [{
                                "name":
                                    "http",  # name is required to let istio understand request protocol
                                "port": 80,
                                "protocol": "TCP",
                                "targetPort": 3000
                            }],
                            "selector": {
                                "app": "ml-pipeline-ui-artifact"
                            }
                        }
                    },
                ]
                print('Received request:\n', json.dumps(parent, sort_keys=True))
                print('Desired resources except secrets:\n', json.dumps(desired_resources, sort_keys=True))
                # Moved after the print argument because this is sensitive data.
                desired_resources.append({
                    "apiVersion": "v1",
                    "kind": "Secret",
                    "metadata": {
                        "name": "mlpipeline-minio-artifact",
                        "namespace": namespace,
                    },
                    "data": {
                        "accesskey": minio_access_key,
                        "secretkey": minio_secret_key,
                    },
                })

                return {"status": desired_status, "children": desired_resources}

            def do_POST(self):
                # Serve the sync() function as a JSON webhook.
                observed = json.loads(
                    self.rfile.read(int(self.headers.get("content-length"))))
                desired = self.sync(observed["parent"], observed["children"])

                self.send_response(200)
                self.send_header("Content-type", "application/json")
                self.end_headers()
                self.wfile.write(bytes(json.dumps(desired), 'utf-8'))

        return HTTPServer((url, int(controller_port)), Controller)


    if __name__ == "__main__":
        main()
kind: ConfigMap
metadata:
  labels:
    app: kubeflow-pipelines-profile-controller
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: kubeflow-pipelines-profile-controller-code-hdk828hd6c
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-configmap-kubeflow-pipelines-profile-controller-env-5252m69c4c" {
  yaml_body = <<YAML
apiVersion: v1
data:
  DISABLE_ISTIO_SIDECAR: "false"
kind: ConfigMap
metadata:
  labels:
    app: kubeflow-pipelines-profile-controller
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: kubeflow-pipelines-profile-controller-env-5252m69c4c
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-configmap-metadata-grpc-configmap" {
  yaml_body = <<YAML
apiVersion: v1
data:
  METADATA_GRPC_SERVICE_HOST: metadata-grpc-service
  METADATA_GRPC_SERVICE_PORT: "8080"
kind: ConfigMap
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
    component: metadata-grpc-server
  name: metadata-grpc-configmap
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-configmap-ml-pipeline-ui-configmap" {
  yaml_body = <<YAML
apiVersion: v1
data:
  viewer-pod-template.json: |-
    {
        "spec": {
            "serviceAccountName": "default-editor"
            "containers": [
              {
                "env": [
                  {
                    "name": "AWS_ACCESS_KEY_ID",
                    "valueFrom": {
                      "secretKeyRef": {
                        "name": "mlpipeline-minio-artifact",
                        "key": "accesskey"
                      }
                    }
                  },
                  {
                    "name": "AWS_SECRET_ACCESS_KEY",
                    "valueFrom": {
                      "secretKeyRef": {
                        "name": "mlpipeline-minio-artifact",
                        "key": "secretkey"
                      }
                    }
                  },
                  {
                    "name": "AWS_REGION",
                    "valueFrom": {
                      "configMapKeyRef": {
                        "name": "pipeline-install-config",
                        "key": "minioServiceRegion"
                      }
                    }
                  }
                ]
              }
            ]
        }
    }
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-ui-configmap
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-configmap-persistenceagent-config-hkgkmd64bh" {
  yaml_body = <<YAML
apiVersion: v1
data:
  MULTIUSER: "true"
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: persistenceagent-config-hkgkmd64bh
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-configmap-pipeline-api-server-config-dc9hkg52h6" {
  yaml_body = <<YAML
apiVersion: v1
data:
  DEFAULTPIPELINERUNNERSERVICEACCOUNT: default-editor
  MULTIUSER: "true"
  VISUALIZATIONSERVICE_NAME: ml-pipeline-visualizationserver
  VISUALIZATIONSERVICE_PORT: "8888"
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: pipeline-api-server-config-dc9hkg52h6
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-configmap-pipeline-install-config" {
  yaml_body = <<YAML
apiVersion: v1
data:
  ConMaxLifeTime: 120s
  DEFAULT_CACHE_STALENESS: ""
  MAXIMUM_CACHE_STALENESS: ""
  appName: pipeline
  appVersion: 2.0.0-alpha.7
  autoUpdatePipelineDefaultVersion: "true"
  minioServiceHost: "s3.${var.ovh_s3_region_name}.io.cloud.ovh.net"
  minioServicePort: "443"
  minioServiceRegion: "${var.ovh_s3_region_name}"
  bucketName: "${var.ovh_s3_bucket_name}-${random_string.bucket_name_suffix.result}"
  cacheDb: cachedb
  cacheImage: gcr.io/google-containers/busybox
  cacheNodeRestrictions: "false"
  cronScheduleTimezone: UTC
  dbHost: "${ovh_cloud_project_database.mysql.endpoints[0].domain}"
  dbPort: "${ovh_cloud_project_database.mysql.endpoints[0].port}"
  defaultPipelineRoot: ""
  mlmdDb: metadb
  pipelineDb: mlpipeline
  warning: |
    1. Do not use kubectl to edit this configmap, because some values are used
    during kustomize build. Instead, change the configmap and apply the entire
    kustomize manifests again.
    2. After updating the configmap, some deployments may need to be restarted
    until the changes take effect. A quick way to restart all deployments in a
    namespace: `kubectl rollout restart deployment -n <your-namespace>`.
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: pipeline-install-config
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kubeflow-configmap-workflow-controller-configmap" {
  yaml_body = <<YAML
apiVersion: v1
data:
  artifactRepository: |
    archiveLogs: true
    s3:
      endpoint: "s3.${var.ovh_s3_region_name}.io.cloud.ovh.net:443"
      bucket: "${var.ovh_s3_bucket_name}-${random_string.bucket_name_suffix.result}"
      # keyFormat is a format pattern to define how artifacts will be organized in a bucket.
      # It can reference workflow metadata variables such as workflow.namespace, workflow.name,
      # pod.name. Can also use strftime formating of workflow.creationTimestamp so that workflow
      # artifacts can be organized by date. If omitted, will use `{{workflow.name}}/{{pod.name}}`,
      # which has potential for have collisions, because names do not guarantee they are unique
      # over the lifetime of the cluster.
      # Refer to https://kubernetes.io/docs/concepts/overview/working-with-objects/names/.
      #
      # The following format looks like:
      # artifacts/my-workflow-abc123/2018/08/23/my-workflow-abc123-1234567890
      # Adding date into the path greatly reduces the chance of {{pod.name}} collision.
      keyFormat: "artifacts/{{workflow.name}}/{{workflow.creationTimestamp.Y}}/{{workflow.creationTimestamp.m}}/{{workflow.creationTimestamp.d}}/{{pod.name}}"
      # insecure will disable TLS. Primarily used for minio installs not configured with TLS
      insecure: false
      accessKeySecret:
        name: mlpipeline-minio-artifact
        key: accesskey
      secretKeySecret:
        name: mlpipeline-minio-artifact
        key: secretkey
  containerRuntimeExecutor: emissary
  executor: |
    imagePullPolicy: IfNotPresent
    resources:
      requests:
        cpu: 0.01
        memory: 32Mi
      limits:
        cpu: 0.5
        memory: 512Mi
kind: ConfigMap
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: workflow-controller-configmap
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-secret-mlpipeline-minio-artifact" {
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: mlpipeline-minio-artifact
  namespace: kubeflow
stringData:
  accesskey: "${var.ovh_s3_access_key}"
  secretkey: "${var.ovh_s3_secret_key}"
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-secret-mysql-config-secret" {
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: mysql-config-secret
  namespace: kubeflow
stringData:
  mysql.cfg: |
    connection_config {
      mysql {
        host: "${ovh_cloud_project_database.mysql.endpoints[0].domain}"
        port: ${ovh_cloud_project_database.mysql.endpoints[0].port}
        database: "metadb"
        user: "${ovh_cloud_project_database_user.kubeflow-mysql-user.name}"
        password: "${ovh_cloud_project_database_user.kubeflow-mysql-user.password}"
        ssl_options {
          verify_server_cert: false
        }
      }
    }
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-secret-mysql-secret" {
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: mysql-secret
  namespace: kubeflow
stringData:
  password: "${ovh_cloud_project_database_user.kubeflow-mysql-user.password}"
  username: "${ovh_cloud_project_database_user.kubeflow-mysql-user.name}"
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-service-cache-server" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  labels:
    app: cache-server
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: cache-server
  namespace: kubeflow
spec:
  ports:
  - port: 443
    targetPort: webhook-api
  selector:
    app: cache-server
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-service-kubeflow-pipelines-profile-controller" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  labels:
    app: kubeflow-pipelines-profile-controller
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: kubeflow-pipelines-profile-controller
  namespace: kubeflow
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 8080
  selector:
    app: kubeflow-pipelines-profile-controller
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-service-metadata-envoy-service" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  labels:
    app: metadata-envoy
    application-crd-id: kubeflow-pipelines
  name: metadata-envoy-service
  namespace: kubeflow
spec:
  ports:
  - name: md-envoy
    port: 9090
    protocol: TCP
  selector:
    application-crd-id: kubeflow-pipelines
    component: metadata-envoy
  type: ClusterIP
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-service-metadata-grpc-service" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  labels:
    app: metadata
    application-crd-id: kubeflow-pipelines
  name: metadata-grpc-service
  namespace: kubeflow
spec:
  ports:
  - name: grpc-api
    port: 8080
    protocol: TCP
  selector:
    application-crd-id: kubeflow-pipelines
    component: metadata-grpc-server
  type: ClusterIP
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-service-ml-pipeline" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  annotations:
    prometheus.io/port: "8888"
    prometheus.io/scheme: http
    prometheus.io/scrape: "true"
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline
  namespace: kubeflow
spec:
  ports:
  - name: http
    port: 8888
    protocol: TCP
    targetPort: 8888
  - name: grpc
    port: 8887
    protocol: TCP
    targetPort: 8887
  selector:
    app: ml-pipeline
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-service-ml-pipeline-ui" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  labels:
    app: ml-pipeline-ui
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-ui
  namespace: kubeflow
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 3000
  selector:
    app: ml-pipeline-ui
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-service-ml-pipeline-visualizationserver" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-visualizationserver
  namespace: kubeflow
spec:
  ports:
  - name: http
    port: 8888
    protocol: TCP
    targetPort: 8888
  selector:
    app: ml-pipeline-visualizationserver
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-service-workflow-controller-metrics" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  annotations:
    workflows.argoproj.io/description: |
      This service is deprecated. It will be removed in v3.4.

      https://github.com/argoproj/argo-workflows/issues/8441
  labels:
    app: workflow-controller
    application-crd-id: kubeflow-pipelines
  name: workflow-controller-metrics
  namespace: kubeflow
spec:
  ports:
  - name: metrics
    port: 9090
    protocol: TCP
    targetPort: 9090
  selector:
    app: workflow-controller
    application-crd-id: kubeflow-pipelines
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-priorityclass-workflow-controller" {
  yaml_body = <<YAML
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: workflow-controller
value: 1000000
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-deployment-cache-server" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: cache-server
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: cache-server
  namespace: kubeflow
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cache-server
      app.kubernetes.io/component: ml-pipeline
      app.kubernetes.io/name: kubeflow-pipelines
      application-crd-id: kubeflow-pipelines
  template:
    metadata:
      labels:
        app: cache-server
        app.kubernetes.io/component: ml-pipeline
        app.kubernetes.io/name: kubeflow-pipelines
        application-crd-id: kubeflow-pipelines
    spec:
      containers:
      - args:
        - --db_driver=$(DBCONFIG_DRIVER)
        - --db_host=$(DBCONFIG_HOST_NAME)
        - --db_port=$(DBCONFIG_PORT)
        - --db_name=$(DBCONFIG_DB_NAME)
        - --db_user=$(DBCONFIG_USER)
        - --db_password=$(DBCONFIG_PASSWORD)
        - --namespace_to_watch=$(NAMESPACE_TO_WATCH)
        - --tls_cert_filename=tls.crt
        - --tls_key_filename=tls.key
        env:
        - name: NAMESPACE_TO_WATCH
          value: ""
        - name: DEFAULT_CACHE_STALENESS
          valueFrom:
            configMapKeyRef:
              key: DEFAULT_CACHE_STALENESS
              name: pipeline-install-config
        - name: MAXIMUM_CACHE_STALENESS
          valueFrom:
            configMapKeyRef:
              key: MAXIMUM_CACHE_STALENESS
              name: pipeline-install-config
        - name: CACHE_IMAGE
          valueFrom:
            configMapKeyRef:
              key: cacheImage
              name: pipeline-install-config
        - name: CACHE_NODE_RESTRICTIONS
          valueFrom:
            configMapKeyRef:
              key: cacheNodeRestrictions
              name: pipeline-install-config
        - name: DBCONFIG_DRIVER
          value: mysql
        - name: DBCONFIG_DB_NAME
          valueFrom:
            configMapKeyRef:
              key: cacheDb
              name: pipeline-install-config
        - name: DBCONFIG_HOST_NAME
          valueFrom:
            configMapKeyRef:
              key: dbHost
              name: pipeline-install-config
        - name: DBCONFIG_PORT
          valueFrom:
            configMapKeyRef:
              key: dbPort
              name: pipeline-install-config
        - name: DBCONFIG_USER
          valueFrom:
            secretKeyRef:
              key: username
              name: mysql-secret
        - name: DBCONFIG_PASSWORD
          valueFrom:
            secretKeyRef:
              key: password
              name: mysql-secret
        image: gcr.io/ml-pipeline/cache-server:2.0.0-alpha.7
        imagePullPolicy: Always
        name: server
        ports:
        - containerPort: 8443
          name: webhook-api
        volumeMounts:
        - mountPath: /etc/webhook/certs
          name: webhook-tls-certs
          readOnly: true
      serviceAccountName: kubeflow-pipelines-cache
      volumes:
      - name: webhook-tls-certs
        secret:
          secretName: webhook-server-tls
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-kubeflow-certificate-kfp-cache-cert, kubectl_manifest.kubeflow-kubeflow-secret-mysql-secret, kubectl_manifest.kubeflow-kubeflow-configmap-pipeline-install-config, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kubeflow-deployment-kubeflow-pipelines-profile-controller" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: kubeflow-pipelines-profile-controller
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: kubeflow-pipelines-profile-controller
  namespace: kubeflow
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kubeflow-pipelines-profile-controller
      app.kubernetes.io/component: ml-pipeline
      app.kubernetes.io/name: kubeflow-pipelines
      application-crd-id: kubeflow-pipelines
  template:
    metadata:
      annotations:
        sidecar.istio.io/inject: "false"
      labels:
        app: kubeflow-pipelines-profile-controller
        app.kubernetes.io/component: ml-pipeline
        app.kubernetes.io/name: kubeflow-pipelines
        application-crd-id: kubeflow-pipelines
    spec:
      containers:
      - command:
        - python
        - /hooks/sync.py
        env:
        - name: KFP_VERSION
          valueFrom:
            configMapKeyRef:
              key: appVersion
              name: pipeline-install-config
        - name: KFP_DEFAULT_PIPELINE_ROOT
          valueFrom:
            configMapKeyRef:
              key: defaultPipelineRoot
              name: pipeline-install-config
              optional: true
        - name: MINIO_ACCESS_KEY
          valueFrom:
            secretKeyRef:
              key: accesskey
              name: mlpipeline-minio-artifact
        - name: MINIO_SECRET_KEY
          valueFrom:
            secretKeyRef:
              key: secretkey
              name: mlpipeline-minio-artifact
        envFrom:
        - configMapRef:
            name: kubeflow-pipelines-profile-controller-env-5252m69c4c
        image: python:3.7
        name: profile-controller
        ports:
        - containerPort: 8080
        volumeMounts:
        - mountPath: /hooks
          name: hooks
      volumes:
      - configMap:
          name: kubeflow-pipelines-profile-controller-code-hdk828hd6c
        name: hooks
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kubeflow-deployment-metadata-envoy-deployment" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
    component: metadata-envoy
  name: metadata-envoy-deployment
  namespace: kubeflow
spec:
  replicas: 1
  selector:
    matchLabels:
      application-crd-id: kubeflow-pipelines
      component: metadata-envoy
  template:
    metadata:
      annotations:
        sidecar.istio.io/inject: "false"
      labels:
        application-crd-id: kubeflow-pipelines
        component: metadata-envoy
    spec:
      containers:
      - image: gcr.io/ml-pipeline/metadata-envoy:2.0.0-alpha.7
        name: container
        ports:
        - containerPort: 9090
          name: md-envoy
        - containerPort: 9901
          name: envoy-admin
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kubeflow-deployment-metadata-grpc-deployment" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
    component: metadata-grpc-server
  name: metadata-grpc-deployment
  namespace: kubeflow
spec:
  replicas: 1
  selector:
    matchLabels:
      application-crd-id: kubeflow-pipelines
      component: metadata-grpc-server
  template:
    metadata:
      labels:
        application-crd-id: kubeflow-pipelines
        component: metadata-grpc-server
    spec:
      initContainers:
      - name: init-kubeflow-user-authentication-mode
        image: bitnami/mariadb:10.6
        env:
        - name: DBCONFIG_DB_NAME
          valueFrom:
            configMapKeyRef:
              key: mlmdDb
              name: pipeline-install-config
        - name: DBCONFIG_HOST_NAME
          valueFrom:
            configMapKeyRef:
              key: dbHost
              name: pipeline-install-config
        - name: DBCONFIG_PORT
          valueFrom:
            configMapKeyRef:
              key: dbPort
              name: pipeline-install-config
        - name: DBCONFIG_USER
          valueFrom:
            secretKeyRef:
              key: username
              name: mysql-secret
        - name: DBCONFIG_PASSWORD
          valueFrom:
            secretKeyRef:
              key: password
              name: mysql-secret
        command:
        - /opt/bitnami/mariadb/bin/mariadb
        args:
        - --host=$(DBCONFIG_HOST_NAME)
        - --port=$(DBCONFIG_PORT)
        - --user=$(DBCONFIG_USER)
        - --password=$(DBCONFIG_PASSWORD)
        - --execute=ALTER USER kubeflow IDENTIFIED WITH mysql_native_password BY '$(DBCONFIG_PASSWORD)';
      containers:
      - args:
        - --grpc_port=8080
        - --metadata_store_server_config_file=/config/mysql.cfg
        - --enable_database_upgrade=true
        command:
        - /bin/metadata_store_server
        volumeMounts:
        - name: mysql-config
          mountPath: /config
        image: gcr.io/tfx-oss-public/ml_metadata_store_server:1.5.0
        livenessProbe:
          initialDelaySeconds: 3
          periodSeconds: 5
          tcpSocket:
            port: grpc-api
          timeoutSeconds: 2
        name: container
        ports:
        - containerPort: 8080
          name: grpc-api
        readinessProbe:
          initialDelaySeconds: 3
          periodSeconds: 5
          tcpSocket:
            port: grpc-api
          timeoutSeconds: 2
      serviceAccountName: metadata-grpc-server
      volumes:
        - name: mysql-config
          secret:
            secretName: mysql-config-secret
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kubeflow-deployment-metadata-writer" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: metadata-writer
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: metadata-writer
  namespace: kubeflow
spec:
  replicas: 1
  selector:
    matchLabels:
      app: metadata-writer
      app.kubernetes.io/component: ml-pipeline
      app.kubernetes.io/name: kubeflow-pipelines
      application-crd-id: kubeflow-pipelines
  template:
    metadata:
      labels:
        app: metadata-writer
        app.kubernetes.io/component: ml-pipeline
        app.kubernetes.io/name: kubeflow-pipelines
        application-crd-id: kubeflow-pipelines
    spec:
      containers:
      - env:
        - name: NAMESPACE_TO_WATCH
          value: ""
        image: gcr.io/ml-pipeline/metadata-writer:2.0.0-alpha.7
        name: main
      serviceAccountName: kubeflow-pipelines-metadata-writer
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kubeflow-deployment-ml-pipeline" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: ml-pipeline
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline
  namespace: kubeflow
spec:
  selector:
    matchLabels:
      app: ml-pipeline
      app.kubernetes.io/component: ml-pipeline
      app.kubernetes.io/name: kubeflow-pipelines
      application-crd-id: kubeflow-pipelines
  template:
    metadata:
      annotations:
        cluster-autoscaler.kubernetes.io/safe-to-evict: "true"
      labels:
        app: ml-pipeline
        app.kubernetes.io/component: ml-pipeline
        app.kubernetes.io/name: kubeflow-pipelines
        application-crd-id: kubeflow-pipelines
    spec:
      containers:
      - env:
        - name: KUBEFLOW_USERID_HEADER
          value: kubeflow-userid
        - name: KUBEFLOW_USERID_PREFIX
          value: ""
        - name: AUTO_UPDATE_PIPELINE_DEFAULT_VERSION
          valueFrom:
            configMapKeyRef:
              key: autoUpdatePipelineDefaultVersion
              name: pipeline-install-config
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: OBJECTSTORECONFIG_SECURE
          value: "true"
        - name: OBJECTSTORECONFIG_HOST
          valueFrom:
            configMapKeyRef:
              key: minioServiceHost
              name: pipeline-install-config
        - name: OBJECTSTORECONFIG_PORT
          valueFrom:
            configMapKeyRef:
              key: minioServicePort
              name: pipeline-install-config
        - name: OBJECTSTORECONFIG_REGION
          valueFrom:
            configMapKeyRef:
              key: minioServiceRegion
              name: pipeline-install-config
        - name: OBJECTSTORECONFIG_BUCKETNAME
          valueFrom:
            configMapKeyRef:
              key: bucketName
              name: pipeline-install-config
        - name: OBJECTSTORECONFIG_ACCESSKEY
          valueFrom:
            secretKeyRef:
              key: accesskey
              name: mlpipeline-minio-artifact
        - name: OBJECTSTORECONFIG_SECRETACCESSKEY
          valueFrom:
            secretKeyRef:
              key: secretkey
              name: mlpipeline-minio-artifact
        - name: DBCONFIG_USER
          valueFrom:
            secretKeyRef:
              key: username
              name: mysql-secret
        - name: DBCONFIG_PASSWORD
          valueFrom:
            secretKeyRef:
              key: password
              name: mysql-secret
        - name: DBCONFIG_DBNAME
          valueFrom:
            configMapKeyRef:
              key: pipelineDb
              name: pipeline-install-config
        - name: DBCONFIG_HOST
          valueFrom:
            configMapKeyRef:
              key: dbHost
              name: pipeline-install-config
        - name: DBCONFIG_PORT
          valueFrom:
            configMapKeyRef:
              key: dbPort
              name: pipeline-install-config
        - name: DBCONFIG_CONMAXLIFETIME
          valueFrom:
            configMapKeyRef:
              key: ConMaxLifeTime
              name: pipeline-install-config
        - name: OBJECTSTORECONFIG_ACCESSKEY
          valueFrom:
            secretKeyRef:
              key: accesskey
              name: mlpipeline-minio-artifact
        - name: OBJECTSTORECONFIG_SECRETACCESSKEY
          valueFrom:
            secretKeyRef:
              key: secretkey
              name: mlpipeline-minio-artifact
        envFrom:
        - configMapRef:
            name: pipeline-api-server-config-dc9hkg52h6
        image: gcr.io/ml-pipeline/api-server:2.0.0-alpha.7
        imagePullPolicy: IfNotPresent
        livenessProbe:
          exec:
            command:
            - wget
            - -q
            - -S
            - -O
            - '-'
            - http://localhost:8888/apis/v1beta1/healthz
          initialDelaySeconds: 3
          periodSeconds: 5
          timeoutSeconds: 2
        name: ml-pipeline-api-server
        ports:
        - containerPort: 8888
          name: http
        - containerPort: 8887
          name: grpc
        readinessProbe:
          exec:
            command:
            - wget
            - -q
            - -S
            - -O
            - '-'
            - http://localhost:8888/apis/v1beta1/healthz
          initialDelaySeconds: 3
          periodSeconds: 5
          timeoutSeconds: 2
        resources:
          requests:
            cpu: 250m
            memory: 500Mi
        startupProbe:
          exec:
            command:
            - wget
            - -q
            - -S
            - -O
            - '-'
            - http://localhost:8888/apis/v1beta1/healthz
          failureThreshold: 12
          periodSeconds: 5
          timeoutSeconds: 2
      serviceAccountName: ml-pipeline
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kubeflow-deployment-ml-pipeline-persistenceagent" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: ml-pipeline-persistenceagent
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-persistenceagent
  namespace: kubeflow
spec:
  selector:
    matchLabels:
      app: ml-pipeline-persistenceagent
      app.kubernetes.io/component: ml-pipeline
      app.kubernetes.io/name: kubeflow-pipelines
      application-crd-id: kubeflow-pipelines
  template:
    metadata:
      annotations:
        cluster-autoscaler.kubernetes.io/safe-to-evict: "true"
      labels:
        app: ml-pipeline-persistenceagent
        app.kubernetes.io/component: ml-pipeline
        app.kubernetes.io/name: kubeflow-pipelines
        application-crd-id: kubeflow-pipelines
    spec:
      containers:
      - env:
        - name: NAMESPACE
          value: ""
        - name: KUBEFLOW_USERID_HEADER
          value: kubeflow-userid
        - name: KUBEFLOW_USERID_PREFIX
          value: ""
        - name: TTL_SECONDS_AFTER_WORKFLOW_FINISH
          value: "86400"
        - name: NUM_WORKERS
          value: "2"
        envFrom:
        - configMapRef:
            name: persistenceagent-config-hkgkmd64bh
        image: gcr.io/ml-pipeline/persistenceagent:2.0.0-alpha.7
        imagePullPolicy: IfNotPresent
        name: ml-pipeline-persistenceagent
        resources:
          requests:
            cpu: 120m
            memory: 500Mi
      serviceAccountName: ml-pipeline-persistenceagent
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kubeflow-deployment-ml-pipeline-scheduledworkflow" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: ml-pipeline-scheduledworkflow
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-scheduledworkflow
  namespace: kubeflow
spec:
  selector:
    matchLabels:
      app: ml-pipeline-scheduledworkflow
      app.kubernetes.io/component: ml-pipeline
      app.kubernetes.io/name: kubeflow-pipelines
      application-crd-id: kubeflow-pipelines
  template:
    metadata:
      annotations:
        cluster-autoscaler.kubernetes.io/safe-to-evict: "true"
      labels:
        app: ml-pipeline-scheduledworkflow
        app.kubernetes.io/component: ml-pipeline
        app.kubernetes.io/name: kubeflow-pipelines
        application-crd-id: kubeflow-pipelines
    spec:
      containers:
      - env:
        - name: NAMESPACE
          value: ""
        - name: CRON_SCHEDULE_TIMEZONE
          valueFrom:
            configMapKeyRef:
              key: cronScheduleTimezone
              name: pipeline-install-config
        image: gcr.io/ml-pipeline/scheduledworkflow:2.0.0-alpha.7
        imagePullPolicy: IfNotPresent
        name: ml-pipeline-scheduledworkflow
      serviceAccountName: ml-pipeline-scheduledworkflow
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kubeflow-deployment-ml-pipeline-ui" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: ml-pipeline-ui
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-ui
  namespace: kubeflow
spec:
  selector:
    matchLabels:
      app: ml-pipeline-ui
      app.kubernetes.io/component: ml-pipeline
      app.kubernetes.io/name: kubeflow-pipelines
      application-crd-id: kubeflow-pipelines
  template:
    metadata:
      annotations:
        cluster-autoscaler.kubernetes.io/safe-to-evict: "true"
      labels:
        app: ml-pipeline-ui
        app.kubernetes.io/component: ml-pipeline
        app.kubernetes.io/name: kubeflow-pipelines
        application-crd-id: kubeflow-pipelines
    spec:
      containers:
      - env:
        - name: VIEWER_TENSORBOARD_POD_TEMPLATE_SPEC_PATH
          value: /etc/config/viewer-pod-template.json
        - name: DEPLOYMENT
          value: KUBEFLOW
        - name: ARTIFACTS_SERVICE_PROXY_NAME
          value: ml-pipeline-ui-artifact
        - name: ARTIFACTS_SERVICE_PROXY_PORT
          value: "80"
        - name: ARTIFACTS_SERVICE_PROXY_ENABLED
          value: "true"
        - name: ENABLE_AUTHZ
          value: "true"
        - name: KUBEFLOW_USERID_HEADER
          value: kubeflow-userid
        - name: KUBEFLOW_USERID_PREFIX
          value: ""
        - name: MINIO_NAMESPACE
          value: ""
        - name: MINIO_HOST
          valueFrom:
            configMapKeyRef:
              key: minioServiceHost
              name: pipeline-install-config
        - name: MINIO_PORT
          valueFrom:
            configMapKeyRef:
              key: minioServicePort
              name: pipeline-install-config
        - name: MINIO_SECURE
          value: "true"
        - name: MINIO_ACCESS_KEY
          valueFrom:
            secretKeyRef:
              key: accesskey
              name: mlpipeline-minio-artifact
        - name: MINIO_SECRET_KEY
          valueFrom:
            secretKeyRef:
              key: secretkey
              name: mlpipeline-minio-artifact
        - name: AWS_S3_ENDPOINT
          valueFrom:
            configMapKeyRef:
              key: minioServiceHost
              name: pipeline-install-config
        - name: AWS_REGION
          valueFrom:
            configMapKeyRef:
              key: minioServiceRegion
              name: pipeline-install-config
        - name: AWS_SSL
          value: "true"
        - name: AWS_ACCESS_KEY_ID
          valueFrom:
            secretKeyRef:
              key: accesskey
              name: mlpipeline-minio-artifact
        - name: AWS_SECRET_ACCESS_KEY
          valueFrom:
            secretKeyRef:
              key: secretkey
              name: mlpipeline-minio-artifact
        - name: ALLOW_CUSTOM_VISUALIZATIONS
          value: "true"
        image: gcr.io/ml-pipeline/frontend:2.0.0-alpha.7
        imagePullPolicy: IfNotPresent
        livenessProbe:
          exec:
            command:
            - wget
            - -q
            - -S
            - -O
            - '-'
            - http://localhost:3000/apis/v1beta1/healthz
          initialDelaySeconds: 3
          periodSeconds: 5
          timeoutSeconds: 2
        name: ml-pipeline-ui
        ports:
        - containerPort: 3000
        readinessProbe:
          exec:
            command:
            - wget
            - -q
            - -S
            - -O
            - '-'
            - http://localhost:3000/apis/v1beta1/healthz
          initialDelaySeconds: 3
          periodSeconds: 5
          timeoutSeconds: 2
        resources:
          requests:
            cpu: 10m
            memory: 70Mi
        volumeMounts:
        - mountPath: /etc/config
          name: config-volume
          readOnly: true
      serviceAccountName: ml-pipeline-ui
      volumes:
      - configMap:
          name: ml-pipeline-ui-configmap
        name: config-volume
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kubeflow-deployment-ml-pipeline-viewer-crd" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: ml-pipeline-viewer-crd
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-viewer-crd
  namespace: kubeflow
spec:
  selector:
    matchLabels:
      app: ml-pipeline-viewer-crd
      app.kubernetes.io/component: ml-pipeline
      app.kubernetes.io/name: kubeflow-pipelines
      application-crd-id: kubeflow-pipelines
  template:
    metadata:
      annotations:
        cluster-autoscaler.kubernetes.io/safe-to-evict: "true"
      labels:
        app: ml-pipeline-viewer-crd
        app.kubernetes.io/component: ml-pipeline
        app.kubernetes.io/name: kubeflow-pipelines
        application-crd-id: kubeflow-pipelines
    spec:
      containers:
      - env:
        - name: NAMESPACE
          value: ""
        - name: MAX_NUM_VIEWERS
          value: "50"
        - name: MINIO_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        image: gcr.io/ml-pipeline/viewer-crd-controller:2.0.0-alpha.7
        imagePullPolicy: Always
        name: ml-pipeline-viewer-crd
      serviceAccountName: ml-pipeline-viewer-crd-service-account
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kubeflow-deployment-ml-pipeline-visualizationserver" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: ml-pipeline-visualizationserver
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-visualizationserver
  namespace: kubeflow
spec:
  selector:
    matchLabels:
      app: ml-pipeline-visualizationserver
      app.kubernetes.io/component: ml-pipeline
      app.kubernetes.io/name: kubeflow-pipelines
      application-crd-id: kubeflow-pipelines
  template:
    metadata:
      annotations:
        cluster-autoscaler.kubernetes.io/safe-to-evict: "true"
      labels:
        app: ml-pipeline-visualizationserver
        app.kubernetes.io/component: ml-pipeline
        app.kubernetes.io/name: kubeflow-pipelines
        application-crd-id: kubeflow-pipelines
    spec:
      containers:
      - image: gcr.io/ml-pipeline/visualization-server:2.0.0-alpha.7
        imagePullPolicy: IfNotPresent
        livenessProbe:
          exec:
            command:
            - wget
            - -q
            - -S
            - -O
            - '-'
            - http://localhost:8888/
          initialDelaySeconds: 3
          periodSeconds: 5
          timeoutSeconds: 2
        name: ml-pipeline-visualizationserver
        ports:
        - containerPort: 8888
          name: http
        readinessProbe:
          exec:
            command:
            - wget
            - -q
            - -S
            - -O
            - '-'
            - http://localhost:8888/
          initialDelaySeconds: 3
          periodSeconds: 5
          timeoutSeconds: 2
        resources:
          requests:
            cpu: 30m
            memory: 500Mi
      serviceAccountName: ml-pipeline-visualizationserver
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kubeflow-deployment-workflow-controller" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: workflow-controller
  namespace: kubeflow
spec:
  selector:
    matchLabels:
      app: workflow-controller
      application-crd-id: kubeflow-pipelines
  template:
    metadata:
      labels:
        app: workflow-controller
        application-crd-id: kubeflow-pipelines
    spec:
      containers:
      - args:
        - --configmap
        - workflow-controller-configmap
        - --executor-image
        - gcr.io/ml-pipeline/argoexec:v3.3.8-license-compliance
        command:
        - workflow-controller
        env:
        - name: LEADER_ELECTION_IDENTITY
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.name
        image: gcr.io/ml-pipeline/workflow-controller:v3.3.8-license-compliance
        livenessProbe:
          failureThreshold: 3
          httpGet:
            path: /healthz
            port: 6060
          initialDelaySeconds: 90
          periodSeconds: 60
          timeoutSeconds: 30
        name: workflow-controller
        ports:
        - containerPort: 9090
          name: metrics
        - containerPort: 6060
        resources:
          requests:
            cpu: 100m
            memory: 500Mi
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          readOnlyRootFilesystem: true
          runAsNonRoot: true
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
      priorityClassName: workflow-controller
      securityContext:
        runAsNonRoot: true
      serviceAccountName: argo
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kubeflow-statefulset-metacontroller" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: StatefulSet
metadata:
  labels:
    app: metacontroller
    application-crd-id: kubeflow-pipelines
    kustomize.component: metacontroller
  name: metacontroller
  namespace: kubeflow
spec:
  replicas: 1
  selector:
    matchLabels:
      app: metacontroller
      application-crd-id: kubeflow-pipelines
      kustomize.component: metacontroller
  serviceName: ""
  template:
    metadata:
      annotations:
        sidecar.istio.io/inject: "false"
      labels:
        app: metacontroller
        application-crd-id: kubeflow-pipelines
        kustomize.component: metacontroller
    spec:
      containers:
      - command:
        - /usr/bin/metacontroller
        - --zap-log-level=4
        - --discovery-interval=3600s
        image: docker.io/metacontrollerio/metacontroller:v2.0.4
        name: metacontroller
        resources:
          limits:
            cpu: "1"
            memory: 1Gi
          requests:
            cpu: 100m
            memory: 256Mi
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          privileged: false
          readOnlyRootFilesystem: true
          runAsNonRoot: true
          runAsUser: 1000
      serviceAccountName: meta-controller-service
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
  volumeClaimTemplates: []
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kubeflow-certificate-kfp-cache-cert" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  labels:
    app: cache-server-cert-manager
  name: kfp-cache-cert
  namespace: kubeflow
spec:
  commonName: kfp-cache-cert
  dnsNames:
  - cache-server
  - cache-server.kubeflow
  - cache-server.kubeflow.svc
  isCA: true
  issuerRef:
    kind: Issuer
    name: kfp-cache-selfsigned-issuer
  secretName: webhook-server-tls
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-cert-manager-deployment-webhook]
}

resource "kubectl_manifest" "kubeflow-kubeflow-issuer-kfp-cache-selfsigned-issuer" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  labels:
    app: cache-server-cert-manager
  name: kfp-cache-selfsigned-issuer
  namespace: kubeflow
spec:
  selfSigned: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-cert-manager-crd-issuers, kubectl_manifest.kubeflow-cert-manager-deployment-webhook]
}

resource "kubectl_manifest" "kubeflow-kubeflow-compositecontroller-kubeflow-pipelines-profile-controller" {
  yaml_body = <<YAML
apiVersion: metacontroller.k8s.io/v1alpha1
kind: CompositeController
metadata:
  labels:
    app: kubeflow-pipelines-profile-controller
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: kubeflow-pipelines-profile-controller
  namespace: kubeflow
spec:
  childResources:
  - apiVersion: v1
    resource: secrets
    updateStrategy:
      method: OnDelete
  - apiVersion: v1
    resource: configmaps
    updateStrategy:
      method: OnDelete
  - apiVersion: apps/v1
    resource: deployments
    updateStrategy:
      method: InPlace
  - apiVersion: v1
    resource: services
    updateStrategy:
      method: InPlace
  - apiVersion: networking.istio.io/v1alpha3
    resource: destinationrules
    updateStrategy:
      method: InPlace
  - apiVersion: security.istio.io/v1beta1
    resource: authorizationpolicies
    updateStrategy:
      method: InPlace
  generateSelector: true
  hooks:
    sync:
      webhook:
        url: http://kubeflow-pipelines-profile-controller/sync
  parentResource:
    apiVersion: v1
    resource: namespaces
  resyncPeriodSeconds: 3600
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-destinationrule-metadata-grpc-service" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: metadata-grpc-service
  namespace: kubeflow
spec:
  host: metadata-grpc-service.kubeflow.svc.cluster.local
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-crd-destinationrules, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-destinationrule-ml-pipeline" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline
  namespace: kubeflow
spec:
  host: ml-pipeline.kubeflow.svc.cluster.local
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-crd-destinationrules, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-destinationrule-ml-pipeline-ui" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-ui
  namespace: kubeflow
spec:
  host: ml-pipeline-ui.kubeflow.svc.cluster.local
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-crd-destinationrules, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-destinationrule-ml-pipeline-visualizationserver" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-visualizationserver
  namespace: kubeflow
spec:
  host: ml-pipeline-visualizationserver.kubeflow.svc.cluster.local
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-crd-destinationrules, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-virtualservice-metadatagrpc" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: metadata-grpc
  namespace: kubeflow
spec:
  gateways:
  - kubeflow-gateway
  hosts:
  - '*'
  http:
  - match:
    - uri:
        prefix: /ml_metadata
    rewrite:
      uri: /ml_metadata
    route:
    - destination:
        host: metadata-envoy-service.kubeflow.svc.cluster.local
        port:
          number: 9090
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-virtualservice-ml-pipeline-ui" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-ui
  namespace: kubeflow
spec:
  gateways:
  - kubeflow-gateway
  hosts:
  - '*'
  http:
  - match:
    - uri:
        prefix: /pipeline
    rewrite:
      uri: /pipeline
    route:
    - destination:
        host: ml-pipeline-ui.kubeflow.svc.cluster.local
        port:
          number: 80
    timeout: 300s
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-authorizationpolicy-metadata-grpc-service" {
  yaml_body = <<YAML
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  labels:
    application-crd-id: kubeflow-pipelines
  name: metadata-grpc-service
  namespace: kubeflow
spec:
  action: ALLOW
  rules:
  - {}
  selector:
    matchLabels:
      component: metadata-grpc-server
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-authorizationpolicy-ml-pipeline" {
  yaml_body = <<YAML
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline
  namespace: kubeflow
spec:
  rules:
  - from:
    - source:
        principals:
        - cluster.local/ns/kubeflow/sa/ml-pipeline
        - cluster.local/ns/kubeflow/sa/ml-pipeline-ui
        - cluster.local/ns/kubeflow/sa/ml-pipeline-persistenceagent
        - cluster.local/ns/kubeflow/sa/ml-pipeline-scheduledworkflow
        - cluster.local/ns/kubeflow/sa/ml-pipeline-viewer-crd-service-account
        - cluster.local/ns/kubeflow/sa/kubeflow-pipelines-cache
  - when:
    - key: request.headers[kubeflow-userid]
      notValues:
      - '*'
  selector:
    matchLabels:
      app: ml-pipeline
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-authorizationpolicy-ml-pipeline-ui" {
  yaml_body = <<YAML
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-ui
  namespace: kubeflow
spec:
  rules:
  - from:
    - source:
        namespaces:
        - istio-system
  selector:
    matchLabels:
      app: ml-pipeline-ui
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-authorizationpolicy-ml-pipeline-visualizationserver" {
  yaml_body = <<YAML
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: ml-pipeline-visualizationserver
  namespace: kubeflow
spec:
  rules:
  - from:
    - source:
        principals:
        - cluster.local/ns/kubeflow/sa/ml-pipeline
        - cluster.local/ns/kubeflow/sa/ml-pipeline-ui
        - cluster.local/ns/kubeflow/sa/ml-pipeline-persistenceagent
        - cluster.local/ns/kubeflow/sa/ml-pipeline-scheduledworkflow
        - cluster.local/ns/kubeflow/sa/ml-pipeline-viewer-crd-service-account
        - cluster.local/ns/kubeflow/sa/kubeflow-pipelines-cache
  selector:
    matchLabels:
      app: ml-pipeline-visualizationserver
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-authorizationpolicy-service-cache-server" {
  yaml_body = <<YAML
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  labels:
    app.kubernetes.io/component: ml-pipeline
    app.kubernetes.io/name: kubeflow-pipelines
    application-crd-id: kubeflow-pipelines
  name: service-cache-server
  namespace: kubeflow
spec:
  rules:
  - {}
  selector:
    matchLabels:
      app: cache-server
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kubeflow-mutatingwebhookconfiguration-cache-webhook-kubeflow" {
  yaml_body = <<YAML
apiVersion: admissionregistration.k8s.io/v1
kind: MutatingWebhookConfiguration
metadata:
  annotations:
    cert-manager.io/inject-ca-from: kubeflow/kfp-cache-cert
  labels:
    app: cache-server-cert-manager
  name: cache-webhook-kubeflow
webhooks:
- admissionReviewVersions:
  - v1beta1
  clientConfig:
    service:
      name: cache-server
      namespace: kubeflow
      path: /mutate
  failurePolicy: Ignore
  name: cache-server.kubeflow.svc
  objectSelector:
    matchLabels:
      pipelines.kubeflow.org/cache_enabled: "true"
  rules:
  - apiGroups:
    - ""
    apiVersions:
    - v1
    operations:
    - CREATE
    resources:
    - pods
  sideEffects: None
  timeoutSeconds: 5
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}