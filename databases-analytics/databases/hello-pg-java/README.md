## Deploy a Quarkus application to access to DBaaS

### General information
 - 🔗 [Getting started with Kubernetes database operator](https://help.ovhcloud.com/csm/en-gb-public-cloud-databases-database-operator?id=kb_article_view&sysparm_article=KB0058469)
 - 🔗 [Using the OVHcloud Managed Kubernetes LoadBalancer](https://help.ovhcloud.com/csm/en-gb-public-cloud-kubernetes-using-lb?id=kb_article_view&sysparm_article=KB0050007)
 - 🔗 [OVH token generation page](https://www.ovh.com/auth/api/createToken?GET=/*&POST=/*&PUT=/*&DELETE=/*)
 - 🔗 [Quarkus](https://quarkus.io/)

### Set up
  - A JDK (at least 21)
  - A database, see demo [postgresql-tf](../postgresql-tf/) to create it
  - Get and set the credentials from the OVHCloud Public Cloud project:
    - `application_key` ➡️ `OVH_APPLICATION_KEY`
    - `application_secret` ➡️ `OVH_APPLICATION_SECRET`
    - `consumer_key` ➡️ `OVH_CONSUMER_KEY`
    - `ovh_endpoint` ➡️ `OVH_ENDPOINT`
  - Get and set the `service_name` (Public Cloud project ID) ➡️ `OVH_CLOUD_PROJECT_SERVICE`
  - Get and set the `serviceId` of the database ➡️ `$DB_ID`
  - Get and set the database information:
    - DB's URL ➡️ `DB_URL`
    - DB's port ➡️ `DB_PORT`
    - DB's username ➡️ `DB_USERNAME`
    - DB's password ➡️ `DB_PASSWORD`

### Demo
  - if needed build the image:
    - `mvn clean package` to create the jar
    - build the image: `docker build -f src/main/docker/Dockerfile.jvm -t ovhcom/hello-pg-java:1.0.0 .` (⚠️ Change the tag corresponding to the app version you build ⚠️)
    - after login to your registry, push the image `docker push ovhcom/hello-pg-java:1.0.0`
  - create the namespace `hello-pg-java`: `kubectl create ns hello-pg-java`
  - deploy the Quarkus app: `envsubst < src/main/kubernetes/deploy-app.yml | kubectl apply -n hello-pg-java -f -`, ⚠️ Note the use of `envsubst` to use local environment variable when you run `kubectl apply` command. Of course you can (should?) use _configmap_, _secret_, _helm_, _kustomize_,... to manage this kind of data.
  - the app is deployed but there is an error in the Quarkus app: `Could not obtain connection to query metadata: java.sql.SQLException: Acquisition timeout while waiting for new connection`
    - the reason: you need to whitelist the MKS node IP to enable the Quarkus app access to the DB
  - create the namespace `ovhcloud`: `kubectl create ns ovhcloud`
  - install the operator with helm: 
```bash
    helm install --set ovhCredentials.applicationKey=$OVH_APPLICATION_KEY \
                 --set ovhCredentials.applicationSecret=$OVH_APPLICATION_SECRET \
                 --set ovhCredentials.consumerKey=$OVH_CONSUMER_KEY \
                 --set ovhCredentials.region=$OVH_ENDPOINT \
                 public-cloud-databases-operator \
                 oci://registry-1.docker.io/ovhcom/public-cloud-databases-operator \
                 --version 0.1.3 \
                 --namespace ovhcloud
```
  - apply the CR: `envsubst < src/main/kubernetes/db-cr.yml | kubectl apply -n ovhcloud -f -`  
  - if needed, delete the pod to force restarting: `kubectl delete pod $(kubectl get pods -l app=quarkus -n hello-pg-java -o jsonpath='{.items[0].metadata.name}') -n hello-pg-java`
  - get the app root URL: `export APP_URL=$(kubectl get svc quarkus-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}' -n hello-pg-java)`
  - test the app: `curl http://$APP_URL/heys`


### After the demo
  - delete the app: `kubectl delete -f ./src/main/kubernetes/deploy-app.yml -n hello-pg-java`
  - delete the CR: `kubectl delete -f ./src/main/kubernetes/db-cr.yml`
  - uninstall the operator: `helm delete public-cloud-databases-operator -n ovhcloud`
  - delete the namespaces: `kubectl delete ns ovhcloud hello-pg-java`
  - if needed delete the token with https://api.ovh.com/console-preview/?section=%2Fme&branch=v1#delete-/me/api/credential/-credentialId-
