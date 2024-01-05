## Create and push an image to a MRS

### Set up

  - Install the Docker CLI

### Demo

  - set the environment variables:

```bash
# OVHcloud provider needed keys
export PRIVATE_REGISTRY_URL="xxx"
export PRIVATE_REGISTRY_USER="xxx"
export PRIVATE_REGISTRY_PASSWORD="xxx"
export PRIVATE_REGISTRY_PROJECT="xxx"
export PRIVATE_REGISTRY_URL_WITHOUT_SCHEME=${PRIVATE_REGISTRY_URL#*//}
```

  - Login to the private registry

```bash
docker login $PRIVATE_REGISTRY_URL -u $PRIVATE_REGISTRY_USER -p $PRIVATE_REGISTRY_PASSWORD
```

  - Build, tag and push the image for the local platform

```bash
docker build -t $PRIVATE_REGISTRY_URL_WITHOUT_SCHEME/$PRIVATE_REGISTRY_PROJECT/hello-ovh:1.0.0 . --push
```

  - Run your image locally

```bash
docker run -d -p 8080:80 $PRIVATE_REGISTRY_URL_WITHOUT_SCHEME/$PRIVATE_REGISTRY_PROJECT/hello-ovh:1.0.0 
```

  - Test your image is running

```bash
curl localhost:8080
```

  - Build, tag and push the image (for linux/amd64 / target Kubernetes's nodes)

```bash
docker buildx build --platform linux/amd64 -t $PRIVATE_REGISTRY_URL_WITHOUT_SCHEME/$PRIVATE_REGISTRY_PROJECT/hello-ovh:1.0.0-linuxamd64 . --push
```

### Known issue

```bash
$ docker run -d -p 8080:80 $PRIVATE_REGISTRY_URL_WITHOUT_SCHEME/$PRIVATE_REGISTRY_PROJECT/hello-ovh:1.0.0
81f6fbef287b2bb35a7943e53d5f4a842b30db6333adb0c947a9dfb45b7ebed7
docker: Error response from daemon: driver failed programming external connectivity on endpoint condescending_jennings (fd17e83da8145b0e152a24fa1bf5075950b0d80fcc25ca5838d59f35401d4ee4): Bind for 0.0.0.0:8080 failed: port is already allocated.
```

Solution:

docker container ls
docker container stop <containr_id>
docker containr rm <container_id>
