package com.ovhcloud.examples.aiendpoints.services;

import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;
import io.smallrye.mutiny.Multi;

@RegisterAiService
public interface ChatBotService {

  @SystemMessage("You are a cool AI assistant.")
  @UserMessage("Answer as best possible to the following question: {question}. The answer must be in a style of a virtual assistant.")
  Multi<String> askAQuestionStreamingMode(String question);
}
