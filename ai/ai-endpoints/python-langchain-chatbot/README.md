This project illustrate how to use[LangChain](https://python.langchain.com/v0.2/) Python Framework with [AI Endpoints](https://endpoints.ai.cloud.ovh.net/).

### 🧰 Pre requisites 🧰

  - Python 3.12.x installed
  - AI Endpoints API token
  - model to use: any of the LLM instruct models
  - have the following environment variables created:
    - OVH_AI_ENDPOINTS_ACCESS_TOKEN: the API token, see [documentation](https://help.ovhcloud.com/csm/en-gb-public-cloud-ai-endpoints-getting-started?id=kb_article_view&sysparm_article=KB0065401#generating-your-first-api-access-key) to know how to generate it
    - OVH_AI_ENDPOINTS_MODEL_URL: URL of the model, see [AI Endpoints website](https://endpoints.ai.cloud.ovh.net/) to know how to get it.
    - OVH_AI_ENDPOINTS_MODEL_NAME: model name, see [AI Endpoints website](https://endpoints.ai.cloud.ovh.net/) to know how to get it.
    - OVH_AI_ENDPOINTS_EMBEDDING_MODEL_NAME: embedding model name, see [AI Endpoints website](https://endpoints.ai.cloud.ovh.net/) to know how to get it.

## How to use the project

  - install the required dependencies: `pip install -r requirements.txt`
  - to use the blocking chatbot: `python chatbot.py`
  - to use the memory chatbot: `python chatbot-memory.py`
  - to use the streaming chatbot: `python chatbot-streaming.py`
  - to use the RAG chatbot: `python chatbot-streaming-rag.py`