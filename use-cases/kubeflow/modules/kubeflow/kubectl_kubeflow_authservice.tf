resource "kubectl_manifest" "kubeflow-authservice-serviceaccount-authservice" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: authservice
  namespace: istio-system
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-authservice-clusterrole-authn-delegator" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: authn-delegator
rules:
- apiGroups:
  - authentication.k8s.io
  resources:
  - tokenreviews
  verbs:
  - create
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-authservice-clusterrolebinding-authn-delegators" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: authn-delegators
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: authn-delegator
subjects:
- kind: ServiceAccount
  name: authservice
  namespace: istio-system
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-authservice-configmap-oidc-authservice-parameters" {
  yaml_body = <<YAML
apiVersion: v1
data:
  AUTHSERVICE_URL_PREFIX: /authservice/
  OIDC_AUTH_URL: /dex/auth
  OIDC_PROVIDER: http://dex.auth.svc.cluster.local:5556/dex
  OIDC_SCOPES: profile email groups
  PORT: '"8080"'
  SKIP_AUTH_URLS: /dex, /.well-known
  STORE_PATH: /var/lib/authservice/data.db
  USERID_CLAIM: email
  USERID_HEADER: kubeflow-userid
  USERID_PREFIX: ""
kind: ConfigMap
metadata:
  name: oidc-authservice-parameters
  namespace: istio-system
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-authservice-secret-oidc-authservice-client" {
  yaml_body = <<YAML
apiVersion: v1
data:
  CLIENT_ID: a3ViZWZsb3ctb2lkYy1hdXRoc2VydmljZQ==
  CLIENT_SECRET: cFVCbkJPWTgwU25YZ2ppYlRZTTlaV056WTJ4cmVOR1Fvaw==
kind: Secret
metadata:
  name: oidc-authservice-client
  namespace: istio-system
type: Opaque
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-authservice-service-authservice" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: authservice
  namespace: istio-system
spec:
  ports:
  - name: http-authservice
    port: 8080
    targetPort: http-api
  publishNotReadyAddresses: true
  selector:
    app: authservice
  type: ClusterIP
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-authservice-persistentvolumeclaim-authservice" {
  yaml_body = <<YAML
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: authservice-pvc
  namespace: istio-system
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace]
}

resource "kubectl_manifest" "kubeflow-authservice-statefulset-oidc-authservice" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: authservice
  namespace: istio-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: authservice
  serviceName: authservice
  template:
    metadata:
      annotations:
        sidecar.istio.io/inject: "false"
      labels:
        app: authservice
    spec:
      containers:
      - envFrom:
        - secretRef:
            name: oidc-authservice-client
        - configMapRef:
            name: oidc-authservice-parameters
        image: docker.io/kubeflowmanifestswg/oidc-authservice:e236439
        imagePullPolicy: Always
        name: authservice
        ports:
        - containerPort: 8080
          name: http-api
        readinessProbe:
          httpGet:
            path: /
            port: 8081
        volumeMounts:
        - mountPath: /var/lib/authservice
          name: data
      securityContext:
        fsGroup: 111
      serviceAccountName: authservice
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: authservice-pvc
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-authservice-envoyfilter-authn-filter" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: authn-filter
  namespace: istio-system
spec:
  configPatches:
  - applyTo: HTTP_FILTER
    match:
      context: GATEWAY
      listener:
        filterChain:
          filter:
            name: envoy.http_connection_manager
    patch:
      operation: INSERT_BEFORE
      value:
        name: envoy.filters.http.ext_authz
        typed_config:
          '@type': type.googleapis.com/envoy.extensions.filters.http.ext_authz.v3.ExtAuthz
          http_service:
            authorization_request:
              allowed_headers:
                patterns:
                - exact: authorization
                - exact: cookie
                - exact: x-auth-token
            authorization_response:
              allowed_upstream_headers:
                patterns:
                - exact: kubeflow-userid
            server_uri:
              cluster: outbound|8080||authservice.istio-system.svc.cluster.local
              timeout: 10s
              uri: http://authservice.istio-system.svc.cluster.local
  workloadSelector:
    labels:
      istio: ingressgateway
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-istio-namespace, kubectl_manifest.kubeflow-istio-crd-envoyfilters]
}