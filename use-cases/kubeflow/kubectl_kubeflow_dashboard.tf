resource "kubectl_manifest" "kubeflow-dashboard-serviceaccount-centraldashboard" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app: centraldashboard
    app.kubernetes.io/component: centraldashboard
    app.kubernetes.io/name: centraldashboard
    kustomize.component: centraldashboard
  name: centraldashboard
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-dashboard-role-centraldashboard" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  labels:
    app: centraldashboard
    app.kubernetes.io/component: centraldashboard
    app.kubernetes.io/name: centraldashboard
    kustomize.component: centraldashboard
  name: centraldashboard
  namespace: kubeflow
rules:
- apiGroups:
  - ""
  - app.k8s.io
  resources:
  - applications
  - pods
  - pods/exec
  - pods/log
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - secrets
  - configmaps
  verbs:
  - get
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-dashboard-clusterrole-centraldashboard" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: centraldashboard
    app.kubernetes.io/component: centraldashboard
    app.kubernetes.io/name: centraldashboard
    kustomize.component: centraldashboard
  name: centraldashboard
rules:
- apiGroups:
  - ""
  resources:
  - events
  - namespaces
  - nodes
  verbs:
  - get
  - list
  - watch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-dashboard-rolebinding-centraldashboard" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    app: centraldashboard
    app.kubernetes.io/component: centraldashboard
    app.kubernetes.io/name: centraldashboard
    kustomize.component: centraldashboard
  name: centraldashboard
  namespace: kubeflow
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: centraldashboard
subjects:
- kind: ServiceAccount
  name: centraldashboard
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-dashboard-clusterrolebinding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app: centraldashboard
    app.kubernetes.io/component: centraldashboard
    app.kubernetes.io/name: centraldashboard
    kustomize.component: centraldashboard
  name: centraldashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: centraldashboard
subjects:
- kind: ServiceAccount
  name: centraldashboard
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-dashboard-configmap-centraldashboard-config" {
  yaml_body = <<YAML
apiVersion: v1
data:
  links: |-
    {
      "menuLinks": [
        {
          "type": "item",
          "link": "/jupyter/",
          "text": "Notebooks",
          "icon": "book"
        },
        {
          "type": "item",
          "link": "/tensorboards/",
          "text": "Tensorboards",
          "icon": "assessment"
        },
        {
          "type": "item",
          "link": "/volumes/",
          "text": "Volumes",
          "icon": "device:storage"
        },
        {
          "type": "item",
          "link": "/kserve-endpoints/",
          "text": "Endpoints",
          "icon": "kubeflow:models"
        },
        {
          "type": "item",
          "link": "/katib/",
          "text": "Experiments (AutoML)",
          "icon": "kubeflow:katib"
        },
        {
          "type": "item",
          "text": "Experiments (KFP)",
          "link": "/pipeline/#/experiments",
          "icon": "done-all"
        },
        {
          "type": "item",
          "link": "/pipeline/#/pipelines",
          "text": "Pipelines",
          "icon": "kubeflow:pipeline-centered"
        },
        {
          "type": "item",
          "link": "/pipeline/#/runs",
          "text": "Runs",
          "icon": "maps:directions-run"
        },
        {
          "type": "item",
          "link": "/pipeline/#/recurringruns",
          "text": "Recurring Runs",
          "icon": "device:access-alarm"
        },
        {
          "type": "item",
          "link": "/pipeline/#/artifacts",
          "text": "Artifacts",
          "icon": "editor:bubble-chart"
        },
        {
          "type": "item",
          "link": "/pipeline/#/executions",
          "text": "Executions",
          "icon": "av:play-arrow"
        }
      ],
      "externalLinks": [ ],
        "quickLinks": [
          {
            "text": "Upload a pipeline",
            "desc": "Pipelines",
            "link": "/pipeline/"
          },
          {
            "text": "View all pipeline runs",
            "desc": "Pipelines",
            "link": "/pipeline/#/runs"
          },
          {
            "text": "Create a new Notebook server",
            "desc": "Notebook Servers",
            "link": "/jupyter/new?namespace=kubeflow"
          },
          {
            "text": "View Katib Experiments",
            "desc": "Katib",
            "link": "/katib/"
          }
        ],
        "documentationItems": [
          {
            "text": "Getting Started with Kubeflow",
            "desc": "Get your machine-learning workflow up and running on Kubeflow",
            "link": "https://www.kubeflow.org/docs/started/getting-started/"
          }
        ]
    }
  settings: |-
    {
      "DASHBOARD_FORCE_IFRAME": true
    }
kind: ConfigMap
metadata:
  labels:
    app: centraldashboard
    app.kubernetes.io/component: centraldashboard
    app.kubernetes.io/name: centraldashboard
    kustomize.component: centraldashboard
  name: centraldashboard-config
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-dashboard-configmap-centraldashboard-parameters" {
  yaml_body = <<YAML
apiVersion: v1
data:
  CD_CLUSTER_DOMAIN: cluster.local
  CD_REGISTRATION_FLOW: "false"
  CD_USERID_HEADER: kubeflow-userid
  CD_USERID_PREFIX: ""
kind: ConfigMap
metadata:
  labels:
    app: centraldashboard
    app.kubernetes.io/component: centraldashboard
    app.kubernetes.io/name: centraldashboard
    kustomize.component: centraldashboard
  name: centraldashboard-parameters
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-dashboard-service-centraldashboard" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  labels:
    app: centraldashboard
    app.kubernetes.io/component: centraldashboard
    app.kubernetes.io/name: centraldashboard
    kustomize.component: centraldashboard
  name: centraldashboard
  namespace: kubeflow
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 8082
  selector:
    app: centraldashboard
    app.kubernetes.io/component: centraldashboard
    app.kubernetes.io/name: centraldashboard
    kustomize.component: centraldashboard
  sessionAffinity: None
  type: ClusterIP
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-dashboard-deployment-centraldashboard" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: centraldashboard
    app.kubernetes.io/component: centraldashboard
    app.kubernetes.io/name: centraldashboard
    kustomize.component: centraldashboard
  name: centraldashboard
  namespace: kubeflow
spec:
  replicas: 1
  selector:
    matchLabels:
      app: centraldashboard
      app.kubernetes.io/component: centraldashboard
      app.kubernetes.io/name: centraldashboard
      kustomize.component: centraldashboard
  template:
    metadata:
      annotations:
        sidecar.istio.io/inject: "true"
      labels:
        app: centraldashboard
        app.kubernetes.io/component: centraldashboard
        app.kubernetes.io/name: centraldashboard
        kustomize.component: centraldashboard
    spec:
      containers:
      - env:
        - name: USERID_HEADER
          value: kubeflow-userid
        - name: USERID_PREFIX
          value: ""
        - name: PROFILES_KFAM_SERVICE_HOST
          value: profiles-kfam.kubeflow
        - name: REGISTRATION_FLOW
          value: "false"
        - name: DASHBOARD_LINKS_CONFIGMAP
          value: centraldashboard-config
        - name: LOGOUT_URL
          value: /authservice/logout
        image: docker.io/kubeflownotebookswg/centraldashboard:v1.7.0
        imagePullPolicy: IfNotPresent
        livenessProbe:
          httpGet:
            path: /healthz
            port: 8082
          initialDelaySeconds: 30
          periodSeconds: 30
        name: centraldashboard
        ports:
        - containerPort: 8082
          protocol: TCP
      serviceAccountName: centraldashboard
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

resource "kubectl_manifest" "kubeflow-dashboard-virtualservice-centraldashboard" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  labels:
    app: centraldashboard
    app.kubernetes.io/component: centraldashboard
    app.kubernetes.io/name: centraldashboard
    kustomize.component: centraldashboard
  name: centraldashboard
  namespace: kubeflow
spec:
  gateways:
  - kubeflow-gateway
  hosts:
  - '*'
  http:
  - match:
    - uri:
        prefix: /
    rewrite:
      uri: /
    route:
    - destination:
        host: centraldashboard.kubeflow.svc.cluster.local
        port:
          number: 80
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-dashboard-authorizationpolicy-central-dashboard" {
  yaml_body = <<YAML
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  labels:
    app: centraldashboard
    app.kubernetes.io/component: centraldashboard
    app.kubernetes.io/name: centraldashboard
    kustomize.component: centraldashboard
  name: central-dashboard
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
      app: centraldashboard
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}