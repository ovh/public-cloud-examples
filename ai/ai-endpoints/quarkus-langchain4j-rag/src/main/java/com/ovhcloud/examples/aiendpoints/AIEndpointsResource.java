package com.ovhcloud.examples.aiendpoints;

import static dev.langchain4j.data.document.loader.FileSystemDocumentLoader.loadDocument;
import java.nio.file.Paths;
import org.jboss.resteasy.reactive.RestQuery;
import com.ovhcloud.examples.aiendpoints.langchain4j.aiendpoints.AIEndpointsModel;
import com.ovhcloud.examples.aiendpoints.services.ChatBotService;
import dev.langchain4j.data.document.Document;
import dev.langchain4j.data.document.DocumentParser;
import dev.langchain4j.data.document.parser.TextDocumentParser;
import dev.langchain4j.data.embedding.Embedding;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.chat.ChatLanguageModel;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.model.mistralai.MistralAiChatModel;
import dev.langchain4j.model.output.Response;
import dev.langchain4j.rag.content.retriever.ContentRetriever;
import dev.langchain4j.rag.content.retriever.EmbeddingStoreContentRetriever;
import dev.langchain4j.service.AiServices;
import dev.langchain4j.store.embedding.EmbeddingStore;
import dev.langchain4j.store.embedding.inmemory.InMemoryEmbeddingStore;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;


@Path("/ovhcloud-ai")
public class AIEndpointsResource {
    // ask resource exposition with POST method
    @Path("ask")
    @GET
    public String ask(@RestQuery("question") String question) throws Exception {
        // Call the Mistral AI chat model
        ChatBotService chatBotService = createChatBotService("rag/rag-content.txt");
        return chatBotService.answer(question);
    }

    /**
     * "Factory" to create a chat bot based on OVHcloud AI Endpoints embedded models.
     * 
     * @param documentPath The path to the docs to ingest.
     * 
     * @return The chat bot service.
     */
    private static ChatBotService createChatBotService(String documentPath) throws Exception {
        ChatLanguageModel chatLanguageModel = MistralAiChatModel.builder()
                .apiKey("null")
                .baseUrl("https://mixtral-8x22b-instruct-v01.endpoints.kepler.ai.cloud.ovh.net/api/openai_compat/v1")
                .modelName("Mixtral-8x22B-Instruct-v0.1")
                .maxTokens(1500)
                .build();

        DocumentParser documentParser = new TextDocumentParser();
        Document document = loadDocument(Paths.get(AIEndpointsResource.class.getClassLoader()
                .getResource(documentPath).toURI()), documentParser);

        //DocumentSplitter splitter = DocumentSplitters.recursive(300, 0);
        //List<TextSegment> segments = splitter.split(document);

        EmbeddingModel embeddingModel = AIEndpointsModel.builder()
            .apiKey("foo")
            .logRequests(true)
            .logResponses(true)
        .build();

        Response<Embedding> embeddings = embeddingModel.embed(document.text());
        EmbeddingStore<TextSegment> embeddingStore = new InMemoryEmbeddingStore<>();
        embeddingStore.add(embeddings.content(), new TextSegment(document.text(), document.metadata()));


        ContentRetriever contentRetriever = EmbeddingStoreContentRetriever.builder()
                .embeddingStore(embeddingStore)
                .embeddingModel(embeddingModel)
                .maxResults(2) 
                .minScore(0.5)
                .build();

        return AiServices.builder(ChatBotService.class)
                            .chatLanguageModel(chatLanguageModel)
                            .contentRetriever(contentRetriever)
                            .build();
    }
}
