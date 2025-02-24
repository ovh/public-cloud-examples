## Instructions to create the job for AI Training

### General information
  - 🔗 [AI Training - Tutorial - Train YOLO to play to "rock paper scissors](https://help.ovhcloud.com/csm/en-ie-public-cloud-ai-training-train-rock-paper-scissors?id=kb_article_view&sysparm_article=KB0060296)

### Set up
  - install `ovhai` CLI, see [documentation](https://help.ovhcloud.com/csm/en-gb-public-cloud-ai-cli-install-client?id=kb_article_view&sysparm_article=KB0047844)
  - we assume that you have an S3* compatible bucket named `rock-paper-scissors` with all needed data from the demo Create a Notebook to [play to rock/paper/scissors](../../rock-paper-scissors/notebooks/rock-paper-scissors.ipynb)

### Image build for AI Training

	- build the image with the Python script: `docker build . -t <Shared Docker Registries>/rock-paper-scissors-training-job:1.0.0`
	- push the image to the registry: `docker push <Shared Docker Registries>/rock-paper-scissors-training-job:1.0.0`

> ℹ️ see the [documentation](https://help.ovhcloud.com/csm/fr-public-cloud-ai-manage-registries?id=kb_article_view&sysparm_article=KB0057958) for more information about the _Shared Docker Registries_ ℹ️

### AI Training Job creation 

Use the CLI to create the Job:
```bash
ovhai job run \
	--name rock-paper-scissors-training-job \
	--gpu 1 \
	--env NB_OF_EPOCHS=50 \
  --volume rock-paper-scissors-data@S3GRA/:/workspace/data:RW:cache \
	--unsecure-http \
	<Shared Docker Registries>/rock-paper-scissors-training-job:1.0.0
```

You can follow the training with the logs: `ovhai job logs -f <job id>`

**\***: S3 is a trademark of Amazon Technologies, Inc. OVHcloud’s service is not sponsored by, endorsed by, or otherwise affiliated with Amazon Technologies, Inc.