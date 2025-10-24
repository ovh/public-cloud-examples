package com.ovhcloud.examples.aiendpoints;

import static dev.langchain4j.data.document.loader.FileSystemDocumentLoader.loadDocument;

import java.nio.file.Path;
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
import dev.langchain4j.model.mistralai.MistralAiStreamingChatModel;
import dev.langchain4j.model.ovhai.OvhAiEmbeddingModel;
import dev.langchain4j.rag.content.retriever.ContentRetriever;
import dev.langchain4j.rag.content.retriever.EmbeddingStoreContentRetriever;
import dev.langchain4j.service.AiServices;
import dev.langchain4j.service.TokenStream;
import dev.langchain4j.store.embedding.EmbeddingStore;
import dev.langchain4j.store.embedding.pgvector.PgVectorEmbeddingStore;

public class RAGStreamingChatbot {
  private static final Logger _LOG = LoggerFactory.getLogger(RAGStreamingChatbot.class);
  private static final String DATABASE_HOST = System.getenv("DATABASE_HOST");
  private static final String DATABASE_USER = System.getenv("DATABASE_USER");
  private static final String DATABASE_PASSWORD = System.getenv("DATABASE_PASSWORD");
  private static final String OVH_AI_ENDPOINTS_ACCESS_TOKEN = System.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN");
  private static final String OVH_AI_ENDPOINTS_MODEL_NAME = System.getenv("OVH_AI_ENDPOINTS_MODEL_NAME");
  private static final String OVH_AI_ENDPOINTS_MODEL_URL = System.getenv("OVH_AI_ENDPOINTS_MODEL_URL"); 
  private static final String OVH_AI_ENDPOINTS_EMBEDDING_MODEL_URL = System.getenv("OVH_AI_ENDPOINTS_EMBEDDING_MODEL_URL"); 


  interface Assistant {
    TokenStream chat(String userMessage);
  }

  public static void main(String[] args) throws Exception {
     // Load the document and split it into chunks
    DocumentParser documentParser = new TextDocumentParser();

    Document document = loadDocument(
            Path.of(ClassLoader.getSystemResource("rag-files/content.txt").toURI()),
            documentParser);

    DocumentSplitter splitter = DocumentSplitters.recursive(300, 0);

    List<TextSegment> segments = splitter.split(document);

    // Do the embeddings and store them in an embedding store
    EmbeddingModel embeddingModel = OvhAiEmbeddingModel.builder()
        .apiKey(OVH_AI_ENDPOINTS_ACCESS_TOKEN)
        .baseUrl(OVH_AI_ENDPOINTS_EMBEDDING_MODEL_URL)
        .build();
    List<Embedding> embeddings = embeddingModel.embedAll(segments).content();

    EmbeddingStore<TextSegment> embeddingStore = PgVectorEmbeddingStore.builder()
                    .host(DATABASE_HOST)
                    .port(20184)
                    .database("rag_demo")
                    .user(DATABASE_USER)
                    .password(DATABASE_PASSWORD)
                    .table("rag_embeddings")
                    .dimension(768)
                    .createTable(false)
                    .build();

    // If you haven't a PostgreSQL database, you can use an in-memory embedding store
    // EmbeddingStore<TextSegment> embeddingStore = new InMemoryEmbeddingStore<>();
    embeddingStore.addAll(embeddings, segments);
    ContentRetriever contentRetriever = EmbeddingStoreContentRetriever.builder()
        .embeddingStore(embeddingStore)
        .embeddingModel(embeddingModel)
        .maxResults(5)
        .minScore(0.9)
        .build();

    MistralAiStreamingChatModel streamingChatModel = MistralAiStreamingChatModel.builder()
        .apiKey(OVH_AI_ENDPOINTS_ACCESS_TOKEN)
        .modelName(OVH_AI_ENDPOINTS_MODEL_NAME)
        .baseUrl(
            OVH_AI_ENDPOINTS_MODEL_URL)
        .maxTokens(512)
        .build();

    Assistant assistant = AiServices
        .builder(Assistant.class)
        .streamingChatLanguageModel(streamingChatModel)
        .contentRetriever(contentRetriever)
        .build();

    _LOG.info("\n💬: What is AI Endpoints?\n");

    TokenStream tokenStream = assistant.chat("Can you explain me what is AI Endpoints?");
    _LOG.info("🤖: ");
    tokenStream
        .onNext(_LOG::info)
        .onError(Throwable::printStackTrace)
        .start();
  }
}
