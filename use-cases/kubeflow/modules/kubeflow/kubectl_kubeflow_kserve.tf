resource "kubectl_manifest" "kubeflow-kserve-crd-clusterservingruntimes" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    controller-gen.kubebuilder.io/version: v0.4.0
  creationTimestamp: null
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: clusterservingruntimes.serving.kserve.io
spec:
  group: serving.kserve.io
  names:
    kind: ClusterServingRuntime
    listKind: ClusterServingRuntimeList
    plural: clusterservingruntimes
    singular: clusterservingruntime
  scope: Cluster
  versions:
  - additionalPrinterColumns:
    - jsonPath: .spec.disabled
      name: Disabled
      type: boolean
    - jsonPath: .spec.supportedModelFormats[*].name
      name: ModelType
      type: string
    - jsonPath: .spec.containers[*].name
      name: Containers
      type: string
    - jsonPath: .metadata.creationTimestamp
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
            properties:
              affinity:
                properties:
                  nodeAffinity:
                    properties:
                      preferredDuringSchedulingIgnoredDuringExecution:
                        items:
                          properties:
                            preference:
                              properties:
                                matchExpressions:
                                  items:
                                    properties:
                                      key:
                                        type: string
                                      operator:
                                        type: string
                                      values:
                                        items:
                                          type: string
                                        type: array
                                    required:
                                    - key
                                    - operator
                                    type: object
                                  type: array
                                matchFields:
                                  items:
                                    properties:
                                      key:
                                        type: string
                                      operator:
                                        type: string
                                      values:
                                        items:
                                          type: string
                                        type: array
                                    required:
                                    - key
                                    - operator
                                    type: object
                                  type: array
                              type: object
                            weight:
                              format: int32
                              type: integer
                          required:
                          - preference
                          - weight
                          type: object
                        type: array
                      requiredDuringSchedulingIgnoredDuringExecution:
                        properties:
                          nodeSelectorTerms:
                            items:
                              properties:
                                matchExpressions:
                                  items:
                                    properties:
                                      key:
                                        type: string
                                      operator:
                                        type: string
                                      values:
                                        items:
                                          type: string
                                        type: array
                                    required:
                                    - key
                                    - operator
                                    type: object
                                  type: array
                                matchFields:
                                  items:
                                    properties:
                                      key:
                                        type: string
                                      operator:
                                        type: string
                                      values:
                                        items:
                                          type: string
                                        type: array
                                    required:
                                    - key
                                    - operator
                                    type: object
                                  type: array
                              type: object
                            type: array
                        required:
                        - nodeSelectorTerms
                        type: object
                    type: object
                  podAffinity:
                    properties:
                      preferredDuringSchedulingIgnoredDuringExecution:
                        items:
                          properties:
                            podAffinityTerm:
                              properties:
                                labelSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaceSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaces:
                                  items:
                                    type: string
                                  type: array
                                topologyKey:
                                  type: string
                              required:
                              - topologyKey
                              type: object
                            weight:
                              format: int32
                              type: integer
                          required:
                          - podAffinityTerm
                          - weight
                          type: object
                        type: array
                      requiredDuringSchedulingIgnoredDuringExecution:
                        items:
                          properties:
                            labelSelector:
                              properties:
                                matchExpressions:
                                  items:
                                    properties:
                                      key:
                                        type: string
                                      operator:
                                        type: string
                                      values:
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
                                  type: object
                              type: object
                            namespaceSelector:
                              properties:
                                matchExpressions:
                                  items:
                                    properties:
                                      key:
                                        type: string
                                      operator:
                                        type: string
                                      values:
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
                                  type: object
                              type: object
                            namespaces:
                              items:
                                type: string
                              type: array
                            topologyKey:
                              type: string
                          required:
                          - topologyKey
                          type: object
                        type: array
                    type: object
                  podAntiAffinity:
                    properties:
                      preferredDuringSchedulingIgnoredDuringExecution:
                        items:
                          properties:
                            podAffinityTerm:
                              properties:
                                labelSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaceSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaces:
                                  items:
                                    type: string
                                  type: array
                                topologyKey:
                                  type: string
                              required:
                              - topologyKey
                              type: object
                            weight:
                              format: int32
                              type: integer
                          required:
                          - podAffinityTerm
                          - weight
                          type: object
                        type: array
                      requiredDuringSchedulingIgnoredDuringExecution:
                        items:
                          properties:
                            labelSelector:
                              properties:
                                matchExpressions:
                                  items:
                                    properties:
                                      key:
                                        type: string
                                      operator:
                                        type: string
                                      values:
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
                                  type: object
                              type: object
                            namespaceSelector:
                              properties:
                                matchExpressions:
                                  items:
                                    properties:
                                      key:
                                        type: string
                                      operator:
                                        type: string
                                      values:
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
                                  type: object
                              type: object
                            namespaces:
                              items:
                                type: string
                              type: array
                            topologyKey:
                              type: string
                          required:
                          - topologyKey
                          type: object
                        type: array
                    type: object
                type: object
              annotations:
                additionalProperties:
                  type: string
                type: object
              builtInAdapter:
                properties:
                  env:
                    items:
                      properties:
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
                            fieldRef:
                              properties:
                                apiVersion:
                                  type: string
                                fieldPath:
                                  type: string
                              required:
                              - fieldPath
                              type: object
                            resourceFieldRef:
                              properties:
                                containerName:
                                  type: string
                                divisor:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                  x-kubernetes-int-or-string: true
                                resource:
                                  type: string
                              required:
                              - resource
                              type: object
                            secretKeyRef:
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
                      required:
                      - name
                      type: object
                    type: array
                  memBufferBytes:
                    type: integer
                  modelLoadingTimeoutMillis:
                    type: integer
                  runtimeManagementPort:
                    type: integer
                  serverType:
                    type: string
                type: object
              containers:
                items:
                  properties:
                    args:
                      items:
                        type: string
                      type: array
                    command:
                      items:
                        type: string
                      type: array
                    env:
                      items:
                        properties:
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
                              fieldRef:
                                properties:
                                  apiVersion:
                                    type: string
                                  fieldPath:
                                    type: string
                                required:
                                - fieldPath
                                type: object
                              resourceFieldRef:
                                properties:
                                  containerName:
                                    type: string
                                  divisor:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                    x-kubernetes-int-or-string: true
                                  resource:
                                    type: string
                                required:
                                - resource
                                type: object
                              secretKeyRef:
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
                        required:
                        - name
                        type: object
                      type: array
                    envFrom:
                      items:
                        properties:
                          configMapRef:
                            properties:
                              name:
                                type: string
                              optional:
                                type: boolean
                            type: object
                          prefix:
                            type: string
                          secretRef:
                            properties:
                              name:
                                type: string
                              optional:
                                type: boolean
                            type: object
                        type: object
                      type: array
                    image:
                      type: string
                    imagePullPolicy:
                      type: string
                    lifecycle:
                      properties:
                        postStart:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              required:
                              - port
                              type: object
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                          type: object
                        preStop:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              required:
                              - port
                              type: object
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                          type: object
                      type: object
                    livenessProbe:
                      properties:
                        exec:
                          properties:
                            command:
                              items:
                                type: string
                              type: array
                          type: object
                        failureThreshold:
                          format: int32
                          type: integer
                        grpc:
                          properties:
                            port:
                              format: int32
                              type: integer
                            service:
                              type: string
                          required:
                          - port
                          type: object
                        httpGet:
                          properties:
                            host:
                              type: string
                            httpHeaders:
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
                            path:
                              type: string
                            port:
                              anyOf:
                              - type: integer
                              - type: string
                              x-kubernetes-int-or-string: true
                            scheme:
                              type: string
                          required:
                          - port
                          type: object
                        initialDelaySeconds:
                          format: int32
                          type: integer
                        periodSeconds:
                          format: int32
                          type: integer
                        successThreshold:
                          format: int32
                          type: integer
                        tcpSocket:
                          properties:
                            host:
                              type: string
                            port:
                              anyOf:
                              - type: integer
                              - type: string
                              x-kubernetes-int-or-string: true
                          required:
                          - port
                          type: object
                        terminationGracePeriodSeconds:
                          format: int64
                          type: integer
                        timeoutSeconds:
                          format: int32
                          type: integer
                      type: object
                    name:
                      type: string
                    ports:
                      items:
                        properties:
                          containerPort:
                            format: int32
                            type: integer
                          hostIP:
                            type: string
                          hostPort:
                            format: int32
                            type: integer
                          name:
                            type: string
                          protocol:
                            default: TCP
                            type: string
                        required:
                        - containerPort
                        type: object
                      type: array
                      x-kubernetes-list-map-keys:
                      - containerPort
                      - protocol
                      x-kubernetes-list-type: map
                    readinessProbe:
                      properties:
                        exec:
                          properties:
                            command:
                              items:
                                type: string
                              type: array
                          type: object
                        failureThreshold:
                          format: int32
                          type: integer
                        grpc:
                          properties:
                            port:
                              format: int32
                              type: integer
                            service:
                              type: string
                          required:
                          - port
                          type: object
                        httpGet:
                          properties:
                            host:
                              type: string
                            httpHeaders:
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
                            path:
                              type: string
                            port:
                              anyOf:
                              - type: integer
                              - type: string
                              x-kubernetes-int-or-string: true
                            scheme:
                              type: string
                          required:
                          - port
                          type: object
                        initialDelaySeconds:
                          format: int32
                          type: integer
                        periodSeconds:
                          format: int32
                          type: integer
                        successThreshold:
                          format: int32
                          type: integer
                        tcpSocket:
                          properties:
                            host:
                              type: string
                            port:
                              anyOf:
                              - type: integer
                              - type: string
                              x-kubernetes-int-or-string: true
                          required:
                          - port
                          type: object
                        terminationGracePeriodSeconds:
                          format: int64
                          type: integer
                        timeoutSeconds:
                          format: int32
                          type: integer
                      type: object
                    resources:
                      properties:
                        limits:
                          additionalProperties:
                            anyOf:
                            - type: integer
                            - type: string
                            pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                            x-kubernetes-int-or-string: true
                          type: object
                        requests:
                          additionalProperties:
                            anyOf:
                            - type: integer
                            - type: string
                            pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                            x-kubernetes-int-or-string: true
                          type: object
                      type: object
                    securityContext:
                      properties:
                        allowPrivilegeEscalation:
                          type: boolean
                        capabilities:
                          properties:
                            add:
                              items:
                                type: string
                              type: array
                            drop:
                              items:
                                type: string
                              type: array
                          type: object
                        privileged:
                          type: boolean
                        procMount:
                          type: string
                        readOnlyRootFilesystem:
                          type: boolean
                        runAsGroup:
                          format: int64
                          type: integer
                        runAsNonRoot:
                          type: boolean
                        runAsUser:
                          format: int64
                          type: integer
                        seLinuxOptions:
                          properties:
                            level:
                              type: string
                            role:
                              type: string
                            type:
                              type: string
                            user:
                              type: string
                          type: object
                        seccompProfile:
                          properties:
                            localhostProfile:
                              type: string
                            type:
                              type: string
                          required:
                          - type
                          type: object
                        windowsOptions:
                          properties:
                            gmsaCredentialSpec:
                              type: string
                            gmsaCredentialSpecName:
                              type: string
                            hostProcess:
                              type: boolean
                            runAsUserName:
                              type: string
                          type: object
                      type: object
                    startupProbe:
                      properties:
                        exec:
                          properties:
                            command:
                              items:
                                type: string
                              type: array
                          type: object
                        failureThreshold:
                          format: int32
                          type: integer
                        grpc:
                          properties:
                            port:
                              format: int32
                              type: integer
                            service:
                              type: string
                          required:
                          - port
                          type: object
                        httpGet:
                          properties:
                            host:
                              type: string
                            httpHeaders:
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
                            path:
                              type: string
                            port:
                              anyOf:
                              - type: integer
                              - type: string
                              x-kubernetes-int-or-string: true
                            scheme:
                              type: string
                          required:
                          - port
                          type: object
                        initialDelaySeconds:
                          format: int32
                          type: integer
                        periodSeconds:
                          format: int32
                          type: integer
                        successThreshold:
                          format: int32
                          type: integer
                        tcpSocket:
                          properties:
                            host:
                              type: string
                            port:
                              anyOf:
                              - type: integer
                              - type: string
                              x-kubernetes-int-or-string: true
                          required:
                          - port
                          type: object
                        terminationGracePeriodSeconds:
                          format: int64
                          type: integer
                        timeoutSeconds:
                          format: int32
                          type: integer
                      type: object
                    stdin:
                      type: boolean
                    stdinOnce:
                      type: boolean
                    terminationMessagePath:
                      type: string
                    terminationMessagePolicy:
                      type: string
                    tty:
                      type: boolean
                    volumeDevices:
                      items:
                        properties:
                          devicePath:
                            type: string
                          name:
                            type: string
                        required:
                        - devicePath
                        - name
                        type: object
                      type: array
                    volumeMounts:
                      items:
                        properties:
                          mountPath:
                            type: string
                          mountPropagation:
                            type: string
                          name:
                            type: string
                          readOnly:
                            type: boolean
                          subPath:
                            type: string
                          subPathExpr:
                            type: string
                        required:
                        - mountPath
                        - name
                        type: object
                      type: array
                    workingDir:
                      type: string
                  required:
                  - name
                  type: object
                type: array
              disabled:
                type: boolean
              grpcDataEndpoint:
                type: string
              grpcEndpoint:
                type: string
              httpDataEndpoint:
                type: string
              imagePullSecrets:
                items:
                  properties:
                    name:
                      type: string
                  type: object
                type: array
              labels:
                additionalProperties:
                  type: string
                type: object
              multiModel:
                type: boolean
              nodeSelector:
                additionalProperties:
                  type: string
                type: object
              protocolVersions:
                items:
                  type: string
                type: array
              replicas:
                type: integer
              storageHelper:
                properties:
                  disabled:
                    type: boolean
                type: object
              supportedModelFormats:
                items:
                  properties:
                    autoSelect:
                      type: boolean
                    name:
                      type: string
                    version:
                      type: string
                  required:
                  - name
                  type: object
                type: array
              tolerations:
                items:
                  properties:
                    effect:
                      type: string
                    key:
                      type: string
                    operator:
                      type: string
                    tolerationSeconds:
                      format: int64
                      type: integer
                    value:
                      type: string
                  type: object
                type: array
              volumes:
                items:
                  properties:
                    awsElasticBlockStore:
                      properties:
                        fsType:
                          type: string
                        partition:
                          format: int32
                          type: integer
                        readOnly:
                          type: boolean
                        volumeID:
                          type: string
                      required:
                      - volumeID
                      type: object
                    azureDisk:
                      properties:
                        cachingMode:
                          type: string
                        diskName:
                          type: string
                        diskURI:
                          type: string
                        fsType:
                          type: string
                        kind:
                          type: string
                        readOnly:
                          type: boolean
                      required:
                      - diskName
                      - diskURI
                      type: object
                    azureFile:
                      properties:
                        readOnly:
                          type: boolean
                        secretName:
                          type: string
                        shareName:
                          type: string
                      required:
                      - secretName
                      - shareName
                      type: object
                    cephfs:
                      properties:
                        monitors:
                          items:
                            type: string
                          type: array
                        path:
                          type: string
                        readOnly:
                          type: boolean
                        secretFile:
                          type: string
                        secretRef:
                          properties:
                            name:
                              type: string
                          type: object
                        user:
                          type: string
                      required:
                      - monitors
                      type: object
                    cinder:
                      properties:
                        fsType:
                          type: string
                        readOnly:
                          type: boolean
                        secretRef:
                          properties:
                            name:
                              type: string
                          type: object
                        volumeID:
                          type: string
                      required:
                      - volumeID
                      type: object
                    configMap:
                      properties:
                        defaultMode:
                          format: int32
                          type: integer
                        items:
                          items:
                            properties:
                              key:
                                type: string
                              mode:
                                format: int32
                                type: integer
                              path:
                                type: string
                            required:
                            - key
                            - path
                            type: object
                          type: array
                        name:
                          type: string
                        optional:
                          type: boolean
                      type: object
                    csi:
                      properties:
                        driver:
                          type: string
                        fsType:
                          type: string
                        nodePublishSecretRef:
                          properties:
                            name:
                              type: string
                          type: object
                        readOnly:
                          type: boolean
                        volumeAttributes:
                          additionalProperties:
                            type: string
                          type: object
                      required:
                      - driver
                      type: object
                    downwardAPI:
                      properties:
                        defaultMode:
                          format: int32
                          type: integer
                        items:
                          items:
                            properties:
                              fieldRef:
                                properties:
                                  apiVersion:
                                    type: string
                                  fieldPath:
                                    type: string
                                required:
                                - fieldPath
                                type: object
                              mode:
                                format: int32
                                type: integer
                              path:
                                type: string
                              resourceFieldRef:
                                properties:
                                  containerName:
                                    type: string
                                  divisor:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                    x-kubernetes-int-or-string: true
                                  resource:
                                    type: string
                                required:
                                - resource
                                type: object
                            required:
                            - path
                            type: object
                          type: array
                      type: object
                    emptyDir:
                      properties:
                        medium:
                          type: string
                        sizeLimit:
                          anyOf:
                          - type: integer
                          - type: string
                          pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                          x-kubernetes-int-or-string: true
                      type: object
                    ephemeral:
                      properties:
                        volumeClaimTemplate:
                          properties:
                            metadata:
                              type: object
                            spec:
                              properties:
                                accessModes:
                                  items:
                                    type: string
                                  type: array
                                dataSource:
                                  properties:
                                    apiGroup:
                                      type: string
                                    kind:
                                      type: string
                                    name:
                                      type: string
                                  required:
                                  - kind
                                  - name
                                  type: object
                                dataSourceRef:
                                  properties:
                                    apiGroup:
                                      type: string
                                    kind:
                                      type: string
                                    name:
                                      type: string
                                  required:
                                  - kind
                                  - name
                                  type: object
                                resources:
                                  properties:
                                    limits:
                                      additionalProperties:
                                        anyOf:
                                        - type: integer
                                        - type: string
                                        pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                        x-kubernetes-int-or-string: true
                                      type: object
                                    requests:
                                      additionalProperties:
                                        anyOf:
                                        - type: integer
                                        - type: string
                                        pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                        x-kubernetes-int-or-string: true
                                      type: object
                                  type: object
                                selector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                storageClassName:
                                  type: string
                                volumeMode:
                                  type: string
                                volumeName:
                                  type: string
                              type: object
                          required:
                          - spec
                          type: object
                      type: object
                    fc:
                      properties:
                        fsType:
                          type: string
                        lun:
                          format: int32
                          type: integer
                        readOnly:
                          type: boolean
                        targetWWNs:
                          items:
                            type: string
                          type: array
                        wwids:
                          items:
                            type: string
                          type: array
                      type: object
                    flexVolume:
                      properties:
                        driver:
                          type: string
                        fsType:
                          type: string
                        options:
                          additionalProperties:
                            type: string
                          type: object
                        readOnly:
                          type: boolean
                        secretRef:
                          properties:
                            name:
                              type: string
                          type: object
                      required:
                      - driver
                      type: object
                    flocker:
                      properties:
                        datasetName:
                          type: string
                        datasetUUID:
                          type: string
                      type: object
                    gcePersistentDisk:
                      properties:
                        fsType:
                          type: string
                        partition:
                          format: int32
                          type: integer
                        pdName:
                          type: string
                        readOnly:
                          type: boolean
                      required:
                      - pdName
                      type: object
                    gitRepo:
                      properties:
                        directory:
                          type: string
                        repository:
                          type: string
                        revision:
                          type: string
                      required:
                      - repository
                      type: object
                    glusterfs:
                      properties:
                        endpoints:
                          type: string
                        path:
                          type: string
                        readOnly:
                          type: boolean
                      required:
                      - endpoints
                      - path
                      type: object
                    hostPath:
                      properties:
                        path:
                          type: string
                        type:
                          type: string
                      required:
                      - path
                      type: object
                    iscsi:
                      properties:
                        chapAuthDiscovery:
                          type: boolean
                        chapAuthSession:
                          type: boolean
                        fsType:
                          type: string
                        initiatorName:
                          type: string
                        iqn:
                          type: string
                        iscsiInterface:
                          type: string
                        lun:
                          format: int32
                          type: integer
                        portals:
                          items:
                            type: string
                          type: array
                        readOnly:
                          type: boolean
                        secretRef:
                          properties:
                            name:
                              type: string
                          type: object
                        targetPortal:
                          type: string
                      required:
                      - iqn
                      - lun
                      - targetPortal
                      type: object
                    name:
                      type: string
                    nfs:
                      properties:
                        path:
                          type: string
                        readOnly:
                          type: boolean
                        server:
                          type: string
                      required:
                      - path
                      - server
                      type: object
                    persistentVolumeClaim:
                      properties:
                        claimName:
                          type: string
                        readOnly:
                          type: boolean
                      required:
                      - claimName
                      type: object
                    photonPersistentDisk:
                      properties:
                        fsType:
                          type: string
                        pdID:
                          type: string
                      required:
                      - pdID
                      type: object
                    portworxVolume:
                      properties:
                        fsType:
                          type: string
                        readOnly:
                          type: boolean
                        volumeID:
                          type: string
                      required:
                      - volumeID
                      type: object
                    projected:
                      properties:
                        defaultMode:
                          format: int32
                          type: integer
                        sources:
                          items:
                            properties:
                              configMap:
                                properties:
                                  items:
                                    items:
                                      properties:
                                        key:
                                          type: string
                                        mode:
                                          format: int32
                                          type: integer
                                        path:
                                          type: string
                                      required:
                                      - key
                                      - path
                                      type: object
                                    type: array
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                                type: object
                              downwardAPI:
                                properties:
                                  items:
                                    items:
                                      properties:
                                        fieldRef:
                                          properties:
                                            apiVersion:
                                              type: string
                                            fieldPath:
                                              type: string
                                          required:
                                          - fieldPath
                                          type: object
                                        mode:
                                          format: int32
                                          type: integer
                                        path:
                                          type: string
                                        resourceFieldRef:
                                          properties:
                                            containerName:
                                              type: string
                                            divisor:
                                              anyOf:
                                              - type: integer
                                              - type: string
                                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                              x-kubernetes-int-or-string: true
                                            resource:
                                              type: string
                                          required:
                                          - resource
                                          type: object
                                      required:
                                      - path
                                      type: object
                                    type: array
                                type: object
                              secret:
                                properties:
                                  items:
                                    items:
                                      properties:
                                        key:
                                          type: string
                                        mode:
                                          format: int32
                                          type: integer
                                        path:
                                          type: string
                                      required:
                                      - key
                                      - path
                                      type: object
                                    type: array
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                                type: object
                              serviceAccountToken:
                                properties:
                                  audience:
                                    type: string
                                  expirationSeconds:
                                    format: int64
                                    type: integer
                                  path:
                                    type: string
                                required:
                                - path
                                type: object
                            type: object
                          type: array
                      type: object
                    quobyte:
                      properties:
                        group:
                          type: string
                        readOnly:
                          type: boolean
                        registry:
                          type: string
                        tenant:
                          type: string
                        user:
                          type: string
                        volume:
                          type: string
                      required:
                      - registry
                      - volume
                      type: object
                    rbd:
                      properties:
                        fsType:
                          type: string
                        image:
                          type: string
                        keyring:
                          type: string
                        monitors:
                          items:
                            type: string
                          type: array
                        pool:
                          type: string
                        readOnly:
                          type: boolean
                        secretRef:
                          properties:
                            name:
                              type: string
                          type: object
                        user:
                          type: string
                      required:
                      - image
                      - monitors
                      type: object
                    scaleIO:
                      properties:
                        fsType:
                          type: string
                        gateway:
                          type: string
                        protectionDomain:
                          type: string
                        readOnly:
                          type: boolean
                        secretRef:
                          properties:
                            name:
                              type: string
                          type: object
                        sslEnabled:
                          type: boolean
                        storageMode:
                          type: string
                        storagePool:
                          type: string
                        system:
                          type: string
                        volumeName:
                          type: string
                      required:
                      - gateway
                      - secretRef
                      - system
                      type: object
                    secret:
                      properties:
                        defaultMode:
                          format: int32
                          type: integer
                        items:
                          items:
                            properties:
                              key:
                                type: string
                              mode:
                                format: int32
                                type: integer
                              path:
                                type: string
                            required:
                            - key
                            - path
                            type: object
                          type: array
                        optional:
                          type: boolean
                        secretName:
                          type: string
                      type: object
                    storageos:
                      properties:
                        fsType:
                          type: string
                        readOnly:
                          type: boolean
                        secretRef:
                          properties:
                            name:
                              type: string
                          type: object
                        volumeName:
                          type: string
                        volumeNamespace:
                          type: string
                      type: object
                    vsphereVolume:
                      properties:
                        fsType:
                          type: string
                        storagePolicyID:
                          type: string
                        storagePolicyName:
                          type: string
                        volumePath:
                          type: string
                      required:
                      - volumePath
                      type: object
                  required:
                  - name
                  type: object
                type: array
            required:
            - containers
            type: object
          status:
            type: object
        type: object
    served: true
    storage: true
    subresources: {}
status:
  acceptedNames:
    kind: ""
    plural: ""
  conditions: []
  storedVersions: []
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kserve-crd-inferencegraphs" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    controller-gen.kubebuilder.io/version: v0.4.0
  creationTimestamp: null
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: inferencegraphs.serving.kserve.io
spec:
  group: serving.kserve.io
  names:
    kind: InferenceGraph
    listKind: InferenceGraphList
    plural: inferencegraphs
    shortNames:
    - ig
    singular: inferencegraph
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - jsonPath: .status.url
      name: URL
      type: string
    - jsonPath: .status.conditions[?(@.type=='Ready')].status
      name: Ready
      type: string
    - jsonPath: .metadata.creationTimestamp
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
            properties:
              nodes:
                additionalProperties:
                  properties:
                    routerType:
                      enum:
                      - Sequence
                      - Splitter
                      - Ensemble
                      - Switch
                      type: string
                    steps:
                      items:
                        properties:
                          condition:
                            type: string
                          data:
                            type: string
                          name:
                            type: string
                          nodeName:
                            type: string
                          serviceName:
                            type: string
                          serviceUrl:
                            type: string
                          weight:
                            format: int64
                            type: integer
                        type: object
                      type: array
                  required:
                  - routerType
                  type: object
                type: object
            required:
            - nodes
            type: object
          status:
            properties:
              annotations:
                additionalProperties:
                  type: string
                type: object
              conditions:
                items:
                  properties:
                    lastTransitionTime:
                      type: string
                    message:
                      type: string
                    reason:
                      type: string
                    severity:
                      type: string
                    status:
                      type: string
                    type:
                      type: string
                  required:
                  - status
                  - type
                  type: object
                type: array
              observedGeneration:
                format: int64
                type: integer
              url:
                type: string
            type: object
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

resource "kubectl_manifest" "kubeflow-kserve-crd-inferenceservices" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    cert-manager.io/inject-ca-from: kubeflow/serving-cert
    controller-gen.kubebuilder.io/version: v0.4.0
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: inferenceservices.serving.kserve.io
spec:
  conversion:
    strategy: Webhook
    webhook:
      clientConfig:
        caBundle: Cg==
        service:
          name: kserve-webhook-server-service
          namespace: kubeflow
          path: /convert
      conversionReviewVersions:
      - v1beta1
  group: serving.kserve.io
  names:
    kind: InferenceService
    listKind: InferenceServiceList
    plural: inferenceservices
    shortNames:
    - isvc
    singular: inferenceservice
  preserveUnknownFields: false
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - jsonPath: .status.url
      name: URL
      type: string
    - jsonPath: .status.conditions[?(@.type=='Ready')].status
      name: Ready
      type: string
    - jsonPath: .status.components.predictor.traffic[?(@.tag=='prev')].percent
      name: Prev
      type: integer
    - jsonPath: .status.components.predictor.traffic[?(@.latestRevision==true)].percent
      name: Latest
      type: integer
    - jsonPath: .status.components.predictor.traffic[?(@.tag=='prev')].revisionName
      name: PrevRolledoutRevision
      type: string
    - jsonPath: .status.components.predictor.traffic[?(@.latestRevision==true)].revisionName
      name: LatestReadyRevision
      type: string
    - jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1beta1
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
            properties:
              explainer:
                properties:
                  activeDeadlineSeconds:
                    format: int64
                    type: integer
                  affinity:
                    properties:
                      nodeAffinity:
                        properties:
                          preferredDuringSchedulingIgnoredDuringExecution:
                            items:
                              properties:
                                preference:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
                                            items:
                                              type: string
                                            type: array
                                        required:
                                        - key
                                        - operator
                                        type: object
                                      type: array
                                    matchFields:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
                                            items:
                                              type: string
                                            type: array
                                        required:
                                        - key
                                        - operator
                                        type: object
                                      type: array
                                  type: object
                                weight:
                                  format: int32
                                  type: integer
                              required:
                              - preference
                              - weight
                              type: object
                            type: array
                          requiredDuringSchedulingIgnoredDuringExecution:
                            properties:
                              nodeSelectorTerms:
                                items:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
                                            items:
                                              type: string
                                            type: array
                                        required:
                                        - key
                                        - operator
                                        type: object
                                      type: array
                                    matchFields:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
                                            items:
                                              type: string
                                            type: array
                                        required:
                                        - key
                                        - operator
                                        type: object
                                      type: array
                                  type: object
                                type: array
                            required:
                            - nodeSelectorTerms
                            type: object
                        type: object
                      podAffinity:
                        properties:
                          preferredDuringSchedulingIgnoredDuringExecution:
                            items:
                              properties:
                                podAffinityTerm:
                                  properties:
                                    labelSelector:
                                      properties:
                                        matchExpressions:
                                          items:
                                            properties:
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                              values:
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
                                          type: object
                                      type: object
                                    namespaceSelector:
                                      properties:
                                        matchExpressions:
                                          items:
                                            properties:
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                              values:
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
                                          type: object
                                      type: object
                                    namespaces:
                                      items:
                                        type: string
                                      type: array
                                    topologyKey:
                                      type: string
                                  required:
                                  - topologyKey
                                  type: object
                                weight:
                                  format: int32
                                  type: integer
                              required:
                              - podAffinityTerm
                              - weight
                              type: object
                            type: array
                          requiredDuringSchedulingIgnoredDuringExecution:
                            items:
                              properties:
                                labelSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaceSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaces:
                                  items:
                                    type: string
                                  type: array
                                topologyKey:
                                  type: string
                              required:
                              - topologyKey
                              type: object
                            type: array
                        type: object
                      podAntiAffinity:
                        properties:
                          preferredDuringSchedulingIgnoredDuringExecution:
                            items:
                              properties:
                                podAffinityTerm:
                                  properties:
                                    labelSelector:
                                      properties:
                                        matchExpressions:
                                          items:
                                            properties:
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                              values:
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
                                          type: object
                                      type: object
                                    namespaceSelector:
                                      properties:
                                        matchExpressions:
                                          items:
                                            properties:
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                              values:
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
                                          type: object
                                      type: object
                                    namespaces:
                                      items:
                                        type: string
                                      type: array
                                    topologyKey:
                                      type: string
                                  required:
                                  - topologyKey
                                  type: object
                                weight:
                                  format: int32
                                  type: integer
                              required:
                              - podAffinityTerm
                              - weight
                              type: object
                            type: array
                          requiredDuringSchedulingIgnoredDuringExecution:
                            items:
                              properties:
                                labelSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaceSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaces:
                                  items:
                                    type: string
                                  type: array
                                topologyKey:
                                  type: string
                              required:
                              - topologyKey
                              type: object
                            type: array
                        type: object
                    type: object
                  aix:
                    properties:
                      args:
                        items:
                          type: string
                        type: array
                      command:
                        items:
                          type: string
                        type: array
                      config:
                        additionalProperties:
                          type: string
                        type: object
                      env:
                        items:
                          properties:
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
                                fieldRef:
                                  properties:
                                    apiVersion:
                                      type: string
                                    fieldPath:
                                      type: string
                                  required:
                                  - fieldPath
                                  type: object
                                resourceFieldRef:
                                  properties:
                                    containerName:
                                      type: string
                                    divisor:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                      x-kubernetes-int-or-string: true
                                    resource:
                                      type: string
                                  required:
                                  - resource
                                  type: object
                                secretKeyRef:
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
                          required:
                          - name
                          type: object
                        type: array
                      envFrom:
                        items:
                          properties:
                            configMapRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                            prefix:
                              type: string
                            secretRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                          type: object
                        type: array
                      image:
                        type: string
                      imagePullPolicy:
                        type: string
                      lifecycle:
                        properties:
                          postStart:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                          preStop:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                        type: object
                      livenessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      name:
                        type: string
                      ports:
                        items:
                          properties:
                            containerPort:
                              format: int32
                              type: integer
                            hostIP:
                              type: string
                            hostPort:
                              format: int32
                              type: integer
                            name:
                              type: string
                            protocol:
                              default: TCP
                              type: string
                          required:
                          - containerPort
                          type: object
                        type: array
                        x-kubernetes-list-map-keys:
                        - containerPort
                        - protocol
                        x-kubernetes-list-type: map
                      readinessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      resources:
                        properties:
                          limits:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                          requests:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                        type: object
                      runtimeVersion:
                        type: string
                      securityContext:
                        properties:
                          allowPrivilegeEscalation:
                            type: boolean
                          capabilities:
                            properties:
                              add:
                                items:
                                  type: string
                                type: array
                              drop:
                                items:
                                  type: string
                                type: array
                            type: object
                          privileged:
                            type: boolean
                          procMount:
                            type: string
                          readOnlyRootFilesystem:
                            type: boolean
                          runAsGroup:
                            format: int64
                            type: integer
                          runAsNonRoot:
                            type: boolean
                          runAsUser:
                            format: int64
                            type: integer
                          seLinuxOptions:
                            properties:
                              level:
                                type: string
                              role:
                                type: string
                              type:
                                type: string
                              user:
                                type: string
                            type: object
                          seccompProfile:
                            properties:
                              localhostProfile:
                                type: string
                              type:
                                type: string
                            required:
                            - type
                            type: object
                          windowsOptions:
                            properties:
                              gmsaCredentialSpec:
                                type: string
                              gmsaCredentialSpecName:
                                type: string
                              hostProcess:
                                type: boolean
                              runAsUserName:
                                type: string
                            type: object
                        type: object
                      startupProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            required:
                            - port
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            required:
                            - port
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      stdin:
                        type: boolean
                      stdinOnce:
                        type: boolean
                      storage:
                        properties:
                          key:
                            type: string
                          parameters:
                            additionalProperties:
                              type: string
                            type: object
                          path:
                            type: string
                          schemaPath:
                            type: string
                        type: object
                      storageUri:
                        type: string
                      terminationMessagePath:
                        type: string
                      terminationMessagePolicy:
                        type: string
                      tty:
                        type: boolean
                      type:
                        type: string
                      volumeDevices:
                        items:
                          properties:
                            devicePath:
                              type: string
                            name:
                              type: string
                          required:
                          - devicePath
                          - name
                          type: object
                        type: array
                      volumeMounts:
                        items:
                          properties:
                            mountPath:
                              type: string
                            mountPropagation:
                              type: string
                            name:
                              type: string
                            readOnly:
                              type: boolean
                            subPath:
                              type: string
                            subPathExpr:
                              type: string
                          required:
                          - mountPath
                          - name
                          type: object
                        type: array
                      workingDir:
                        type: string
                    type: object
                  alibi:
                    properties:
                      args:
                        items:
                          type: string
                        type: array
                      command:
                        items:
                          type: string
                        type: array
                      config:
                        additionalProperties:
                          type: string
                        type: object
                      env:
                        items:
                          properties:
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
                                fieldRef:
                                  properties:
                                    apiVersion:
                                      type: string
                                    fieldPath:
                                      type: string
                                  required:
                                  - fieldPath
                                  type: object
                                resourceFieldRef:
                                  properties:
                                    containerName:
                                      type: string
                                    divisor:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                      x-kubernetes-int-or-string: true
                                    resource:
                                      type: string
                                  required:
                                  - resource
                                  type: object
                                secretKeyRef:
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
                          required:
                          - name
                          type: object
                        type: array
                      envFrom:
                        items:
                          properties:
                            configMapRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                            prefix:
                              type: string
                            secretRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                          type: object
                        type: array
                      image:
                        type: string
                      imagePullPolicy:
                        type: string
                      lifecycle:
                        properties:
                          postStart:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                          preStop:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                        type: object
                      livenessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      name:
                        type: string
                      ports:
                        items:
                          properties:
                            containerPort:
                              format: int32
                              type: integer
                            hostIP:
                              type: string
                            hostPort:
                              format: int32
                              type: integer
                            name:
                              type: string
                            protocol:
                              default: TCP
                              type: string
                          required:
                          - containerPort
                          type: object
                        type: array
                        x-kubernetes-list-map-keys:
                        - containerPort
                        - protocol
                        x-kubernetes-list-type: map
                      readinessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      resources:
                        properties:
                          limits:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                          requests:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                        type: object
                      runtimeVersion:
                        type: string
                      securityContext:
                        properties:
                          allowPrivilegeEscalation:
                            type: boolean
                          capabilities:
                            properties:
                              add:
                                items:
                                  type: string
                                type: array
                              drop:
                                items:
                                  type: string
                                type: array
                            type: object
                          privileged:
                            type: boolean
                          procMount:
                            type: string
                          readOnlyRootFilesystem:
                            type: boolean
                          runAsGroup:
                            format: int64
                            type: integer
                          runAsNonRoot:
                            type: boolean
                          runAsUser:
                            format: int64
                            type: integer
                          seLinuxOptions:
                            properties:
                              level:
                                type: string
                              role:
                                type: string
                              type:
                                type: string
                              user:
                                type: string
                            type: object
                          seccompProfile:
                            properties:
                              localhostProfile:
                                type: string
                              type:
                                type: string
                            required:
                            - type
                            type: object
                          windowsOptions:
                            properties:
                              gmsaCredentialSpec:
                                type: string
                              gmsaCredentialSpecName:
                                type: string
                              hostProcess:
                                type: boolean
                              runAsUserName:
                                type: string
                            type: object
                        type: object
                      startupProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            required:
                            - port
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            required:
                            - port
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      stdin:
                        type: boolean
                      stdinOnce:
                        type: boolean
                      storage:
                        properties:
                          key:
                            type: string
                          parameters:
                            additionalProperties:
                              type: string
                            type: object
                          path:
                            type: string
                          schemaPath:
                            type: string
                        type: object
                      storageUri:
                        type: string
                      terminationMessagePath:
                        type: string
                      terminationMessagePolicy:
                        type: string
                      tty:
                        type: boolean
                      type:
                        type: string
                      volumeDevices:
                        items:
                          properties:
                            devicePath:
                              type: string
                            name:
                              type: string
                          required:
                          - devicePath
                          - name
                          type: object
                        type: array
                      volumeMounts:
                        items:
                          properties:
                            mountPath:
                              type: string
                            mountPropagation:
                              type: string
                            name:
                              type: string
                            readOnly:
                              type: boolean
                            subPath:
                              type: string
                            subPathExpr:
                              type: string
                          required:
                          - mountPath
                          - name
                          type: object
                        type: array
                      workingDir:
                        type: string
                    type: object
                  art:
                    properties:
                      args:
                        items:
                          type: string
                        type: array
                      command:
                        items:
                          type: string
                        type: array
                      config:
                        additionalProperties:
                          type: string
                        type: object
                      env:
                        items:
                          properties:
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
                                fieldRef:
                                  properties:
                                    apiVersion:
                                      type: string
                                    fieldPath:
                                      type: string
                                  required:
                                  - fieldPath
                                  type: object
                                resourceFieldRef:
                                  properties:
                                    containerName:
                                      type: string
                                    divisor:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                      x-kubernetes-int-or-string: true
                                    resource:
                                      type: string
                                  required:
                                  - resource
                                  type: object
                                secretKeyRef:
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
                          required:
                          - name
                          type: object
                        type: array
                      envFrom:
                        items:
                          properties:
                            configMapRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                            prefix:
                              type: string
                            secretRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                          type: object
                        type: array
                      image:
                        type: string
                      imagePullPolicy:
                        type: string
                      lifecycle:
                        properties:
                          postStart:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                          preStop:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                        type: object
                      livenessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      name:
                        type: string
                      ports:
                        items:
                          properties:
                            containerPort:
                              format: int32
                              type: integer
                            hostIP:
                              type: string
                            hostPort:
                              format: int32
                              type: integer
                            name:
                              type: string
                            protocol:
                              default: TCP
                              type: string
                          required:
                          - containerPort
                          type: object
                        type: array
                        x-kubernetes-list-map-keys:
                        - containerPort
                        - protocol
                        x-kubernetes-list-type: map
                      readinessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      resources:
                        properties:
                          limits:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                          requests:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                        type: object
                      runtimeVersion:
                        type: string
                      securityContext:
                        properties:
                          allowPrivilegeEscalation:
                            type: boolean
                          capabilities:
                            properties:
                              add:
                                items:
                                  type: string
                                type: array
                              drop:
                                items:
                                  type: string
                                type: array
                            type: object
                          privileged:
                            type: boolean
                          procMount:
                            type: string
                          readOnlyRootFilesystem:
                            type: boolean
                          runAsGroup:
                            format: int64
                            type: integer
                          runAsNonRoot:
                            type: boolean
                          runAsUser:
                            format: int64
                            type: integer
                          seLinuxOptions:
                            properties:
                              level:
                                type: string
                              role:
                                type: string
                              type:
                                type: string
                              user:
                                type: string
                            type: object
                          seccompProfile:
                            properties:
                              localhostProfile:
                                type: string
                              type:
                                type: string
                            required:
                            - type
                            type: object
                          windowsOptions:
                            properties:
                              gmsaCredentialSpec:
                                type: string
                              gmsaCredentialSpecName:
                                type: string
                              hostProcess:
                                type: boolean
                              runAsUserName:
                                type: string
                            type: object
                        type: object
                      startupProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            required:
                            - port
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            required:
                            - port
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      stdin:
                        type: boolean
                      stdinOnce:
                        type: boolean
                      storage:
                        properties:
                          key:
                            type: string
                          parameters:
                            additionalProperties:
                              type: string
                            type: object
                          path:
                            type: string
                          schemaPath:
                            type: string
                        type: object
                      storageUri:
                        type: string
                      terminationMessagePath:
                        type: string
                      terminationMessagePolicy:
                        type: string
                      tty:
                        type: boolean
                      type:
                        type: string
                      volumeDevices:
                        items:
                          properties:
                            devicePath:
                              type: string
                            name:
                              type: string
                          required:
                          - devicePath
                          - name
                          type: object
                        type: array
                      volumeMounts:
                        items:
                          properties:
                            mountPath:
                              type: string
                            mountPropagation:
                              type: string
                            name:
                              type: string
                            readOnly:
                              type: boolean
                            subPath:
                              type: string
                            subPathExpr:
                              type: string
                          required:
                          - mountPath
                          - name
                          type: object
                        type: array
                      workingDir:
                        type: string
                    type: object
                  automountServiceAccountToken:
                    type: boolean
                  batcher:
                    properties:
                      maxBatchSize:
                        type: integer
                      maxLatency:
                        type: integer
                      timeout:
                        type: integer
                    type: object
                  canaryTrafficPercent:
                    format: int64
                    type: integer
                  containerConcurrency:
                    format: int64
                    type: integer
                  containers:
                    items:
                      properties:
                        args:
                          items:
                            type: string
                          type: array
                        command:
                          items:
                            type: string
                          type: array
                        env:
                          items:
                            properties:
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
                                  fieldRef:
                                    properties:
                                      apiVersion:
                                        type: string
                                      fieldPath:
                                        type: string
                                    required:
                                    - fieldPath
                                    type: object
                                  resourceFieldRef:
                                    properties:
                                      containerName:
                                        type: string
                                      divisor:
                                        anyOf:
                                        - type: integer
                                        - type: string
                                        pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                        x-kubernetes-int-or-string: true
                                      resource:
                                        type: string
                                    required:
                                    - resource
                                    type: object
                                  secretKeyRef:
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
                            required:
                            - name
                            type: object
                          type: array
                        envFrom:
                          items:
                            properties:
                              configMapRef:
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                                type: object
                              prefix:
                                type: string
                              secretRef:
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                                type: object
                            type: object
                          type: array
                        image:
                          type: string
                        imagePullPolicy:
                          type: string
                        lifecycle:
                          properties:
                            postStart:
                              properties:
                                exec:
                                  properties:
                                    command:
                                      items:
                                        type: string
                                      type: array
                                  type: object
                                httpGet:
                                  properties:
                                    host:
                                      type: string
                                    httpHeaders:
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
                                    path:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                    scheme:
                                      type: string
                                  required:
                                  - port
                                  type: object
                                tcpSocket:
                                  properties:
                                    host:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                  required:
                                  - port
                                  type: object
                              type: object
                            preStop:
                              properties:
                                exec:
                                  properties:
                                    command:
                                      items:
                                        type: string
                                      type: array
                                  type: object
                                httpGet:
                                  properties:
                                    host:
                                      type: string
                                    httpHeaders:
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
                                    path:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                    scheme:
                                      type: string
                                  required:
                                  - port
                                  type: object
                                tcpSocket:
                                  properties:
                                    host:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                  required:
                                  - port
                                  type: object
                              type: object
                          type: object
                        livenessProbe:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            failureThreshold:
                              format: int32
                              type: integer
                            grpc:
                              properties:
                                port:
                                  format: int32
                                  type: integer
                                service:
                                  type: string
                              required:
                              - port
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              type: object
                            initialDelaySeconds:
                              format: int32
                              type: integer
                            periodSeconds:
                              format: int32
                              type: integer
                            successThreshold:
                              format: int32
                              type: integer
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                            terminationGracePeriodSeconds:
                              format: int64
                              type: integer
                            timeoutSeconds:
                              format: int32
                              type: integer
                          type: object
                        name:
                          type: string
                        ports:
                          items:
                            properties:
                              containerPort:
                                format: int32
                                type: integer
                              hostIP:
                                type: string
                              hostPort:
                                format: int32
                                type: integer
                              name:
                                type: string
                              protocol:
                                default: TCP
                                type: string
                            required:
                            - containerPort
                            type: object
                          type: array
                          x-kubernetes-list-map-keys:
                          - containerPort
                          - protocol
                          x-kubernetes-list-type: map
                        readinessProbe:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            failureThreshold:
                              format: int32
                              type: integer
                            grpc:
                              properties:
                                port:
                                  format: int32
                                  type: integer
                                service:
                                  type: string
                              required:
                              - port
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              type: object
                            initialDelaySeconds:
                              format: int32
                              type: integer
                            periodSeconds:
                              format: int32
                              type: integer
                            successThreshold:
                              format: int32
                              type: integer
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                            terminationGracePeriodSeconds:
                              format: int64
                              type: integer
                            timeoutSeconds:
                              format: int32
                              type: integer
                          type: object
                        resources:
                          properties:
                            limits:
                              additionalProperties:
                                anyOf:
                                - type: integer
                                - type: string
                                pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                x-kubernetes-int-or-string: true
                              type: object
                            requests:
                              additionalProperties:
                                anyOf:
                                - type: integer
                                - type: string
                                pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                x-kubernetes-int-or-string: true
                              type: object
                          type: object
                        securityContext:
                          properties:
                            allowPrivilegeEscalation:
                              type: boolean
                            capabilities:
                              properties:
                                add:
                                  items:
                                    type: string
                                  type: array
                                drop:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            privileged:
                              type: boolean
                            procMount:
                              type: string
                            readOnlyRootFilesystem:
                              type: boolean
                            runAsGroup:
                              format: int64
                              type: integer
                            runAsNonRoot:
                              type: boolean
                            runAsUser:
                              format: int64
                              type: integer
                            seLinuxOptions:
                              properties:
                                level:
                                  type: string
                                role:
                                  type: string
                                type:
                                  type: string
                                user:
                                  type: string
                              type: object
                            seccompProfile:
                              properties:
                                localhostProfile:
                                  type: string
                                type:
                                  type: string
                              required:
                              - type
                              type: object
                            windowsOptions:
                              properties:
                                gmsaCredentialSpec:
                                  type: string
                                gmsaCredentialSpecName:
                                  type: string
                                hostProcess:
                                  type: boolean
                                runAsUserName:
                                  type: string
                              type: object
                          type: object
                        startupProbe:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            failureThreshold:
                              format: int32
                              type: integer
                            grpc:
                              properties:
                                port:
                                  format: int32
                                  type: integer
                                service:
                                  type: string
                              required:
                              - port
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              required:
                              - port
                              type: object
                            initialDelaySeconds:
                              format: int32
                              type: integer
                            periodSeconds:
                              format: int32
                              type: integer
                            successThreshold:
                              format: int32
                              type: integer
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                            terminationGracePeriodSeconds:
                              format: int64
                              type: integer
                            timeoutSeconds:
                              format: int32
                              type: integer
                          type: object
                        stdin:
                          type: boolean
                        stdinOnce:
                          type: boolean
                        terminationMessagePath:
                          type: string
                        terminationMessagePolicy:
                          type: string
                        tty:
                          type: boolean
                        volumeDevices:
                          items:
                            properties:
                              devicePath:
                                type: string
                              name:
                                type: string
                            required:
                            - devicePath
                            - name
                            type: object
                          type: array
                        volumeMounts:
                          items:
                            properties:
                              mountPath:
                                type: string
                              mountPropagation:
                                type: string
                              name:
                                type: string
                              readOnly:
                                type: boolean
                              subPath:
                                type: string
                              subPathExpr:
                                type: string
                            required:
                            - mountPath
                            - name
                            type: object
                          type: array
                        workingDir:
                          type: string
                      required:
                      - name
                      type: object
                    type: array
                  dnsConfig:
                    properties:
                      nameservers:
                        items:
                          type: string
                        type: array
                      options:
                        items:
                          properties:
                            name:
                              type: string
                            value:
                              type: string
                          type: object
                        type: array
                      searches:
                        items:
                          type: string
                        type: array
                    type: object
                  dnsPolicy:
                    type: string
                  enableServiceLinks:
                    type: boolean
                  hostAliases:
                    items:
                      properties:
                        hostnames:
                          items:
                            type: string
                          type: array
                        ip:
                          type: string
                      type: object
                    type: array
                  hostIPC:
                    type: boolean
                  hostNetwork:
                    type: boolean
                  hostPID:
                    type: boolean
                  hostname:
                    type: string
                  imagePullSecrets:
                    items:
                      properties:
                        name:
                          type: string
                      type: object
                    type: array
                  initContainers:
                    items:
                      properties:
                        args:
                          items:
                            type: string
                          type: array
                        command:
                          items:
                            type: string
                          type: array
                        env:
                          items:
                            properties:
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
                                  fieldRef:
                                    properties:
                                      apiVersion:
                                        type: string
                                      fieldPath:
                                        type: string
                                    required:
                                    - fieldPath
                                    type: object
                                  resourceFieldRef:
                                    properties:
                                      containerName:
                                        type: string
                                      divisor:
                                        anyOf:
                                        - type: integer
                                        - type: string
                                        pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                        x-kubernetes-int-or-string: true
                                      resource:
                                        type: string
                                    required:
                                    - resource
                                    type: object
                                  secretKeyRef:
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
                            required:
                            - name
                            type: object
                          type: array
                        envFrom:
                          items:
                            properties:
                              configMapRef:
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                                type: object
                              prefix:
                                type: string
                              secretRef:
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                                type: object
                            type: object
                          type: array
                        image:
                          type: string
                        imagePullPolicy:
                          type: string
                        lifecycle:
                          properties:
                            postStart:
                              properties:
                                exec:
                                  properties:
                                    command:
                                      items:
                                        type: string
                                      type: array
                                  type: object
                                httpGet:
                                  properties:
                                    host:
                                      type: string
                                    httpHeaders:
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
                                    path:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                    scheme:
                                      type: string
                                  required:
                                  - port
                                  type: object
                                tcpSocket:
                                  properties:
                                    host:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                  required:
                                  - port
                                  type: object
                              type: object
                            preStop:
                              properties:
                                exec:
                                  properties:
                                    command:
                                      items:
                                        type: string
                                      type: array
                                  type: object
                                httpGet:
                                  properties:
                                    host:
                                      type: string
                                    httpHeaders:
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
                                    path:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                    scheme:
                                      type: string
                                  required:
                                  - port
                                  type: object
                                tcpSocket:
                                  properties:
                                    host:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                  required:
                                  - port
                                  type: object
                              type: object
                          type: object
                        livenessProbe:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            failureThreshold:
                              format: int32
                              type: integer
                            grpc:
                              properties:
                                port:
                                  format: int32
                                  type: integer
                                service:
                                  type: string
                              required:
                              - port
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              required:
                              - port
                              type: object
                            initialDelaySeconds:
                              format: int32
                              type: integer
                            periodSeconds:
                              format: int32
                              type: integer
                            successThreshold:
                              format: int32
                              type: integer
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                            terminationGracePeriodSeconds:
                              format: int64
                              type: integer
                            timeoutSeconds:
                              format: int32
                              type: integer
                          type: object
                        name:
                          type: string
                        ports:
                          items:
                            properties:
                              containerPort:
                                format: int32
                                type: integer
                              hostIP:
                                type: string
                              hostPort:
                                format: int32
                                type: integer
                              name:
                                type: string
                              protocol:
                                default: TCP
                                type: string
                            required:
                            - containerPort
                            type: object
                          type: array
                          x-kubernetes-list-map-keys:
                          - containerPort
                          - protocol
                          x-kubernetes-list-type: map
                        readinessProbe:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            failureThreshold:
                              format: int32
                              type: integer
                            grpc:
                              properties:
                                port:
                                  format: int32
                                  type: integer
                                service:
                                  type: string
                              required:
                              - port
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              required:
                              - port
                              type: object
                            initialDelaySeconds:
                              format: int32
                              type: integer
                            periodSeconds:
                              format: int32
                              type: integer
                            successThreshold:
                              format: int32
                              type: integer
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                            terminationGracePeriodSeconds:
                              format: int64
                              type: integer
                            timeoutSeconds:
                              format: int32
                              type: integer
                          type: object
                        resources:
                          properties:
                            limits:
                              additionalProperties:
                                anyOf:
                                - type: integer
                                - type: string
                                pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                x-kubernetes-int-or-string: true
                              type: object
                            requests:
                              additionalProperties:
                                anyOf:
                                - type: integer
                                - type: string
                                pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                x-kubernetes-int-or-string: true
                              type: object
                          type: object
                        securityContext:
                          properties:
                            allowPrivilegeEscalation:
                              type: boolean
                            capabilities:
                              properties:
                                add:
                                  items:
                                    type: string
                                  type: array
                                drop:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            privileged:
                              type: boolean
                            procMount:
                              type: string
                            readOnlyRootFilesystem:
                              type: boolean
                            runAsGroup:
                              format: int64
                              type: integer
                            runAsNonRoot:
                              type: boolean
                            runAsUser:
                              format: int64
                              type: integer
                            seLinuxOptions:
                              properties:
                                level:
                                  type: string
                                role:
                                  type: string
                                type:
                                  type: string
                                user:
                                  type: string
                              type: object
                            seccompProfile:
                              properties:
                                localhostProfile:
                                  type: string
                                type:
                                  type: string
                              required:
                              - type
                              type: object
                            windowsOptions:
                              properties:
                                gmsaCredentialSpec:
                                  type: string
                                gmsaCredentialSpecName:
                                  type: string
                                hostProcess:
                                  type: boolean
                                runAsUserName:
                                  type: string
                              type: object
                          type: object
                        startupProbe:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            failureThreshold:
                              format: int32
                              type: integer
                            grpc:
                              properties:
                                port:
                                  format: int32
                                  type: integer
                                service:
                                  type: string
                              required:
                              - port
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              required:
                              - port
                              type: object
                            initialDelaySeconds:
                              format: int32
                              type: integer
                            periodSeconds:
                              format: int32
                              type: integer
                            successThreshold:
                              format: int32
                              type: integer
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                            terminationGracePeriodSeconds:
                              format: int64
                              type: integer
                            timeoutSeconds:
                              format: int32
                              type: integer
                          type: object
                        stdin:
                          type: boolean
                        stdinOnce:
                          type: boolean
                        terminationMessagePath:
                          type: string
                        terminationMessagePolicy:
                          type: string
                        tty:
                          type: boolean
                        volumeDevices:
                          items:
                            properties:
                              devicePath:
                                type: string
                              name:
                                type: string
                            required:
                            - devicePath
                            - name
                            type: object
                          type: array
                        volumeMounts:
                          items:
                            properties:
                              mountPath:
                                type: string
                              mountPropagation:
                                type: string
                              name:
                                type: string
                              readOnly:
                                type: boolean
                              subPath:
                                type: string
                              subPathExpr:
                                type: string
                            required:
                            - mountPath
                            - name
                            type: object
                          type: array
                        workingDir:
                          type: string
                      required:
                      - name
                      type: object
                    type: array
                  logger:
                    properties:
                      mode:
                        enum:
                        - all
                        - request
                        - response
                        type: string
                      url:
                        type: string
                    type: object
                  maxReplicas:
                    type: integer
                  minReplicas:
                    type: integer
                  nodeName:
                    type: string
                  nodeSelector:
                    additionalProperties:
                      type: string
                    type: object
                    x-kubernetes-map-type: atomic
                  os:
                    properties:
                      name:
                        type: string
                    type: object
                  overhead:
                    additionalProperties:
                      anyOf:
                      - type: integer
                      - type: string
                      pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                      x-kubernetes-int-or-string: true
                    type: object
                  preemptionPolicy:
                    type: string
                  priority:
                    format: int32
                    type: integer
                  priorityClassName:
                    type: string
                  readinessGates:
                    items:
                      properties:
                        conditionType:
                          type: string
                      required:
                      - conditionType
                      type: object
                    type: array
                  restartPolicy:
                    type: string
                  runtimeClassName:
                    type: string
                  scaleMetric:
                    enum:
                    - cpu
                    - memory
                    - concurrency
                    - rps
                    type: string
                  scaleTarget:
                    type: integer
                  schedulerName:
                    type: string
                  securityContext:
                    properties:
                      fsGroup:
                        format: int64
                        type: integer
                      fsGroupChangePolicy:
                        type: string
                      runAsGroup:
                        format: int64
                        type: integer
                      runAsNonRoot:
                        type: boolean
                      runAsUser:
                        format: int64
                        type: integer
                      seLinuxOptions:
                        properties:
                          level:
                            type: string
                          role:
                            type: string
                          type:
                            type: string
                          user:
                            type: string
                        type: object
                      seccompProfile:
                        properties:
                          localhostProfile:
                            type: string
                          type:
                            type: string
                        required:
                        - type
                        type: object
                      supplementalGroups:
                        items:
                          format: int64
                          type: integer
                        type: array
                      sysctls:
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
                      windowsOptions:
                        properties:
                          gmsaCredentialSpec:
                            type: string
                          gmsaCredentialSpecName:
                            type: string
                          hostProcess:
                            type: boolean
                          runAsUserName:
                            type: string
                        type: object
                    type: object
                  serviceAccount:
                    type: string
                  serviceAccountName:
                    type: string
                  setHostnameAsFQDN:
                    type: boolean
                  shareProcessNamespace:
                    type: boolean
                  subdomain:
                    type: string
                  terminationGracePeriodSeconds:
                    format: int64
                    type: integer
                  timeout:
                    format: int64
                    type: integer
                  tolerations:
                    items:
                      properties:
                        effect:
                          type: string
                        key:
                          type: string
                        operator:
                          type: string
                        tolerationSeconds:
                          format: int64
                          type: integer
                        value:
                          type: string
                      type: object
                    type: array
                  topologySpreadConstraints:
                    items:
                      properties:
                        labelSelector:
                          properties:
                            matchExpressions:
                              items:
                                properties:
                                  key:
                                    type: string
                                  operator:
                                    type: string
                                  values:
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
                              type: object
                          type: object
                        maxSkew:
                          format: int32
                          type: integer
                        topologyKey:
                          type: string
                        whenUnsatisfiable:
                          type: string
                      required:
                      - maxSkew
                      - topologyKey
                      - whenUnsatisfiable
                      type: object
                    type: array
                    x-kubernetes-list-map-keys:
                    - topologyKey
                    - whenUnsatisfiable
                    x-kubernetes-list-type: map
                  volumes:
                    items:
                      properties:
                        awsElasticBlockStore:
                          properties:
                            fsType:
                              type: string
                            partition:
                              format: int32
                              type: integer
                            readOnly:
                              type: boolean
                            volumeID:
                              type: string
                          required:
                          - volumeID
                          type: object
                        azureDisk:
                          properties:
                            cachingMode:
                              type: string
                            diskName:
                              type: string
                            diskURI:
                              type: string
                            fsType:
                              type: string
                            kind:
                              type: string
                            readOnly:
                              type: boolean
                          required:
                          - diskName
                          - diskURI
                          type: object
                        azureFile:
                          properties:
                            readOnly:
                              type: boolean
                            secretName:
                              type: string
                            shareName:
                              type: string
                          required:
                          - secretName
                          - shareName
                          type: object
                        cephfs:
                          properties:
                            monitors:
                              items:
                                type: string
                              type: array
                            path:
                              type: string
                            readOnly:
                              type: boolean
                            secretFile:
                              type: string
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            user:
                              type: string
                          required:
                          - monitors
                          type: object
                        cinder:
                          properties:
                            fsType:
                              type: string
                            readOnly:
                              type: boolean
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            volumeID:
                              type: string
                          required:
                          - volumeID
                          type: object
                        configMap:
                          properties:
                            defaultMode:
                              format: int32
                              type: integer
                            items:
                              items:
                                properties:
                                  key:
                                    type: string
                                  mode:
                                    format: int32
                                    type: integer
                                  path:
                                    type: string
                                required:
                                - key
                                - path
                                type: object
                              type: array
                            name:
                              type: string
                            optional:
                              type: boolean
                          type: object
                        csi:
                          properties:
                            driver:
                              type: string
                            fsType:
                              type: string
                            nodePublishSecretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            readOnly:
                              type: boolean
                            volumeAttributes:
                              additionalProperties:
                                type: string
                              type: object
                          required:
                          - driver
                          type: object
                        downwardAPI:
                          properties:
                            defaultMode:
                              format: int32
                              type: integer
                            items:
                              items:
                                properties:
                                  fieldRef:
                                    properties:
                                      apiVersion:
                                        type: string
                                      fieldPath:
                                        type: string
                                    required:
                                    - fieldPath
                                    type: object
                                  mode:
                                    format: int32
                                    type: integer
                                  path:
                                    type: string
                                  resourceFieldRef:
                                    properties:
                                      containerName:
                                        type: string
                                      divisor:
                                        anyOf:
                                        - type: integer
                                        - type: string
                                        pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                        x-kubernetes-int-or-string: true
                                      resource:
                                        type: string
                                    required:
                                    - resource
                                    type: object
                                required:
                                - path
                                type: object
                              type: array
                          type: object
                        emptyDir:
                          properties:
                            medium:
                              type: string
                            sizeLimit:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                          type: object
                        ephemeral:
                          properties:
                            volumeClaimTemplate:
                              properties:
                                metadata:
                                  type: object
                                spec:
                                  properties:
                                    accessModes:
                                      items:
                                        type: string
                                      type: array
                                    dataSource:
                                      properties:
                                        apiGroup:
                                          type: string
                                        kind:
                                          type: string
                                        name:
                                          type: string
                                      required:
                                      - kind
                                      - name
                                      type: object
                                    dataSourceRef:
                                      properties:
                                        apiGroup:
                                          type: string
                                        kind:
                                          type: string
                                        name:
                                          type: string
                                      required:
                                      - kind
                                      - name
                                      type: object
                                    resources:
                                      properties:
                                        limits:
                                          additionalProperties:
                                            anyOf:
                                            - type: integer
                                            - type: string
                                            pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                            x-kubernetes-int-or-string: true
                                          type: object
                                        requests:
                                          additionalProperties:
                                            anyOf:
                                            - type: integer
                                            - type: string
                                            pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                            x-kubernetes-int-or-string: true
                                          type: object
                                      type: object
                                    selector:
                                      properties:
                                        matchExpressions:
                                          items:
                                            properties:
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                              values:
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
                                          type: object
                                      type: object
                                    storageClassName:
                                      type: string
                                    volumeMode:
                                      type: string
                                    volumeName:
                                      type: string
                                  type: object
                              required:
                              - spec
                              type: object
                          type: object
                        fc:
                          properties:
                            fsType:
                              type: string
                            lun:
                              format: int32
                              type: integer
                            readOnly:
                              type: boolean
                            targetWWNs:
                              items:
                                type: string
                              type: array
                            wwids:
                              items:
                                type: string
                              type: array
                          type: object
                        flexVolume:
                          properties:
                            driver:
                              type: string
                            fsType:
                              type: string
                            options:
                              additionalProperties:
                                type: string
                              type: object
                            readOnly:
                              type: boolean
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                          required:
                          - driver
                          type: object
                        flocker:
                          properties:
                            datasetName:
                              type: string
                            datasetUUID:
                              type: string
                          type: object
                        gcePersistentDisk:
                          properties:
                            fsType:
                              type: string
                            partition:
                              format: int32
                              type: integer
                            pdName:
                              type: string
                            readOnly:
                              type: boolean
                          required:
                          - pdName
                          type: object
                        gitRepo:
                          properties:
                            directory:
                              type: string
                            repository:
                              type: string
                            revision:
                              type: string
                          required:
                          - repository
                          type: object
                        glusterfs:
                          properties:
                            endpoints:
                              type: string
                            path:
                              type: string
                            readOnly:
                              type: boolean
                          required:
                          - endpoints
                          - path
                          type: object
                        hostPath:
                          properties:
                            path:
                              type: string
                            type:
                              type: string
                          required:
                          - path
                          type: object
                        iscsi:
                          properties:
                            chapAuthDiscovery:
                              type: boolean
                            chapAuthSession:
                              type: boolean
                            fsType:
                              type: string
                            initiatorName:
                              type: string
                            iqn:
                              type: string
                            iscsiInterface:
                              type: string
                            lun:
                              format: int32
                              type: integer
                            portals:
                              items:
                                type: string
                              type: array
                            readOnly:
                              type: boolean
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            targetPortal:
                              type: string
                          required:
                          - iqn
                          - lun
                          - targetPortal
                          type: object
                        name:
                          type: string
                        nfs:
                          properties:
                            path:
                              type: string
                            readOnly:
                              type: boolean
                            server:
                              type: string
                          required:
                          - path
                          - server
                          type: object
                        persistentVolumeClaim:
                          properties:
                            claimName:
                              type: string
                            readOnly:
                              type: boolean
                          required:
                          - claimName
                          type: object
                        photonPersistentDisk:
                          properties:
                            fsType:
                              type: string
                            pdID:
                              type: string
                          required:
                          - pdID
                          type: object
                        portworxVolume:
                          properties:
                            fsType:
                              type: string
                            readOnly:
                              type: boolean
                            volumeID:
                              type: string
                          required:
                          - volumeID
                          type: object
                        projected:
                          properties:
                            defaultMode:
                              format: int32
                              type: integer
                            sources:
                              items:
                                properties:
                                  configMap:
                                    properties:
                                      items:
                                        items:
                                          properties:
                                            key:
                                              type: string
                                            mode:
                                              format: int32
                                              type: integer
                                            path:
                                              type: string
                                          required:
                                          - key
                                          - path
                                          type: object
                                        type: array
                                      name:
                                        type: string
                                      optional:
                                        type: boolean
                                    type: object
                                  downwardAPI:
                                    properties:
                                      items:
                                        items:
                                          properties:
                                            fieldRef:
                                              properties:
                                                apiVersion:
                                                  type: string
                                                fieldPath:
                                                  type: string
                                              required:
                                              - fieldPath
                                              type: object
                                            mode:
                                              format: int32
                                              type: integer
                                            path:
                                              type: string
                                            resourceFieldRef:
                                              properties:
                                                containerName:
                                                  type: string
                                                divisor:
                                                  anyOf:
                                                  - type: integer
                                                  - type: string
                                                  pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                                  x-kubernetes-int-or-string: true
                                                resource:
                                                  type: string
                                              required:
                                              - resource
                                              type: object
                                          required:
                                          - path
                                          type: object
                                        type: array
                                    type: object
                                  secret:
                                    properties:
                                      items:
                                        items:
                                          properties:
                                            key:
                                              type: string
                                            mode:
                                              format: int32
                                              type: integer
                                            path:
                                              type: string
                                          required:
                                          - key
                                          - path
                                          type: object
                                        type: array
                                      name:
                                        type: string
                                      optional:
                                        type: boolean
                                    type: object
                                  serviceAccountToken:
                                    properties:
                                      audience:
                                        type: string
                                      expirationSeconds:
                                        format: int64
                                        type: integer
                                      path:
                                        type: string
                                    required:
                                    - path
                                    type: object
                                type: object
                              type: array
                          type: object
                        quobyte:
                          properties:
                            group:
                              type: string
                            readOnly:
                              type: boolean
                            registry:
                              type: string
                            tenant:
                              type: string
                            user:
                              type: string
                            volume:
                              type: string
                          required:
                          - registry
                          - volume
                          type: object
                        rbd:
                          properties:
                            fsType:
                              type: string
                            image:
                              type: string
                            keyring:
                              type: string
                            monitors:
                              items:
                                type: string
                              type: array
                            pool:
                              type: string
                            readOnly:
                              type: boolean
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            user:
                              type: string
                          required:
                          - image
                          - monitors
                          type: object
                        scaleIO:
                          properties:
                            fsType:
                              type: string
                            gateway:
                              type: string
                            protectionDomain:
                              type: string
                            readOnly:
                              type: boolean
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            sslEnabled:
                              type: boolean
                            storageMode:
                              type: string
                            storagePool:
                              type: string
                            system:
                              type: string
                            volumeName:
                              type: string
                          required:
                          - gateway
                          - secretRef
                          - system
                          type: object
                        secret:
                          properties:
                            defaultMode:
                              format: int32
                              type: integer
                            items:
                              items:
                                properties:
                                  key:
                                    type: string
                                  mode:
                                    format: int32
                                    type: integer
                                  path:
                                    type: string
                                required:
                                - key
                                - path
                                type: object
                              type: array
                            optional:
                              type: boolean
                            secretName:
                              type: string
                          type: object
                        storageos:
                          properties:
                            fsType:
                              type: string
                            readOnly:
                              type: boolean
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            volumeName:
                              type: string
                            volumeNamespace:
                              type: string
                          type: object
                        vsphereVolume:
                          properties:
                            fsType:
                              type: string
                            storagePolicyID:
                              type: string
                            storagePolicyName:
                              type: string
                            volumePath:
                              type: string
                          required:
                          - volumePath
                          type: object
                      required:
                      - name
                      type: object
                    type: array
                type: object
              predictor:
                properties:
                  activeDeadlineSeconds:
                    format: int64
                    type: integer
                  affinity:
                    properties:
                      nodeAffinity:
                        properties:
                          preferredDuringSchedulingIgnoredDuringExecution:
                            items:
                              properties:
                                preference:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
                                            items:
                                              type: string
                                            type: array
                                        required:
                                        - key
                                        - operator
                                        type: object
                                      type: array
                                    matchFields:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
                                            items:
                                              type: string
                                            type: array
                                        required:
                                        - key
                                        - operator
                                        type: object
                                      type: array
                                  type: object
                                weight:
                                  format: int32
                                  type: integer
                              required:
                              - preference
                              - weight
                              type: object
                            type: array
                          requiredDuringSchedulingIgnoredDuringExecution:
                            properties:
                              nodeSelectorTerms:
                                items:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
                                            items:
                                              type: string
                                            type: array
                                        required:
                                        - key
                                        - operator
                                        type: object
                                      type: array
                                    matchFields:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
                                            items:
                                              type: string
                                            type: array
                                        required:
                                        - key
                                        - operator
                                        type: object
                                      type: array
                                  type: object
                                type: array
                            required:
                            - nodeSelectorTerms
                            type: object
                        type: object
                      podAffinity:
                        properties:
                          preferredDuringSchedulingIgnoredDuringExecution:
                            items:
                              properties:
                                podAffinityTerm:
                                  properties:
                                    labelSelector:
                                      properties:
                                        matchExpressions:
                                          items:
                                            properties:
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                              values:
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
                                          type: object
                                      type: object
                                    namespaceSelector:
                                      properties:
                                        matchExpressions:
                                          items:
                                            properties:
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                              values:
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
                                          type: object
                                      type: object
                                    namespaces:
                                      items:
                                        type: string
                                      type: array
                                    topologyKey:
                                      type: string
                                  required:
                                  - topologyKey
                                  type: object
                                weight:
                                  format: int32
                                  type: integer
                              required:
                              - podAffinityTerm
                              - weight
                              type: object
                            type: array
                          requiredDuringSchedulingIgnoredDuringExecution:
                            items:
                              properties:
                                labelSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaceSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaces:
                                  items:
                                    type: string
                                  type: array
                                topologyKey:
                                  type: string
                              required:
                              - topologyKey
                              type: object
                            type: array
                        type: object
                      podAntiAffinity:
                        properties:
                          preferredDuringSchedulingIgnoredDuringExecution:
                            items:
                              properties:
                                podAffinityTerm:
                                  properties:
                                    labelSelector:
                                      properties:
                                        matchExpressions:
                                          items:
                                            properties:
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                              values:
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
                                          type: object
                                      type: object
                                    namespaceSelector:
                                      properties:
                                        matchExpressions:
                                          items:
                                            properties:
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                              values:
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
                                          type: object
                                      type: object
                                    namespaces:
                                      items:
                                        type: string
                                      type: array
                                    topologyKey:
                                      type: string
                                  required:
                                  - topologyKey
                                  type: object
                                weight:
                                  format: int32
                                  type: integer
                              required:
                              - podAffinityTerm
                              - weight
                              type: object
                            type: array
                          requiredDuringSchedulingIgnoredDuringExecution:
                            items:
                              properties:
                                labelSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaceSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaces:
                                  items:
                                    type: string
                                  type: array
                                topologyKey:
                                  type: string
                              required:
                              - topologyKey
                              type: object
                            type: array
                        type: object
                    type: object
                  automountServiceAccountToken:
                    type: boolean
                  batcher:
                    properties:
                      maxBatchSize:
                        type: integer
                      maxLatency:
                        type: integer
                      timeout:
                        type: integer
                    type: object
                  canaryTrafficPercent:
                    format: int64
                    type: integer
                  containerConcurrency:
                    format: int64
                    type: integer
                  containers:
                    items:
                      properties:
                        args:
                          items:
                            type: string
                          type: array
                        command:
                          items:
                            type: string
                          type: array
                        env:
                          items:
                            properties:
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
                                  fieldRef:
                                    properties:
                                      apiVersion:
                                        type: string
                                      fieldPath:
                                        type: string
                                    required:
                                    - fieldPath
                                    type: object
                                  resourceFieldRef:
                                    properties:
                                      containerName:
                                        type: string
                                      divisor:
                                        anyOf:
                                        - type: integer
                                        - type: string
                                        pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                        x-kubernetes-int-or-string: true
                                      resource:
                                        type: string
                                    required:
                                    - resource
                                    type: object
                                  secretKeyRef:
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
                            required:
                            - name
                            type: object
                          type: array
                        envFrom:
                          items:
                            properties:
                              configMapRef:
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                                type: object
                              prefix:
                                type: string
                              secretRef:
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                                type: object
                            type: object
                          type: array
                        image:
                          type: string
                        imagePullPolicy:
                          type: string
                        lifecycle:
                          properties:
                            postStart:
                              properties:
                                exec:
                                  properties:
                                    command:
                                      items:
                                        type: string
                                      type: array
                                  type: object
                                httpGet:
                                  properties:
                                    host:
                                      type: string
                                    httpHeaders:
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
                                    path:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                    scheme:
                                      type: string
                                  required:
                                  - port
                                  type: object
                                tcpSocket:
                                  properties:
                                    host:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                  required:
                                  - port
                                  type: object
                              type: object
                            preStop:
                              properties:
                                exec:
                                  properties:
                                    command:
                                      items:
                                        type: string
                                      type: array
                                  type: object
                                httpGet:
                                  properties:
                                    host:
                                      type: string
                                    httpHeaders:
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
                                    path:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                    scheme:
                                      type: string
                                  required:
                                  - port
                                  type: object
                                tcpSocket:
                                  properties:
                                    host:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                  required:
                                  - port
                                  type: object
                              type: object
                          type: object
                        livenessProbe:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            failureThreshold:
                              format: int32
                              type: integer
                            grpc:
                              properties:
                                port:
                                  format: int32
                                  type: integer
                                service:
                                  type: string
                              required:
                              - port
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              type: object
                            initialDelaySeconds:
                              format: int32
                              type: integer
                            periodSeconds:
                              format: int32
                              type: integer
                            successThreshold:
                              format: int32
                              type: integer
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                            terminationGracePeriodSeconds:
                              format: int64
                              type: integer
                            timeoutSeconds:
                              format: int32
                              type: integer
                          type: object
                        name:
                          type: string
                        ports:
                          items:
                            properties:
                              containerPort:
                                format: int32
                                type: integer
                              hostIP:
                                type: string
                              hostPort:
                                format: int32
                                type: integer
                              name:
                                type: string
                              protocol:
                                default: TCP
                                type: string
                            required:
                            - containerPort
                            type: object
                          type: array
                          x-kubernetes-list-map-keys:
                          - containerPort
                          - protocol
                          x-kubernetes-list-type: map
                        readinessProbe:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            failureThreshold:
                              format: int32
                              type: integer
                            grpc:
                              properties:
                                port:
                                  format: int32
                                  type: integer
                                service:
                                  type: string
                              required:
                              - port
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              type: object
                            initialDelaySeconds:
                              format: int32
                              type: integer
                            periodSeconds:
                              format: int32
                              type: integer
                            successThreshold:
                              format: int32
                              type: integer
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                            terminationGracePeriodSeconds:
                              format: int64
                              type: integer
                            timeoutSeconds:
                              format: int32
                              type: integer
                          type: object
                        resources:
                          properties:
                            limits:
                              additionalProperties:
                                anyOf:
                                - type: integer
                                - type: string
                                pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                x-kubernetes-int-or-string: true
                              type: object
                            requests:
                              additionalProperties:
                                anyOf:
                                - type: integer
                                - type: string
                                pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                x-kubernetes-int-or-string: true
                              type: object
                          type: object
                        securityContext:
                          properties:
                            allowPrivilegeEscalation:
                              type: boolean
                            capabilities:
                              properties:
                                add:
                                  items:
                                    type: string
                                  type: array
                                drop:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            privileged:
                              type: boolean
                            procMount:
                              type: string
                            readOnlyRootFilesystem:
                              type: boolean
                            runAsGroup:
                              format: int64
                              type: integer
                            runAsNonRoot:
                              type: boolean
                            runAsUser:
                              format: int64
                              type: integer
                            seLinuxOptions:
                              properties:
                                level:
                                  type: string
                                role:
                                  type: string
                                type:
                                  type: string
                                user:
                                  type: string
                              type: object
                            seccompProfile:
                              properties:
                                localhostProfile:
                                  type: string
                                type:
                                  type: string
                              required:
                              - type
                              type: object
                            windowsOptions:
                              properties:
                                gmsaCredentialSpec:
                                  type: string
                                gmsaCredentialSpecName:
                                  type: string
                                hostProcess:
                                  type: boolean
                                runAsUserName:
                                  type: string
                              type: object
                          type: object
                        startupProbe:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            failureThreshold:
                              format: int32
                              type: integer
                            grpc:
                              properties:
                                port:
                                  format: int32
                                  type: integer
                                service:
                                  type: string
                              required:
                              - port
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              required:
                              - port
                              type: object
                            initialDelaySeconds:
                              format: int32
                              type: integer
                            periodSeconds:
                              format: int32
                              type: integer
                            successThreshold:
                              format: int32
                              type: integer
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                            terminationGracePeriodSeconds:
                              format: int64
                              type: integer
                            timeoutSeconds:
                              format: int32
                              type: integer
                          type: object
                        stdin:
                          type: boolean
                        stdinOnce:
                          type: boolean
                        terminationMessagePath:
                          type: string
                        terminationMessagePolicy:
                          type: string
                        tty:
                          type: boolean
                        volumeDevices:
                          items:
                            properties:
                              devicePath:
                                type: string
                              name:
                                type: string
                            required:
                            - devicePath
                            - name
                            type: object
                          type: array
                        volumeMounts:
                          items:
                            properties:
                              mountPath:
                                type: string
                              mountPropagation:
                                type: string
                              name:
                                type: string
                              readOnly:
                                type: boolean
                              subPath:
                                type: string
                              subPathExpr:
                                type: string
                            required:
                            - mountPath
                            - name
                            type: object
                          type: array
                        workingDir:
                          type: string
                      required:
                      - name
                      type: object
                    type: array
                  dnsConfig:
                    properties:
                      nameservers:
                        items:
                          type: string
                        type: array
                      options:
                        items:
                          properties:
                            name:
                              type: string
                            value:
                              type: string
                          type: object
                        type: array
                      searches:
                        items:
                          type: string
                        type: array
                    type: object
                  dnsPolicy:
                    type: string
                  enableServiceLinks:
                    type: boolean
                  hostAliases:
                    items:
                      properties:
                        hostnames:
                          items:
                            type: string
                          type: array
                        ip:
                          type: string
                      type: object
                    type: array
                  hostIPC:
                    type: boolean
                  hostNetwork:
                    type: boolean
                  hostPID:
                    type: boolean
                  hostname:
                    type: string
                  imagePullSecrets:
                    items:
                      properties:
                        name:
                          type: string
                      type: object
                    type: array
                  initContainers:
                    items:
                      properties:
                        args:
                          items:
                            type: string
                          type: array
                        command:
                          items:
                            type: string
                          type: array
                        env:
                          items:
                            properties:
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
                                  fieldRef:
                                    properties:
                                      apiVersion:
                                        type: string
                                      fieldPath:
                                        type: string
                                    required:
                                    - fieldPath
                                    type: object
                                  resourceFieldRef:
                                    properties:
                                      containerName:
                                        type: string
                                      divisor:
                                        anyOf:
                                        - type: integer
                                        - type: string
                                        pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                        x-kubernetes-int-or-string: true
                                      resource:
                                        type: string
                                    required:
                                    - resource
                                    type: object
                                  secretKeyRef:
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
                            required:
                            - name
                            type: object
                          type: array
                        envFrom:
                          items:
                            properties:
                              configMapRef:
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                                type: object
                              prefix:
                                type: string
                              secretRef:
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                                type: object
                            type: object
                          type: array
                        image:
                          type: string
                        imagePullPolicy:
                          type: string
                        lifecycle:
                          properties:
                            postStart:
                              properties:
                                exec:
                                  properties:
                                    command:
                                      items:
                                        type: string
                                      type: array
                                  type: object
                                httpGet:
                                  properties:
                                    host:
                                      type: string
                                    httpHeaders:
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
                                    path:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                    scheme:
                                      type: string
                                  required:
                                  - port
                                  type: object
                                tcpSocket:
                                  properties:
                                    host:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                  required:
                                  - port
                                  type: object
                              type: object
                            preStop:
                              properties:
                                exec:
                                  properties:
                                    command:
                                      items:
                                        type: string
                                      type: array
                                  type: object
                                httpGet:
                                  properties:
                                    host:
                                      type: string
                                    httpHeaders:
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
                                    path:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                    scheme:
                                      type: string
                                  required:
                                  - port
                                  type: object
                                tcpSocket:
                                  properties:
                                    host:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                  required:
                                  - port
                                  type: object
                              type: object
                          type: object
                        livenessProbe:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            failureThreshold:
                              format: int32
                              type: integer
                            grpc:
                              properties:
                                port:
                                  format: int32
                                  type: integer
                                service:
                                  type: string
                              required:
                              - port
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              required:
                              - port
                              type: object
                            initialDelaySeconds:
                              format: int32
                              type: integer
                            periodSeconds:
                              format: int32
                              type: integer
                            successThreshold:
                              format: int32
                              type: integer
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                            terminationGracePeriodSeconds:
                              format: int64
                              type: integer
                            timeoutSeconds:
                              format: int32
                              type: integer
                          type: object
                        name:
                          type: string
                        ports:
                          items:
                            properties:
                              containerPort:
                                format: int32
                                type: integer
                              hostIP:
                                type: string
                              hostPort:
                                format: int32
                                type: integer
                              name:
                                type: string
                              protocol:
                                default: TCP
                                type: string
                            required:
                            - containerPort
                            type: object
                          type: array
                          x-kubernetes-list-map-keys:
                          - containerPort
                          - protocol
                          x-kubernetes-list-type: map
                        readinessProbe:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            failureThreshold:
                              format: int32
                              type: integer
                            grpc:
                              properties:
                                port:
                                  format: int32
                                  type: integer
                                service:
                                  type: string
                              required:
                              - port
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              required:
                              - port
                              type: object
                            initialDelaySeconds:
                              format: int32
                              type: integer
                            periodSeconds:
                              format: int32
                              type: integer
                            successThreshold:
                              format: int32
                              type: integer
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                            terminationGracePeriodSeconds:
                              format: int64
                              type: integer
                            timeoutSeconds:
                              format: int32
                              type: integer
                          type: object
                        resources:
                          properties:
                            limits:
                              additionalProperties:
                                anyOf:
                                - type: integer
                                - type: string
                                pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                x-kubernetes-int-or-string: true
                              type: object
                            requests:
                              additionalProperties:
                                anyOf:
                                - type: integer
                                - type: string
                                pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                x-kubernetes-int-or-string: true
                              type: object
                          type: object
                        securityContext:
                          properties:
                            allowPrivilegeEscalation:
                              type: boolean
                            capabilities:
                              properties:
                                add:
                                  items:
                                    type: string
                                  type: array
                                drop:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            privileged:
                              type: boolean
                            procMount:
                              type: string
                            readOnlyRootFilesystem:
                              type: boolean
                            runAsGroup:
                              format: int64
                              type: integer
                            runAsNonRoot:
                              type: boolean
                            runAsUser:
                              format: int64
                              type: integer
                            seLinuxOptions:
                              properties:
                                level:
                                  type: string
                                role:
                                  type: string
                                type:
                                  type: string
                                user:
                                  type: string
                              type: object
                            seccompProfile:
                              properties:
                                localhostProfile:
                                  type: string
                                type:
                                  type: string
                              required:
                              - type
                              type: object
                            windowsOptions:
                              properties:
                                gmsaCredentialSpec:
                                  type: string
                                gmsaCredentialSpecName:
                                  type: string
                                hostProcess:
                                  type: boolean
                                runAsUserName:
                                  type: string
                              type: object
                          type: object
                        startupProbe:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            failureThreshold:
                              format: int32
                              type: integer
                            grpc:
                              properties:
                                port:
                                  format: int32
                                  type: integer
                                service:
                                  type: string
                              required:
                              - port
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              required:
                              - port
                              type: object
                            initialDelaySeconds:
                              format: int32
                              type: integer
                            periodSeconds:
                              format: int32
                              type: integer
                            successThreshold:
                              format: int32
                              type: integer
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                            terminationGracePeriodSeconds:
                              format: int64
                              type: integer
                            timeoutSeconds:
                              format: int32
                              type: integer
                          type: object
                        stdin:
                          type: boolean
                        stdinOnce:
                          type: boolean
                        terminationMessagePath:
                          type: string
                        terminationMessagePolicy:
                          type: string
                        tty:
                          type: boolean
                        volumeDevices:
                          items:
                            properties:
                              devicePath:
                                type: string
                              name:
                                type: string
                            required:
                            - devicePath
                            - name
                            type: object
                          type: array
                        volumeMounts:
                          items:
                            properties:
                              mountPath:
                                type: string
                              mountPropagation:
                                type: string
                              name:
                                type: string
                              readOnly:
                                type: boolean
                              subPath:
                                type: string
                              subPathExpr:
                                type: string
                            required:
                            - mountPath
                            - name
                            type: object
                          type: array
                        workingDir:
                          type: string
                      required:
                      - name
                      type: object
                    type: array
                  lightgbm:
                    properties:
                      args:
                        items:
                          type: string
                        type: array
                      command:
                        items:
                          type: string
                        type: array
                      env:
                        items:
                          properties:
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
                                fieldRef:
                                  properties:
                                    apiVersion:
                                      type: string
                                    fieldPath:
                                      type: string
                                  required:
                                  - fieldPath
                                  type: object
                                resourceFieldRef:
                                  properties:
                                    containerName:
                                      type: string
                                    divisor:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                      x-kubernetes-int-or-string: true
                                    resource:
                                      type: string
                                  required:
                                  - resource
                                  type: object
                                secretKeyRef:
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
                          required:
                          - name
                          type: object
                        type: array
                      envFrom:
                        items:
                          properties:
                            configMapRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                            prefix:
                              type: string
                            secretRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                          type: object
                        type: array
                      image:
                        type: string
                      imagePullPolicy:
                        type: string
                      lifecycle:
                        properties:
                          postStart:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                          preStop:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                        type: object
                      livenessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      name:
                        type: string
                      ports:
                        items:
                          properties:
                            containerPort:
                              format: int32
                              type: integer
                            hostIP:
                              type: string
                            hostPort:
                              format: int32
                              type: integer
                            name:
                              type: string
                            protocol:
                              default: TCP
                              type: string
                          required:
                          - containerPort
                          type: object
                        type: array
                        x-kubernetes-list-map-keys:
                        - containerPort
                        - protocol
                        x-kubernetes-list-type: map
                      protocolVersion:
                        type: string
                      readinessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      resources:
                        properties:
                          limits:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                          requests:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                        type: object
                      runtimeVersion:
                        type: string
                      securityContext:
                        properties:
                          allowPrivilegeEscalation:
                            type: boolean
                          capabilities:
                            properties:
                              add:
                                items:
                                  type: string
                                type: array
                              drop:
                                items:
                                  type: string
                                type: array
                            type: object
                          privileged:
                            type: boolean
                          procMount:
                            type: string
                          readOnlyRootFilesystem:
                            type: boolean
                          runAsGroup:
                            format: int64
                            type: integer
                          runAsNonRoot:
                            type: boolean
                          runAsUser:
                            format: int64
                            type: integer
                          seLinuxOptions:
                            properties:
                              level:
                                type: string
                              role:
                                type: string
                              type:
                                type: string
                              user:
                                type: string
                            type: object
                          seccompProfile:
                            properties:
                              localhostProfile:
                                type: string
                              type:
                                type: string
                            required:
                            - type
                            type: object
                          windowsOptions:
                            properties:
                              gmsaCredentialSpec:
                                type: string
                              gmsaCredentialSpecName:
                                type: string
                              hostProcess:
                                type: boolean
                              runAsUserName:
                                type: string
                            type: object
                        type: object
                      startupProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            required:
                            - port
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            required:
                            - port
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      stdin:
                        type: boolean
                      stdinOnce:
                        type: boolean
                      storage:
                        properties:
                          key:
                            type: string
                          parameters:
                            additionalProperties:
                              type: string
                            type: object
                          path:
                            type: string
                          schemaPath:
                            type: string
                        type: object
                      storageUri:
                        type: string
                      terminationMessagePath:
                        type: string
                      terminationMessagePolicy:
                        type: string
                      tty:
                        type: boolean
                      volumeDevices:
                        items:
                          properties:
                            devicePath:
                              type: string
                            name:
                              type: string
                          required:
                          - devicePath
                          - name
                          type: object
                        type: array
                      volumeMounts:
                        items:
                          properties:
                            mountPath:
                              type: string
                            mountPropagation:
                              type: string
                            name:
                              type: string
                            readOnly:
                              type: boolean
                            subPath:
                              type: string
                            subPathExpr:
                              type: string
                          required:
                          - mountPath
                          - name
                          type: object
                        type: array
                      workingDir:
                        type: string
                    type: object
                  logger:
                    properties:
                      mode:
                        enum:
                        - all
                        - request
                        - response
                        type: string
                      url:
                        type: string
                    type: object
                  maxReplicas:
                    type: integer
                  minReplicas:
                    type: integer
                  model:
                    properties:
                      args:
                        items:
                          type: string
                        type: array
                      command:
                        items:
                          type: string
                        type: array
                      env:
                        items:
                          properties:
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
                                fieldRef:
                                  properties:
                                    apiVersion:
                                      type: string
                                    fieldPath:
                                      type: string
                                  required:
                                  - fieldPath
                                  type: object
                                resourceFieldRef:
                                  properties:
                                    containerName:
                                      type: string
                                    divisor:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                      x-kubernetes-int-or-string: true
                                    resource:
                                      type: string
                                  required:
                                  - resource
                                  type: object
                                secretKeyRef:
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
                          required:
                          - name
                          type: object
                        type: array
                      envFrom:
                        items:
                          properties:
                            configMapRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                            prefix:
                              type: string
                            secretRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                          type: object
                        type: array
                      image:
                        type: string
                      imagePullPolicy:
                        type: string
                      lifecycle:
                        properties:
                          postStart:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                          preStop:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                        type: object
                      livenessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      modelFormat:
                        properties:
                          name:
                            type: string
                          version:
                            type: string
                        required:
                        - name
                        type: object
                      name:
                        type: string
                      ports:
                        items:
                          properties:
                            containerPort:
                              format: int32
                              type: integer
                            hostIP:
                              type: string
                            hostPort:
                              format: int32
                              type: integer
                            name:
                              type: string
                            protocol:
                              default: TCP
                              type: string
                          required:
                          - containerPort
                          type: object
                        type: array
                        x-kubernetes-list-map-keys:
                        - containerPort
                        - protocol
                        x-kubernetes-list-type: map
                      protocolVersion:
                        type: string
                      readinessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      resources:
                        properties:
                          limits:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                          requests:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                        type: object
                      runtime:
                        type: string
                      runtimeVersion:
                        type: string
                      securityContext:
                        properties:
                          allowPrivilegeEscalation:
                            type: boolean
                          capabilities:
                            properties:
                              add:
                                items:
                                  type: string
                                type: array
                              drop:
                                items:
                                  type: string
                                type: array
                            type: object
                          privileged:
                            type: boolean
                          procMount:
                            type: string
                          readOnlyRootFilesystem:
                            type: boolean
                          runAsGroup:
                            format: int64
                            type: integer
                          runAsNonRoot:
                            type: boolean
                          runAsUser:
                            format: int64
                            type: integer
                          seLinuxOptions:
                            properties:
                              level:
                                type: string
                              role:
                                type: string
                              type:
                                type: string
                              user:
                                type: string
                            type: object
                          seccompProfile:
                            properties:
                              localhostProfile:
                                type: string
                              type:
                                type: string
                            required:
                            - type
                            type: object
                          windowsOptions:
                            properties:
                              gmsaCredentialSpec:
                                type: string
                              gmsaCredentialSpecName:
                                type: string
                              hostProcess:
                                type: boolean
                              runAsUserName:
                                type: string
                            type: object
                        type: object
                      startupProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            required:
                            - port
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            required:
                            - port
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      stdin:
                        type: boolean
                      stdinOnce:
                        type: boolean
                      storage:
                        properties:
                          key:
                            type: string
                          parameters:
                            additionalProperties:
                              type: string
                            type: object
                          path:
                            type: string
                          schemaPath:
                            type: string
                        type: object
                      storageUri:
                        type: string
                      terminationMessagePath:
                        type: string
                      terminationMessagePolicy:
                        type: string
                      tty:
                        type: boolean
                      volumeDevices:
                        items:
                          properties:
                            devicePath:
                              type: string
                            name:
                              type: string
                          required:
                          - devicePath
                          - name
                          type: object
                        type: array
                      volumeMounts:
                        items:
                          properties:
                            mountPath:
                              type: string
                            mountPropagation:
                              type: string
                            name:
                              type: string
                            readOnly:
                              type: boolean
                            subPath:
                              type: string
                            subPathExpr:
                              type: string
                          required:
                          - mountPath
                          - name
                          type: object
                        type: array
                      workingDir:
                        type: string
                    type: object
                  nodeName:
                    type: string
                  nodeSelector:
                    additionalProperties:
                      type: string
                    type: object
                    x-kubernetes-map-type: atomic
                  onnx:
                    properties:
                      args:
                        items:
                          type: string
                        type: array
                      command:
                        items:
                          type: string
                        type: array
                      env:
                        items:
                          properties:
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
                                fieldRef:
                                  properties:
                                    apiVersion:
                                      type: string
                                    fieldPath:
                                      type: string
                                  required:
                                  - fieldPath
                                  type: object
                                resourceFieldRef:
                                  properties:
                                    containerName:
                                      type: string
                                    divisor:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                      x-kubernetes-int-or-string: true
                                    resource:
                                      type: string
                                  required:
                                  - resource
                                  type: object
                                secretKeyRef:
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
                          required:
                          - name
                          type: object
                        type: array
                      envFrom:
                        items:
                          properties:
                            configMapRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                            prefix:
                              type: string
                            secretRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                          type: object
                        type: array
                      image:
                        type: string
                      imagePullPolicy:
                        type: string
                      lifecycle:
                        properties:
                          postStart:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                          preStop:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                        type: object
                      livenessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      name:
                        type: string
                      ports:
                        items:
                          properties:
                            containerPort:
                              format: int32
                              type: integer
                            hostIP:
                              type: string
                            hostPort:
                              format: int32
                              type: integer
                            name:
                              type: string
                            protocol:
                              default: TCP
                              type: string
                          required:
                          - containerPort
                          type: object
                        type: array
                        x-kubernetes-list-map-keys:
                        - containerPort
                        - protocol
                        x-kubernetes-list-type: map
                      protocolVersion:
                        type: string
                      readinessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      resources:
                        properties:
                          limits:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                          requests:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                        type: object
                      runtimeVersion:
                        type: string
                      securityContext:
                        properties:
                          allowPrivilegeEscalation:
                            type: boolean
                          capabilities:
                            properties:
                              add:
                                items:
                                  type: string
                                type: array
                              drop:
                                items:
                                  type: string
                                type: array
                            type: object
                          privileged:
                            type: boolean
                          procMount:
                            type: string
                          readOnlyRootFilesystem:
                            type: boolean
                          runAsGroup:
                            format: int64
                            type: integer
                          runAsNonRoot:
                            type: boolean
                          runAsUser:
                            format: int64
                            type: integer
                          seLinuxOptions:
                            properties:
                              level:
                                type: string
                              role:
                                type: string
                              type:
                                type: string
                              user:
                                type: string
                            type: object
                          seccompProfile:
                            properties:
                              localhostProfile:
                                type: string
                              type:
                                type: string
                            required:
                            - type
                            type: object
                          windowsOptions:
                            properties:
                              gmsaCredentialSpec:
                                type: string
                              gmsaCredentialSpecName:
                                type: string
                              hostProcess:
                                type: boolean
                              runAsUserName:
                                type: string
                            type: object
                        type: object
                      startupProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            required:
                            - port
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            required:
                            - port
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      stdin:
                        type: boolean
                      stdinOnce:
                        type: boolean
                      storage:
                        properties:
                          key:
                            type: string
                          parameters:
                            additionalProperties:
                              type: string
                            type: object
                          path:
                            type: string
                          schemaPath:
                            type: string
                        type: object
                      storageUri:
                        type: string
                      terminationMessagePath:
                        type: string
                      terminationMessagePolicy:
                        type: string
                      tty:
                        type: boolean
                      volumeDevices:
                        items:
                          properties:
                            devicePath:
                              type: string
                            name:
                              type: string
                          required:
                          - devicePath
                          - name
                          type: object
                        type: array
                      volumeMounts:
                        items:
                          properties:
                            mountPath:
                              type: string
                            mountPropagation:
                              type: string
                            name:
                              type: string
                            readOnly:
                              type: boolean
                            subPath:
                              type: string
                            subPathExpr:
                              type: string
                          required:
                          - mountPath
                          - name
                          type: object
                        type: array
                      workingDir:
                        type: string
                    type: object
                  os:
                    properties:
                      name:
                        type: string
                    type: object
                  overhead:
                    additionalProperties:
                      anyOf:
                      - type: integer
                      - type: string
                      pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                      x-kubernetes-int-or-string: true
                    type: object
                  paddle:
                    properties:
                      args:
                        items:
                          type: string
                        type: array
                      command:
                        items:
                          type: string
                        type: array
                      env:
                        items:
                          properties:
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
                                fieldRef:
                                  properties:
                                    apiVersion:
                                      type: string
                                    fieldPath:
                                      type: string
                                  required:
                                  - fieldPath
                                  type: object
                                resourceFieldRef:
                                  properties:
                                    containerName:
                                      type: string
                                    divisor:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                      x-kubernetes-int-or-string: true
                                    resource:
                                      type: string
                                  required:
                                  - resource
                                  type: object
                                secretKeyRef:
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
                          required:
                          - name
                          type: object
                        type: array
                      envFrom:
                        items:
                          properties:
                            configMapRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                            prefix:
                              type: string
                            secretRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                          type: object
                        type: array
                      image:
                        type: string
                      imagePullPolicy:
                        type: string
                      lifecycle:
                        properties:
                          postStart:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                          preStop:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                        type: object
                      livenessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      name:
                        type: string
                      ports:
                        items:
                          properties:
                            containerPort:
                              format: int32
                              type: integer
                            hostIP:
                              type: string
                            hostPort:
                              format: int32
                              type: integer
                            name:
                              type: string
                            protocol:
                              default: TCP
                              type: string
                          required:
                          - containerPort
                          type: object
                        type: array
                        x-kubernetes-list-map-keys:
                        - containerPort
                        - protocol
                        x-kubernetes-list-type: map
                      protocolVersion:
                        type: string
                      readinessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      resources:
                        properties:
                          limits:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                          requests:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                        type: object
                      runtimeVersion:
                        type: string
                      securityContext:
                        properties:
                          allowPrivilegeEscalation:
                            type: boolean
                          capabilities:
                            properties:
                              add:
                                items:
                                  type: string
                                type: array
                              drop:
                                items:
                                  type: string
                                type: array
                            type: object
                          privileged:
                            type: boolean
                          procMount:
                            type: string
                          readOnlyRootFilesystem:
                            type: boolean
                          runAsGroup:
                            format: int64
                            type: integer
                          runAsNonRoot:
                            type: boolean
                          runAsUser:
                            format: int64
                            type: integer
                          seLinuxOptions:
                            properties:
                              level:
                                type: string
                              role:
                                type: string
                              type:
                                type: string
                              user:
                                type: string
                            type: object
                          seccompProfile:
                            properties:
                              localhostProfile:
                                type: string
                              type:
                                type: string
                            required:
                            - type
                            type: object
                          windowsOptions:
                            properties:
                              gmsaCredentialSpec:
                                type: string
                              gmsaCredentialSpecName:
                                type: string
                              hostProcess:
                                type: boolean
                              runAsUserName:
                                type: string
                            type: object
                        type: object
                      startupProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            required:
                            - port
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            required:
                            - port
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      stdin:
                        type: boolean
                      stdinOnce:
                        type: boolean
                      storage:
                        properties:
                          key:
                            type: string
                          parameters:
                            additionalProperties:
                              type: string
                            type: object
                          path:
                            type: string
                          schemaPath:
                            type: string
                        type: object
                      storageUri:
                        type: string
                      terminationMessagePath:
                        type: string
                      terminationMessagePolicy:
                        type: string
                      tty:
                        type: boolean
                      volumeDevices:
                        items:
                          properties:
                            devicePath:
                              type: string
                            name:
                              type: string
                          required:
                          - devicePath
                          - name
                          type: object
                        type: array
                      volumeMounts:
                        items:
                          properties:
                            mountPath:
                              type: string
                            mountPropagation:
                              type: string
                            name:
                              type: string
                            readOnly:
                              type: boolean
                            subPath:
                              type: string
                            subPathExpr:
                              type: string
                          required:
                          - mountPath
                          - name
                          type: object
                        type: array
                      workingDir:
                        type: string
                    type: object
                  pmml:
                    properties:
                      args:
                        items:
                          type: string
                        type: array
                      command:
                        items:
                          type: string
                        type: array
                      env:
                        items:
                          properties:
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
                                fieldRef:
                                  properties:
                                    apiVersion:
                                      type: string
                                    fieldPath:
                                      type: string
                                  required:
                                  - fieldPath
                                  type: object
                                resourceFieldRef:
                                  properties:
                                    containerName:
                                      type: string
                                    divisor:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                      x-kubernetes-int-or-string: true
                                    resource:
                                      type: string
                                  required:
                                  - resource
                                  type: object
                                secretKeyRef:
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
                          required:
                          - name
                          type: object
                        type: array
                      envFrom:
                        items:
                          properties:
                            configMapRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                            prefix:
                              type: string
                            secretRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                          type: object
                        type: array
                      image:
                        type: string
                      imagePullPolicy:
                        type: string
                      lifecycle:
                        properties:
                          postStart:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                          preStop:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                        type: object
                      livenessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      name:
                        type: string
                      ports:
                        items:
                          properties:
                            containerPort:
                              format: int32
                              type: integer
                            hostIP:
                              type: string
                            hostPort:
                              format: int32
                              type: integer
                            name:
                              type: string
                            protocol:
                              default: TCP
                              type: string
                          required:
                          - containerPort
                          type: object
                        type: array
                        x-kubernetes-list-map-keys:
                        - containerPort
                        - protocol
                        x-kubernetes-list-type: map
                      protocolVersion:
                        type: string
                      readinessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      resources:
                        properties:
                          limits:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                          requests:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                        type: object
                      runtimeVersion:
                        type: string
                      securityContext:
                        properties:
                          allowPrivilegeEscalation:
                            type: boolean
                          capabilities:
                            properties:
                              add:
                                items:
                                  type: string
                                type: array
                              drop:
                                items:
                                  type: string
                                type: array
                            type: object
                          privileged:
                            type: boolean
                          procMount:
                            type: string
                          readOnlyRootFilesystem:
                            type: boolean
                          runAsGroup:
                            format: int64
                            type: integer
                          runAsNonRoot:
                            type: boolean
                          runAsUser:
                            format: int64
                            type: integer
                          seLinuxOptions:
                            properties:
                              level:
                                type: string
                              role:
                                type: string
                              type:
                                type: string
                              user:
                                type: string
                            type: object
                          seccompProfile:
                            properties:
                              localhostProfile:
                                type: string
                              type:
                                type: string
                            required:
                            - type
                            type: object
                          windowsOptions:
                            properties:
                              gmsaCredentialSpec:
                                type: string
                              gmsaCredentialSpecName:
                                type: string
                              hostProcess:
                                type: boolean
                              runAsUserName:
                                type: string
                            type: object
                        type: object
                      startupProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            required:
                            - port
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            required:
                            - port
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      stdin:
                        type: boolean
                      stdinOnce:
                        type: boolean
                      storage:
                        properties:
                          key:
                            type: string
                          parameters:
                            additionalProperties:
                              type: string
                            type: object
                          path:
                            type: string
                          schemaPath:
                            type: string
                        type: object
                      storageUri:
                        type: string
                      terminationMessagePath:
                        type: string
                      terminationMessagePolicy:
                        type: string
                      tty:
                        type: boolean
                      volumeDevices:
                        items:
                          properties:
                            devicePath:
                              type: string
                            name:
                              type: string
                          required:
                          - devicePath
                          - name
                          type: object
                        type: array
                      volumeMounts:
                        items:
                          properties:
                            mountPath:
                              type: string
                            mountPropagation:
                              type: string
                            name:
                              type: string
                            readOnly:
                              type: boolean
                            subPath:
                              type: string
                            subPathExpr:
                              type: string
                          required:
                          - mountPath
                          - name
                          type: object
                        type: array
                      workingDir:
                        type: string
                    type: object
                  preemptionPolicy:
                    type: string
                  priority:
                    format: int32
                    type: integer
                  priorityClassName:
                    type: string
                  pytorch:
                    properties:
                      args:
                        items:
                          type: string
                        type: array
                      command:
                        items:
                          type: string
                        type: array
                      env:
                        items:
                          properties:
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
                                fieldRef:
                                  properties:
                                    apiVersion:
                                      type: string
                                    fieldPath:
                                      type: string
                                  required:
                                  - fieldPath
                                  type: object
                                resourceFieldRef:
                                  properties:
                                    containerName:
                                      type: string
                                    divisor:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                      x-kubernetes-int-or-string: true
                                    resource:
                                      type: string
                                  required:
                                  - resource
                                  type: object
                                secretKeyRef:
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
                          required:
                          - name
                          type: object
                        type: array
                      envFrom:
                        items:
                          properties:
                            configMapRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                            prefix:
                              type: string
                            secretRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                          type: object
                        type: array
                      image:
                        type: string
                      imagePullPolicy:
                        type: string
                      lifecycle:
                        properties:
                          postStart:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                          preStop:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                        type: object
                      livenessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      name:
                        type: string
                      ports:
                        items:
                          properties:
                            containerPort:
                              format: int32
                              type: integer
                            hostIP:
                              type: string
                            hostPort:
                              format: int32
                              type: integer
                            name:
                              type: string
                            protocol:
                              default: TCP
                              type: string
                          required:
                          - containerPort
                          type: object
                        type: array
                        x-kubernetes-list-map-keys:
                        - containerPort
                        - protocol
                        x-kubernetes-list-type: map
                      protocolVersion:
                        type: string
                      readinessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      resources:
                        properties:
                          limits:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                          requests:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                        type: object
                      runtimeVersion:
                        type: string
                      securityContext:
                        properties:
                          allowPrivilegeEscalation:
                            type: boolean
                          capabilities:
                            properties:
                              add:
                                items:
                                  type: string
                                type: array
                              drop:
                                items:
                                  type: string
                                type: array
                            type: object
                          privileged:
                            type: boolean
                          procMount:
                            type: string
                          readOnlyRootFilesystem:
                            type: boolean
                          runAsGroup:
                            format: int64
                            type: integer
                          runAsNonRoot:
                            type: boolean
                          runAsUser:
                            format: int64
                            type: integer
                          seLinuxOptions:
                            properties:
                              level:
                                type: string
                              role:
                                type: string
                              type:
                                type: string
                              user:
                                type: string
                            type: object
                          seccompProfile:
                            properties:
                              localhostProfile:
                                type: string
                              type:
                                type: string
                            required:
                            - type
                            type: object
                          windowsOptions:
                            properties:
                              gmsaCredentialSpec:
                                type: string
                              gmsaCredentialSpecName:
                                type: string
                              hostProcess:
                                type: boolean
                              runAsUserName:
                                type: string
                            type: object
                        type: object
                      startupProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            required:
                            - port
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            required:
                            - port
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      stdin:
                        type: boolean
                      stdinOnce:
                        type: boolean
                      storage:
                        properties:
                          key:
                            type: string
                          parameters:
                            additionalProperties:
                              type: string
                            type: object
                          path:
                            type: string
                          schemaPath:
                            type: string
                        type: object
                      storageUri:
                        type: string
                      terminationMessagePath:
                        type: string
                      terminationMessagePolicy:
                        type: string
                      tty:
                        type: boolean
                      volumeDevices:
                        items:
                          properties:
                            devicePath:
                              type: string
                            name:
                              type: string
                          required:
                          - devicePath
                          - name
                          type: object
                        type: array
                      volumeMounts:
                        items:
                          properties:
                            mountPath:
                              type: string
                            mountPropagation:
                              type: string
                            name:
                              type: string
                            readOnly:
                              type: boolean
                            subPath:
                              type: string
                            subPathExpr:
                              type: string
                          required:
                          - mountPath
                          - name
                          type: object
                        type: array
                      workingDir:
                        type: string
                    type: object
                  readinessGates:
                    items:
                      properties:
                        conditionType:
                          type: string
                      required:
                      - conditionType
                      type: object
                    type: array
                  restartPolicy:
                    type: string
                  runtimeClassName:
                    type: string
                  scaleMetric:
                    enum:
                    - cpu
                    - memory
                    - concurrency
                    - rps
                    type: string
                  scaleTarget:
                    type: integer
                  schedulerName:
                    type: string
                  securityContext:
                    properties:
                      fsGroup:
                        format: int64
                        type: integer
                      fsGroupChangePolicy:
                        type: string
                      runAsGroup:
                        format: int64
                        type: integer
                      runAsNonRoot:
                        type: boolean
                      runAsUser:
                        format: int64
                        type: integer
                      seLinuxOptions:
                        properties:
                          level:
                            type: string
                          role:
                            type: string
                          type:
                            type: string
                          user:
                            type: string
                        type: object
                      seccompProfile:
                        properties:
                          localhostProfile:
                            type: string
                          type:
                            type: string
                        required:
                        - type
                        type: object
                      supplementalGroups:
                        items:
                          format: int64
                          type: integer
                        type: array
                      sysctls:
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
                      windowsOptions:
                        properties:
                          gmsaCredentialSpec:
                            type: string
                          gmsaCredentialSpecName:
                            type: string
                          hostProcess:
                            type: boolean
                          runAsUserName:
                            type: string
                        type: object
                    type: object
                  serviceAccount:
                    type: string
                  serviceAccountName:
                    type: string
                  setHostnameAsFQDN:
                    type: boolean
                  shareProcessNamespace:
                    type: boolean
                  sklearn:
                    properties:
                      args:
                        items:
                          type: string
                        type: array
                      command:
                        items:
                          type: string
                        type: array
                      env:
                        items:
                          properties:
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
                                fieldRef:
                                  properties:
                                    apiVersion:
                                      type: string
                                    fieldPath:
                                      type: string
                                  required:
                                  - fieldPath
                                  type: object
                                resourceFieldRef:
                                  properties:
                                    containerName:
                                      type: string
                                    divisor:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                      x-kubernetes-int-or-string: true
                                    resource:
                                      type: string
                                  required:
                                  - resource
                                  type: object
                                secretKeyRef:
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
                          required:
                          - name
                          type: object
                        type: array
                      envFrom:
                        items:
                          properties:
                            configMapRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                            prefix:
                              type: string
                            secretRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                          type: object
                        type: array
                      image:
                        type: string
                      imagePullPolicy:
                        type: string
                      lifecycle:
                        properties:
                          postStart:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                          preStop:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                        type: object
                      livenessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      name:
                        type: string
                      ports:
                        items:
                          properties:
                            containerPort:
                              format: int32
                              type: integer
                            hostIP:
                              type: string
                            hostPort:
                              format: int32
                              type: integer
                            name:
                              type: string
                            protocol:
                              default: TCP
                              type: string
                          required:
                          - containerPort
                          type: object
                        type: array
                        x-kubernetes-list-map-keys:
                        - containerPort
                        - protocol
                        x-kubernetes-list-type: map
                      protocolVersion:
                        type: string
                      readinessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      resources:
                        properties:
                          limits:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                          requests:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                        type: object
                      runtimeVersion:
                        type: string
                      securityContext:
                        properties:
                          allowPrivilegeEscalation:
                            type: boolean
                          capabilities:
                            properties:
                              add:
                                items:
                                  type: string
                                type: array
                              drop:
                                items:
                                  type: string
                                type: array
                            type: object
                          privileged:
                            type: boolean
                          procMount:
                            type: string
                          readOnlyRootFilesystem:
                            type: boolean
                          runAsGroup:
                            format: int64
                            type: integer
                          runAsNonRoot:
                            type: boolean
                          runAsUser:
                            format: int64
                            type: integer
                          seLinuxOptions:
                            properties:
                              level:
                                type: string
                              role:
                                type: string
                              type:
                                type: string
                              user:
                                type: string
                            type: object
                          seccompProfile:
                            properties:
                              localhostProfile:
                                type: string
                              type:
                                type: string
                            required:
                            - type
                            type: object
                          windowsOptions:
                            properties:
                              gmsaCredentialSpec:
                                type: string
                              gmsaCredentialSpecName:
                                type: string
                              hostProcess:
                                type: boolean
                              runAsUserName:
                                type: string
                            type: object
                        type: object
                      startupProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            required:
                            - port
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            required:
                            - port
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      stdin:
                        type: boolean
                      stdinOnce:
                        type: boolean
                      storage:
                        properties:
                          key:
                            type: string
                          parameters:
                            additionalProperties:
                              type: string
                            type: object
                          path:
                            type: string
                          schemaPath:
                            type: string
                        type: object
                      storageUri:
                        type: string
                      terminationMessagePath:
                        type: string
                      terminationMessagePolicy:
                        type: string
                      tty:
                        type: boolean
                      volumeDevices:
                        items:
                          properties:
                            devicePath:
                              type: string
                            name:
                              type: string
                          required:
                          - devicePath
                          - name
                          type: object
                        type: array
                      volumeMounts:
                        items:
                          properties:
                            mountPath:
                              type: string
                            mountPropagation:
                              type: string
                            name:
                              type: string
                            readOnly:
                              type: boolean
                            subPath:
                              type: string
                            subPathExpr:
                              type: string
                          required:
                          - mountPath
                          - name
                          type: object
                        type: array
                      workingDir:
                        type: string
                    type: object
                  subdomain:
                    type: string
                  tensorflow:
                    properties:
                      args:
                        items:
                          type: string
                        type: array
                      command:
                        items:
                          type: string
                        type: array
                      env:
                        items:
                          properties:
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
                                fieldRef:
                                  properties:
                                    apiVersion:
                                      type: string
                                    fieldPath:
                                      type: string
                                  required:
                                  - fieldPath
                                  type: object
                                resourceFieldRef:
                                  properties:
                                    containerName:
                                      type: string
                                    divisor:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                      x-kubernetes-int-or-string: true
                                    resource:
                                      type: string
                                  required:
                                  - resource
                                  type: object
                                secretKeyRef:
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
                          required:
                          - name
                          type: object
                        type: array
                      envFrom:
                        items:
                          properties:
                            configMapRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                            prefix:
                              type: string
                            secretRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                          type: object
                        type: array
                      image:
                        type: string
                      imagePullPolicy:
                        type: string
                      lifecycle:
                        properties:
                          postStart:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                          preStop:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                        type: object
                      livenessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      name:
                        type: string
                      ports:
                        items:
                          properties:
                            containerPort:
                              format: int32
                              type: integer
                            hostIP:
                              type: string
                            hostPort:
                              format: int32
                              type: integer
                            name:
                              type: string
                            protocol:
                              default: TCP
                              type: string
                          required:
                          - containerPort
                          type: object
                        type: array
                        x-kubernetes-list-map-keys:
                        - containerPort
                        - protocol
                        x-kubernetes-list-type: map
                      protocolVersion:
                        type: string
                      readinessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      resources:
                        properties:
                          limits:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                          requests:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                        type: object
                      runtimeVersion:
                        type: string
                      securityContext:
                        properties:
                          allowPrivilegeEscalation:
                            type: boolean
                          capabilities:
                            properties:
                              add:
                                items:
                                  type: string
                                type: array
                              drop:
                                items:
                                  type: string
                                type: array
                            type: object
                          privileged:
                            type: boolean
                          procMount:
                            type: string
                          readOnlyRootFilesystem:
                            type: boolean
                          runAsGroup:
                            format: int64
                            type: integer
                          runAsNonRoot:
                            type: boolean
                          runAsUser:
                            format: int64
                            type: integer
                          seLinuxOptions:
                            properties:
                              level:
                                type: string
                              role:
                                type: string
                              type:
                                type: string
                              user:
                                type: string
                            type: object
                          seccompProfile:
                            properties:
                              localhostProfile:
                                type: string
                              type:
                                type: string
                            required:
                            - type
                            type: object
                          windowsOptions:
                            properties:
                              gmsaCredentialSpec:
                                type: string
                              gmsaCredentialSpecName:
                                type: string
                              hostProcess:
                                type: boolean
                              runAsUserName:
                                type: string
                            type: object
                        type: object
                      startupProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            required:
                            - port
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            required:
                            - port
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      stdin:
                        type: boolean
                      stdinOnce:
                        type: boolean
                      storage:
                        properties:
                          key:
                            type: string
                          parameters:
                            additionalProperties:
                              type: string
                            type: object
                          path:
                            type: string
                          schemaPath:
                            type: string
                        type: object
                      storageUri:
                        type: string
                      terminationMessagePath:
                        type: string
                      terminationMessagePolicy:
                        type: string
                      tty:
                        type: boolean
                      volumeDevices:
                        items:
                          properties:
                            devicePath:
                              type: string
                            name:
                              type: string
                          required:
                          - devicePath
                          - name
                          type: object
                        type: array
                      volumeMounts:
                        items:
                          properties:
                            mountPath:
                              type: string
                            mountPropagation:
                              type: string
                            name:
                              type: string
                            readOnly:
                              type: boolean
                            subPath:
                              type: string
                            subPathExpr:
                              type: string
                          required:
                          - mountPath
                          - name
                          type: object
                        type: array
                      workingDir:
                        type: string
                    type: object
                  terminationGracePeriodSeconds:
                    format: int64
                    type: integer
                  timeout:
                    format: int64
                    type: integer
                  tolerations:
                    items:
                      properties:
                        effect:
                          type: string
                        key:
                          type: string
                        operator:
                          type: string
                        tolerationSeconds:
                          format: int64
                          type: integer
                        value:
                          type: string
                      type: object
                    type: array
                  topologySpreadConstraints:
                    items:
                      properties:
                        labelSelector:
                          properties:
                            matchExpressions:
                              items:
                                properties:
                                  key:
                                    type: string
                                  operator:
                                    type: string
                                  values:
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
                              type: object
                          type: object
                        maxSkew:
                          format: int32
                          type: integer
                        topologyKey:
                          type: string
                        whenUnsatisfiable:
                          type: string
                      required:
                      - maxSkew
                      - topologyKey
                      - whenUnsatisfiable
                      type: object
                    type: array
                    x-kubernetes-list-map-keys:
                    - topologyKey
                    - whenUnsatisfiable
                    x-kubernetes-list-type: map
                  triton:
                    properties:
                      args:
                        items:
                          type: string
                        type: array
                      command:
                        items:
                          type: string
                        type: array
                      env:
                        items:
                          properties:
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
                                fieldRef:
                                  properties:
                                    apiVersion:
                                      type: string
                                    fieldPath:
                                      type: string
                                  required:
                                  - fieldPath
                                  type: object
                                resourceFieldRef:
                                  properties:
                                    containerName:
                                      type: string
                                    divisor:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                      x-kubernetes-int-or-string: true
                                    resource:
                                      type: string
                                  required:
                                  - resource
                                  type: object
                                secretKeyRef:
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
                          required:
                          - name
                          type: object
                        type: array
                      envFrom:
                        items:
                          properties:
                            configMapRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                            prefix:
                              type: string
                            secretRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                          type: object
                        type: array
                      image:
                        type: string
                      imagePullPolicy:
                        type: string
                      lifecycle:
                        properties:
                          postStart:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                          preStop:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                        type: object
                      livenessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      name:
                        type: string
                      ports:
                        items:
                          properties:
                            containerPort:
                              format: int32
                              type: integer
                            hostIP:
                              type: string
                            hostPort:
                              format: int32
                              type: integer
                            name:
                              type: string
                            protocol:
                              default: TCP
                              type: string
                          required:
                          - containerPort
                          type: object
                        type: array
                        x-kubernetes-list-map-keys:
                        - containerPort
                        - protocol
                        x-kubernetes-list-type: map
                      protocolVersion:
                        type: string
                      readinessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      resources:
                        properties:
                          limits:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                          requests:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                        type: object
                      runtimeVersion:
                        type: string
                      securityContext:
                        properties:
                          allowPrivilegeEscalation:
                            type: boolean
                          capabilities:
                            properties:
                              add:
                                items:
                                  type: string
                                type: array
                              drop:
                                items:
                                  type: string
                                type: array
                            type: object
                          privileged:
                            type: boolean
                          procMount:
                            type: string
                          readOnlyRootFilesystem:
                            type: boolean
                          runAsGroup:
                            format: int64
                            type: integer
                          runAsNonRoot:
                            type: boolean
                          runAsUser:
                            format: int64
                            type: integer
                          seLinuxOptions:
                            properties:
                              level:
                                type: string
                              role:
                                type: string
                              type:
                                type: string
                              user:
                                type: string
                            type: object
                          seccompProfile:
                            properties:
                              localhostProfile:
                                type: string
                              type:
                                type: string
                            required:
                            - type
                            type: object
                          windowsOptions:
                            properties:
                              gmsaCredentialSpec:
                                type: string
                              gmsaCredentialSpecName:
                                type: string
                              hostProcess:
                                type: boolean
                              runAsUserName:
                                type: string
                            type: object
                        type: object
                      startupProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            required:
                            - port
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            required:
                            - port
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      stdin:
                        type: boolean
                      stdinOnce:
                        type: boolean
                      storage:
                        properties:
                          key:
                            type: string
                          parameters:
                            additionalProperties:
                              type: string
                            type: object
                          path:
                            type: string
                          schemaPath:
                            type: string
                        type: object
                      storageUri:
                        type: string
                      terminationMessagePath:
                        type: string
                      terminationMessagePolicy:
                        type: string
                      tty:
                        type: boolean
                      volumeDevices:
                        items:
                          properties:
                            devicePath:
                              type: string
                            name:
                              type: string
                          required:
                          - devicePath
                          - name
                          type: object
                        type: array
                      volumeMounts:
                        items:
                          properties:
                            mountPath:
                              type: string
                            mountPropagation:
                              type: string
                            name:
                              type: string
                            readOnly:
                              type: boolean
                            subPath:
                              type: string
                            subPathExpr:
                              type: string
                          required:
                          - mountPath
                          - name
                          type: object
                        type: array
                      workingDir:
                        type: string
                    type: object
                  volumes:
                    items:
                      properties:
                        awsElasticBlockStore:
                          properties:
                            fsType:
                              type: string
                            partition:
                              format: int32
                              type: integer
                            readOnly:
                              type: boolean
                            volumeID:
                              type: string
                          required:
                          - volumeID
                          type: object
                        azureDisk:
                          properties:
                            cachingMode:
                              type: string
                            diskName:
                              type: string
                            diskURI:
                              type: string
                            fsType:
                              type: string
                            kind:
                              type: string
                            readOnly:
                              type: boolean
                          required:
                          - diskName
                          - diskURI
                          type: object
                        azureFile:
                          properties:
                            readOnly:
                              type: boolean
                            secretName:
                              type: string
                            shareName:
                              type: string
                          required:
                          - secretName
                          - shareName
                          type: object
                        cephfs:
                          properties:
                            monitors:
                              items:
                                type: string
                              type: array
                            path:
                              type: string
                            readOnly:
                              type: boolean
                            secretFile:
                              type: string
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            user:
                              type: string
                          required:
                          - monitors
                          type: object
                        cinder:
                          properties:
                            fsType:
                              type: string
                            readOnly:
                              type: boolean
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            volumeID:
                              type: string
                          required:
                          - volumeID
                          type: object
                        configMap:
                          properties:
                            defaultMode:
                              format: int32
                              type: integer
                            items:
                              items:
                                properties:
                                  key:
                                    type: string
                                  mode:
                                    format: int32
                                    type: integer
                                  path:
                                    type: string
                                required:
                                - key
                                - path
                                type: object
                              type: array
                            name:
                              type: string
                            optional:
                              type: boolean
                          type: object
                        csi:
                          properties:
                            driver:
                              type: string
                            fsType:
                              type: string
                            nodePublishSecretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            readOnly:
                              type: boolean
                            volumeAttributes:
                              additionalProperties:
                                type: string
                              type: object
                          required:
                          - driver
                          type: object
                        downwardAPI:
                          properties:
                            defaultMode:
                              format: int32
                              type: integer
                            items:
                              items:
                                properties:
                                  fieldRef:
                                    properties:
                                      apiVersion:
                                        type: string
                                      fieldPath:
                                        type: string
                                    required:
                                    - fieldPath
                                    type: object
                                  mode:
                                    format: int32
                                    type: integer
                                  path:
                                    type: string
                                  resourceFieldRef:
                                    properties:
                                      containerName:
                                        type: string
                                      divisor:
                                        anyOf:
                                        - type: integer
                                        - type: string
                                        pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                        x-kubernetes-int-or-string: true
                                      resource:
                                        type: string
                                    required:
                                    - resource
                                    type: object
                                required:
                                - path
                                type: object
                              type: array
                          type: object
                        emptyDir:
                          properties:
                            medium:
                              type: string
                            sizeLimit:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                          type: object
                        ephemeral:
                          properties:
                            volumeClaimTemplate:
                              properties:
                                metadata:
                                  type: object
                                spec:
                                  properties:
                                    accessModes:
                                      items:
                                        type: string
                                      type: array
                                    dataSource:
                                      properties:
                                        apiGroup:
                                          type: string
                                        kind:
                                          type: string
                                        name:
                                          type: string
                                      required:
                                      - kind
                                      - name
                                      type: object
                                    dataSourceRef:
                                      properties:
                                        apiGroup:
                                          type: string
                                        kind:
                                          type: string
                                        name:
                                          type: string
                                      required:
                                      - kind
                                      - name
                                      type: object
                                    resources:
                                      properties:
                                        limits:
                                          additionalProperties:
                                            anyOf:
                                            - type: integer
                                            - type: string
                                            pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                            x-kubernetes-int-or-string: true
                                          type: object
                                        requests:
                                          additionalProperties:
                                            anyOf:
                                            - type: integer
                                            - type: string
                                            pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                            x-kubernetes-int-or-string: true
                                          type: object
                                      type: object
                                    selector:
                                      properties:
                                        matchExpressions:
                                          items:
                                            properties:
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                              values:
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
                                          type: object
                                      type: object
                                    storageClassName:
                                      type: string
                                    volumeMode:
                                      type: string
                                    volumeName:
                                      type: string
                                  type: object
                              required:
                              - spec
                              type: object
                          type: object
                        fc:
                          properties:
                            fsType:
                              type: string
                            lun:
                              format: int32
                              type: integer
                            readOnly:
                              type: boolean
                            targetWWNs:
                              items:
                                type: string
                              type: array
                            wwids:
                              items:
                                type: string
                              type: array
                          type: object
                        flexVolume:
                          properties:
                            driver:
                              type: string
                            fsType:
                              type: string
                            options:
                              additionalProperties:
                                type: string
                              type: object
                            readOnly:
                              type: boolean
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                          required:
                          - driver
                          type: object
                        flocker:
                          properties:
                            datasetName:
                              type: string
                            datasetUUID:
                              type: string
                          type: object
                        gcePersistentDisk:
                          properties:
                            fsType:
                              type: string
                            partition:
                              format: int32
                              type: integer
                            pdName:
                              type: string
                            readOnly:
                              type: boolean
                          required:
                          - pdName
                          type: object
                        gitRepo:
                          properties:
                            directory:
                              type: string
                            repository:
                              type: string
                            revision:
                              type: string
                          required:
                          - repository
                          type: object
                        glusterfs:
                          properties:
                            endpoints:
                              type: string
                            path:
                              type: string
                            readOnly:
                              type: boolean
                          required:
                          - endpoints
                          - path
                          type: object
                        hostPath:
                          properties:
                            path:
                              type: string
                            type:
                              type: string
                          required:
                          - path
                          type: object
                        iscsi:
                          properties:
                            chapAuthDiscovery:
                              type: boolean
                            chapAuthSession:
                              type: boolean
                            fsType:
                              type: string
                            initiatorName:
                              type: string
                            iqn:
                              type: string
                            iscsiInterface:
                              type: string
                            lun:
                              format: int32
                              type: integer
                            portals:
                              items:
                                type: string
                              type: array
                            readOnly:
                              type: boolean
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            targetPortal:
                              type: string
                          required:
                          - iqn
                          - lun
                          - targetPortal
                          type: object
                        name:
                          type: string
                        nfs:
                          properties:
                            path:
                              type: string
                            readOnly:
                              type: boolean
                            server:
                              type: string
                          required:
                          - path
                          - server
                          type: object
                        persistentVolumeClaim:
                          properties:
                            claimName:
                              type: string
                            readOnly:
                              type: boolean
                          required:
                          - claimName
                          type: object
                        photonPersistentDisk:
                          properties:
                            fsType:
                              type: string
                            pdID:
                              type: string
                          required:
                          - pdID
                          type: object
                        portworxVolume:
                          properties:
                            fsType:
                              type: string
                            readOnly:
                              type: boolean
                            volumeID:
                              type: string
                          required:
                          - volumeID
                          type: object
                        projected:
                          properties:
                            defaultMode:
                              format: int32
                              type: integer
                            sources:
                              items:
                                properties:
                                  configMap:
                                    properties:
                                      items:
                                        items:
                                          properties:
                                            key:
                                              type: string
                                            mode:
                                              format: int32
                                              type: integer
                                            path:
                                              type: string
                                          required:
                                          - key
                                          - path
                                          type: object
                                        type: array
                                      name:
                                        type: string
                                      optional:
                                        type: boolean
                                    type: object
                                  downwardAPI:
                                    properties:
                                      items:
                                        items:
                                          properties:
                                            fieldRef:
                                              properties:
                                                apiVersion:
                                                  type: string
                                                fieldPath:
                                                  type: string
                                              required:
                                              - fieldPath
                                              type: object
                                            mode:
                                              format: int32
                                              type: integer
                                            path:
                                              type: string
                                            resourceFieldRef:
                                              properties:
                                                containerName:
                                                  type: string
                                                divisor:
                                                  anyOf:
                                                  - type: integer
                                                  - type: string
                                                  pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                                  x-kubernetes-int-or-string: true
                                                resource:
                                                  type: string
                                              required:
                                              - resource
                                              type: object
                                          required:
                                          - path
                                          type: object
                                        type: array
                                    type: object
                                  secret:
                                    properties:
                                      items:
                                        items:
                                          properties:
                                            key:
                                              type: string
                                            mode:
                                              format: int32
                                              type: integer
                                            path:
                                              type: string
                                          required:
                                          - key
                                          - path
                                          type: object
                                        type: array
                                      name:
                                        type: string
                                      optional:
                                        type: boolean
                                    type: object
                                  serviceAccountToken:
                                    properties:
                                      audience:
                                        type: string
                                      expirationSeconds:
                                        format: int64
                                        type: integer
                                      path:
                                        type: string
                                    required:
                                    - path
                                    type: object
                                type: object
                              type: array
                          type: object
                        quobyte:
                          properties:
                            group:
                              type: string
                            readOnly:
                              type: boolean
                            registry:
                              type: string
                            tenant:
                              type: string
                            user:
                              type: string
                            volume:
                              type: string
                          required:
                          - registry
                          - volume
                          type: object
                        rbd:
                          properties:
                            fsType:
                              type: string
                            image:
                              type: string
                            keyring:
                              type: string
                            monitors:
                              items:
                                type: string
                              type: array
                            pool:
                              type: string
                            readOnly:
                              type: boolean
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            user:
                              type: string
                          required:
                          - image
                          - monitors
                          type: object
                        scaleIO:
                          properties:
                            fsType:
                              type: string
                            gateway:
                              type: string
                            protectionDomain:
                              type: string
                            readOnly:
                              type: boolean
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            sslEnabled:
                              type: boolean
                            storageMode:
                              type: string
                            storagePool:
                              type: string
                            system:
                              type: string
                            volumeName:
                              type: string
                          required:
                          - gateway
                          - secretRef
                          - system
                          type: object
                        secret:
                          properties:
                            defaultMode:
                              format: int32
                              type: integer
                            items:
                              items:
                                properties:
                                  key:
                                    type: string
                                  mode:
                                    format: int32
                                    type: integer
                                  path:
                                    type: string
                                required:
                                - key
                                - path
                                type: object
                              type: array
                            optional:
                              type: boolean
                            secretName:
                              type: string
                          type: object
                        storageos:
                          properties:
                            fsType:
                              type: string
                            readOnly:
                              type: boolean
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            volumeName:
                              type: string
                            volumeNamespace:
                              type: string
                          type: object
                        vsphereVolume:
                          properties:
                            fsType:
                              type: string
                            storagePolicyID:
                              type: string
                            storagePolicyName:
                              type: string
                            volumePath:
                              type: string
                          required:
                          - volumePath
                          type: object
                      required:
                      - name
                      type: object
                    type: array
                  xgboost:
                    properties:
                      args:
                        items:
                          type: string
                        type: array
                      command:
                        items:
                          type: string
                        type: array
                      env:
                        items:
                          properties:
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
                                fieldRef:
                                  properties:
                                    apiVersion:
                                      type: string
                                    fieldPath:
                                      type: string
                                  required:
                                  - fieldPath
                                  type: object
                                resourceFieldRef:
                                  properties:
                                    containerName:
                                      type: string
                                    divisor:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                      x-kubernetes-int-or-string: true
                                    resource:
                                      type: string
                                  required:
                                  - resource
                                  type: object
                                secretKeyRef:
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
                          required:
                          - name
                          type: object
                        type: array
                      envFrom:
                        items:
                          properties:
                            configMapRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                            prefix:
                              type: string
                            secretRef:
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                              type: object
                          type: object
                        type: array
                      image:
                        type: string
                      imagePullPolicy:
                        type: string
                      lifecycle:
                        properties:
                          postStart:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                          preStop:
                            properties:
                              exec:
                                properties:
                                  command:
                                    items:
                                      type: string
                                    type: array
                                type: object
                              httpGet:
                                properties:
                                  host:
                                    type: string
                                  httpHeaders:
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
                                  path:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                  scheme:
                                    type: string
                                required:
                                - port
                                type: object
                              tcpSocket:
                                properties:
                                  host:
                                    type: string
                                  port:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    x-kubernetes-int-or-string: true
                                required:
                                - port
                                type: object
                            type: object
                        type: object
                      livenessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      name:
                        type: string
                      ports:
                        items:
                          properties:
                            containerPort:
                              format: int32
                              type: integer
                            hostIP:
                              type: string
                            hostPort:
                              format: int32
                              type: integer
                            name:
                              type: string
                            protocol:
                              default: TCP
                              type: string
                          required:
                          - containerPort
                          type: object
                        type: array
                        x-kubernetes-list-map-keys:
                        - containerPort
                        - protocol
                        x-kubernetes-list-type: map
                      protocolVersion:
                        type: string
                      readinessProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      resources:
                        properties:
                          limits:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                          requests:
                            additionalProperties:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                            type: object
                        type: object
                      runtimeVersion:
                        type: string
                      securityContext:
                        properties:
                          allowPrivilegeEscalation:
                            type: boolean
                          capabilities:
                            properties:
                              add:
                                items:
                                  type: string
                                type: array
                              drop:
                                items:
                                  type: string
                                type: array
                            type: object
                          privileged:
                            type: boolean
                          procMount:
                            type: string
                          readOnlyRootFilesystem:
                            type: boolean
                          runAsGroup:
                            format: int64
                            type: integer
                          runAsNonRoot:
                            type: boolean
                          runAsUser:
                            format: int64
                            type: integer
                          seLinuxOptions:
                            properties:
                              level:
                                type: string
                              role:
                                type: string
                              type:
                                type: string
                              user:
                                type: string
                            type: object
                          seccompProfile:
                            properties:
                              localhostProfile:
                                type: string
                              type:
                                type: string
                            required:
                            - type
                            type: object
                          windowsOptions:
                            properties:
                              gmsaCredentialSpec:
                                type: string
                              gmsaCredentialSpecName:
                                type: string
                              hostProcess:
                                type: boolean
                              runAsUserName:
                                type: string
                            type: object
                        type: object
                      startupProbe:
                        properties:
                          exec:
                            properties:
                              command:
                                items:
                                  type: string
                                type: array
                            type: object
                          failureThreshold:
                            format: int32
                            type: integer
                          grpc:
                            properties:
                              port:
                                format: int32
                                type: integer
                              service:
                                type: string
                            required:
                            - port
                            type: object
                          httpGet:
                            properties:
                              host:
                                type: string
                              httpHeaders:
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
                              path:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                              scheme:
                                type: string
                            required:
                            - port
                            type: object
                          initialDelaySeconds:
                            format: int32
                            type: integer
                          periodSeconds:
                            format: int32
                            type: integer
                          successThreshold:
                            format: int32
                            type: integer
                          tcpSocket:
                            properties:
                              host:
                                type: string
                              port:
                                anyOf:
                                - type: integer
                                - type: string
                                x-kubernetes-int-or-string: true
                            required:
                            - port
                            type: object
                          terminationGracePeriodSeconds:
                            format: int64
                            type: integer
                          timeoutSeconds:
                            format: int32
                            type: integer
                        type: object
                      stdin:
                        type: boolean
                      stdinOnce:
                        type: boolean
                      storage:
                        properties:
                          key:
                            type: string
                          parameters:
                            additionalProperties:
                              type: string
                            type: object
                          path:
                            type: string
                          schemaPath:
                            type: string
                        type: object
                      storageUri:
                        type: string
                      terminationMessagePath:
                        type: string
                      terminationMessagePolicy:
                        type: string
                      tty:
                        type: boolean
                      volumeDevices:
                        items:
                          properties:
                            devicePath:
                              type: string
                            name:
                              type: string
                          required:
                          - devicePath
                          - name
                          type: object
                        type: array
                      volumeMounts:
                        items:
                          properties:
                            mountPath:
                              type: string
                            mountPropagation:
                              type: string
                            name:
                              type: string
                            readOnly:
                              type: boolean
                            subPath:
                              type: string
                            subPathExpr:
                              type: string
                          required:
                          - mountPath
                          - name
                          type: object
                        type: array
                      workingDir:
                        type: string
                    type: object
                type: object
              transformer:
                properties:
                  activeDeadlineSeconds:
                    format: int64
                    type: integer
                  affinity:
                    properties:
                      nodeAffinity:
                        properties:
                          preferredDuringSchedulingIgnoredDuringExecution:
                            items:
                              properties:
                                preference:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
                                            items:
                                              type: string
                                            type: array
                                        required:
                                        - key
                                        - operator
                                        type: object
                                      type: array
                                    matchFields:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
                                            items:
                                              type: string
                                            type: array
                                        required:
                                        - key
                                        - operator
                                        type: object
                                      type: array
                                  type: object
                                weight:
                                  format: int32
                                  type: integer
                              required:
                              - preference
                              - weight
                              type: object
                            type: array
                          requiredDuringSchedulingIgnoredDuringExecution:
                            properties:
                              nodeSelectorTerms:
                                items:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
                                            items:
                                              type: string
                                            type: array
                                        required:
                                        - key
                                        - operator
                                        type: object
                                      type: array
                                    matchFields:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
                                            items:
                                              type: string
                                            type: array
                                        required:
                                        - key
                                        - operator
                                        type: object
                                      type: array
                                  type: object
                                type: array
                            required:
                            - nodeSelectorTerms
                            type: object
                        type: object
                      podAffinity:
                        properties:
                          preferredDuringSchedulingIgnoredDuringExecution:
                            items:
                              properties:
                                podAffinityTerm:
                                  properties:
                                    labelSelector:
                                      properties:
                                        matchExpressions:
                                          items:
                                            properties:
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                              values:
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
                                          type: object
                                      type: object
                                    namespaceSelector:
                                      properties:
                                        matchExpressions:
                                          items:
                                            properties:
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                              values:
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
                                          type: object
                                      type: object
                                    namespaces:
                                      items:
                                        type: string
                                      type: array
                                    topologyKey:
                                      type: string
                                  required:
                                  - topologyKey
                                  type: object
                                weight:
                                  format: int32
                                  type: integer
                              required:
                              - podAffinityTerm
                              - weight
                              type: object
                            type: array
                          requiredDuringSchedulingIgnoredDuringExecution:
                            items:
                              properties:
                                labelSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaceSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaces:
                                  items:
                                    type: string
                                  type: array
                                topologyKey:
                                  type: string
                              required:
                              - topologyKey
                              type: object
                            type: array
                        type: object
                      podAntiAffinity:
                        properties:
                          preferredDuringSchedulingIgnoredDuringExecution:
                            items:
                              properties:
                                podAffinityTerm:
                                  properties:
                                    labelSelector:
                                      properties:
                                        matchExpressions:
                                          items:
                                            properties:
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                              values:
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
                                          type: object
                                      type: object
                                    namespaceSelector:
                                      properties:
                                        matchExpressions:
                                          items:
                                            properties:
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                              values:
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
                                          type: object
                                      type: object
                                    namespaces:
                                      items:
                                        type: string
                                      type: array
                                    topologyKey:
                                      type: string
                                  required:
                                  - topologyKey
                                  type: object
                                weight:
                                  format: int32
                                  type: integer
                              required:
                              - podAffinityTerm
                              - weight
                              type: object
                            type: array
                          requiredDuringSchedulingIgnoredDuringExecution:
                            items:
                              properties:
                                labelSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaceSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaces:
                                  items:
                                    type: string
                                  type: array
                                topologyKey:
                                  type: string
                              required:
                              - topologyKey
                              type: object
                            type: array
                        type: object
                    type: object
                  automountServiceAccountToken:
                    type: boolean
                  batcher:
                    properties:
                      maxBatchSize:
                        type: integer
                      maxLatency:
                        type: integer
                      timeout:
                        type: integer
                    type: object
                  canaryTrafficPercent:
                    format: int64
                    type: integer
                  containerConcurrency:
                    format: int64
                    type: integer
                  containers:
                    items:
                      properties:
                        args:
                          items:
                            type: string
                          type: array
                        command:
                          items:
                            type: string
                          type: array
                        env:
                          items:
                            properties:
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
                                  fieldRef:
                                    properties:
                                      apiVersion:
                                        type: string
                                      fieldPath:
                                        type: string
                                    required:
                                    - fieldPath
                                    type: object
                                  resourceFieldRef:
                                    properties:
                                      containerName:
                                        type: string
                                      divisor:
                                        anyOf:
                                        - type: integer
                                        - type: string
                                        pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                        x-kubernetes-int-or-string: true
                                      resource:
                                        type: string
                                    required:
                                    - resource
                                    type: object
                                  secretKeyRef:
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
                            required:
                            - name
                            type: object
                          type: array
                        envFrom:
                          items:
                            properties:
                              configMapRef:
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                                type: object
                              prefix:
                                type: string
                              secretRef:
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                                type: object
                            type: object
                          type: array
                        image:
                          type: string
                        imagePullPolicy:
                          type: string
                        lifecycle:
                          properties:
                            postStart:
                              properties:
                                exec:
                                  properties:
                                    command:
                                      items:
                                        type: string
                                      type: array
                                  type: object
                                httpGet:
                                  properties:
                                    host:
                                      type: string
                                    httpHeaders:
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
                                    path:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                    scheme:
                                      type: string
                                  required:
                                  - port
                                  type: object
                                tcpSocket:
                                  properties:
                                    host:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                  required:
                                  - port
                                  type: object
                              type: object
                            preStop:
                              properties:
                                exec:
                                  properties:
                                    command:
                                      items:
                                        type: string
                                      type: array
                                  type: object
                                httpGet:
                                  properties:
                                    host:
                                      type: string
                                    httpHeaders:
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
                                    path:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                    scheme:
                                      type: string
                                  required:
                                  - port
                                  type: object
                                tcpSocket:
                                  properties:
                                    host:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                  required:
                                  - port
                                  type: object
                              type: object
                          type: object
                        livenessProbe:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            failureThreshold:
                              format: int32
                              type: integer
                            grpc:
                              properties:
                                port:
                                  format: int32
                                  type: integer
                                service:
                                  type: string
                              required:
                              - port
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              type: object
                            initialDelaySeconds:
                              format: int32
                              type: integer
                            periodSeconds:
                              format: int32
                              type: integer
                            successThreshold:
                              format: int32
                              type: integer
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                            terminationGracePeriodSeconds:
                              format: int64
                              type: integer
                            timeoutSeconds:
                              format: int32
                              type: integer
                          type: object
                        name:
                          type: string
                        ports:
                          items:
                            properties:
                              containerPort:
                                format: int32
                                type: integer
                              hostIP:
                                type: string
                              hostPort:
                                format: int32
                                type: integer
                              name:
                                type: string
                              protocol:
                                default: TCP
                                type: string
                            required:
                            - containerPort
                            type: object
                          type: array
                          x-kubernetes-list-map-keys:
                          - containerPort
                          - protocol
                          x-kubernetes-list-type: map
                        readinessProbe:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            failureThreshold:
                              format: int32
                              type: integer
                            grpc:
                              properties:
                                port:
                                  format: int32
                                  type: integer
                                service:
                                  type: string
                              required:
                              - port
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              type: object
                            initialDelaySeconds:
                              format: int32
                              type: integer
                            periodSeconds:
                              format: int32
                              type: integer
                            successThreshold:
                              format: int32
                              type: integer
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                            terminationGracePeriodSeconds:
                              format: int64
                              type: integer
                            timeoutSeconds:
                              format: int32
                              type: integer
                          type: object
                        resources:
                          properties:
                            limits:
                              additionalProperties:
                                anyOf:
                                - type: integer
                                - type: string
                                pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                x-kubernetes-int-or-string: true
                              type: object
                            requests:
                              additionalProperties:
                                anyOf:
                                - type: integer
                                - type: string
                                pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                x-kubernetes-int-or-string: true
                              type: object
                          type: object
                        securityContext:
                          properties:
                            allowPrivilegeEscalation:
                              type: boolean
                            capabilities:
                              properties:
                                add:
                                  items:
                                    type: string
                                  type: array
                                drop:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            privileged:
                              type: boolean
                            procMount:
                              type: string
                            readOnlyRootFilesystem:
                              type: boolean
                            runAsGroup:
                              format: int64
                              type: integer
                            runAsNonRoot:
                              type: boolean
                            runAsUser:
                              format: int64
                              type: integer
                            seLinuxOptions:
                              properties:
                                level:
                                  type: string
                                role:
                                  type: string
                                type:
                                  type: string
                                user:
                                  type: string
                              type: object
                            seccompProfile:
                              properties:
                                localhostProfile:
                                  type: string
                                type:
                                  type: string
                              required:
                              - type
                              type: object
                            windowsOptions:
                              properties:
                                gmsaCredentialSpec:
                                  type: string
                                gmsaCredentialSpecName:
                                  type: string
                                hostProcess:
                                  type: boolean
                                runAsUserName:
                                  type: string
                              type: object
                          type: object
                        startupProbe:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            failureThreshold:
                              format: int32
                              type: integer
                            grpc:
                              properties:
                                port:
                                  format: int32
                                  type: integer
                                service:
                                  type: string
                              required:
                              - port
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              required:
                              - port
                              type: object
                            initialDelaySeconds:
                              format: int32
                              type: integer
                            periodSeconds:
                              format: int32
                              type: integer
                            successThreshold:
                              format: int32
                              type: integer
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                            terminationGracePeriodSeconds:
                              format: int64
                              type: integer
                            timeoutSeconds:
                              format: int32
                              type: integer
                          type: object
                        stdin:
                          type: boolean
                        stdinOnce:
                          type: boolean
                        terminationMessagePath:
                          type: string
                        terminationMessagePolicy:
                          type: string
                        tty:
                          type: boolean
                        volumeDevices:
                          items:
                            properties:
                              devicePath:
                                type: string
                              name:
                                type: string
                            required:
                            - devicePath
                            - name
                            type: object
                          type: array
                        volumeMounts:
                          items:
                            properties:
                              mountPath:
                                type: string
                              mountPropagation:
                                type: string
                              name:
                                type: string
                              readOnly:
                                type: boolean
                              subPath:
                                type: string
                              subPathExpr:
                                type: string
                            required:
                            - mountPath
                            - name
                            type: object
                          type: array
                        workingDir:
                          type: string
                      required:
                      - name
                      type: object
                    type: array
                  dnsConfig:
                    properties:
                      nameservers:
                        items:
                          type: string
                        type: array
                      options:
                        items:
                          properties:
                            name:
                              type: string
                            value:
                              type: string
                          type: object
                        type: array
                      searches:
                        items:
                          type: string
                        type: array
                    type: object
                  dnsPolicy:
                    type: string
                  enableServiceLinks:
                    type: boolean
                  hostAliases:
                    items:
                      properties:
                        hostnames:
                          items:
                            type: string
                          type: array
                        ip:
                          type: string
                      type: object
                    type: array
                  hostIPC:
                    type: boolean
                  hostNetwork:
                    type: boolean
                  hostPID:
                    type: boolean
                  hostname:
                    type: string
                  imagePullSecrets:
                    items:
                      properties:
                        name:
                          type: string
                      type: object
                    type: array
                  initContainers:
                    items:
                      properties:
                        args:
                          items:
                            type: string
                          type: array
                        command:
                          items:
                            type: string
                          type: array
                        env:
                          items:
                            properties:
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
                                  fieldRef:
                                    properties:
                                      apiVersion:
                                        type: string
                                      fieldPath:
                                        type: string
                                    required:
                                    - fieldPath
                                    type: object
                                  resourceFieldRef:
                                    properties:
                                      containerName:
                                        type: string
                                      divisor:
                                        anyOf:
                                        - type: integer
                                        - type: string
                                        pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                        x-kubernetes-int-or-string: true
                                      resource:
                                        type: string
                                    required:
                                    - resource
                                    type: object
                                  secretKeyRef:
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
                            required:
                            - name
                            type: object
                          type: array
                        envFrom:
                          items:
                            properties:
                              configMapRef:
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                                type: object
                              prefix:
                                type: string
                              secretRef:
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                                type: object
                            type: object
                          type: array
                        image:
                          type: string
                        imagePullPolicy:
                          type: string
                        lifecycle:
                          properties:
                            postStart:
                              properties:
                                exec:
                                  properties:
                                    command:
                                      items:
                                        type: string
                                      type: array
                                  type: object
                                httpGet:
                                  properties:
                                    host:
                                      type: string
                                    httpHeaders:
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
                                    path:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                    scheme:
                                      type: string
                                  required:
                                  - port
                                  type: object
                                tcpSocket:
                                  properties:
                                    host:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                  required:
                                  - port
                                  type: object
                              type: object
                            preStop:
                              properties:
                                exec:
                                  properties:
                                    command:
                                      items:
                                        type: string
                                      type: array
                                  type: object
                                httpGet:
                                  properties:
                                    host:
                                      type: string
                                    httpHeaders:
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
                                    path:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                    scheme:
                                      type: string
                                  required:
                                  - port
                                  type: object
                                tcpSocket:
                                  properties:
                                    host:
                                      type: string
                                    port:
                                      anyOf:
                                      - type: integer
                                      - type: string
                                      x-kubernetes-int-or-string: true
                                  required:
                                  - port
                                  type: object
                              type: object
                          type: object
                        livenessProbe:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            failureThreshold:
                              format: int32
                              type: integer
                            grpc:
                              properties:
                                port:
                                  format: int32
                                  type: integer
                                service:
                                  type: string
                              required:
                              - port
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              required:
                              - port
                              type: object
                            initialDelaySeconds:
                              format: int32
                              type: integer
                            periodSeconds:
                              format: int32
                              type: integer
                            successThreshold:
                              format: int32
                              type: integer
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                            terminationGracePeriodSeconds:
                              format: int64
                              type: integer
                            timeoutSeconds:
                              format: int32
                              type: integer
                          type: object
                        name:
                          type: string
                        ports:
                          items:
                            properties:
                              containerPort:
                                format: int32
                                type: integer
                              hostIP:
                                type: string
                              hostPort:
                                format: int32
                                type: integer
                              name:
                                type: string
                              protocol:
                                default: TCP
                                type: string
                            required:
                            - containerPort
                            type: object
                          type: array
                          x-kubernetes-list-map-keys:
                          - containerPort
                          - protocol
                          x-kubernetes-list-type: map
                        readinessProbe:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            failureThreshold:
                              format: int32
                              type: integer
                            grpc:
                              properties:
                                port:
                                  format: int32
                                  type: integer
                                service:
                                  type: string
                              required:
                              - port
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              required:
                              - port
                              type: object
                            initialDelaySeconds:
                              format: int32
                              type: integer
                            periodSeconds:
                              format: int32
                              type: integer
                            successThreshold:
                              format: int32
                              type: integer
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                            terminationGracePeriodSeconds:
                              format: int64
                              type: integer
                            timeoutSeconds:
                              format: int32
                              type: integer
                          type: object
                        resources:
                          properties:
                            limits:
                              additionalProperties:
                                anyOf:
                                - type: integer
                                - type: string
                                pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                x-kubernetes-int-or-string: true
                              type: object
                            requests:
                              additionalProperties:
                                anyOf:
                                - type: integer
                                - type: string
                                pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                x-kubernetes-int-or-string: true
                              type: object
                          type: object
                        securityContext:
                          properties:
                            allowPrivilegeEscalation:
                              type: boolean
                            capabilities:
                              properties:
                                add:
                                  items:
                                    type: string
                                  type: array
                                drop:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            privileged:
                              type: boolean
                            procMount:
                              type: string
                            readOnlyRootFilesystem:
                              type: boolean
                            runAsGroup:
                              format: int64
                              type: integer
                            runAsNonRoot:
                              type: boolean
                            runAsUser:
                              format: int64
                              type: integer
                            seLinuxOptions:
                              properties:
                                level:
                                  type: string
                                role:
                                  type: string
                                type:
                                  type: string
                                user:
                                  type: string
                              type: object
                            seccompProfile:
                              properties:
                                localhostProfile:
                                  type: string
                                type:
                                  type: string
                              required:
                              - type
                              type: object
                            windowsOptions:
                              properties:
                                gmsaCredentialSpec:
                                  type: string
                                gmsaCredentialSpecName:
                                  type: string
                                hostProcess:
                                  type: boolean
                                runAsUserName:
                                  type: string
                              type: object
                          type: object
                        startupProbe:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            failureThreshold:
                              format: int32
                              type: integer
                            grpc:
                              properties:
                                port:
                                  format: int32
                                  type: integer
                                service:
                                  type: string
                              required:
                              - port
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              required:
                              - port
                              type: object
                            initialDelaySeconds:
                              format: int32
                              type: integer
                            periodSeconds:
                              format: int32
                              type: integer
                            successThreshold:
                              format: int32
                              type: integer
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                            terminationGracePeriodSeconds:
                              format: int64
                              type: integer
                            timeoutSeconds:
                              format: int32
                              type: integer
                          type: object
                        stdin:
                          type: boolean
                        stdinOnce:
                          type: boolean
                        terminationMessagePath:
                          type: string
                        terminationMessagePolicy:
                          type: string
                        tty:
                          type: boolean
                        volumeDevices:
                          items:
                            properties:
                              devicePath:
                                type: string
                              name:
                                type: string
                            required:
                            - devicePath
                            - name
                            type: object
                          type: array
                        volumeMounts:
                          items:
                            properties:
                              mountPath:
                                type: string
                              mountPropagation:
                                type: string
                              name:
                                type: string
                              readOnly:
                                type: boolean
                              subPath:
                                type: string
                              subPathExpr:
                                type: string
                            required:
                            - mountPath
                            - name
                            type: object
                          type: array
                        workingDir:
                          type: string
                      required:
                      - name
                      type: object
                    type: array
                  logger:
                    properties:
                      mode:
                        enum:
                        - all
                        - request
                        - response
                        type: string
                      url:
                        type: string
                    type: object
                  maxReplicas:
                    type: integer
                  minReplicas:
                    type: integer
                  nodeName:
                    type: string
                  nodeSelector:
                    additionalProperties:
                      type: string
                    type: object
                    x-kubernetes-map-type: atomic
                  os:
                    properties:
                      name:
                        type: string
                    type: object
                  overhead:
                    additionalProperties:
                      anyOf:
                      - type: integer
                      - type: string
                      pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                      x-kubernetes-int-or-string: true
                    type: object
                  preemptionPolicy:
                    type: string
                  priority:
                    format: int32
                    type: integer
                  priorityClassName:
                    type: string
                  readinessGates:
                    items:
                      properties:
                        conditionType:
                          type: string
                      required:
                      - conditionType
                      type: object
                    type: array
                  restartPolicy:
                    type: string
                  runtimeClassName:
                    type: string
                  scaleMetric:
                    enum:
                    - cpu
                    - memory
                    - concurrency
                    - rps
                    type: string
                  scaleTarget:
                    type: integer
                  schedulerName:
                    type: string
                  securityContext:
                    properties:
                      fsGroup:
                        format: int64
                        type: integer
                      fsGroupChangePolicy:
                        type: string
                      runAsGroup:
                        format: int64
                        type: integer
                      runAsNonRoot:
                        type: boolean
                      runAsUser:
                        format: int64
                        type: integer
                      seLinuxOptions:
                        properties:
                          level:
                            type: string
                          role:
                            type: string
                          type:
                            type: string
                          user:
                            type: string
                        type: object
                      seccompProfile:
                        properties:
                          localhostProfile:
                            type: string
                          type:
                            type: string
                        required:
                        - type
                        type: object
                      supplementalGroups:
                        items:
                          format: int64
                          type: integer
                        type: array
                      sysctls:
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
                      windowsOptions:
                        properties:
                          gmsaCredentialSpec:
                            type: string
                          gmsaCredentialSpecName:
                            type: string
                          hostProcess:
                            type: boolean
                          runAsUserName:
                            type: string
                        type: object
                    type: object
                  serviceAccount:
                    type: string
                  serviceAccountName:
                    type: string
                  setHostnameAsFQDN:
                    type: boolean
                  shareProcessNamespace:
                    type: boolean
                  subdomain:
                    type: string
                  terminationGracePeriodSeconds:
                    format: int64
                    type: integer
                  timeout:
                    format: int64
                    type: integer
                  tolerations:
                    items:
                      properties:
                        effect:
                          type: string
                        key:
                          type: string
                        operator:
                          type: string
                        tolerationSeconds:
                          format: int64
                          type: integer
                        value:
                          type: string
                      type: object
                    type: array
                  topologySpreadConstraints:
                    items:
                      properties:
                        labelSelector:
                          properties:
                            matchExpressions:
                              items:
                                properties:
                                  key:
                                    type: string
                                  operator:
                                    type: string
                                  values:
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
                              type: object
                          type: object
                        maxSkew:
                          format: int32
                          type: integer
                        topologyKey:
                          type: string
                        whenUnsatisfiable:
                          type: string
                      required:
                      - maxSkew
                      - topologyKey
                      - whenUnsatisfiable
                      type: object
                    type: array
                    x-kubernetes-list-map-keys:
                    - topologyKey
                    - whenUnsatisfiable
                    x-kubernetes-list-type: map
                  volumes:
                    items:
                      properties:
                        awsElasticBlockStore:
                          properties:
                            fsType:
                              type: string
                            partition:
                              format: int32
                              type: integer
                            readOnly:
                              type: boolean
                            volumeID:
                              type: string
                          required:
                          - volumeID
                          type: object
                        azureDisk:
                          properties:
                            cachingMode:
                              type: string
                            diskName:
                              type: string
                            diskURI:
                              type: string
                            fsType:
                              type: string
                            kind:
                              type: string
                            readOnly:
                              type: boolean
                          required:
                          - diskName
                          - diskURI
                          type: object
                        azureFile:
                          properties:
                            readOnly:
                              type: boolean
                            secretName:
                              type: string
                            shareName:
                              type: string
                          required:
                          - secretName
                          - shareName
                          type: object
                        cephfs:
                          properties:
                            monitors:
                              items:
                                type: string
                              type: array
                            path:
                              type: string
                            readOnly:
                              type: boolean
                            secretFile:
                              type: string
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            user:
                              type: string
                          required:
                          - monitors
                          type: object
                        cinder:
                          properties:
                            fsType:
                              type: string
                            readOnly:
                              type: boolean
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            volumeID:
                              type: string
                          required:
                          - volumeID
                          type: object
                        configMap:
                          properties:
                            defaultMode:
                              format: int32
                              type: integer
                            items:
                              items:
                                properties:
                                  key:
                                    type: string
                                  mode:
                                    format: int32
                                    type: integer
                                  path:
                                    type: string
                                required:
                                - key
                                - path
                                type: object
                              type: array
                            name:
                              type: string
                            optional:
                              type: boolean
                          type: object
                        csi:
                          properties:
                            driver:
                              type: string
                            fsType:
                              type: string
                            nodePublishSecretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            readOnly:
                              type: boolean
                            volumeAttributes:
                              additionalProperties:
                                type: string
                              type: object
                          required:
                          - driver
                          type: object
                        downwardAPI:
                          properties:
                            defaultMode:
                              format: int32
                              type: integer
                            items:
                              items:
                                properties:
                                  fieldRef:
                                    properties:
                                      apiVersion:
                                        type: string
                                      fieldPath:
                                        type: string
                                    required:
                                    - fieldPath
                                    type: object
                                  mode:
                                    format: int32
                                    type: integer
                                  path:
                                    type: string
                                  resourceFieldRef:
                                    properties:
                                      containerName:
                                        type: string
                                      divisor:
                                        anyOf:
                                        - type: integer
                                        - type: string
                                        pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                        x-kubernetes-int-or-string: true
                                      resource:
                                        type: string
                                    required:
                                    - resource
                                    type: object
                                required:
                                - path
                                type: object
                              type: array
                          type: object
                        emptyDir:
                          properties:
                            medium:
                              type: string
                            sizeLimit:
                              anyOf:
                              - type: integer
                              - type: string
                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                              x-kubernetes-int-or-string: true
                          type: object
                        ephemeral:
                          properties:
                            volumeClaimTemplate:
                              properties:
                                metadata:
                                  type: object
                                spec:
                                  properties:
                                    accessModes:
                                      items:
                                        type: string
                                      type: array
                                    dataSource:
                                      properties:
                                        apiGroup:
                                          type: string
                                        kind:
                                          type: string
                                        name:
                                          type: string
                                      required:
                                      - kind
                                      - name
                                      type: object
                                    dataSourceRef:
                                      properties:
                                        apiGroup:
                                          type: string
                                        kind:
                                          type: string
                                        name:
                                          type: string
                                      required:
                                      - kind
                                      - name
                                      type: object
                                    resources:
                                      properties:
                                        limits:
                                          additionalProperties:
                                            anyOf:
                                            - type: integer
                                            - type: string
                                            pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                            x-kubernetes-int-or-string: true
                                          type: object
                                        requests:
                                          additionalProperties:
                                            anyOf:
                                            - type: integer
                                            - type: string
                                            pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                            x-kubernetes-int-or-string: true
                                          type: object
                                      type: object
                                    selector:
                                      properties:
                                        matchExpressions:
                                          items:
                                            properties:
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                              values:
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
                                          type: object
                                      type: object
                                    storageClassName:
                                      type: string
                                    volumeMode:
                                      type: string
                                    volumeName:
                                      type: string
                                  type: object
                              required:
                              - spec
                              type: object
                          type: object
                        fc:
                          properties:
                            fsType:
                              type: string
                            lun:
                              format: int32
                              type: integer
                            readOnly:
                              type: boolean
                            targetWWNs:
                              items:
                                type: string
                              type: array
                            wwids:
                              items:
                                type: string
                              type: array
                          type: object
                        flexVolume:
                          properties:
                            driver:
                              type: string
                            fsType:
                              type: string
                            options:
                              additionalProperties:
                                type: string
                              type: object
                            readOnly:
                              type: boolean
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                          required:
                          - driver
                          type: object
                        flocker:
                          properties:
                            datasetName:
                              type: string
                            datasetUUID:
                              type: string
                          type: object
                        gcePersistentDisk:
                          properties:
                            fsType:
                              type: string
                            partition:
                              format: int32
                              type: integer
                            pdName:
                              type: string
                            readOnly:
                              type: boolean
                          required:
                          - pdName
                          type: object
                        gitRepo:
                          properties:
                            directory:
                              type: string
                            repository:
                              type: string
                            revision:
                              type: string
                          required:
                          - repository
                          type: object
                        glusterfs:
                          properties:
                            endpoints:
                              type: string
                            path:
                              type: string
                            readOnly:
                              type: boolean
                          required:
                          - endpoints
                          - path
                          type: object
                        hostPath:
                          properties:
                            path:
                              type: string
                            type:
                              type: string
                          required:
                          - path
                          type: object
                        iscsi:
                          properties:
                            chapAuthDiscovery:
                              type: boolean
                            chapAuthSession:
                              type: boolean
                            fsType:
                              type: string
                            initiatorName:
                              type: string
                            iqn:
                              type: string
                            iscsiInterface:
                              type: string
                            lun:
                              format: int32
                              type: integer
                            portals:
                              items:
                                type: string
                              type: array
                            readOnly:
                              type: boolean
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            targetPortal:
                              type: string
                          required:
                          - iqn
                          - lun
                          - targetPortal
                          type: object
                        name:
                          type: string
                        nfs:
                          properties:
                            path:
                              type: string
                            readOnly:
                              type: boolean
                            server:
                              type: string
                          required:
                          - path
                          - server
                          type: object
                        persistentVolumeClaim:
                          properties:
                            claimName:
                              type: string
                            readOnly:
                              type: boolean
                          required:
                          - claimName
                          type: object
                        photonPersistentDisk:
                          properties:
                            fsType:
                              type: string
                            pdID:
                              type: string
                          required:
                          - pdID
                          type: object
                        portworxVolume:
                          properties:
                            fsType:
                              type: string
                            readOnly:
                              type: boolean
                            volumeID:
                              type: string
                          required:
                          - volumeID
                          type: object
                        projected:
                          properties:
                            defaultMode:
                              format: int32
                              type: integer
                            sources:
                              items:
                                properties:
                                  configMap:
                                    properties:
                                      items:
                                        items:
                                          properties:
                                            key:
                                              type: string
                                            mode:
                                              format: int32
                                              type: integer
                                            path:
                                              type: string
                                          required:
                                          - key
                                          - path
                                          type: object
                                        type: array
                                      name:
                                        type: string
                                      optional:
                                        type: boolean
                                    type: object
                                  downwardAPI:
                                    properties:
                                      items:
                                        items:
                                          properties:
                                            fieldRef:
                                              properties:
                                                apiVersion:
                                                  type: string
                                                fieldPath:
                                                  type: string
                                              required:
                                              - fieldPath
                                              type: object
                                            mode:
                                              format: int32
                                              type: integer
                                            path:
                                              type: string
                                            resourceFieldRef:
                                              properties:
                                                containerName:
                                                  type: string
                                                divisor:
                                                  anyOf:
                                                  - type: integer
                                                  - type: string
                                                  pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                                  x-kubernetes-int-or-string: true
                                                resource:
                                                  type: string
                                              required:
                                              - resource
                                              type: object
                                          required:
                                          - path
                                          type: object
                                        type: array
                                    type: object
                                  secret:
                                    properties:
                                      items:
                                        items:
                                          properties:
                                            key:
                                              type: string
                                            mode:
                                              format: int32
                                              type: integer
                                            path:
                                              type: string
                                          required:
                                          - key
                                          - path
                                          type: object
                                        type: array
                                      name:
                                        type: string
                                      optional:
                                        type: boolean
                                    type: object
                                  serviceAccountToken:
                                    properties:
                                      audience:
                                        type: string
                                      expirationSeconds:
                                        format: int64
                                        type: integer
                                      path:
                                        type: string
                                    required:
                                    - path
                                    type: object
                                type: object
                              type: array
                          type: object
                        quobyte:
                          properties:
                            group:
                              type: string
                            readOnly:
                              type: boolean
                            registry:
                              type: string
                            tenant:
                              type: string
                            user:
                              type: string
                            volume:
                              type: string
                          required:
                          - registry
                          - volume
                          type: object
                        rbd:
                          properties:
                            fsType:
                              type: string
                            image:
                              type: string
                            keyring:
                              type: string
                            monitors:
                              items:
                                type: string
                              type: array
                            pool:
                              type: string
                            readOnly:
                              type: boolean
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            user:
                              type: string
                          required:
                          - image
                          - monitors
                          type: object
                        scaleIO:
                          properties:
                            fsType:
                              type: string
                            gateway:
                              type: string
                            protectionDomain:
                              type: string
                            readOnly:
                              type: boolean
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            sslEnabled:
                              type: boolean
                            storageMode:
                              type: string
                            storagePool:
                              type: string
                            system:
                              type: string
                            volumeName:
                              type: string
                          required:
                          - gateway
                          - secretRef
                          - system
                          type: object
                        secret:
                          properties:
                            defaultMode:
                              format: int32
                              type: integer
                            items:
                              items:
                                properties:
                                  key:
                                    type: string
                                  mode:
                                    format: int32
                                    type: integer
                                  path:
                                    type: string
                                required:
                                - key
                                - path
                                type: object
                              type: array
                            optional:
                              type: boolean
                            secretName:
                              type: string
                          type: object
                        storageos:
                          properties:
                            fsType:
                              type: string
                            readOnly:
                              type: boolean
                            secretRef:
                              properties:
                                name:
                                  type: string
                              type: object
                            volumeName:
                              type: string
                            volumeNamespace:
                              type: string
                          type: object
                        vsphereVolume:
                          properties:
                            fsType:
                              type: string
                            storagePolicyID:
                              type: string
                            storagePolicyName:
                              type: string
                            volumePath:
                              type: string
                          required:
                          - volumePath
                          type: object
                      required:
                      - name
                      type: object
                    type: array
                type: object
            required:
            - predictor
            type: object
          status:
            properties:
              address:
                properties:
                  url:
                    type: string
                type: object
              annotations:
                additionalProperties:
                  type: string
                type: object
              components:
                additionalProperties:
                  properties:
                    address:
                      properties:
                        url:
                          type: string
                      type: object
                    grpcUrl:
                      type: string
                    latestCreatedRevision:
                      type: string
                    latestReadyRevision:
                      type: string
                    latestRolledoutRevision:
                      type: string
                    previousRolledoutRevision:
                      type: string
                    restUrl:
                      type: string
                    traffic:
                      items:
                        properties:
                          configurationName:
                            type: string
                          latestRevision:
                            type: boolean
                          percent:
                            format: int64
                            type: integer
                          revisionName:
                            type: string
                          tag:
                            type: string
                          url:
                            type: string
                        type: object
                      type: array
                    url:
                      type: string
                  type: object
                type: object
              conditions:
                items:
                  properties:
                    lastTransitionTime:
                      type: string
                    message:
                      type: string
                    reason:
                      type: string
                    severity:
                      type: string
                    status:
                      type: string
                    type:
                      type: string
                  required:
                  - status
                  - type
                  type: object
                type: array
              modelStatus:
                properties:
                  copies:
                    properties:
                      failedCopies:
                        default: 0
                        type: integer
                      totalCopies:
                        type: integer
                    required:
                    - failedCopies
                    type: object
                  lastFailureInfo:
                    properties:
                      exitCode:
                        format: int32
                        type: integer
                      location:
                        type: string
                      message:
                        type: string
                      modelRevisionName:
                        type: string
                      reason:
                        enum:
                        - ModelLoadFailed
                        - RuntimeUnhealthy
                        - RuntimeDisabled
                        - NoSupportingRuntime
                        - RuntimeNotRecognized
                        - InvalidPredictorSpec
                        type: string
                      time:
                        format: date-time
                        type: string
                    type: object
                  states:
                    properties:
                      activeModelState:
                        default: Pending
                        enum:
                        - ""
                        - Pending
                        - Standby
                        - Loading
                        - Loaded
                        - FailedToLoad
                        type: string
                      targetModelState:
                        default: ""
                        enum:
                        - ""
                        - Pending
                        - Standby
                        - Loading
                        - Loaded
                        - FailedToLoad
                        type: string
                    required:
                    - activeModelState
                    type: object
                  transitionStatus:
                    default: UpToDate
                    enum:
                    - ""
                    - UpToDate
                    - InProgress
                    - BlockedByFailedLoad
                    - InvalidSpec
                    type: string
                required:
                - transitionStatus
                type: object
              observedGeneration:
                format: int64
                type: integer
              url:
                type: string
            type: object
            x-kubernetes-preserve-unknown-fields: true
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

resource "kubectl_manifest" "kubeflow-kserve-crd-servingruntimes" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    controller-gen.kubebuilder.io/version: v0.4.0
  creationTimestamp: null
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: servingruntimes.serving.kserve.io
spec:
  group: serving.kserve.io
  names:
    kind: ServingRuntime
    listKind: ServingRuntimeList
    plural: servingruntimes
    singular: servingruntime
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - jsonPath: .spec.disabled
      name: Disabled
      type: boolean
    - jsonPath: .spec.supportedModelFormats[*].name
      name: ModelType
      type: string
    - jsonPath: .spec.containers[*].name
      name: Containers
      type: string
    - jsonPath: .metadata.creationTimestamp
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
            properties:
              affinity:
                properties:
                  nodeAffinity:
                    properties:
                      preferredDuringSchedulingIgnoredDuringExecution:
                        items:
                          properties:
                            preference:
                              properties:
                                matchExpressions:
                                  items:
                                    properties:
                                      key:
                                        type: string
                                      operator:
                                        type: string
                                      values:
                                        items:
                                          type: string
                                        type: array
                                    required:
                                    - key
                                    - operator
                                    type: object
                                  type: array
                                matchFields:
                                  items:
                                    properties:
                                      key:
                                        type: string
                                      operator:
                                        type: string
                                      values:
                                        items:
                                          type: string
                                        type: array
                                    required:
                                    - key
                                    - operator
                                    type: object
                                  type: array
                              type: object
                            weight:
                              format: int32
                              type: integer
                          required:
                          - preference
                          - weight
                          type: object
                        type: array
                      requiredDuringSchedulingIgnoredDuringExecution:
                        properties:
                          nodeSelectorTerms:
                            items:
                              properties:
                                matchExpressions:
                                  items:
                                    properties:
                                      key:
                                        type: string
                                      operator:
                                        type: string
                                      values:
                                        items:
                                          type: string
                                        type: array
                                    required:
                                    - key
                                    - operator
                                    type: object
                                  type: array
                                matchFields:
                                  items:
                                    properties:
                                      key:
                                        type: string
                                      operator:
                                        type: string
                                      values:
                                        items:
                                          type: string
                                        type: array
                                    required:
                                    - key
                                    - operator
                                    type: object
                                  type: array
                              type: object
                            type: array
                        required:
                        - nodeSelectorTerms
                        type: object
                    type: object
                  podAffinity:
                    properties:
                      preferredDuringSchedulingIgnoredDuringExecution:
                        items:
                          properties:
                            podAffinityTerm:
                              properties:
                                labelSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaceSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaces:
                                  items:
                                    type: string
                                  type: array
                                topologyKey:
                                  type: string
                              required:
                              - topologyKey
                              type: object
                            weight:
                              format: int32
                              type: integer
                          required:
                          - podAffinityTerm
                          - weight
                          type: object
                        type: array
                      requiredDuringSchedulingIgnoredDuringExecution:
                        items:
                          properties:
                            labelSelector:
                              properties:
                                matchExpressions:
                                  items:
                                    properties:
                                      key:
                                        type: string
                                      operator:
                                        type: string
                                      values:
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
                                  type: object
                              type: object
                            namespaceSelector:
                              properties:
                                matchExpressions:
                                  items:
                                    properties:
                                      key:
                                        type: string
                                      operator:
                                        type: string
                                      values:
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
                                  type: object
                              type: object
                            namespaces:
                              items:
                                type: string
                              type: array
                            topologyKey:
                              type: string
                          required:
                          - topologyKey
                          type: object
                        type: array
                    type: object
                  podAntiAffinity:
                    properties:
                      preferredDuringSchedulingIgnoredDuringExecution:
                        items:
                          properties:
                            podAffinityTerm:
                              properties:
                                labelSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaceSelector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                namespaces:
                                  items:
                                    type: string
                                  type: array
                                topologyKey:
                                  type: string
                              required:
                              - topologyKey
                              type: object
                            weight:
                              format: int32
                              type: integer
                          required:
                          - podAffinityTerm
                          - weight
                          type: object
                        type: array
                      requiredDuringSchedulingIgnoredDuringExecution:
                        items:
                          properties:
                            labelSelector:
                              properties:
                                matchExpressions:
                                  items:
                                    properties:
                                      key:
                                        type: string
                                      operator:
                                        type: string
                                      values:
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
                                  type: object
                              type: object
                            namespaceSelector:
                              properties:
                                matchExpressions:
                                  items:
                                    properties:
                                      key:
                                        type: string
                                      operator:
                                        type: string
                                      values:
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
                                  type: object
                              type: object
                            namespaces:
                              items:
                                type: string
                              type: array
                            topologyKey:
                              type: string
                          required:
                          - topologyKey
                          type: object
                        type: array
                    type: object
                type: object
              annotations:
                additionalProperties:
                  type: string
                type: object
              builtInAdapter:
                properties:
                  env:
                    items:
                      properties:
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
                            fieldRef:
                              properties:
                                apiVersion:
                                  type: string
                                fieldPath:
                                  type: string
                              required:
                              - fieldPath
                              type: object
                            resourceFieldRef:
                              properties:
                                containerName:
                                  type: string
                                divisor:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                  x-kubernetes-int-or-string: true
                                resource:
                                  type: string
                              required:
                              - resource
                              type: object
                            secretKeyRef:
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
                      required:
                      - name
                      type: object
                    type: array
                  memBufferBytes:
                    type: integer
                  modelLoadingTimeoutMillis:
                    type: integer
                  runtimeManagementPort:
                    type: integer
                  serverType:
                    type: string
                type: object
              containers:
                items:
                  properties:
                    args:
                      items:
                        type: string
                      type: array
                    command:
                      items:
                        type: string
                      type: array
                    env:
                      items:
                        properties:
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
                              fieldRef:
                                properties:
                                  apiVersion:
                                    type: string
                                  fieldPath:
                                    type: string
                                required:
                                - fieldPath
                                type: object
                              resourceFieldRef:
                                properties:
                                  containerName:
                                    type: string
                                  divisor:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                    x-kubernetes-int-or-string: true
                                  resource:
                                    type: string
                                required:
                                - resource
                                type: object
                              secretKeyRef:
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
                        required:
                        - name
                        type: object
                      type: array
                    envFrom:
                      items:
                        properties:
                          configMapRef:
                            properties:
                              name:
                                type: string
                              optional:
                                type: boolean
                            type: object
                          prefix:
                            type: string
                          secretRef:
                            properties:
                              name:
                                type: string
                              optional:
                                type: boolean
                            type: object
                        type: object
                      type: array
                    image:
                      type: string
                    imagePullPolicy:
                      type: string
                    lifecycle:
                      properties:
                        postStart:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              required:
                              - port
                              type: object
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                          type: object
                        preStop:
                          properties:
                            exec:
                              properties:
                                command:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            httpGet:
                              properties:
                                host:
                                  type: string
                                httpHeaders:
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
                                path:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                                scheme:
                                  type: string
                              required:
                              - port
                              type: object
                            tcpSocket:
                              properties:
                                host:
                                  type: string
                                port:
                                  anyOf:
                                  - type: integer
                                  - type: string
                                  x-kubernetes-int-or-string: true
                              required:
                              - port
                              type: object
                          type: object
                      type: object
                    livenessProbe:
                      properties:
                        exec:
                          properties:
                            command:
                              items:
                                type: string
                              type: array
                          type: object
                        failureThreshold:
                          format: int32
                          type: integer
                        grpc:
                          properties:
                            port:
                              format: int32
                              type: integer
                            service:
                              type: string
                          required:
                          - port
                          type: object
                        httpGet:
                          properties:
                            host:
                              type: string
                            httpHeaders:
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
                            path:
                              type: string
                            port:
                              anyOf:
                              - type: integer
                              - type: string
                              x-kubernetes-int-or-string: true
                            scheme:
                              type: string
                          required:
                          - port
                          type: object
                        initialDelaySeconds:
                          format: int32
                          type: integer
                        periodSeconds:
                          format: int32
                          type: integer
                        successThreshold:
                          format: int32
                          type: integer
                        tcpSocket:
                          properties:
                            host:
                              type: string
                            port:
                              anyOf:
                              - type: integer
                              - type: string
                              x-kubernetes-int-or-string: true
                          required:
                          - port
                          type: object
                        terminationGracePeriodSeconds:
                          format: int64
                          type: integer
                        timeoutSeconds:
                          format: int32
                          type: integer
                      type: object
                    name:
                      type: string
                    ports:
                      items:
                        properties:
                          containerPort:
                            format: int32
                            type: integer
                          hostIP:
                            type: string
                          hostPort:
                            format: int32
                            type: integer
                          name:
                            type: string
                          protocol:
                            default: TCP
                            type: string
                        required:
                        - containerPort
                        type: object
                      type: array
                      x-kubernetes-list-map-keys:
                      - containerPort
                      - protocol
                      x-kubernetes-list-type: map
                    readinessProbe:
                      properties:
                        exec:
                          properties:
                            command:
                              items:
                                type: string
                              type: array
                          type: object
                        failureThreshold:
                          format: int32
                          type: integer
                        grpc:
                          properties:
                            port:
                              format: int32
                              type: integer
                            service:
                              type: string
                          required:
                          - port
                          type: object
                        httpGet:
                          properties:
                            host:
                              type: string
                            httpHeaders:
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
                            path:
                              type: string
                            port:
                              anyOf:
                              - type: integer
                              - type: string
                              x-kubernetes-int-or-string: true
                            scheme:
                              type: string
                          required:
                          - port
                          type: object
                        initialDelaySeconds:
                          format: int32
                          type: integer
                        periodSeconds:
                          format: int32
                          type: integer
                        successThreshold:
                          format: int32
                          type: integer
                        tcpSocket:
                          properties:
                            host:
                              type: string
                            port:
                              anyOf:
                              - type: integer
                              - type: string
                              x-kubernetes-int-or-string: true
                          required:
                          - port
                          type: object
                        terminationGracePeriodSeconds:
                          format: int64
                          type: integer
                        timeoutSeconds:
                          format: int32
                          type: integer
                      type: object
                    resources:
                      properties:
                        limits:
                          additionalProperties:
                            anyOf:
                            - type: integer
                            - type: string
                            pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                            x-kubernetes-int-or-string: true
                          type: object
                        requests:
                          additionalProperties:
                            anyOf:
                            - type: integer
                            - type: string
                            pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                            x-kubernetes-int-or-string: true
                          type: object
                      type: object
                    securityContext:
                      properties:
                        allowPrivilegeEscalation:
                          type: boolean
                        capabilities:
                          properties:
                            add:
                              items:
                                type: string
                              type: array
                            drop:
                              items:
                                type: string
                              type: array
                          type: object
                        privileged:
                          type: boolean
                        procMount:
                          type: string
                        readOnlyRootFilesystem:
                          type: boolean
                        runAsGroup:
                          format: int64
                          type: integer
                        runAsNonRoot:
                          type: boolean
                        runAsUser:
                          format: int64
                          type: integer
                        seLinuxOptions:
                          properties:
                            level:
                              type: string
                            role:
                              type: string
                            type:
                              type: string
                            user:
                              type: string
                          type: object
                        seccompProfile:
                          properties:
                            localhostProfile:
                              type: string
                            type:
                              type: string
                          required:
                          - type
                          type: object
                        windowsOptions:
                          properties:
                            gmsaCredentialSpec:
                              type: string
                            gmsaCredentialSpecName:
                              type: string
                            hostProcess:
                              type: boolean
                            runAsUserName:
                              type: string
                          type: object
                      type: object
                    startupProbe:
                      properties:
                        exec:
                          properties:
                            command:
                              items:
                                type: string
                              type: array
                          type: object
                        failureThreshold:
                          format: int32
                          type: integer
                        grpc:
                          properties:
                            port:
                              format: int32
                              type: integer
                            service:
                              type: string
                          required:
                          - port
                          type: object
                        httpGet:
                          properties:
                            host:
                              type: string
                            httpHeaders:
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
                            path:
                              type: string
                            port:
                              anyOf:
                              - type: integer
                              - type: string
                              x-kubernetes-int-or-string: true
                            scheme:
                              type: string
                          required:
                          - port
                          type: object
                        initialDelaySeconds:
                          format: int32
                          type: integer
                        periodSeconds:
                          format: int32
                          type: integer
                        successThreshold:
                          format: int32
                          type: integer
                        tcpSocket:
                          properties:
                            host:
                              type: string
                            port:
                              anyOf:
                              - type: integer
                              - type: string
                              x-kubernetes-int-or-string: true
                          required:
                          - port
                          type: object
                        terminationGracePeriodSeconds:
                          format: int64
                          type: integer
                        timeoutSeconds:
                          format: int32
                          type: integer
                      type: object
                    stdin:
                      type: boolean
                    stdinOnce:
                      type: boolean
                    terminationMessagePath:
                      type: string
                    terminationMessagePolicy:
                      type: string
                    tty:
                      type: boolean
                    volumeDevices:
                      items:
                        properties:
                          devicePath:
                            type: string
                          name:
                            type: string
                        required:
                        - devicePath
                        - name
                        type: object
                      type: array
                    volumeMounts:
                      items:
                        properties:
                          mountPath:
                            type: string
                          mountPropagation:
                            type: string
                          name:
                            type: string
                          readOnly:
                            type: boolean
                          subPath:
                            type: string
                          subPathExpr:
                            type: string
                        required:
                        - mountPath
                        - name
                        type: object
                      type: array
                    workingDir:
                      type: string
                  required:
                  - name
                  type: object
                type: array
              disabled:
                type: boolean
              grpcDataEndpoint:
                type: string
              grpcEndpoint:
                type: string
              httpDataEndpoint:
                type: string
              imagePullSecrets:
                items:
                  properties:
                    name:
                      type: string
                  type: object
                type: array
              labels:
                additionalProperties:
                  type: string
                type: object
              multiModel:
                type: boolean
              nodeSelector:
                additionalProperties:
                  type: string
                type: object
              protocolVersions:
                items:
                  type: string
                type: array
              replicas:
                type: integer
              storageHelper:
                properties:
                  disabled:
                    type: boolean
                type: object
              supportedModelFormats:
                items:
                  properties:
                    autoSelect:
                      type: boolean
                    name:
                      type: string
                    version:
                      type: string
                  required:
                  - name
                  type: object
                type: array
              tolerations:
                items:
                  properties:
                    effect:
                      type: string
                    key:
                      type: string
                    operator:
                      type: string
                    tolerationSeconds:
                      format: int64
                      type: integer
                    value:
                      type: string
                  type: object
                type: array
              volumes:
                items:
                  properties:
                    awsElasticBlockStore:
                      properties:
                        fsType:
                          type: string
                        partition:
                          format: int32
                          type: integer
                        readOnly:
                          type: boolean
                        volumeID:
                          type: string
                      required:
                      - volumeID
                      type: object
                    azureDisk:
                      properties:
                        cachingMode:
                          type: string
                        diskName:
                          type: string
                        diskURI:
                          type: string
                        fsType:
                          type: string
                        kind:
                          type: string
                        readOnly:
                          type: boolean
                      required:
                      - diskName
                      - diskURI
                      type: object
                    azureFile:
                      properties:
                        readOnly:
                          type: boolean
                        secretName:
                          type: string
                        shareName:
                          type: string
                      required:
                      - secretName
                      - shareName
                      type: object
                    cephfs:
                      properties:
                        monitors:
                          items:
                            type: string
                          type: array
                        path:
                          type: string
                        readOnly:
                          type: boolean
                        secretFile:
                          type: string
                        secretRef:
                          properties:
                            name:
                              type: string
                          type: object
                        user:
                          type: string
                      required:
                      - monitors
                      type: object
                    cinder:
                      properties:
                        fsType:
                          type: string
                        readOnly:
                          type: boolean
                        secretRef:
                          properties:
                            name:
                              type: string
                          type: object
                        volumeID:
                          type: string
                      required:
                      - volumeID
                      type: object
                    configMap:
                      properties:
                        defaultMode:
                          format: int32
                          type: integer
                        items:
                          items:
                            properties:
                              key:
                                type: string
                              mode:
                                format: int32
                                type: integer
                              path:
                                type: string
                            required:
                            - key
                            - path
                            type: object
                          type: array
                        name:
                          type: string
                        optional:
                          type: boolean
                      type: object
                    csi:
                      properties:
                        driver:
                          type: string
                        fsType:
                          type: string
                        nodePublishSecretRef:
                          properties:
                            name:
                              type: string
                          type: object
                        readOnly:
                          type: boolean
                        volumeAttributes:
                          additionalProperties:
                            type: string
                          type: object
                      required:
                      - driver
                      type: object
                    downwardAPI:
                      properties:
                        defaultMode:
                          format: int32
                          type: integer
                        items:
                          items:
                            properties:
                              fieldRef:
                                properties:
                                  apiVersion:
                                    type: string
                                  fieldPath:
                                    type: string
                                required:
                                - fieldPath
                                type: object
                              mode:
                                format: int32
                                type: integer
                              path:
                                type: string
                              resourceFieldRef:
                                properties:
                                  containerName:
                                    type: string
                                  divisor:
                                    anyOf:
                                    - type: integer
                                    - type: string
                                    pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                    x-kubernetes-int-or-string: true
                                  resource:
                                    type: string
                                required:
                                - resource
                                type: object
                            required:
                            - path
                            type: object
                          type: array
                      type: object
                    emptyDir:
                      properties:
                        medium:
                          type: string
                        sizeLimit:
                          anyOf:
                          - type: integer
                          - type: string
                          pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                          x-kubernetes-int-or-string: true
                      type: object
                    ephemeral:
                      properties:
                        volumeClaimTemplate:
                          properties:
                            metadata:
                              type: object
                            spec:
                              properties:
                                accessModes:
                                  items:
                                    type: string
                                  type: array
                                dataSource:
                                  properties:
                                    apiGroup:
                                      type: string
                                    kind:
                                      type: string
                                    name:
                                      type: string
                                  required:
                                  - kind
                                  - name
                                  type: object
                                dataSourceRef:
                                  properties:
                                    apiGroup:
                                      type: string
                                    kind:
                                      type: string
                                    name:
                                      type: string
                                  required:
                                  - kind
                                  - name
                                  type: object
                                resources:
                                  properties:
                                    limits:
                                      additionalProperties:
                                        anyOf:
                                        - type: integer
                                        - type: string
                                        pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                        x-kubernetes-int-or-string: true
                                      type: object
                                    requests:
                                      additionalProperties:
                                        anyOf:
                                        - type: integer
                                        - type: string
                                        pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                        x-kubernetes-int-or-string: true
                                      type: object
                                  type: object
                                selector:
                                  properties:
                                    matchExpressions:
                                      items:
                                        properties:
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                          values:
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
                                      type: object
                                  type: object
                                storageClassName:
                                  type: string
                                volumeMode:
                                  type: string
                                volumeName:
                                  type: string
                              type: object
                          required:
                          - spec
                          type: object
                      type: object
                    fc:
                      properties:
                        fsType:
                          type: string
                        lun:
                          format: int32
                          type: integer
                        readOnly:
                          type: boolean
                        targetWWNs:
                          items:
                            type: string
                          type: array
                        wwids:
                          items:
                            type: string
                          type: array
                      type: object
                    flexVolume:
                      properties:
                        driver:
                          type: string
                        fsType:
                          type: string
                        options:
                          additionalProperties:
                            type: string
                          type: object
                        readOnly:
                          type: boolean
                        secretRef:
                          properties:
                            name:
                              type: string
                          type: object
                      required:
                      - driver
                      type: object
                    flocker:
                      properties:
                        datasetName:
                          type: string
                        datasetUUID:
                          type: string
                      type: object
                    gcePersistentDisk:
                      properties:
                        fsType:
                          type: string
                        partition:
                          format: int32
                          type: integer
                        pdName:
                          type: string
                        readOnly:
                          type: boolean
                      required:
                      - pdName
                      type: object
                    gitRepo:
                      properties:
                        directory:
                          type: string
                        repository:
                          type: string
                        revision:
                          type: string
                      required:
                      - repository
                      type: object
                    glusterfs:
                      properties:
                        endpoints:
                          type: string
                        path:
                          type: string
                        readOnly:
                          type: boolean
                      required:
                      - endpoints
                      - path
                      type: object
                    hostPath:
                      properties:
                        path:
                          type: string
                        type:
                          type: string
                      required:
                      - path
                      type: object
                    iscsi:
                      properties:
                        chapAuthDiscovery:
                          type: boolean
                        chapAuthSession:
                          type: boolean
                        fsType:
                          type: string
                        initiatorName:
                          type: string
                        iqn:
                          type: string
                        iscsiInterface:
                          type: string
                        lun:
                          format: int32
                          type: integer
                        portals:
                          items:
                            type: string
                          type: array
                        readOnly:
                          type: boolean
                        secretRef:
                          properties:
                            name:
                              type: string
                          type: object
                        targetPortal:
                          type: string
                      required:
                      - iqn
                      - lun
                      - targetPortal
                      type: object
                    name:
                      type: string
                    nfs:
                      properties:
                        path:
                          type: string
                        readOnly:
                          type: boolean
                        server:
                          type: string
                      required:
                      - path
                      - server
                      type: object
                    persistentVolumeClaim:
                      properties:
                        claimName:
                          type: string
                        readOnly:
                          type: boolean
                      required:
                      - claimName
                      type: object
                    photonPersistentDisk:
                      properties:
                        fsType:
                          type: string
                        pdID:
                          type: string
                      required:
                      - pdID
                      type: object
                    portworxVolume:
                      properties:
                        fsType:
                          type: string
                        readOnly:
                          type: boolean
                        volumeID:
                          type: string
                      required:
                      - volumeID
                      type: object
                    projected:
                      properties:
                        defaultMode:
                          format: int32
                          type: integer
                        sources:
                          items:
                            properties:
                              configMap:
                                properties:
                                  items:
                                    items:
                                      properties:
                                        key:
                                          type: string
                                        mode:
                                          format: int32
                                          type: integer
                                        path:
                                          type: string
                                      required:
                                      - key
                                      - path
                                      type: object
                                    type: array
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                                type: object
                              downwardAPI:
                                properties:
                                  items:
                                    items:
                                      properties:
                                        fieldRef:
                                          properties:
                                            apiVersion:
                                              type: string
                                            fieldPath:
                                              type: string
                                          required:
                                          - fieldPath
                                          type: object
                                        mode:
                                          format: int32
                                          type: integer
                                        path:
                                          type: string
                                        resourceFieldRef:
                                          properties:
                                            containerName:
                                              type: string
                                            divisor:
                                              anyOf:
                                              - type: integer
                                              - type: string
                                              pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                                              x-kubernetes-int-or-string: true
                                            resource:
                                              type: string
                                          required:
                                          - resource
                                          type: object
                                      required:
                                      - path
                                      type: object
                                    type: array
                                type: object
                              secret:
                                properties:
                                  items:
                                    items:
                                      properties:
                                        key:
                                          type: string
                                        mode:
                                          format: int32
                                          type: integer
                                        path:
                                          type: string
                                      required:
                                      - key
                                      - path
                                      type: object
                                    type: array
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                                type: object
                              serviceAccountToken:
                                properties:
                                  audience:
                                    type: string
                                  expirationSeconds:
                                    format: int64
                                    type: integer
                                  path:
                                    type: string
                                required:
                                - path
                                type: object
                            type: object
                          type: array
                      type: object
                    quobyte:
                      properties:
                        group:
                          type: string
                        readOnly:
                          type: boolean
                        registry:
                          type: string
                        tenant:
                          type: string
                        user:
                          type: string
                        volume:
                          type: string
                      required:
                      - registry
                      - volume
                      type: object
                    rbd:
                      properties:
                        fsType:
                          type: string
                        image:
                          type: string
                        keyring:
                          type: string
                        monitors:
                          items:
                            type: string
                          type: array
                        pool:
                          type: string
                        readOnly:
                          type: boolean
                        secretRef:
                          properties:
                            name:
                              type: string
                          type: object
                        user:
                          type: string
                      required:
                      - image
                      - monitors
                      type: object
                    scaleIO:
                      properties:
                        fsType:
                          type: string
                        gateway:
                          type: string
                        protectionDomain:
                          type: string
                        readOnly:
                          type: boolean
                        secretRef:
                          properties:
                            name:
                              type: string
                          type: object
                        sslEnabled:
                          type: boolean
                        storageMode:
                          type: string
                        storagePool:
                          type: string
                        system:
                          type: string
                        volumeName:
                          type: string
                      required:
                      - gateway
                      - secretRef
                      - system
                      type: object
                    secret:
                      properties:
                        defaultMode:
                          format: int32
                          type: integer
                        items:
                          items:
                            properties:
                              key:
                                type: string
                              mode:
                                format: int32
                                type: integer
                              path:
                                type: string
                            required:
                            - key
                            - path
                            type: object
                          type: array
                        optional:
                          type: boolean
                        secretName:
                          type: string
                      type: object
                    storageos:
                      properties:
                        fsType:
                          type: string
                        readOnly:
                          type: boolean
                        secretRef:
                          properties:
                            name:
                              type: string
                          type: object
                        volumeName:
                          type: string
                        volumeNamespace:
                          type: string
                      type: object
                    vsphereVolume:
                      properties:
                        fsType:
                          type: string
                        storagePolicyID:
                          type: string
                        storagePolicyName:
                          type: string
                        volumePath:
                          type: string
                      required:
                      - volumePath
                      type: object
                  required:
                  - name
                  type: object
                type: array
            required:
            - containers
            type: object
          status:
            type: object
        type: object
    served: true
    storage: true
    subresources: {}
status:
  acceptedNames:
    kind: ""
    plural: ""
  conditions: []
  storedVersions: []
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kserve-crd-trainedmodels" {
  yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    controller-gen.kubebuilder.io/version: v0.4.0
  creationTimestamp: null
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: trainedmodels.serving.kserve.io
spec:
  group: serving.kserve.io
  names:
    kind: TrainedModel
    listKind: TrainedModelList
    plural: trainedmodels
    shortNames:
    - tm
    singular: trainedmodel
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - jsonPath: .status.url
      name: URL
      type: string
    - jsonPath: .status.conditions[?(@.type=='Ready')].status
      name: Ready
      type: string
    - jsonPath: .metadata.creationTimestamp
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
            properties:
              inferenceService:
                type: string
              model:
                properties:
                  framework:
                    type: string
                  memory:
                    anyOf:
                    - type: integer
                    - type: string
                    pattern: ^(\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\+|-)?(([0-9]+(\.[0-9]*)?)|(\.[0-9]+))))?$
                    x-kubernetes-int-or-string: true
                  storageUri:
                    type: string
                required:
                - framework
                - memory
                - storageUri
                type: object
            required:
            - inferenceService
            - model
            type: object
          status:
            properties:
              address:
                properties:
                  url:
                    type: string
                type: object
              annotations:
                additionalProperties:
                  type: string
                type: object
              conditions:
                items:
                  properties:
                    lastTransitionTime:
                      type: string
                    message:
                      type: string
                    reason:
                      type: string
                    severity:
                      type: string
                    status:
                      type: string
                    type:
                      type: string
                  required:
                  - status
                  - type
                  type: object
                type: array
              observedGeneration:
                format: int64
                type: integer
              url:
                type: string
            type: object
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

resource "kubectl_manifest" "kubeflow-kserve-serviceaccount-kserve-controller-manager" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app: kserve
    app.kubernetes.io/instance: kserve-controller-manager
    app.kubernetes.io/managed-by: kserve-controller-manager
    app.kubernetes.io/name: kserve
  name: kserve-controller-manager
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kserve-role-kserve-leader-election-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: kserve-leader-election-role
  namespace: kubeflow
rules:
- apiGroups:
  - coordination.k8s.io
  resources:
  - leases
  verbs:
  - create
  - get
  - list
  - update
- apiGroups:
  - ""
  resources:
  - configmaps
  verbs:
  - get
  - list
  - watch
  - create
  - update
  - patch
  - delete
- apiGroups:
  - ""
  resources:
  - configmaps/status
  verbs:
  - get
  - update
  - patch
- apiGroups:
  - ""
  resources:
  - events
  verbs:
  - create
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kserve-clusterrole-kserve-manager-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  creationTimestamp: null
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: kserve-manager-role
rules:
- apiGroups:
  - admissionregistration.k8s.io
  resources:
  - mutatingwebhookconfigurations
  - validatingwebhookconfigurations
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - apps
  resources:
  - deployments
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - autoscaling
  resources:
  - horizontalpodautoscalers
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - ""
  resources:
  - configmaps
  verbs:
  - create
  - get
  - list
  - update
  - watch
- apiGroups:
  - ""
  resources:
  - events
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
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
  - ""
  resources:
  - pods
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - ""
  resources:
  - serviceaccounts
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - services
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - networking.istio.io
  resources:
  - virtualservices
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - networking.istio.io
  resources:
  - virtualservices/finalizers
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - networking.istio.io
  resources:
  - virtualservices/status
  verbs:
  - get
  - patch
  - update
- apiGroups:
  - networking.k8s.io
  resources:
  - ingresses
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - serving.knative.dev
  resources:
  - services
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - serving.knative.dev
  resources:
  - services/finalizers
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - serving.knative.dev
  resources:
  - services/status
  verbs:
  - get
  - patch
  - update
- apiGroups:
  - serving.kserve.io
  resources:
  - clusterservingruntimes
  - clusterservingruntimes/finalizers
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - serving.kserve.io
  resources:
  - clusterservingruntimes/status
  verbs:
  - get
  - patch
  - update
- apiGroups:
  - serving.kserve.io
  resources:
  - inferencegraphs
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - serving.kserve.io
  resources:
  - inferencegraphs/status
  verbs:
  - get
  - patch
  - update
- apiGroups:
  - serving.kserve.io
  resources:
  - inferenceservices
  - inferenceservices/finalizers
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - serving.kserve.io
  resources:
  - inferenceservices/status
  verbs:
  - get
  - patch
  - update
- apiGroups:
  - serving.kserve.io
  resources:
  - servingruntimes
  - servingruntimes/finalizers
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - serving.kserve.io
  resources:
  - servingruntimes/status
  verbs:
  - get
  - patch
  - update
- apiGroups:
  - serving.kserve.io
  resources:
  - trainedmodels
  verbs:
  - create
  - delete
  - get
  - list
  - patch
  - update
  - watch
- apiGroups:
  - serving.kserve.io
  resources:
  - trainedmodels/status
  verbs:
  - get
  - patch
  - update
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kserve-clusterrole-kserve-proxy-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: kserve-proxy-role
rules:
- apiGroups:
  - authentication.k8s.io
  resources:
  - tokenreviews
  verbs:
  - create
- apiGroups:
  - authorization.k8s.io
  resources:
  - subjectaccessreviews
  verbs:
  - create
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kserve-clusterrole-kubeflow-serve-admin" {
  yaml_body = <<YAML
aggregationRule:
  clusterRoleSelectors:
  - matchLabels:
      rbac.authorization.kubeflow.org/aggregate-to-kubeflow-kserve-admin: "true"
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-admin: "true"
  name: kubeflow-kserve-admin
rules: []
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kserve-clusterrole-kubeflow-kserve-edit" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-edit: "true"
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-kserve-admin: "true"
  name: kubeflow-kserve-edit
rules:
- apiGroups:
  - serving.kserve.io
  resources:
  - inferenceservices
  - servingruntimes
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
  - serving.knative.dev
  resources:
  - services
  - services/status
  - routes
  - routes/status
  - configurations
  - configurations/status
  - revisions
  - revisions/status
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

resource "kubectl_manifest" "kubeflow-kserve-clusterrole-kubeflow-kserve-view" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
    rbac.authorization.kubeflow.org/aggregate-to-kubeflow-view: "true"
  name: kubeflow-kserve-view
rules:
- apiGroups:
  - serving.kserve.io
  resources:
  - inferenceservices
  - servingruntimes
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - serving.knative.dev
  resources:
  - services
  - services/status
  - routes
  - routes/status
  - configurations
  - configurations/status
  - revisions
  - revisions/status
  verbs:
  - get
  - list
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kserve-rolebinding-kserve-leader-election-rolebinding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: kserve-leader-election-rolebinding
  namespace: kubeflow
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: kserve-leader-election-role
subjects:
- kind: ServiceAccount
  name: kserve-controller-manager
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kserve-clusterrolebinding-kserve-manager-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: kserve-manager-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: kserve-manager-role
subjects:
- kind: ServiceAccount
  name: kserve-controller-manager
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kserve-clusterrolebinding-kserve-proxy-rolebinding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: kserve-proxy-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: kserve-proxy-role
subjects:
- kind: ServiceAccount
  name: kserve-controller-manager
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kserve-configmap-inference-service-config" {
  yaml_body = <<YAML
apiVersion: v1
data:
  agent: |-
    {
        "image" : "kserve/agent:v0.10.0",
        "memoryRequest": "100Mi",
        "memoryLimit": "1Gi",
        "cpuRequest": "100m",
        "cpuLimit": "1"
    }
  batcher: |-
    {
        "image" : "kserve/agent:v0.10.0",
        "memoryRequest": "1Gi",
        "memoryLimit": "1Gi",
        "cpuRequest": "1",
        "cpuLimit": "1"
    }
  credentials: |-
    {
       "gcs": {
           "gcsCredentialFileName": "gcloud-application-credentials.json"
       },
       "s3": {
           "s3AccessKeyIDName": "AWS_ACCESS_KEY_ID",
           "s3SecretAccessKeyName": "AWS_SECRET_ACCESS_KEY",
           "s3Endpoint": "",
           "s3UseHttps": "",
           "s3Region": "",
           "s3VerifySSL": "",
           "s3UseVirtualBucket": "",
           "s3UseAnonymousCredential": "",
           "s3CABundle": ""
       }
    }
  deploy: |-
    {
      "defaultDeploymentMode": "Serverless"
    }
  explainers: |-
    {
        "alibi": {
            "image" : "kserve/alibi-explainer",
            "defaultImageVersion": "latest"
        },
        "aix": {
            "image" : "kserve/aix-explainer",
            "defaultImageVersion": "latest"
        },
        "art": {
            "image" : "kserve/art-explainer",
            "defaultImageVersion": "latest"
        }
    }
  ingress: |-
    {
      "ingressGateway": "kubeflow/kubeflow-gateway",
      "ingressService": "istio-ingressgateway.istio-system.svc.cluster.local",
      "localGateway": "knative-serving/knative-local-gateway",
      "localGatewayService": "knative-local-gateway.istio-system.svc.cluster.local",
      "ingressDomain": "example.com",
      "ingressClassName": "istio",
      "domainTemplate": "{{ .Name }}-{{ .Namespace }}.{{ .IngressDomain }}",
      "urlScheme": "http",
      "disableIstioVirtualHost": false
    }
  logger: |-
    {
        "image" : "kserve/agent:v0.10.0",
        "memoryRequest": "100Mi",
        "memoryLimit": "1Gi",
        "cpuRequest": "100m",
        "cpuLimit": "1",
        "defaultUrl": "http://default-broker"
    }
  metricsAggregator: |-
    {
      "enableMetricAggregation": "false",
      "enablePrometheusScraping" : "false"
    }
  router: |-
    {
        "image" : "kserve/router:v0.10.0",
        "memoryRequest": "100Mi",
        "memoryLimit": "1Gi",
        "cpuRequest": "100m",
        "cpuLimit": "1"
    }
  storageInitializer: |-
    {
        "image" : "kserve/storage-initializer:v0.10.0",
        "memoryRequest": "100Mi",
        "memoryLimit": "1Gi",
        "cpuRequest": "100m",
        "cpuLimit": "1",
        "storageSpecSecretName": "storage-config"
    }
kind: ConfigMap
metadata:
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: inferenceservice-config
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kserve-secret-kserve-webhook-server-secret" {
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: kserve-webhook-server-secret
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kserve-service-kserve-controller-manager-metrics-service" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  annotations:
    prometheus.io/port: "8443"
    prometheus.io/scheme: https
    prometheus.io/scrape: "true"
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
    control-plane: kserve-controller-manager
    controller-tools.k8s.io: "1.0"
  name: kserve-controller-manager-metrics-service
  namespace: kubeflow
spec:
  ports:
  - name: https
    port: 8443
    targetPort: https
  selector:
    app: kserve
    app.kubernetes.io/name: kserve
    control-plane: kserve-controller-manager
    controller-tools.k8s.io: "1.0"
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kserve-service-kserve-controller-manager-service" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
    control-plane: kserve-controller-manager
    controller-tools.k8s.io: "1.0"
  name: kserve-controller-manager-service
  namespace: kubeflow
spec:
  ports:
  - port: 8443
    protocol: TCP
    targetPort: https
  selector:
    app: kserve
    app.kubernetes.io/name: kserve
    control-plane: kserve-controller-manager
    controller-tools.k8s.io: "1.0"
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kserve-service-kserve-webhook-server-service" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: kserve-webhook-server-service
  namespace: kubeflow
spec:
  ports:
  - port: 443
    targetPort: webhook-server
  selector:
    app: kserve
    app.kubernetes.io/name: kserve
    control-plane: kserve-controller-manager
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kserve-deployment-kserve-controller-manager" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
    control-plane: kserve-controller-manager
    controller-tools.k8s.io: "1.0"
  name: kserve-controller-manager
  namespace: kubeflow
spec:
  selector:
    matchLabels:
      app: kserve
      app.kubernetes.io/name: kserve
      control-plane: kserve-controller-manager
      controller-tools.k8s.io: "1.0"
  template:
    metadata:
      annotations:
        kubectl.kubernetes.io/default-container: manager
        sidecar.istio.io/inject: "false"
      labels:
        app: kserve
        app.kubernetes.io/name: kserve
        control-plane: kserve-controller-manager
        controller-tools.k8s.io: "1.0"
    spec:
      containers:
      - args:
        - --metrics-addr=127.0.0.1:8080
        - --leader-elect
        command:
        - /manager
        env:
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: SECRET_NAME
          value: kserve-webhook-server-cert
        image: kserve/kserve-controller:v0.10.0
        imagePullPolicy: Always
        name: manager
        ports:
        - containerPort: 9443
          name: webhook-server
          protocol: TCP
        resources:
          limits:
            cpu: 100m
            memory: 300Mi
          requests:
            cpu: 100m
            memory: 200Mi
        securityContext:
          allowPrivilegeEscalation: false
        volumeMounts:
        - mountPath: /tmp/k8s-webhook-server/serving-certs
          name: cert
          readOnly: true
      - args:
        - --secure-listen-address=0.0.0.0:8443
        - --upstream=http://127.0.0.1:8080/
        - --logtostderr=true
        - --v=10
        image: gcr.io/kubebuilder/kube-rbac-proxy:v0.13.1
        name: kube-rbac-proxy
        ports:
        - containerPort: 8443
          name: https
          protocol: TCP
      securityContext:
        runAsNonRoot: true
      serviceAccountName: kserve-controller-manager
      terminationGracePeriodSeconds: 10
      volumes:
      - name: cert
        secret:
          defaultMode: 420
          secretName: kserve-webhook-server-cert
      tolerations:
      - key: "kubeflow"
        operator: "Equal"
        value: "control-plane"
        effect: "NoSchedule"
      nodeSelector:
        kubeflow: control-plane
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-kserve-certificate-serving-cert, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kserve-certificate-serving-cert" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: serving-cert
  namespace: kubeflow
spec:
  commonName: kserve-webhook-server-service.kubeflow.svc
  dnsNames:
  - kserve-webhook-server-service.kubeflow.svc
  issuerRef:
    kind: Issuer
    name: selfsigned-issuer
  secretName: kserve-webhook-server-cert
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-cert-manager-deployment-webhook]
}

resource "kubectl_manifest" "kubeflow-kserve-issuer-selfsigned-issuer" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: selfsigned-issuer
  namespace: kubeflow
spec:
  selfSigned: {}
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace, kubectl_manifest.kubeflow-cert-manager-crd-issuers, kubectl_manifest.kubeflow-cert-manager-deployment-webhook]
}

resource "kubectl_manifest" "kubeflow-kserve-clusterservingruntime-kserve-lgbserver" {
  yaml_body = <<YAML
apiVersion: serving.kserve.io/v1alpha1
kind: ClusterServingRuntime
metadata:
  name: kserve-lgbserver
spec:
  annotations:
    prometheus.kserve.io/path: /metrics
    prometheus.kserve.io/port: "8080"
  containers:
  - args:
    - --model_name={{.Name}}
    - --model_dir=/mnt/models
    - --http_port=8080
    - --nthread=1
    image: kserve/lgbserver:v0.10.0
    name: kserve-container
    resources:
      limits:
        cpu: "1"
        memory: 2Gi
      requests:
        cpu: "1"
        memory: 2Gi
  protocolVersions:
  - v1
  supportedModelFormats:
  - autoSelect: true
    name: lightgbm
    version: "3"
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kserve-crd-clusterservingruntimes, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kserve-clusterservingruntime-kserve-mlserver" {
  yaml_body = <<YAML
apiVersion: serving.kserve.io/v1alpha1
kind: ClusterServingRuntime
metadata:
  name: kserve-mlserver
spec:
  annotations:
    prometheus.kserve.io/path: /metrics
    prometheus.kserve.io/port: "8080"
  containers:
  - env:
    - name: MLSERVER_MODEL_IMPLEMENTATION
      value: '{{.Labels.modelClass}}'
    - name: MLSERVER_HTTP_PORT
      value: "8080"
    - name: MLSERVER_GRPC_PORT
      value: "9000"
    - name: MODELS_DIR
      value: /mnt/models
    image: docker.io/seldonio/mlserver:1.0.0
    name: kserve-container
    resources:
      limits:
        cpu: "1"
        memory: 2Gi
      requests:
        cpu: "1"
        memory: 2Gi
  protocolVersions:
  - v2
  supportedModelFormats:
  - autoSelect: true
    name: sklearn
    version: "0"
  - autoSelect: true
    name: xgboost
    version: "1"
  - autoSelect: true
    name: lightgbm
    version: "3"
  - autoSelect: true
    name: mlflow
    version: "1"
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kserve-crd-clusterservingruntimes, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kserve-clusterservingruntime-kserve-paddleserver" {
  yaml_body = <<YAML
apiVersion: serving.kserve.io/v1alpha1
kind: ClusterServingRuntime
metadata:
  name: kserve-paddleserver
spec:
  annotations:
    prometheus.kserve.io/path: /metrics
    prometheus.kserve.io/port: "8080"
  containers:
  - args:
    - --model_name={{.Name}}
    - --model_dir=/mnt/models
    - --http_port=8080
    image: kserve/paddleserver:v0.10.0
    name: kserve-container
    resources:
      limits:
        cpu: "1"
        memory: 2Gi
      requests:
        cpu: "1"
        memory: 2Gi
  protocolVersions:
  - v1
  supportedModelFormats:
  - autoSelect: true
    name: paddle
    version: "2"
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kserve-crd-clusterservingruntimes, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kserve-clusterservingruntime-kserve-pmmlserver" {
  yaml_body = <<YAML
apiVersion: serving.kserve.io/v1alpha1
kind: ClusterServingRuntime
metadata:
  name: kserve-pmmlserver
spec:
  annotations:
    prometheus.kserve.io/path: /metrics
    prometheus.kserve.io/port: "8080"
  containers:
  - args:
    - --model_name={{.Name}}
    - --model_dir=/mnt/models
    - --http_port=8080
    image: kserve/pmmlserver:v0.10.0
    name: kserve-container
    resources:
      limits:
        cpu: "1"
        memory: 2Gi
      requests:
        cpu: "1"
        memory: 2Gi
  protocolVersions:
  - v1
  supportedModelFormats:
  - autoSelect: true
    name: pmml
    version: "3"
  - autoSelect: true
    name: pmml
    version: "4"
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kserve-crd-clusterservingruntimes, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kserve-clusterservingruntime-kserve-sklearnserver" {
  yaml_body = <<YAML
apiVersion: serving.kserve.io/v1alpha1
kind: ClusterServingRuntime
metadata:
  name: kserve-sklearnserver
spec:
  annotations:
    prometheus.kserve.io/path: /metrics
    prometheus.kserve.io/port: "8080"
  containers:
  - args:
    - --model_name={{.Name}}
    - --model_dir=/mnt/models
    - --http_port=8080
    image: kserve/sklearnserver:v0.10.0
    name: kserve-container
    resources:
      limits:
        cpu: "1"
        memory: 2Gi
      requests:
        cpu: "1"
        memory: 2Gi
  protocolVersions:
  - v1
  supportedModelFormats:
  - autoSelect: true
    name: sklearn
    version: "1"
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kserve-crd-clusterservingruntimes, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kserve-clusterservingruntime-kserve-tensorflow-serving" {
  yaml_body = <<YAML
apiVersion: serving.kserve.io/v1alpha1
kind: ClusterServingRuntime
metadata:
  name: kserve-tensorflow-serving
spec:
  annotations:
    prometheus.kserve.io/path: /metrics
    prometheus.kserve.io/port: "8080"
  containers:
  - args:
    - --model_name={{.Name}}
    - --port=9000
    - --rest_api_port=8080
    - --model_base_path=/mnt/models
    - --rest_api_timeout_in_ms=60000
    command:
    - /usr/bin/tensorflow_model_server
    image: tensorflow/serving:2.6.2
    name: kserve-container
    resources:
      limits:
        cpu: "1"
        memory: 2Gi
      requests:
        cpu: "1"
        memory: 2Gi
  protocolVersions:
  - v1
  - grpc-v1
  supportedModelFormats:
  - autoSelect: true
    name: tensorflow
    version: "1"
  - autoSelect: true
    name: tensorflow
    version: "2"
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kserve-crd-clusterservingruntimes, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kserve-clusterservingruntime-kserve-torchserve" {
  yaml_body = <<YAML
apiVersion: serving.kserve.io/v1alpha1
kind: ClusterServingRuntime
metadata:
  name: kserve-torchserve
spec:
  annotations:
    prometheus.kserve.io/path: /metrics
    prometheus.kserve.io/port: "8082"
  containers:
  - args:
    - torchserve
    - --start
    - --model-store=/mnt/models/model-store
    - --ts-config=/mnt/models/config/config.properties
    env:
    - name: TS_SERVICE_ENVELOPE
      value: '{{.Labels.serviceEnvelope}}'
    image: pytorch/torchserve-kfs:0.7.0
    name: kserve-container
    resources:
      limits:
        cpu: "1"
        memory: 2Gi
      requests:
        cpu: "1"
        memory: 2Gi
  protocolVersions:
  - v1
  - v2
  - grpc-v1
  supportedModelFormats:
  - autoSelect: true
    name: pytorch
    version: "1"
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kserve-crd-clusterservingruntimes, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kserve-clusterservingruntime-kserve-tritonserver" {
  yaml_body = <<YAML
apiVersion: serving.kserve.io/v1alpha1
kind: ClusterServingRuntime
metadata:
  name: kserve-tritonserver
spec:
  annotations:
    prometheus.kserve.io/path: /metrics
    prometheus.kserve.io/port: "8002"
  containers:
  - args:
    - tritonserver
    - --model-store=/mnt/models
    - --grpc-port=9000
    - --http-port=8080
    - --allow-grpc=true
    - --allow-http=true
    image: nvcr.io/nvidia/tritonserver:21.09-py3
    name: kserve-container
    resources:
      limits:
        cpu: "1"
        memory: 2Gi
      requests:
        cpu: "1"
        memory: 2Gi
  protocolVersions:
  - v2
  - grpc-v2
  supportedModelFormats:
  - autoSelect: true
    name: tensorrt
    version: "8"
  - autoSelect: true
    name: tensorflow
    version: "1"
  - autoSelect: true
    name: tensorflow
    version: "2"
  - autoSelect: true
    name: onnx
    version: "1"
  - name: pytorch
    version: "1"
  - autoSelect: true
    name: triton
    version: "2"
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kserve-crd-clusterservingruntimes, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kserve-clusterservingruntime-kserve-xgbserver" {
  yaml_body = <<YAML
apiVersion: serving.kserve.io/v1alpha1
kind: ClusterServingRuntime
metadata:
  name: kserve-xgbserver
spec:
  annotations:
    prometheus.kserve.io/path: /metrics
    prometheus.kserve.io/port: "8080"
  containers:
  - args:
    - --model_name={{.Name}}
    - --model_dir=/mnt/models
    - --http_port=8080
    - --nthread=1
    image: kserve/xgbserver:v0.10.0
    name: kserve-container
    resources:
      limits:
        cpu: "1"
        memory: 2Gi
      requests:
        cpu: "1"
        memory: 2Gi
  protocolVersions:
  - v1
  supportedModelFormats:
  - autoSelect: true
    name: xgboost
    version: "1"
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kserve-crd-clusterservingruntimes, kubectl_manifest.kubeflow-istio-deployment-istiod, kubectl_manifest.kubeflow-istio-mutatingwebhookconfiguration-sidecar-injector]
}

resource "kubectl_manifest" "kubeflow-kserve-mutatingwebhookconfiguration-inferenceservice" {
  yaml_body = <<YAML
apiVersion: admissionregistration.k8s.io/v1
kind: MutatingWebhookConfiguration
metadata:
  annotations:
    cert-manager.io/inject-ca-from: kubeflow/serving-cert
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: inferenceservice.serving.kserve.io
webhooks:
- admissionReviewVersions:
  - v1beta1
  clientConfig:
    caBundle: Cg==
    service:
      name: kserve-webhook-server-service
      namespace: kubeflow
      path: /mutate-serving-kserve-io-v1beta1-inferenceservice
  failurePolicy: Fail
  name: inferenceservice.kserve-webhook-server.defaulter
  rules:
  - apiGroups:
    - serving.kserve.io
    apiVersions:
    - v1beta1
    operations:
    - CREATE
    - UPDATE
    resources:
    - inferenceservices
  sideEffects: None
- admissionReviewVersions:
  - v1beta1
  clientConfig:
    caBundle: Cg==
    service:
      name: kserve-webhook-server-service
      namespace: kubeflow
      path: /mutate-pods
  failurePolicy: Fail
  name: inferenceservice.kserve-webhook-server.pod-mutator
  namespaceSelector:
    matchExpressions:
    - key: control-plane
      operator: DoesNotExist
  objectSelector:
    matchExpressions:
    - key: serving.kserve.io/inferenceservice
      operator: Exists
  rules:
  - apiGroups:
    - ""
    apiVersions:
    - v1
    operations:
    - CREATE
    - UPDATE
    resources:
    - pods
  sideEffects: None
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kserve-validatingwebhookconfiguration-inferencegraph" {
  yaml_body = <<YAML
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  annotations:
    cert-manager.io/inject-ca-from: kubeflow/serving-cert
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: inferencegraph.serving.kserve.io
webhooks:
- admissionReviewVersions:
  - v1beta1
  clientConfig:
    caBundle: Cg==
    service:
      name: kserve-webhook-server-service
      namespace: kubeflow
      path: /validate-serving-kserve-io-v1alpha1-inferencegraph
  failurePolicy: Fail
  name: inferencegraph.kserve-webhook-server.validator
  rules:
  - apiGroups:
    - serving.kserve.io
    apiVersions:
    - v1alpha1
    operations:
    - CREATE
    - UPDATE
    resources:
    - inferencegraphs
  sideEffects: None
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kserve-validatingwebhookconfiguration-inferenceservice" {
  yaml_body = <<YAML
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  annotations:
    cert-manager.io/inject-ca-from: kubeflow/serving-cert
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: inferenceservice.serving.kserve.io
webhooks:
- admissionReviewVersions:
  - v1beta1
  clientConfig:
    caBundle: Cg==
    service:
      name: kserve-webhook-server-service
      namespace: kubeflow
      path: /validate-serving-kserve-io-v1beta1-inferenceservice
  failurePolicy: Fail
  name: inferenceservice.kserve-webhook-server.validator
  rules:
  - apiGroups:
    - serving.kserve.io
    apiVersions:
    - v1beta1
    operations:
    - CREATE
    - UPDATE
    resources:
    - inferenceservices
  sideEffects: None
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kserve-validatingwebhookconfiguration-trainedmodel" {
  yaml_body = <<YAML
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  annotations:
    cert-manager.io/inject-ca-from: kubeflow/serving-cert
  labels:
    app: kserve
    app.kubernetes.io/name: kserve
  name: trainedmodel.serving.kserve.io
webhooks:
- admissionReviewVersions:
  - v1beta1
  clientConfig:
    caBundle: Cg==
    service:
      name: kserve-webhook-server-service
      namespace: kubeflow
      path: /validate-serving-kserve-io-v1alpha1-trainedmodel
  failurePolicy: Fail
  name: trainedmodel.kserve-webhook-server.validator
  rules:
  - apiGroups:
    - serving.kserve.io
    apiVersions:
    - v1alpha1
    operations:
    - CREATE
    - UPDATE
    resources:
    - trainedmodels
  sideEffects: None
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kserve-serviceaccount-kserve-models-web-app" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app: kserve
    app.kubernetes.io/component: kserve-models-web-app
    app.kubernetes.io/name: kserve
    kustomize.component: kserve-models-web-app
  name: kserve-models-web-app
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kserve-clusterrole-kserve-models-web-app-cluster-role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: kserve
    app.kubernetes.io/component: kserve-models-web-app
    app.kubernetes.io/name: kserve
    kustomize.component: kserve-models-web-app
  name: kserve-models-web-app-cluster-role
rules:
- apiGroups:
  - authorization.k8s.io
  resources:
  - subjectaccessreviews
  verbs:
  - create
- apiGroups:
  - ""
  resources:
  - namespaces
  - pods
  - pods/log
  - events
  verbs:
  - get
  - list
- apiGroups:
  - serving.kserve.io
  resources:
  - inferenceservices
  - inferenceservices/status
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
  - serving.knative.dev
  resources:
  - services
  - services/status
  - routes
  - routes/status
  - configurations
  - configurations/status
  - revisions
  - revisions/status
  verbs:
  - get
  - list
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kserve-clusterrolebinding-kserve-models-web-app-binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app: kserve
    app.kubernetes.io/component: kserve-models-web-app
    app.kubernetes.io/name: kserve
    kustomize.component: kserve-models-web-app
  name: kserve-models-web-app-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: kserve-models-web-app-cluster-role
subjects:
- kind: ServiceAccount
  name: kserve-models-web-app
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool]
}

resource "kubectl_manifest" "kubeflow-kserve-configmap-kserve-models-web-app-config" {
  yaml_body = <<YAML
apiVersion: v1
data:
  APP_PREFIX: /kserve-endpoints
  USERID_HEADER: kubeflow-userid
kind: ConfigMap
metadata:
  labels:
    app: kserve
    app.kubernetes.io/component: kserve-models-web-app
    app.kubernetes.io/name: kserve
    kustomize.component: kserve-models-web-app
  name: kserve-models-web-app-config
  namespace: kubeflow
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kserve-service-kserve-models-web-app" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  labels:
    app: kserve
    app.kubernetes.io/component: kserve-models-web-app
    app.kubernetes.io/name: kserve
    kustomize.component: kserve-models-web-app
  name: kserve-models-web-app
  namespace: kubeflow
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 5000
  selector:
    app: kserve
    app.kubernetes.io/component: kserve-models-web-app
    app.kubernetes.io/name: kserve
    kustomize.component: kserve-models-web-app
  type: ClusterIP
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kserve-deployment-kserve-models-web-app" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: kserve
    app.kubernetes.io/component: kserve-models-web-app
    app.kubernetes.io/name: kserve
    kustomize.component: kserve-models-web-app
  name: kserve-models-web-app
  namespace: kubeflow
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kserve
      app.kubernetes.io/component: kserve-models-web-app
      app.kubernetes.io/name: kserve
      kustomize.component: kserve-models-web-app
  template:
    metadata:
      annotations:
        sidecar.istio.io/inject: "true"
      labels:
        app: kserve
        app.kubernetes.io/component: kserve-models-web-app
        app.kubernetes.io/name: kserve
        kustomize.component: kserve-models-web-app
    spec:
      containers:
      - envFrom:
        - configMapRef:
            name: kserve-models-web-app-config
        image: kserve/models-web-app:v0.10.0
        imagePullPolicy: Always
        livenessProbe:
          failureThreshold: 3
          httpGet:
            path: /healthz/liveness
            port: http
          initialDelaySeconds: 0
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 1
        name: kserve-models-web-app
        ports:
        - containerPort: 5000
          name: http
        readinessProbe:
          failureThreshold: 3
          httpGet:
            path: /healthz/readiness
            port: http
          initialDelaySeconds: 0
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 1
      serviceAccountName: kserve-models-web-app
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

resource "kubectl_manifest" "kubeflow-kserve-virtualservice-kserve-models-web-app" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  labels:
    app: kserve
    app.kubernetes.io/component: kserve-models-web-app
    app.kubernetes.io/name: kserve
    kustomize.component: kserve-models-web-app
  name: kserve-models-web-app
  namespace: kubeflow
spec:
  gateways:
  - kubeflow/kubeflow-gateway
  hosts:
  - '*'
  http:
  - match:
    - uri:
        prefix: /kserve-endpoints/
    rewrite:
      uri: /
    route:
    - destination:
        host: kserve-models-web-app.kubeflow.svc.cluster.local
        port:
          number: 80
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}

resource "kubectl_manifest" "kubeflow-kserve-authorizationpolicy-kserve-models-web-app" {
  yaml_body = <<YAML
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  labels:
    app: kserve
    app.kubernetes.io/component: kserve-models-web-app
    app.kubernetes.io/name: kserve
    kustomize.component: kserve-models-web-app
  name: kserve-models-web-app
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
      app: kserve
      app.kubernetes.io/component: kserve-models-web-app
      app.kubernetes.io/name: kserve
      kustomize.component: kserve-models-web-app
YAML

depends_on = [ovh_cloud_project_kube.ovh_kube_cluster, ovh_cloud_project_kube_nodepool.control_plane_pool, kubectl_manifest.kubeflow-kubeflow-namespace]
}