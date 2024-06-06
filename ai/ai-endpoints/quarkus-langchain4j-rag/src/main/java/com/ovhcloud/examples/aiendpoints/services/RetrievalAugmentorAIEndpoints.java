package com.ovhcloud.examples.aiendpoints.services;

import java.nio.file.Paths;
import java.util.function.Supplier;
import com.ovhcloud.examples.aiendpoints.AIEndpointsResource;
import com.ovhcloud.examples.aiendpoints.langchain4j.aiendpoints.AIEndpointsModel;
import dev.langchain4j.data.document.Document;
import dev.langchain4j.data.document.DocumentParser;
import dev.langchain4j.data.document.parser.TextDocumentParser;
import dev.langchain4j.data.embedding.Embedding;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.model.output.Response;
import dev.langchain4j.rag.DefaultRetrievalAugmentor;
import dev.langchain4j.rag.RetrievalAugmentor;
import dev.langchain4j.rag.content.retriever.ContentRetriever;
import dev.langchain4j.rag.content.retriever.EmbeddingStoreContentRetriever;
import dev.langchain4j.store.embedding.EmbeddingStore;
import dev.langchain4j.store.embedding.inmemory.InMemoryEmbeddingStore;
import jakarta.inject.Singleton;
import static dev.langchain4j.data.document.loader.FileSystemDocumentLoader.loadDocument;

@Singleton
public class RetrievalAugmentorAIEndpoints implements Supplier<RetrievalAugmentor> {

  private final RetrievalAugmentor augmentor;

  RetrievalAugmentorAIEndpoints() throws Exception{
    EmbeddingModel embeddingModel = AIEndpointsModel.builder()
            .apiKey("foo")
            .logRequests(true)
            .logResponses(true)
        .build();

        DocumentParser documentParser = new TextDocumentParser();
        Document document = loadDocument(Paths.get(RetrievalAugmentorAIEndpoints.class.getClassLoader()
                .getResource("rag/rag-content.txt").toURI()), documentParser);

        Response<Embedding> embeddings = embeddingModel.embed(document.text());
        EmbeddingStore<TextSegment> embeddingStore = new InMemoryEmbeddingStore<>();
        embeddingStore.add(embeddings.content(), new TextSegment(document.text(), document.metadata()));



    ContentRetriever contentRetriever = EmbeddingStoreContentRetriever.builder()
    .embeddingStore(embeddingStore)
    .embeddingModel(embeddingModel)
    .maxResults(2) 
    .minScore(0.5)
    .build();

     augmentor = DefaultRetrievalAugmentor
              .builder()
              .contentRetriever(contentRetriever)
              .build();
  }



  @Override
  public RetrievalAugmentor get() {
      return augmentor;
  }
}
