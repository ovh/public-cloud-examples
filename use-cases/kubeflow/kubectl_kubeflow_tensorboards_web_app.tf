resource "kubectl_manifest" "kubeflow-tensorboards-web-app-serviceaccount-tensorboards-web-app-service-account" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app: tensorboards-web-app
    kustomize.component: tensorboards-web-app
  name: tensorboards-web-app-service-account
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-tensorboards-web-app-clusterrole-tensorboards-web-app-cluster-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: tensorboards-web-app
    kustomize.component: tensorboards-web-app
  name: tensorboards-web-app-cluster-role
rules:
- apiGroups:
  - ""
  resources:
  - namespaces
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
  - tensorboard.kubeflow.org
  resources:
  - tensorboards
  - tensorboards/finalizers
  verbs:
  - get
  - list
  - create
  - delete
- apiGroups:
  - ""
  resources:
  - persistentvolumeclaims
  verbs:
  - create
  - delete
  - get
  - list
- apiGroups:
  - storage.k8s.io
  resources:
  - storageclasses
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - kubeflow.org
  resources:
  - poddefaults
  verbs:
  - get
  - list
  - watch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-tensorboards-web-app-clusterrole-tensorboards-web-app-kubeflow-tensorboard-ui-admin" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: tensorboards-web-app
    kustomize.component: tensorboards-web-app
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-admin: "true"
  name: tensorboards-web-app-kubeflow-tensorboard-ui-admin
rules: []
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-tensorboards-web-app-clusterrole-tensorboards-web-app-kubeflow-tensorboard-ui-edit" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: tensorboards-web-app
    kustomize.component: tensorboards-web-app
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-edit: "true"
  name: tensorboards-web-app-kubeflow-tensorboard-ui-edit
rules:
- apiGroups:
  - tensorboard.kubeflow.org
  resources:
  - tensorboards
  - tensorboards/finalizers
  verbs:
  - get
  - list
  - create
  - delete
- apiGroups:
  - kubeflow.org
  resources:
  - poddefaults
  verbs:
  - get
  - list
  - watch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-tensorboards-web-app-clusterrole-tensorboards-web-app-kubeflow-tensorboard-ui-view" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: tensorboards-web-app
    kustomize.component: tensorboards-web-app
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-view: "true"
  name: tensorboards-web-app-kubeflow-tensorboard-ui-view
rules:
- apiGroups:
  - tensorboard.kubeflow.org
  resources:
  - tensorboards
  - tensorboards/finalizers
  verbs:
  - get
  - list
- apiGroups:
  - storage.k8s.io
  resources:
  - storageclasses
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - kubeflow.org
  resources:
  - poddefaults
  verbs:
  - get
  - list
  - watch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-tensorboards-web-app-clusterrolebinding-tensorboards-web-app-cluster-role-binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app: tensorboards-web-app
    kustomize.component: tensorboards-web-app
  name: tensorboards-web-app-cluster-role-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: tensorboards-web-app-cluster-role
subjects:
- kind: ServiceAccount
  name: tensorboards-web-app-service-account
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-tensorboards-web-app-tensors-web-app-parameters" {
  yaml_body = <<YAML
apiVersion: v1
data:
  TWA_APP_SECURE_COOKIES: 'true '
  TWA_CLUSTER_DOMAIN: cluster.local
  TWA_PREFIX: /tensorboards
  TWA_USERID_HEADER: kubeflow-userid
  TWA_USERID_PREFIX: ""
kind: ConfigMap
metadata:
  labels:
    app: tensorboards-web-app
    kustomize.component: tensorboards-web-app
  name: tensorboards-web-app-parameters-642bbg7t66
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-tensorboards-web-app-service-tensorboards-web-app-service" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  labels:
    app: tensorboards-web-app
    kustomize.component: tensorboards-web-app
    run: tensorboards-web-app
  name: tensorboards-web-app-service
  namespace: kubeflow
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 5000
  selector:
    app: tensorboards-web-app
    kustomize.component: tensorboards-web-app
  type: ClusterIP
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-tensorboards-web-app-deployment-tensorboards-web-app-deployment" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: tensorboards-web-app
    kustomize.component: tensorboards-web-app
  name: tensorboards-web-app-deployment
  namespace: kubeflow
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tensorboards-web-app
      kustomize.component: tensorboards-web-app
  template:
    metadata:
      labels:
        app: tensorboards-web-app
        kustomize.component: tensorboards-web-app
    spec:
      containers:
      - env:
        - name: APP_PREFIX
          value: /tensorboards
        - name: USERID_HEADER
          value: kubeflow-userid
        - name: USERID_PREFIX
          value: ""
        - name: APP_SECURE_COOKIES
          value: 'true '
        image: docker.io/kubeflownotebookswg/tensorboards-web-app:v1.7.0
        name: tensorboards-web-app
        ports:
        - containerPort: 5000
      serviceAccountName: tensorboards-web-app-service-account
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

resource "kubectl_manifest" "kubeflow-tensorboards-web-app-destinationrule-tensorboards-web-app" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  labels:
    app: tensorboards-web-app
    kustomize.component: tensorboards-web-app
  name: tensorboards-web-app
  namespace: kubeflow
spec:
  host: tensorboards-web-app-service.kubeflow.svc.cluster.local
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-crd-destinationrules, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-tensorboards-web-app-virtualservice-tensorboards-web-app-tensorboards-webapp" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  labels:
    app: tensorboards-web-app
    kustomize.component: tensorboards-web-app
  name: tensorboards-web-app-tensorboards-web-app
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
          x-forwarded-prefix: /tensorboards
    match:
    - uri:
        prefix: /tensorboards/
    rewrite:
      uri: /
    route:
    - destination:
        host: tensorboards-web-app-service.kubeflow.svc.cluster.local
        port:
          number: 80
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-tensorboards-web-app-authorizationpolicy-tensorboards-web-app" {
  yaml_body = <<YAML
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  labels:
    app: tensorboards-web-app
    kustomize.component: tensorboards-web-app
  name: tensorboards-web-app
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
      app: tensorboards-web-app
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}