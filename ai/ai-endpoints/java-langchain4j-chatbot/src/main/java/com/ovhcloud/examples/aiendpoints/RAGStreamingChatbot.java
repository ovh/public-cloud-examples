package com.ovhcloud.examples.aiendpoints;

import static dev.langchain4j.data.document.loader.FileSystemDocumentLoader.loadDocument;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import dev.langchain4j.data.document.Document;
import dev.langchain4j.data.document.DocumentParser;
import dev.langchain4j.data.document.DocumentSplitter;
import dev.langchain4j.data.document.parser.TextDocumentParser;
import dev.langchain4j.data.document.splitter.DocumentSplitters;
import dev.langchain4j.data.embedding.Embedding;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.model.embedding.bge.small.en.v15.BgeSmallEnV15QuantizedEmbeddingModel;
import dev.langchain4j.model.mistralai.MistralAiStreamingChatModel;
import dev.langchain4j.rag.content.retriever.ContentRetriever;
import dev.langchain4j.rag.content.retriever.EmbeddingStoreContentRetriever;
import dev.langchain4j.service.AiServices;
import dev.langchain4j.service.TokenStream;
import dev.langchain4j.store.embedding.EmbeddingStore;
import dev.langchain4j.store.embedding.inmemory.InMemoryEmbeddingStore;

public class RAGStreamingChatbot {
    private static final Logger _LOG = LoggerFactory.getLogger(RAGStreamingChatbot.class);
    private static final String OVHCLOUD_API_KEY = System.getenv("OVHCLOUD_API_KEY");

    interface Assistant {
        TokenStream chat(String userMessage);
    }

    public static void main(String[] args) {
        DocumentParser documentParser = new TextDocumentParser();;
        Document document = loadDocument(
                RAGStreamingChatbot.class.getResource("/rag-files/content.txt").getFile(),
                documentParser);


        DocumentSplitter splitter = DocumentSplitters.recursive(300, 0);
        List<TextSegment> segments =
                splitter.split(document);

        EmbeddingModel embeddingModel = new BgeSmallEnV15QuantizedEmbeddingModel();
        List<Embedding> embeddings = embeddingModel.embedAll(segments).content();

        EmbeddingStore<TextSegment> embeddingStore = new InMemoryEmbeddingStore<>();
        embeddingStore.addAll(embeddings, segments);

        ContentRetriever contentRetriever = EmbeddingStoreContentRetriever.builder()
                .embeddingStore(embeddingStore)
                .embeddingModel(embeddingModel)
                .maxResults(2)
                .minScore(0.5)
                .build();

        MistralAiStreamingChatModel streamingChatModel = MistralAiStreamingChatModel.builder()
                .apiKey(OVHCLOUD_API_KEY).modelName("Mixtral-8x22B-Instruct-v0.1")
                .baseUrl(
                        "https://mixtral-8x22b-instruct-v01.endpoints.kepler.ai.cloud.ovh.net/api/openai_compat/v1/")
                .maxTokens(1500).build();

        Assistant assistant =
                AiServices.builder(Assistant.class)
                        .streamingChatLanguageModel(streamingChatModel)
                        .contentRetriever(contentRetriever)
                        .build();

        _LOG.info("\n💬: What is AI Endpoints?.\n");
        TokenStream tokenStream = assistant.chat("What is AI Endpoints?");
        _LOG.info("🤖: ");
        tokenStream
                .onNext(_LOG::info)
                .onError(Throwable::printStackTrace)
                .start();

    }
}
