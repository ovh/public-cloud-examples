package com.ovhcloud.examples.aiendpoints.services;

import dev.langchain4j.data.message.AiMessage;
import dev.langchain4j.model.StreamingResponseHandler;
import dev.langchain4j.model.chat.ChatLanguageModel;
import dev.langchain4j.model.chat.StreamingChatLanguageModel;
import dev.langchain4j.model.output.Response;
import io.smallrye.mutiny.Multi;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class ChatBotService {
  private final ChatLanguageModel chatModel;
  private final StreamingChatLanguageModel streamingChatModel;

  public ChatBotService(ChatLanguageModel chatModel,
      StreamingChatLanguageModel streamingChatModel) {
    this.chatModel = chatModel;
    this.streamingChatModel = streamingChatModel;
  }

  /**
   * Method to use streaming mode with AI Endpoints Mistral model.
   * 
   * @param question The question to ask.
   * @return Multi<String>: the answer.
   */
  public Multi<String> askAQuestionStreamingMode(String question) {
    return Multi.createFrom().emitter(emitter -> {
      streamingChatModel.generate(question, new StreamingResponseHandler<>() {
        @Override
        public void onNext(String token) {
          if (token != null) {
            emitter.emit(token);
          }
        }

        @Override
        public void onError(Throwable error) {
          emitter.fail(error);
        }

        @Override
        public void onComplete(Response<AiMessage> response) {
          emitter.complete();
        }
      });
    });

  }
}
