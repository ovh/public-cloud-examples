# 🎯 What is the goals of this example ? 🎯

This example show you how it's very simple to fine tune a LLM with the [axolotl](https://docs.axolotl.ai/) Framework and OVHcloud [Machine Learning Services](https://www.ovhcloud.com/fr/public-cloud/ai-machine-learning/).

## 📚 Prerequisites 📚

 - An OVHcloud [public cloud project created](https://help.ovhcloud.com/csm/en-ie-public-cloud-compute-essential-information?id=kb_article_view&sysparm_article=KB0050387)
 - An OVHcloud [AI Endpoints valid API Key](https://help.ovhcloud.com/csm/en-ie-public-cloud-ai-endpoints-getting-started?id=kb_article_view&sysparm_article=KB0065398) stored in an environment variable named `OVH_AI_ENDPOINTS_ACCESS_TOKEN`
 - A valid AI Endpoint model URL stored in an environment variable named `OVH_AI_ENDPOINTS_MODEL_URL`
 - A valid AI Endpoint model name stored in an environment variable named `OVH_AI_ENDPOINTS_MODEL_NAME`
 - A [Hugging Face](https://huggingface.co/) account with a valid API Key
 - Optional: 
  - a valid Python installation
  - a valid Docker installation

## 💬 The chatbot 🤖

To test the created models, you can use the chatbot in the [chatbot](./chatbot) folder.
**⚠️ It's a simple chatbot to tests purpose only, not for real production 😉 ⚠️**

The chatbot is packaged with Docker and can be built with the provided [Dockerfile](./chatbot/Dockerfile): `cd ./chatbot && docker buildx build --platform="linux/amd64"  -t <id>/fine-tune-chatbot:1.0.0 .`
You can run the chatbot using:
  - your local Python installation: `cd ./chatbot && pip install -r requirements.txt && python ./chatbot/chatbot.py`
  - your local Docker installation: `cd ./chatbot && docker run -p 7860:7860 <id>/fine-tune-chatbot:1.0.0 .`
  - using [OVHcloud AI Deploy](https://www.ovhcloud.com/fr/public-cloud/ai-deploy/):
```bash
ovhai app run \
    --name fine-tune-chatbot \
    --cpu 1 \
    --default-http-port 7860 \
    --env OVH_AI_ENDPOINTS_ACCESS_TOKEN=$OVH_AI_ENDPOINTS_ACCESS_TOKEN \
    --unsecure-http \
    my-id/fine-tune-chatbot:1.0.0
```

And you can access the chatbot by navigating to `http://127.0.0.1:8080` or using the public URL provided by OVHcloud AI Deploy.

## 📚 The data generation 📚

To train the model you need data.
Data are generated from the OVHcloud AI Endpoints [official documentation](https://help.ovhcloud.com/csm/en-gb-documentation-public-cloud-ai-and-machine-learning-ai-endpoints?id=kb_browse_cat&kb_id=574a8325551974502d4c6e78b7421938&kb_category=ea1d6daa918a1a541e11d3d71f8624aa&spa=1).

You have two Python scripts:
  - one to generate valide dataset from the markdown documentation: [DatasetCreation.py](./dataset/DatasetCreation.py)
  - one to generate synthetic data from the previous generated documentation: [DatasetAugmentation.py](./dataset/DatasetAugmentation.py) 

Once you have set the environment variables (see Prerequisites section) you can run the scripts with Python : `python DatasetCreation.py`

## 🏋️‍♀️ Train the model 🏋

You have to create a notebook thanks to `ovhai` CLI:
```bash
ovhai notebook run conda jupyterlab \
	--name axolto-llm-fine-tune \
	--framework-version conda-py311-cudaDevel11.8 \
	--flavor l4-1-gpu \
	--gpu 1 \
  --volume https://github.com/ovh/public-cloud-examples.git:/workspace/public-cloud-examples:RW \
	--envvar HF_TOKEN=$MY_HF_TOKEN \
	--envvar WANDB_TOKEN=$MY_WANDB_TOKEN \
	--unsecure-http
```

To train the model please follow the steps in the [notebook](./notebook/axolto-llm-fine-tune-Meta-Llama-3.2-1B-instruct-ai-endpoints.ipynb) provided in the [notebook](./notebook/) folder.  
You have to upload the previously generated data in the [ai-endpoints-doc](./notebook/ai-endpoints-doc/) folder.
