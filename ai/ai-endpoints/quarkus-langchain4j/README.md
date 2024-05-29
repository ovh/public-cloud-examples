This project illustrate how to use[Quarkus LangChain4j](https://github.com/quarkiverse/quarkus-langchain4j) extension with [AI Endpoints](https://endpoints.ai.cloud.ovh.net/).

## How to use the project
  - start `quarkus dev` mode
  - call the exposed endpoint with _curl_: 
  ```bash
  curl  --header "Content-Type: application/json" \
        --request POST \
        --data '{"question": "What is OVHcloud?"}' \
  http://localhost:8080/ovhcloud-ai/ask
  ```

