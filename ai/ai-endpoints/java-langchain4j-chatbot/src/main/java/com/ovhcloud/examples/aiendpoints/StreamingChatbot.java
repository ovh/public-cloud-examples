package com.ovhcloud.examples.aiendpoints;

import java.util.concurrent.CompletableFuture;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import dev.langchain4j.data.message.AiMessage;
import dev.langchain4j.model.StreamingResponseHandler;
import dev.langchain4j.model.mistralai.MistralAiStreamingChatModel;
import dev.langchain4j.model.output.Response;

public class StreamingChatbot {

  private static final Logger _LOG = LoggerFactory.getLogger(StreamingChatbot.class);
  private static final String OVHCLOUD_API_KEY = System.getenv("OVHCLOUD_API_KEY");

  public static void main(String[] args) {
    MistralAiStreamingChatModel streamingChatModel = MistralAiStreamingChatModel.builder()
        .apiKey(OVHCLOUD_API_KEY).modelName("Mixtral-8x22B-Instruct-v0.1")
        .baseUrl(
            "https://mixtral-8x22b-instruct-v01.endpoints.kepler.ai.cloud.ovh.net/api/openai_compat/v1/")
        .maxTokens(1500).build();

    _LOG.info("🤖: ");

    CompletableFuture<Response<AiMessage>> futureResponse = new CompletableFuture<>();
    streamingChatModel.generate("Tell me more about OVHcloud company.",
        new StreamingResponseHandler<AiMessage>() {
          @Override
          public void onNext(String token) {
            _LOG.info("{}", token);
          }

          @Override
          public void onComplete(Response<AiMessage> response) {
            futureResponse.complete(response);
          }

          @Override
          public void onError(Throwable error) {
            futureResponse.completeExceptionally(error);
          }
        });

    futureResponse.join();
  }
}
