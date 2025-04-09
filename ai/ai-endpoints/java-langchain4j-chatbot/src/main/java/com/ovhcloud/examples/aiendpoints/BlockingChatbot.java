package com.ovhcloud.examples.aiendpoints;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import dev.langchain4j.model.mistralai.MistralAiChatModel;

public class BlockingChatbot {
  private static final Logger _LOG = LoggerFactory.getLogger(BlockingChatbot.class);
  private static final String OVH_AI_ENDPOINTS_ACCESS_TOKEN = System.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN");
  private static final String OVH_AI_ENDPOINTS_MODEL_NAME = System.getenv("OVH_AI_ENDPOINTS_MODEL_NAME");
  private static final String OVH_AI_ENDPOINTS_MODEL_URL = System.getenv("OVH_AI_ENDPOINTS_MODEL_URL");

  public static void main(String[] args) {


    MistralAiChatModel aiChatModel = MistralAiChatModel.builder()
      .apiKey(OVH_AI_ENDPOINTS_ACCESS_TOKEN)
      .modelName(OVH_AI_ENDPOINTS_MODEL_NAME)
      .baseUrl(OVH_AI_ENDPOINTS_MODEL_URL)
      .maxTokens(1500)
      .build();

      _LOG.info("🤖: {}", aiChatModel.generate("Can you tell me what is the OVHcloud company and what kind of products are they propose?"));
  }
}
