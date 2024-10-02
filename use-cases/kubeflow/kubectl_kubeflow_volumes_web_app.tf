resource "kubectl_manifest" "kubeflow-volumes-web-app-serviceaccount-volumes-web-app-service-account" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app: volumes-web-app
    kustomize.component: volumes-web-app
  name: volumes-web-app-service-account
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-volumes-web-app-clusterrole-volumes-web-app-cluster-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: volumes-web-app
    kustomize.component: volumes-web-app
  name: volumes-web-app-cluster-role
rules:
- apiGroups:
  - ""
  resources:
  - namespaces
  - pods
  verbs:
  - get
  - list
- apiGroups:
  - authorization.k8s.io
  resources:
  - subjectaccessreviews
  verbs:
  - create
- apiGroups:
  - ""
  resources:
  - persistentvolumeclaims
  verbs:
  - create
  - delete
  - get
  - list
  - watch
  - update
  - patch
- apiGroups:
  - storage.k8s.io
  resources:
  - storageclasses
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - events
  verbs:
  - list
- apiGroups:
  - kubeflow.org
  resources:
  - notebooks
  verbs:
  - list
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-volumes-web-app-clusterrole-volumes-web-app-kubeflow-volume-ui-admin" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: volumes-web-app
    kustomize.component: volumes-web-app
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-admin: "true"
  name: volumes-web-app-kubeflow-volume-ui-admin
rules: []
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-volumes-web-app-volumes-web-app-kubeflow-volume-ui-edit" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: volumes-web-app
    kustomize.component: volumes-web-app
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-edit: "true"
  name: volumes-web-app-kubeflow-volume-ui-edit
rules:
- apiGroups:
  - ""
  resources:
  - persistentvolumeclaims
  verbs:
  - create
  - delete
  - get
  - list
  - watch
  - update
  - patch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-volumes-web-app-clusterrole-volumes-web-app-kubeflow-volume-ui-view" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: volumes-web-app
    kustomize.component: volumes-web-app
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-view: "true"
  name: volumes-web-app-kubeflow-volume-ui-view
rules:
- apiGroups:
  - ""
  resources:
  - persistentvolumeclaims
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - storage.k8s.io
  resources:
  - storageclasses
  verbs:
  - get
  - list
  - watch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-volumes-web-app-clusterrolebinding-volumes-web-app-cluster-role-binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app: volumes-web-app
    kustomize.component: volumes-web-app
  name: volumes-web-app-cluster-role-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: volumes-web-app-cluster-role
subjects:
- kind: ServiceAccount
  name: volumes-web-app-service-account
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-volumes-web-app-configmap-volumes-web-app-parameters" {
  yaml_body = <<YAML
apiVersion: v1
data:
  VWA_APP_SECURE_COOKIES: "true"
  VWA_CLUSTER_DOMAIN: cluster.local
  VWA_PREFIX: /volumes
  VWA_USERID_HEADER: kubeflow-userid
  VWA_USERID_PREFIX: ""
kind: ConfigMap
metadata:
  labels:
    app: volumes-web-app
    kustomize.component: volumes-web-app
  name: volumes-web-app-parameters-57h65c44mg
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-volumes-web-app-service-volumes-web-app-service" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  labels:
    app: volumes-web-app
    kustomize.component: volumes-web-app
    run: volumes-web-app
  name: volumes-web-app-service
  namespace: kubeflow
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 5000
  selector:
    app: volumes-web-app
    kustomize.component: volumes-web-app
  type: ClusterIP
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-volumes-web-app-deployment-volumes-web-app-deployment" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: volumes-web-app
    kustomize.component: volumes-web-app
  name: volumes-web-app-deployment
  namespace: kubeflow
spec:
  replicas: 1
  selector:
    matchLabels:
      app: volumes-web-app
      kustomize.component: volumes-web-app
  template:
    metadata:
      labels:
        app: volumes-web-app
        kustomize.component: volumes-web-app
    spec:
      containers:
      - env:
        - name: APP_PREFIX
          value: /volumes
        - name: USERID_HEADER
          value: kubeflow-userid
        - name: USERID_PREFIX
          value: ""
        - name: APP_SECURE_COOKIES
          value: "true"
        image: docker.io/kubeflownotebookswg/volumes-web-app:v1.7.0
        name: volumes-web-app
        ports:
        - containerPort: 5000
      serviceAccountName: volumes-web-app-service-account
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

resource "kubectl_manifest" "kubeflow-volumes-web-app-destinationrule-volumes-web-app" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  labels:
    app: volumes-web-app
    kustomize.component: volumes-web-app
  name: volumes-web-app
  namespace: kubeflow
spec:
  host: volumes-web-app-service.kubeflow.svc.cluster.local
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-crd-destinationrules, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-volumes-web-app-virtualservice" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  labels:
    app: volumes-web-app
    kustomize.component: volumes-web-app
  name: volumes-web-app-volumes-web-app
  namespace: kubeflow
spec:
  gateways:
  - kubeflow-gateway
  hosts:
  - '*'
  http:
  - headers:
      request:
        add:
          x-forwarded-prefix: /volumes
    match:
    - uri:
        prefix: /volumes/
    rewrite:
      uri: /
    route:
    - destination:
        host: volumes-web-app-service.kubeflow.svc.cluster.local
        port:
          number: 80
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-volumes-web-app-authorizationpolicy" {
  yaml_body = <<YAML
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  labels:
    app: volumes-web-app
    kustomize.component: volumes-web-app
  name: volumes-web-app
  namespace: kubeflow
spec:
  action: ALLOW
  rules:
  - from:
    - source:
        principals:
        - cluster.local/ns/istio-system/sa/istio-ingressgateway-service-account
  selector:
    matchLabels:
      app: volumes-web-app
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}