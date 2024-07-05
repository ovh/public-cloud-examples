package com.ovhcloud.examples.aiendpoints;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import dev.langchain4j.memory.ChatMemory;
import dev.langchain4j.memory.chat.MessageWindowChatMemory;
import dev.langchain4j.model.mistralai.MistralAiStreamingChatModel;
import dev.langchain4j.service.AiServices;
import dev.langchain4j.service.TokenStream;

public class MemoryStreamingChatbot {

  private static final Logger _LOG = LoggerFactory.getLogger(MemoryStreamingChatbot.class);
  private static final String OVHCLOUD_API_KEY = System.getenv("OVHCLOUD_API_KEY");

  interface Assistant {
    TokenStream chat(String message);
  }

  public static void main(String[] args) {
    MistralAiStreamingChatModel streamingChatModel = MistralAiStreamingChatModel.builder()
        .apiKey(OVHCLOUD_API_KEY)
        .modelName("Mixtral-8x22B-Instruct-v0.1")
        .baseUrl(
            "https://mixtral-8x22b-instruct-v01.endpoints.kepler.ai.cloud.ovh.net/api/openai_compat/v1/")
        .maxTokens(1500)
        .build();

    ChatMemory chatMemory = MessageWindowChatMemory.withMaxMessages(10);

    Assistant assistant = AiServices.builder(Assistant.class)
        .streamingChatLanguageModel(streamingChatModel)
        .chatMemory(chatMemory)
        .build();

    _LOG.info("💬: My name is Stéphane.\n");
    TokenStream tokenStream = assistant.chat("My name is Stéphane.");
    _LOG.info("🤖: ");
    tokenStream
        .onNext(_LOG::info)
        .onComplete(token -> {
          _LOG.info("\n💬: What is my name?\n");
          _LOG.info("🤖: ");
          assistant.chat("What is my name?")
              .onNext(_LOG::info)
              .onComplete(m -> _LOG.info(m.finishReason().toString()))
              .onError(Throwable::printStackTrace).start();
        })
        .onError(Throwable::printStackTrace).start();



  }
}
