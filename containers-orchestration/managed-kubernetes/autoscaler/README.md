## Cluster autoscaler

### General information
 - 🔗 https://help.ovhcloud.com/csm/fr-public-cloud-kubernetes-cluster-autoscaler-example?id=kb_article_view&sysparm_article=KB0054914
 - 🔗 https://help.ovhcloud.com/csm/fr-public-cloud-kubernetes-configure-cluster-autoscaler?id=kb_article_view&sysparm_article=KB0054929

### Set up
 - create a mks with activated autoscaler:
   - name: whatever you want
   - flavor: D2-4
   - autoscalling set to `true` with 1 node pool as min and 10 as max
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
  - create a namespace: `kubectl create ns cluster-autoscaler`
  - apply the [cpu-load.yaml](cpu-load.yaml) manifest: `kubectl apply -f cpu-load.yml -n cluster-autoscaler`
  - display the created pods: `kubectl get pods -n cluster-autoscaler -w` (or use [k9s](https://k9scli.io/) 😉)
  - display the nodepools information: `kubectl get nodepools`
  - increase the replicas to 10 and watch the pods and the nodepools:
    - `kubectl patch deployment python-cpu-load --type="merge" --patch='{"spec": {"replicas": 10}}' -n cluster-autoscaler`
    - `kubectl get pods -n cluster-autoscaler -w`
    - `kubectl get nodepools`
  - downsize the replicas to 3 and watch the pods and the nodepools (⚠️ the effective deletion occurs after 10 mins ⚠️):
    - `kubectl patch deployment python-cpu-load --type="merge" --patch='{"spec": {"replicas": 3}}' -n cluster-autoscaler`
    - `kubectl get pods -n cluster-autoscaler -w`
    - `kubectl get nodepools`
  - delete the deployment: `kubectl delete -f cpu-load.yml -n cluster-autoscaler`
  - delete the namespace: `kubectl delete ns cluster-autoscaler`
  - if needed delete the nodepool / cluster.