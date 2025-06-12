///usr/bin/env jbang "$0" "$@" ; exit $?
//JAVA 24+
//PREVIEW
//DEPS dev.langchain4j:langchain4j-mcp:1.0.1-beta6 dev.langchain4j:langchain4j:1.0.1 dev.langchain4j:langchain4j-mistral-ai:1.0.1-beta6


import dev.langchain4j.mcp.McpToolProvider;
import dev.langchain4j.mcp.client.DefaultMcpClient;
import dev.langchain4j.mcp.client.McpClient;
import dev.langchain4j.mcp.client.transport.McpTransport;
import dev.langchain4j.mcp.client.transport.http.HttpMcpTransport;
import dev.langchain4j.model.chat.ChatModel;
import dev.langchain4j.model.mistralai.MistralAiChatModel;
import dev.langchain4j.service.AiServices;

// Simple chatbot definition with AI Services from LangChain4J
public interface Bot {
    String chat(String prompt);
}

void main() {
    // Mistral model from OVHcloud AI Endpoints
    ChatModel chatModel = MistralAiChatModel.builder()
            .apiKey(System.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN"))
            .baseUrl(System.getenv("OVH_AI_ENDPOINTS_MODEL_URL"))
            .modelName(System.getenv("OVH_AI_ENDPOINTS_MODEL_NAME"))
            .logRequests(false)
            .logResponses(false)
            .build();

    // Configure the MCP server to use
    McpTransport transport = new HttpMcpTransport.Builder()
            // https://xxxx/mcp/sse
            .sseUrl(System.getenv("MCP_SERVER_URL"))
            .logRequests(false)
            .logResponses(false)
            .build();

    // Create the MCP client for the given MCP server
    McpClient mcpClient = new DefaultMcpClient.Builder()
            .transport(transport)
            .build();

    // Configure the tools list for the LLM
    McpToolProvider toolProvider = McpToolProvider.builder()
            .mcpClients(mcpClient)
            .build();

    // Create the chatbot with the given LLM and tools list
    Bot bot = AiServices.builder(Bot.class)
            .chatModel(chatModel)
            .toolProvider(toolProvider)
            .build();

    // Play with the chatbot 🤖
    String response = bot.chat("Can I have some details about my OVHcloud account?");
    System.out.println("RESPONSE: " + response);

}
