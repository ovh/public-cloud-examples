package com.ovhcloud.examples.aiendpoints;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import dev.langchain4j.model.mistralai.MistralAiChatModel;

public class BlockingChatbot {
  private static final Logger _LOG = LoggerFactory.getLogger(BlockingChatbot.class);
  private static final String OVHCLOUD_API_KEY = System.getenv("OVHCLOUD_API_KEY");


  public static void main(String[] args) {


    MistralAiChatModel aiChatModel = MistralAiChatModel.builder()
      .apiKey(OVHCLOUD_API_KEY)
      .modelName("Mixtral-8x22B-Instruct-v0.1")
      .baseUrl("https://mixtral-8x22b-instruct-v01.endpoints.kepler.ai.cloud.ovh.net/api/openai_compat/v1/")
      .maxTokens(1500)
      .build();

      _LOG.info("🤖: {}", aiChatModel.generate("Can you tell me what is the OVHcloud compagny and what kind of products are they propose?"));
  }
}
