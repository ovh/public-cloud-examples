## Instructions to use the JupyterLab Notebook to create a model

### General information
  - 🔗 [AI Notebooks - Tutorial - Train YOLO to play rock paper scissors](https://help.ovhcloud.com/csm/en-gb-public-cloud-ai-notebooks-tuto-rock-paper-scissors?id=kb_article_view&sysparm_article=KB0060272)
  - 🔗 [Rock Paper Scissors dataset](https://universe.roboflow.com/roboflow-58fyf/rock-paper-scissors-sxsw)

### Set up
  - install `ovhai` CLI, see [documentation](https://help.ovhcloud.com/csm/en-gb-public-cloud-ai-cli-install-client?id=kb_article_view&sysparm_article=KB0047844)
  - create an S3* compatible bucket named `rock-paper-scissors` ⚠️ This step is optional, this is more convenient to use the data with other demos or OVHcloud products ⚠️
  - create an account on (roboflow)[https://universe.roboflow.com]

#### AI Notebook with JupyterLab
  - create a notebook with the following command:
```bash
ovhai notebook run conda jupyterlab \
          --name rock-paper-scissors \
          --framework-version conda-py311-cudaDevel11.8 \
          --gpu 1 \
          --volume rock-paper-scissors-data@S3GRA/:/workspace/data:RW:cache \
          --volume https://github.com/ovh/public-cloud-examples.git:/workspace/public-cloud-examples:RW \
          --unsecure-http
```
  - display your notebook URL and open it: `ovhai notebook list`
  - in the notebook's files explorer go to `public-cloud-examples/ai/rock-paper-scissors/notebooks` and open `rock-paper-scissors.ipynb` file
  - follow the steps in the notebook
  - stop the Notebook if needed

  **\***: S3 is a trademark of Amazon Technologies, Inc. OVHcloud’s service is not sponsored by, endorsed by, or otherwise affiliated with Amazon Technologies, Inc.