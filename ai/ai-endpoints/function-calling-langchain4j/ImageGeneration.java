///usr/bin/env jbang "$0" "$@" ; exit $?
//JAVA 24+
//PREVIEW
//DEPS dev.langchain4j:langchain4j:1.0.1 dev.langchain4j:langchain4j-mistral-ai:1.0.1-beta6

import dev.langchain4j.agent.tool.P;
import dev.langchain4j.agent.tool.Tool;
import dev.langchain4j.memory.ChatMemory;
import dev.langchain4j.memory.chat.MessageWindowChatMemory;
import dev.langchain4j.model.chat.ChatModel;
import dev.langchain4j.model.mistralai.MistralAiChatModel;
import dev.langchain4j.service.AiServices;
import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Scanner;

class ImageGenTools {

    @Tool("""
    Tool to create an image with Stable Diffusion XL given a prompt and a negative prompt.
    """)
    void generateImage(@P("Prompt that explains the image") String prompt, @P("Negative prompt that explains what the image must not contains") String negativePrompt) throws IOException, InterruptedException {
        System.out.println("Prompt: " + prompt);
        System.out.println("Negative prompt: " + negativePrompt);

        HttpRequest httpRequest = HttpRequest.newBuilder()
                .uri(URI.create(System.getenv("OVH_AI_ENDPOINTS_SD_URL")))
                .POST(HttpRequest.BodyPublishers.ofString("""
                        {"prompt": "%s", 
                         "negative_prompt": "%s"}
                        """.formatted(prompt, negativePrompt)))
                .header("accept", "application/octet-stream")
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + System.getenv("OVH_AI_ENDPOINTS_SDXL_ACCESS_TOKEN"))
                .build();

        HttpResponse<byte[]> response = HttpClient.newHttpClient()
                .send(httpRequest, HttpResponse.BodyHandlers.ofByteArray());

        System.out.println("SDXL status code: " + response.statusCode());
        Files.write(Path.of("generated-image.jpeg"), response.body());
    }
}

/// Chatbot definition.
/// The goal of the chatbot is to build a powerful prompt for Stable diffusion XML.
interface ChatBot {
    @SystemMessage("""
            Your are an expert of using the Stable Diffusion XL model.
            The user explains in natural language what kind of image he wants.
            You must do the following steps:
              - Understand the user's request.
              - Generate the two kinds of prompts for stable diffusion: the prompt and the negative prompt
              - the prompts must be in english and detailed and optimized for the Stable Diffusion XL model. 
              - once and only once you have this two prompts call the tool with the two prompts.
            If asked about to create an image, you MUST call the `generateImage` function.
            """)
    @UserMessage("Create an image with stable diffusion XL following this description: {{userMessage}}")
    String chat(String userMessage);
}

void main() throws Exception {

    // Main chatbot configuration, choose on of the available models on the AI Endpoints catalog (https://endpoints.ai.cloud.ovh.net/catalog)
    ChatModel chatModel = MistralAiChatModel.builder()
            .apiKey(System.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN"))
            .baseUrl(System.getenv("OVH_AI_ENDPOINTS_MODEL_URL"))
            .modelName(System.getenv("OVH_AI_ENDPOINTS_MODEL_NAME"))
            .logRequests(false)
            .logResponses(false)
            // To have more deterministic outputs, set temperature to 0.
            .temperature(0.0)
            .build();

    // Add memory to fine tune the SDXL prompt.
    ChatMemory chatMemory = MessageWindowChatMemory.withMaxMessages(10);

    // Build the chatbot thanks to LangChain4J AI Servises mode
    ChatBot chatBot = AiServices.builder(ChatBot.class)
            .chatModel(chatModel)
            .tools(new ImageGenTools())
            .chatMemory(chatMemory)
            .build();

    // Start the conversation loop (enter "exit" to quit)
    String userInput = "";
    Scanner scanner = new Scanner(System.in);
    while (true) {
        System.out.print("Enter your message: ");
        userInput = scanner.nextLine();
        if (userInput.equalsIgnoreCase("exit")) break;
        System.out.println("Response: " + chatBot.chat(userInput));
    }
    scanner.close();
}
