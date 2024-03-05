## Deploy a Quarkus application to access to DBaaS

### General information
 - 🔗 [Getting started with Kubernetes database operator](https://help.ovhcloud.com/csm/en-gb-public-cloud-databases-database-operator?id=kb_article_view&sysparm_article=KB0058469)
 - 🔗 [Using the OVHcloud Managed Kubernetes LoadBalancer](https://help.ovhcloud.com/csm/en-gb-public-cloud-kubernetes-using-lb?id=kb_article_view&sysparm_article=KB0050007)
 - 🔗 [OVH token generation page](https://www.ovh.com/auth/api/createToken?GET=/*&POST=/*&PUT=/*&DELETE=/*)
 - 🔗 [Quarkus](https://quarkus.io/)


### Set up
  - A JDK (at least 17)
  - Get the credentials from the OVHCloud Public Cloud project:
    - `application_key`
    - `application_secret`
    - `consumer_key`
  - Get the `service_name` (Public Cloud project ID)

### Demo
  - if needed build the image:
    - `mvn clean package` to create the jar
    - build the image: `docker build -f src/main/docker/Dockerfile.jvm -t ovhcom/hello-pg-java:1.0.0 .` (⚠️ Change the tag corresponding to the app version you build ⚠️)
    - after login to your registry, push the image `docker push ovhcom/hello-pg-java:1.0.0`
  - copy [_deploy-app.yml](./src/main/kubernetes/_template/_deploy-app.yml) template file to `src/main/kubernetes` and rename it `deploy-app.yml`
  - update the `deploy-app.yml` with the DB credentials:
    - replace the placeholder for each environment variables: `<your DB username>`, `<your DB password>`, `<your DB URL>` and `<your DB port>`
    - replace the placeholder for registry credential: `<your base 64 encoded docker JSON configuration file>`. ⚠️ To create this value you have to base64 encode your ` ~/.docker/config.json` file ⚠️ (`base64 -i ~/.docker/config.json`)
  - create the namespace `hello-pg`: `kubectl create ns hello-pg`
  - deploy the Quarkus app: `kubectl apply -f src/main/kubernetes/deploy-app.yml -n hello-pg`
  - the app is deployed but there error in the Quarkus app: `Could not obtain connection to query metadata: java.sql.SQLException: Acquisition timeout while waiting for new connection`
    - the reason: you need to whitelist the MKS node IP to enable the Quarkus app access to the DB
  - copy the [_db-operator-values.yml](./src/main/kubernetes/_template/_db-operator-values.yml) template file to `./src/main/kubernetes` and rename it `db-operator-values.yml`
  - replace the placeholders `<your_application_key>`, `<your_application_secret>` and `<your_consumer_key>`
  - create the namespace `ovhcloud`: `kubectl create ns ovhcloud`
  - install the operator with helm: `helm install -f ./src/main/kubernetes/db-operator-values.yml public-cloud-databases-operator oci://registry-1.docker.io/ovhcom/public-cloud-databases-operator --version 0.1.1`
  - copy the [src/main/kubernetes/_template/_db-cr.yml](./src/main/kubernetes/_template/_db-cr.yml) template to `src/main/kubernetes/` and rename it `db-cr.yml`
  - replace the placeholders `<public cloud project ID>` and `<database ID>`
  - apply the CR: `kubectl apply -f src/main/kubernetes/db-cr.yml`
  - delete the Quarkus app: `kubectl delete -f ./src/main/kubernetes/deploy-app.yml -n hello-pg`
  - redeploy the app: `kubectl apply -f src/main/kubernetes/deploy-app.yml -n hello-pg`
  - test the app: `curl http://<public IP>/heys`
### After the demo
  - delete the app: `kubectl delete -f ./src/main/kubernetes/deploy-app.yml -n hello-pg`
  - delete the CR: `kubectl delete -f ./src/main/kubernetes/db-cr.yml`
  - uninstall the operator: `helm delete public-cloud-databases-operator`
  - delete the namespaces: `kubectl delete ns ovhcloud hello-pg`
  - if needed delete the token with https://api.ovh.com/console-preview/?section=%2Fme&branch=v1#delete-/me/api/credential/-credentialId-
