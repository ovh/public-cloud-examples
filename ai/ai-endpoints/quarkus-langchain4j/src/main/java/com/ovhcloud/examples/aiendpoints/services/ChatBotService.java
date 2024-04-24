package com.ovhcloud.examples.aiendpoints.services;

import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;

@RegisterAiService
public interface ChatBotService {
  // Scope / context passed to the LLM
  @SystemMessage("You are a virtual, an AI assistant.")
  // Prompt (with detailed instructions and variable section) passed to the LLM
  @UserMessage("Answer as best possible to the following question: {question}. The answer must be in a style of a virtual assistant and add some emojis to make the answer more fun.")
  String askAQuestion(String question);
}
