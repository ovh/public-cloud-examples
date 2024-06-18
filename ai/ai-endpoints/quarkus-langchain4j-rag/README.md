This project illustrate how to use[Quarkus LangChain4j](https://github.com/quarkiverse/quarkus-langchain4j) extension with [AI Endpoints](https://endpoints.ai.cloud.ovh.net/).
The goal of this project is to use LLMs' _RAG mode_.

## How to use the project
  - start `quarkus dev` mode
  - call the exposed endpoint with _curl_: `curl -G --data-urlencode 'question="What is AI Endpoints?"' http://localhost:8080/ovhcloud-ai/ask`

