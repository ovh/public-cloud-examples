## Cluster autoscaler

### General information
 - 🔗 https://help.ovhcloud.com/csm/fr-public-cloud-kubernetes-cluster-autoscaler-example?id=kb_article_view&sysparm_article=KB0054914
 - 🔗 https://help.ovhcloud.com/csm/fr-public-cloud-kubernetes-configure-cluster-autoscaler?id=kb_article_view&sysparm_article=KB0054929

### Set up
 - create a MKS cluster with activated autoscaler:
   - name: whatever you want
   - flavor: D2-4 (for example)
   - autoscaling set to `true` with a node pool with 1 node minimum and 10 maximum
   - set the _kubeconfig_ file in the `KUBECONFIG` environment variable: `export KUBECONFIG=...`
 - if needed, build the heavy CPU load image:
   - `docker build -t <your-organisation>/python-cpu-load:1.0.0 .`, for example `docker build -t ovhcom/python-cpu-load:1.0.0 .`

### Demo
  - display the cluster information: `kubectl cluster-info`
  - display the nodepool information: `kubectl get nodepools`:
    - _AUTOSCALED_ to `true`
    - _DESIRED_ to `1`
    - _CURRENT_ to `1`
    - _UP-TO-DATE_ to `1`
    - _AVAILABLE_ to `1`      
  - optional, to scale down quicker you can decrease the thinking time to 2 mins: `kubectl patch nodepool <node name> --type="merge" --patch='{"spec": {"autoscaling": {"scaleDownUnneededTimeSeconds": 120}}}'`
  - create a namespace: `kubectl create ns cluster-autoscaler`
  - apply the [cpu-load.yaml](cpu-load.yaml) manifest: `kubectl apply -f cpu-load.yml -n cluster-autoscaler`
  - display the created pods: `kubectl get pods -n cluster-autoscaler -w` (or use [k9s](https://k9scli.io/) 😉)
  - display the nodepools information: `kubectl get nodepools`
  - display the nodes information: `kubectl get nodes -o wide`
  - increase the replicas to 10 and watch the pods and the nodepools:
    - `kubectl scale --replicas=10 deploy/python-cpu-load -n cluster-autoscaler`
    - `kubectl get pods -n cluster-autoscaler -w`
    - `kubectl get nodepools`
  - downsize the replicas to 3 and watch the pods and the nodepools (⚠️ the effective deletion occurs after 10 mins ⚠️):
    - `kubectl scale --replicas=3 deploy/python-cpu-load -n cluster-autoscaler`
    - `kubectl get pods -n cluster-autoscaler -w`
    - `kubectl get nodepools`
  - delete the deployment: `kubectl delete -f cpu-load.yml -n cluster-autoscaler`
  - delete the namespace: `kubectl delete ns cluster-autoscaler`
  - if needed delete the nodepool / cluster.