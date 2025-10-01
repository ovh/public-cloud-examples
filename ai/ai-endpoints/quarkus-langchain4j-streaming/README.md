This project illustrate how to use[Quarkus LangChain4j](https://github.com/quarkiverse/quarkus-langchain4j) extension with [AI Endpoints](https://endpoints.ai.cloud.ovh.net/).
The goal of this project is to use LLMs' _streaming mode_.

## How to use the project
  - start `quarkus dev` mode
  - call the exposed endpoint with _curl_: 
  ```bash
  curl -N http://localhost:8080/ovhcloud-ai/ask \                                                 
     -X POST \
     -d '{"question":"Can you tell me what OVHcloud is and what kind of products it offers?"}' \
     -H 'Content-Type: application/json'
  ```

