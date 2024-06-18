package com.ovhcloud.examples.aiendpoints.langchain4j.aiendpoints;

import static dev.langchain4j.internal.RetryUtils.withRetry;
import static dev.langchain4j.internal.Utils.getOrDefault;
import static java.time.Duration.ofSeconds;
import static java.util.stream.Collectors.toList;
import java.time.Duration;
import java.util.List;
import dev.langchain4j.data.embedding.Embedding;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.model.output.Response;
import lombok.Builder;

public class AIEndpointsModel implements EmbeddingModel {
 private static final String DEFAULT_BASE_URL =
                        "https://multilingual-e5-base.endpoints.kepler.ai.cloud.ovh.net";
        private static final String DEFAULT_API_KEY = "<KEY>";

        private final AIEndpointsClient client;
        private final Integer maxRetries;

        @Builder
        public AIEndpointsModel(String baseUrl, String apiKey, Duration timeout, Integer maxRetries,
                        Boolean logRequests, Boolean logResponses) {
                this.client = AIEndpointsClient.builder()
                                .baseUrl(getOrDefault(baseUrl, DEFAULT_BASE_URL))
                                .apiKey(getOrDefault(apiKey, DEFAULT_API_KEY))
                                .timeout(getOrDefault(timeout, ofSeconds(60)))
                                .logRequests(getOrDefault(logRequests, false))
                                .logResponses(getOrDefault(logResponses, false)).build();
                this.maxRetries = getOrDefault(maxRetries, 3);
        }

        public static AIEndpointsModel withApiKey(String apiKey) {
                return AIEndpointsModel.builder().apiKey(apiKey).build();
        }

        @Override
        public Response<List<Embedding>> embedAll(List<TextSegment> textSegments) {

                EmbeddingRequest request = EmbeddingRequest.builder()
                                .input(textSegments.stream().map(TextSegment::text)
                                                .collect(toList()))
                                .build();

                EmbeddingResponse response = withRetry(() -> client.embed(request), maxRetries);

                List<Embedding> embeddings = response.getEmbeddings().stream().map(Embedding::from)
                                .collect(toList());

                // TokenUsage tokenUsage = new TokenUsage(response.getUsage().getTotalTokens(), 0);

                // return Response.from(embeddings, tokenUsage);
                return Response.from(embeddings);
        }

}
