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
  private static final String OVH_AI_ENDPOINTS_ACCESS_TOKEN = System.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN");
  private static final String OVH_AI_ENDPOINTS_MODEL_NAME = System.getenv("OVH_AI_ENDPOINTS_MODEL_NAME");
  private static final String OVH_AI_ENDPOINTS_MODEL_URL = System.getenv("OVH_AI_ENDPOINTS_MODEL_URL");


  public static void main(String[] args) {
    MistralAiStreamingChatModel streamingChatModel = MistralAiStreamingChatModel.builder()
        .apiKey(OVH_AI_ENDPOINTS_ACCESS_TOKEN)
        .modelName(OVH_AI_ENDPOINTS_MODEL_NAME)
        .baseUrl(OVH_AI_ENDPOINTS_MODEL_URL)
        .maxTokens(1500)
    .build();

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
