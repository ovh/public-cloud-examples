This project illustrate how to use[LangChain](https://python.langchain.com/v0.2/) Python Framework with [AI Endpoints](https://endpoints.ai.cloud.ovh.net/).

## How to use the project

  - set the `OVH_AI_ENDPOINTS_ACCESS_TOKEN` environment variable with your API token (see https://endpoints.ai.cloud.ovh.net/)
  - install lib magic: `brew install libmagic`
  - install the required dependencies: `pip install -r requirements.txt`
  - to use the blocking chatbot: `python chat-bot.py --question "What is OVHcloud?"`
  - to use the memory chatbot: `python chat-bot-memory.py`
  - to use the streaming chatbot: `python chat-bot-streaming.py --question "What is OVHcloud?"`
  - to use the RAG chatbot: `python chat-bot-streaming-rag.py --question "What is AI Endpoints?"`