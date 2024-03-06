## Instructions to create the job for AI Training

### General information
  - 🔗 [AI Deploy - Tutorial - Create an application to play rock paper scissors with YoloV8](https://help.ovhcloud.com/csm/en-ie-public-cloud-ai-deploy-rock-paper-scissors?id=kb_article_view&sysparm_article=KB0060262)

### Set up
  - install `ovhai` CLI, see [documentation](https://help.ovhcloud.com/csm/en-gb-public-cloud-ai-cli-install-client?id=kb_article_view&sysparm_article=KB0047844)
  - we assume that you have an S3 bucket named `rock-paper-scissors` with all needed data from the demo Create a Notebook to [play to rock/paper/scissors](../../notebooks/YOLOV8/)

### Image build for AI Deploy

    - build the image: `docker build . -t ovhcom/rock-paper-scissors-deploy-app:1.0.0`
    - push the image in the registry: `docker push ovhcom/rock-paper-scissors-deploy-app:1.0.0`

### Deploy the application with AI Deploy

 - run the app with AI App:
```bash
ovhai app run \
    --name rock-paper-scissors-app \
    --cpu 1 \
    --default-http-port 8501 \
    --volume rock-paper-scissors-data@S3GRA/:/workspace/data:RW:cache \
    --unsecure-http \
    rock-paper-scissors-deploy-app:1.0.0
```

You can follow the training with the logs: `ovhai app logs -f <job id>`