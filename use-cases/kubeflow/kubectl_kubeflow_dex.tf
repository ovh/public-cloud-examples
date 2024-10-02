resource "kubectl_manifest" "kubeflow-dex-namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: auth
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-dex-customresourcedefinition-authcodes" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: authcodes.dex.coreos.com
spec:
  group: dex.coreos.com
  names:
    kind: AuthCode
    listKind: AuthCodeList
    plural: authcodes
    singular: authcode
  scope: Namespaced
  versions:
  - name: v1
    schema:
      openAPIV3Schema:
        type: object
        x-kubernetes-preserve-unknown-fields: true
    served: true
    storage: true
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-dex-namespace]
}

resource "kubectl_manifest" "kubeflow-dex-serviceaccount-dex" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: dex
  namespace: auth
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-dex-namespace]
}

resource "kubectl_manifest" "kubeflow-dex-clusterrole-dex" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: dex
rules:
- apiGroups:
  - dex.coreos.com
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - apiextensions.k8s.io
  resources:
  - customresourcedefinitions
  verbs:
  - create
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-dex-namespace]
}

resource "kubectl_manifest" "kubeflow-dex-clusterrolebinding-dex" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: dex
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: dex
subjects:
- kind: ServiceAccount
  name: dex
  namespace: auth
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-dex-namespace]
}

resource "kubectl_manifest" "kubeflow-dex-configmap-dex" {
  yaml_body = <<YAML
apiVersion: v1
data:
  config.yaml: |
    issuer: http://dex.auth.svc.cluster.local:5556/dex
    storage:
      type: kubernetes
      config:
        inCluster: true
    web:
      http: 0.0.0.0:5556
    logger:
      level: "debug"
      format: text
    oauth2:
      skipApprovalScreen: true
    enablePasswordDB: true
    staticPasswords:
    - email: "${var.kubeflow_default_user_name}@${var.ovh_dns_domain}"
      hash: "${var.kubeflow_default_user_password_hash}"
      # https://github.com/dexidp/dex/pull/1601/commits
      # FIXME: Use hashFromEnv instead
      username: user
      userID: "15841185641784"
    staticClients:
    # https://github.com/dexidp/dex/pull/1664
    - idEnv: OIDC_CLIENT_ID
      redirectURIs: ["/authservice/oidc/callback"]
      name: 'Dex Login Application'
      secretEnv: OIDC_CLIENT_SECRET
kind: ConfigMap
metadata:
  name: dex
  namespace: auth
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-dex-namespace]
}

resource "kubectl_manifest" "kubeflow-dex-secret-dex-oidc-client" {
  yaml_body = <<YAML
apiVersion: v1
data:
  OIDC_CLIENT_ID: a3ViZWZsb3ctb2lkYy1hdXRoc2VydmljZQ==
  OIDC_CLIENT_SECRET: cFVCbkJPWTgwU25YZ2ppYlRZTTlaV056WTJ4cmVOR1Fvaw==
kind: Secret
metadata:
  name: dex-oidc-client
  namespace: auth
type: Opaque
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-dex-namespace]
}

resource "kubectl_manifest" "kubeflow-dex-service-dex" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: dex
  namespace: auth
spec:
  ports:
  - name: dex
    port: 5556
    protocol: TCP
    targetPort: 5556
  selector:
    app: dex
  type: ClusterIP
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-dex-namespace]
}

resource "kubectl_manifest" "kubeflow-dex-deployment-dex" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: dex
  name: dex
  namespace: auth
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dex
  template:
    metadata:
      labels:
        app: dex
    spec:
      containers:
      - command:
        - dex
        - serve
        - /etc/dex/cfg/config.yaml
        env:
        - name: KUBERNETES_POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        envFrom:
        - secretRef:
            name: dex-oidc-client
        image: ghcr.io/dexidp/dex:v2.31.2
        name: dex
        ports:
        - containerPort: 5556
          name: http
        volumeMounts:
        - mountPath: /etc/dex/cfg
          name: config
      serviceAccountName: dex
      volumes:
      - configMap:
          items:
          - key: config.yaml
            path: config.yaml
          name: dex
        name: config
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-dex-namespace, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-dex-virtualservice-dex" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: dex
  namespace: auth
spec:
  gateways:
  - kubeflow/kubeflow-gateway
  hosts:
  - '*'
  http:
  - match:
    - uri:
        prefix: /dex/
    route:
    - destination:
        host: dex.auth.svc.cluster.local
        port:
          number: 5556
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-dex-namespace, kubectl_manifest.kubeflow-istio-crd-virtualservices]
}
