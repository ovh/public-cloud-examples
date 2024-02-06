The 101 AI hands on can be used with a CDE like Gitpod.  
This folder contains the docker file used.

As an example, here is a process to be used with OVHcloud Managed Private Registry.  
To create and use an image in that case, you can read the [dedicated documentation](https://help.ovhcloud.com/csm/en-gb-public-cloud-private-registry-create-private-image?id=kb_article_view&sysparm_article=KB0050337)

1. login into your registry  
   `docker login [YOUR_PRIVATE_REGISTRY_URL]`  
   as an example something like  
   `docker login https://bdmxla3s.gra7.container-registry.ovh.net/`

2. run the command to build the image from this folder
   `docker build --tag [YOUR_PRIVATE_REGISTRY_URL]/[YOUR_PROJECT]/[YOUR IMAGE NAME]:[YOUR VERSION] .`  
   as an example something like  
   `docker build --tag bdmxla3s.gra7.container-registry.ovh.net/workshop_ia/101_ia:1.2.2 .`

3. push this image to a registry  
   `docker push [YOUR_PRIVATE_REGISTRY_URL]/[YOUR_PROJECT]/[YOUR IMAGE NAME]:[YOUR VERSION]`  
   as an example something like  
   `docker push bdmxla3s.gra7.container-registry.ovh.net/workshop_ia/101_ia:1.2.2`

4. modify the .gitpod.yml file to use this image
