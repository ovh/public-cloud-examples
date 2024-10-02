resource "kubectl_manifest" "kubeflow-katib-crd-experiments" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: experiments.kubeflow.org
spec:
  group: kubeflow.org
  names:
    categories:
    - all
    - kubeflow
    - katib
    kind: Experiment
    plural: experiments
    singular: experiment
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - jsonPath: .status.conditions[-1:].type
      name: Type
      type: string
    - jsonPath: .status.conditions[-1:].status
      name: Status
      type: string
    - jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1beta1
    schema:
      openAPIV3Schema:
        type: object
        x-kubernetes-preserve-unknown-fields: true
    served: true
    storage: true
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-katib-crd-suggestions" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: suggestions.kubeflow.org
spec:
  group: kubeflow.org
  names:
    categories:
    - all
    - kubeflow
    - katib
    kind: Suggestion
    plural: suggestions
    singular: suggestion
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - jsonPath: .status.conditions[-1:].type
      name: Type
      type: string
    - jsonPath: .status.conditions[-1:].status
      name: Status
      type: string
    - jsonPath: .spec.requests
      name: Requested
      type: string
    - jsonPath: .status.suggestionCount
      name: Assigned
      type: string
    - jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1beta1
    schema:
      openAPIV3Schema:
        type: object
        x-kubernetes-preserve-unknown-fields: true
    served: true
    storage: true
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-katib-crd-trials" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: trials.kubeflow.org
spec:
  group: kubeflow.org
  names:
    categories:
    - all
    - kubeflow
    - katib
    kind: Trial
    plural: trials
    singular: trial
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - jsonPath: .status.conditions[-1:].type
      name: Type
      type: string
    - jsonPath: .status.conditions[-1:].status
      name: Status
      type: string
    - jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1beta1
    schema:
      openAPIV3Schema:
        type: object
        x-kubernetes-preserve-unknown-fields: true
    served: true
    storage: true
    subresources:
      status: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-katib-serviceaccount-katib-controller" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: katib-controller
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-katib-serviceaccount-katib-ui" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: katib-ui
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-katib-clusterrole-katib-controller" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: katib-controller
rules:
- apiGroups:
  - ""
  resources:
  - services
  verbs:
  - get
  - list
  - watch
  - create
  - delete
- apiGroups:
  - ""
  resources:
  - events
  verbs:
  - create
  - patch
  - update
- apiGroups:
  - ""
  resources:
  - serviceaccounts
  - persistentvolumes
  - persistentvolumeclaims
  verbs:
  - get
  - list
  - watch
  - create
- apiGroups:
  - ""
  resources:
  - namespaces
  - configmaps
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - pods
  - pods/status
  verbs:
  - get
- apiGroups:
  - apps
  resources:
  - deployments
  verbs:
  - get
  - list
  - watch
  - create
  - delete
- apiGroups:
  - rbac.authorization.k8s.io
  resources:
  - roles
  - rolebindings
  verbs:
  - get
  - create
  - list
  - watch
- apiGroups:
  - batch
  resources:
  - jobs
  - cronjobs
  verbs:
  - get
  - list
  - watch
  - create
  - delete
- apiGroups:
  - kubeflow.org
  resources:
  - tfjobs
  - pytorchjobs
  - mpijobs
  - xgboostjobs
  - mxjobs
  verbs:
  - get
  - list
  - watch
  - create
  - delete
- apiGroups:
  - kubeflow.org
  resources:
  - experiments
  - experiments/status
  - experiments/finalizers
  - trials
  - trials/status
  - trials/finalizers
  - suggestions
  - suggestions/status
  - suggestions/finalizers
  verbs:
  - '*'
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-katib-clusterrole-katib-ui" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: katib-ui
rules:
- apiGroups:
  - ""
  resources:
  - configmaps
  - namespaces
  verbs:
  - '*'
- apiGroups:
  - kubeflow.org
  resources:
  - experiments
  - trials
  - suggestions
  verbs:
  - '*'
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - list
- apiGroups:
  - ""
  resources:
  - pods/log
  verbs:
  - get
- apiGroups:
  - authorization.k8s.io
  resources:
  - subjectaccessreviews
  verbs:
  - create
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-katib-clusterrole-kubeflow-katib-admin" {
  yaml_body = <<YAML
aggregationRule:
  clusterRoleSelectors:
  - matchLabels:
      rbac.authorization.kubeflow.org/aggregate-to-kubeflow-katib-admin: "true"
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-admin: "true"
  name: kubeflow-katib-admin
rules: []
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-katib-clusterrole-kubeflow-katib-edit" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-edit: "true"
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-katib-admin: "true"
  name: kubeflow-katib-edit
rules:
- apiGroups:
  - kubeflow.org
  resources:
  - experiments
  - trials
  - suggestions
  verbs:
  - get
  - list
  - watch
  - create
  - delete
  - deletecollection
  - patch
  - update
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - list
- apiGroups:
  - ""
  resources:
  - pods/log
  verbs:
  - get
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-katib-clusterrole-kubeflow-katib-view" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-view: "true"
  name: kubeflow-katib-view
rules:
- apiGroups:
  - kubeflow.org
  resources:
  - experiments
  - trials
  - suggestions
  verbs:
  - get
  - list
  - watch
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-katib-clusterrolebinding-katib-controller" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: katib-controller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: katib-controller
subjects:
- kind: ServiceAccount
  name: katib-controller
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-katib-clusterrolebinding-katib-ui" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: katib-ui
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: katib-ui
subjects:
- kind: ServiceAccount
  name: katib-ui
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-katib-configmap-katib-config" {
  yaml_body = <<YAML
apiVersion: v1
data:
  early-stopping: |-
    {
      "medianstop": {
        "image": "docker.io/kubeflowkatib/earlystopping-medianstop:v0.15.0"
      }
    }
  metrics-collector-sidecar: |-
    {
      "StdOut": {
        "image": "docker.io/kubeflowkatib/file-metrics-collector:v0.15.0"
      },
      "File": {
        "image": "docker.io/kubeflowkatib/file-metrics-collector:v0.15.0"
      },
      "TensorFlowEvent": {
        "image": "docker.io/kubeflowkatib/tfevent-metrics-collector:v0.15.0",
        "resources": {
          "limits": {
            "memory": "1Gi"
          }
        }
      }
    }
  suggestion: |-
    {
      "random": {
        "image": "docker.io/kubeflowkatib/suggestion-hyperopt:v0.15.0"
      },
      "tpe": {
        "image": "docker.io/kubeflowkatib/suggestion-hyperopt:v0.15.0"
      },
      "grid": {
        "image": "docker.io/kubeflowkatib/suggestion-optuna:v0.15.0"
      },
      "hyperband": {
        "image": "docker.io/kubeflowkatib/suggestion-hyperband:v0.15.0"
      },
      "bayesianoptimization": {
        "image": "docker.io/kubeflowkatib/suggestion-skopt:v0.15.0"
      },
      "cmaes": {
        "image": "docker.io/kubeflowkatib/suggestion-goptuna:v0.15.0"
      },
      "sobol": {
        "image": "docker.io/kubeflowkatib/suggestion-goptuna:v0.15.0"
      },
      "multivariate-tpe": {
        "image": "docker.io/kubeflowkatib/suggestion-optuna:v0.15.0"
      },
      "enas": {
        "image": "docker.io/kubeflowkatib/suggestion-enas:v0.15.0",
        "resources": {
          "limits": {
            "memory": "200Mi"
          }
        }
      },
      "darts": {
        "image": "docker.io/kubeflowkatib/suggestion-darts:v0.15.0"
      },
      "pbt": {
        "image": "docker.io/kubeflowkatib/suggestion-pbt:v0.15.0",
        "persistentVolumeClaimSpec": {
          "accessModes": [
            "ReadWriteMany"
          ],
          "resources": {
            "requests": {
              "storage": "5Gi"
            }
          }
        }
      }
    }
kind: ConfigMap
metadata:
  name: katib-config
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-katib-configmap-trial-templates" {
  yaml_body = <<YAML
apiVersion: v1
data:
  defaultTrialTemplate.yaml: |-
    apiVersion: batch/v1
    kind: Job
    spec:
      template:
        spec:
          containers:
            - name: training-container
              image: docker.io/kubeflowkatib/mxnet-mnist:v0.15.0
              command:
                - "python3"
                - "/opt/mxnet-mnist/mnist.py"
                - "--batch-size=64"
                - "--lr=$${trialParameters.learningRate}"
                - "--num-layers=$${trialParameters.numberLayers}"
                - "--optimizer=$${trialParameters.optimizer}"
          restartPolicy: Never
  enasCPUTemplate: |-
    apiVersion: batch/v1
    kind: Job
    spec:
      template:
        spec:
          containers:
            - name: training-container
              image: docker.io/kubeflowkatib/enas-cnn-cifar10-cpu:v0.15.0
              command:
                - python3
                - -u
                - RunTrial.py
                - --num_epochs=1
                - "--architecture=\"$${trialParameters.neuralNetworkArchitecture}\""
                - "--nn_config=\"$${trialParameters.neuralNetworkConfig}\""
          restartPolicy: Never
  pytorchJobTemplate: |-
    apiVersion: kubeflow.org/v1
    kind: PyTorchJob
    spec:
      pytorchReplicaSpecs:
        Master:
          replicas: 1
          restartPolicy: OnFailure
          template:
            spec:
              containers:
                - name: pytorch
                  image: docker.io/kubeflowkatib/pytorch-mnist-cpu:v0.15.0
                  command:
                    - "python3"
                    - "/opt/pytorch-mnist/mnist.py"
                    - "--epochs=1"
                    - "--lr=$${trialParameters.learningRate}"
                    - "--momentum=$${trialParameters.momentum}"
        Worker:
          replicas: 2
          restartPolicy: OnFailure
          template:
            spec:
              containers:
                - name: pytorch
                  image: docker.io/kubeflowkatib/pytorch-mnist-cpu:v0.15.0
                  command:
                    - "python3"
                    - "/opt/pytorch-mnist/mnist.py"
                    - "--epochs=1"
                    - "--lr=$${trialParameters.learningRate}"
                    - "--momentum=$${trialParameters.momentum}"
kind: ConfigMap
metadata:
  labels:
    katib.kubeflow.org/component: trial-templates
  name: trial-templates
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-katib-secret-katib-mysql-secrets" {
  yaml_body = <<YAML
apiVersion: v1
stringData:
  user: ${ovh_cloud_project_database_user.katib-mysql-user.name}
  password: ${ovh_cloud_project_database_user.katib-mysql-user.password}
kind: Secret
metadata:
  name: katib-mysql-secrets
  namespace: kubeflow
type: Opaque
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-katib-service-katib-controller" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  annotations:
    prometheus.io/port: "8080"
    prometheus.io/scheme: http
    prometheus.io/scrape: "true"
  labels:
    katib.kubeflow.org/component: controller
  name: katib-controller
  namespace: kubeflow
spec:
  ports:
  - name: webhook
    port: 443
    protocol: TCP
    targetPort: 8443
  - name: metrics
    port: 8080
    targetPort: 8080
  - name: healthz
    port: 18080
    targetPort: 18080
  selector:
    katib.kubeflow.org/component: controller
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-katib-service-katib-db-manager" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  labels:
    katib.kubeflow.org/component: db-manager
  name: katib-db-manager
  namespace: kubeflow
spec:
  ports:
  - name: api
    port: 6789
    protocol: TCP
  selector:
    katib.kubeflow.org/component: db-manager
  type: ClusterIP
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-katib-service-katib-ui" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  labels:
    katib.kubeflow.org/component: ui
  name: katib-ui
  namespace: kubeflow
spec:
  ports:
  - name: ui
    port: 80
    protocol: TCP
    targetPort: 8080
  selector:
    katib.kubeflow.org/component: ui
  type: ClusterIP
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-katib-deployment-katib-controller" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    katib.kubeflow.org/component: controller
  name: katib-controller
  namespace: kubeflow
spec:
  replicas: 1
  selector:
    matchLabels:
      katib.kubeflow.org/component: controller
  template:
    metadata:
      annotations:
        prometheus.io/port: "8080"
        prometheus.io/scrape: "true"
        sidecar.istio.io/inject: "false"
      labels:
        katib.kubeflow.org/component: controller
    spec:
      containers:
      - args:
        - --webhook-port=8443
        - --trial-resources=Job.v1.batch
        - --trial-resources=TFJob.v1.kubeflow.org
        - --trial-resources=PyTorchJob.v1.kubeflow.org
        - --trial-resources=MPIJob.v1.kubeflow.org
        - --trial-resources=XGBoostJob.v1.kubeflow.org
        - --trial-resources=MXJob.v1.kubeflow.org
        command:
        - ./katib-controller
        env:
        - name: KATIB_CORE_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        image: docker.io/kubeflowkatib/katib-controller:v0.15.0
        livenessProbe:
          httpGet:
            path: /healthz
            port: healthz
        name: katib-controller
        ports:
        - containerPort: 8443
          name: webhook
          protocol: TCP
        - containerPort: 8080
          name: metrics
          protocol: TCP
        - containerPort: 18080
          name: healthz
          protocol: TCP
        readinessProbe:
          httpGet:
            path: /readyz
            port: healthz
        volumeMounts:
        - mountPath: /tmp/cert
          name: cert
          readOnly: true
      serviceAccountName: katib-controller
      volumes:
      - name: cert
        secret:
          defaultMode: 420
          secretName: katib-webhook-cert
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-katib-certificate-katib-webhook-cert, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-katib-deployment-katib-db-manager" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    katib.kubeflow.org/component: db-manager
  name: katib-db-manager
  namespace: kubeflow
spec:
  replicas: 1
  selector:
    matchLabels:
      katib.kubeflow.org/component: db-manager
  template:
    metadata:
      annotations:
        sidecar.istio.io/inject: "false"
      labels:
        katib.kubeflow.org/component: db-manager
    spec:
      containers:
      - command:
        - ./katib-db-manager
        env:
        - name: DB_NAME
          value: mysql
        - name: KATIB_MYSQL_DB_HOST
          value: "${ovh_cloud_project_database.mysql.endpoints[0].domain}"
        - name: KATIB_MYSQL_DB_PORT
          value: "${ovh_cloud_project_database.mysql.endpoints[0].port}"
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              key: user
              name: katib-mysql-secrets
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              key: password
              name: katib-mysql-secrets
        image: docker.io/kubeflowkatib/katib-db-manager:v0.15.0
        livenessProbe:
          exec:
            command:
            - /bin/grpc_health_probe
            - -addr=:6789
          failureThreshold: 5
          initialDelaySeconds: 10
          periodSeconds: 60
        name: katib-db-manager
        ports:
        - containerPort: 6789
          name: api
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-katib-secret-katib-mysql-secrets, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-katib-deployment-katib-ui" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    katib.kubeflow.org/component: ui
  name: katib-ui
  namespace: kubeflow
spec:
  replicas: 1
  selector:
    matchLabels:
      katib.kubeflow.org/component: ui
  template:
    metadata:
      annotations:
        sidecar.istio.io/inject: "true"
      labels:
        katib.kubeflow.org/component: ui
    spec:
      containers:
      - args:
        - --port=8080
        command:
        - ./katib-ui
        env:
        - name: KATIB_CORE_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: APP_DISABLE_AUTH
          value: "false"
        image: docker.io/kubeflowkatib/katib-ui:v0.15.0
        name: katib-ui
        ports:
        - containerPort: 8080
          name: ui
      serviceAccountName: katib-ui
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

resource "kubectl_manifest" "kubeflow-katib-certificate-katib-webhook-cert" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: katib-webhook-cert
  namespace: kubeflow
spec:
  commonName: katib-controller.kubeflow.svc
  dnsNames:
  - katib-controller.kubeflow.svc
  - katib-controller.kubeflow.svc.cluster.local
  isCA: true
  issuerRef:
    kind: Issuer
    name: katib-selfsigned-issuer
  secretName: katib-webhook-cert
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-cert-manager-deployment-webhook]
}

resource "kubectl_manifest" "kubeflow-katib-issuer-katib-selfsigned-issuer" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: katib-selfsigned-issuer
  namespace: kubeflow
spec:
  selfSigned: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-cert-manager-crd-issuers, kubectl_manifest.kubeflow-cert-manager-deployment-webhook]
}

resource "kubectl_manifest" "kubeflow-katib-virtualservice-katib-ui" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: katib-ui
  namespace: kubeflow
spec:
  gateways:
  - kubeflow-gateway
  hosts:
  - '*'
  http:
  - match:
    - uri:
        prefix: /katib/
    rewrite:
      uri: /katib/
    route:
    - destination:
        host: katib-ui.kubeflow.svc.cluster.local
        port:
          number: 80
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-katib-security-katib-ui" {
  yaml_body = <<YAML
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: katib-ui
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
      katib.kubeflow.org/component: ui
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-katib-mutatingwebhookconfiguration-katib" {
  yaml_body = <<YAML
apiVersion: admissionregistration.k8s.io/v1
kind: MutatingWebhookConfiguration
metadata:
  annotations:
    cert-manager.io/inject-ca-from: kubeflow/katib-webhook-cert
  name: katib.kubeflow.org
webhooks:
- admissionReviewVersions:
  - v1
  clientConfig:
    caBundle: Cg==
    service:
      name: katib-controller
      namespace: kubeflow
      path: /mutate-experiment
  failurePolicy: Ignore
  name: defaulter.experiment.katib.kubeflow.org
  rules:
  - apiGroups:
    - kubeflow.org
    apiVersions:
    - v1beta1
    operations:
    - CREATE
    - UPDATE
    resources:
    - experiments
  sideEffects: None
- admissionReviewVersions:
  - v1
  clientConfig:
    caBundle: Cg==
    service:
      name: katib-controller
      namespace: kubeflow
      path: /mutate-pod
  failurePolicy: Ignore
  name: mutator.pod.katib.kubeflow.org
  namespaceSelector:
    matchLabels:
      katib.kubeflow.org/metrics-collector-injection: enabled
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
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-katib-validatingwebhookconfiguration-katib" {
  yaml_body = <<YAML
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  annotations:
    cert-manager.io/inject-ca-from: kubeflow/katib-webhook-cert
  name: katib.kubeflow.org
webhooks:
- admissionReviewVersions:
  - v1
  clientConfig:
    caBundle: Cg==
    service:
      name: katib-controller
      namespace: kubeflow
      path: /validate-experiment
  failurePolicy: Ignore
  name: validator.experiment.katib.kubeflow.org
  rules:
  - apiGroups:
    - kubeflow.org
    apiVersions:
    - v1beta1
    operations:
    - CREATE
    - UPDATE
    resources:
    - experiments
  sideEffects: None
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}