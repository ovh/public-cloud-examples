package com.ovhcloud.examples.aiendpoints;

import dev.langchain4j.agent.tool.Tool;
import dev.langchain4j.model.mistralai.MistralAiStreamingChatModel;
import dev.langchain4j.service.AiServices;
import dev.langchain4j.service.TokenStream;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * ⚠️ This example is not working yet, as the Mistral AI streaming endpoint does not support tools yet. ⚠️
 */
public class ChatbotWithTools {

    private static final Logger _LOG = LoggerFactory.getLogger(StreamingChatbot.class);
    private static final String OVHCLOUD_API_KEY = System.getenv("OVHCLOUD_API_KEY");

    public static void main(String[] args) {
        MistralAiStreamingChatModel streamingChatModel = MistralAiStreamingChatModel.builder()
                .apiKey(OVHCLOUD_API_KEY)
                .modelName("Mixtral-8x22B-Instruct-v0.1")
                .baseUrl(
                        "https://mixtral-8x22b-instruct-v01.endpoints.kepler.ai.cloud.ovh.net/api/openai_compat/v1/")
                .maxTokens(1500)
                .logRequests(true)
                .logResponses(false)
                .build();

        Assistant assistant = AiServices.builder(Assistant.class)
                .streamingChatLanguageModel(streamingChatModel)
                .tools(new Calculator())
                .build();

        _LOG.info("💬: What is the square root of 456789?\n");
        TokenStream tokenStream = assistant.chat("What is the square root of 456789?");
        _LOG.info("🤖: ");
        tokenStream
                .onNext(_LOG::info)
                .onError(Throwable::printStackTrace).start();
    }

    interface Assistant {
        TokenStream chat(String message);
    }

    static class Calculator {
        @Tool
        public double squareRoot(double x) {
          _LOG.info("Square root of {} is {}", x, Math.sqrt(x));
            return Math.sqrt(x);
        }
    }
}
