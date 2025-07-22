# 🎯 What is the goals of this example ? 🎯

This example show you how it's very simple to fine tune a LLM with the [axolotl](https://docs.axolotl.ai/) Framework and OVHcloud [Machine Learning Services](https://www.ovhcloud.com/fr/public-cloud/ai-machine-learning/).

## 📚 Prerequisites 📚

 - An OVHcloud [public cloud project created](https://help.ovhcloud.com/csm/en-ie-public-cloud-compute-essential-information?id=kb_article_view&sysparm_article=KB0050387)
 - An OVHcloud [AI Endpoints valid API Key](https://help.ovhcloud.com/csm/en-ie-public-cloud-ai-endpoints-getting-started?id=kb_article_view&sysparm_article=KB0065398) stored in an environment variable named `OVH_AI_ENDPOINTS_ACCESS_TOKEN`
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