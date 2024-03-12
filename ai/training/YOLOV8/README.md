## Instructions to create the job for AI Training

### General information
  - 🔗 [AI Training - Tutorial - Train YOLOv8 to play to "rock paper scissors](https://help.ovhcloud.com/csm/en-ie-public-cloud-ai-training-train-rock-paper-scissors?id=kb_article_view&sysparm_article=KB0060296)

### Set up
  - install `ovhai` CLI, see [documentation](https://help.ovhcloud.com/csm/en-gb-public-cloud-ai-cli-install-client?id=kb_article_view&sysparm_article=KB0047844)
  - we assume that you have an S3 bucket named `rock-paper-scissors` with all needed data from the demo Create a Notebook to [play to rock/paper/scissors](../../notebooks/YOLOV8/)

### Image build for AI Training

	- build the image with the Python script: `docker build . -t ovhcom/rock-paper-scissors-training-job:1.0.0`
	- push the image to the registry: `docker push ovhcom/rock-paper-scissors-training-job:1.0.0`

### AI Training Job creation 

Use the CLI to create the Job:
```bash
ovhai job run \
	--name rock-paper-scissors-training-job \
	--gpu 1 \
	--env NB_OF_EPOCHS=50 \
  --volume rock-paper-scissors-data@S3GRA/:/workspace/data:RW:cache \
	--unsecure-http \
	ovhcom/rock-paper-scissors-training-job:1.0.0
```

You can follow the training with the logs: `ovhai job logs -f <job id>`