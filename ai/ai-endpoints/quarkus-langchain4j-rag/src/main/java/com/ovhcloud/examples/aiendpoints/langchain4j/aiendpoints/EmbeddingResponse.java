package com.ovhcloud.examples.aiendpoints.langchain4j.aiendpoints;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EmbeddingResponse {
  private List<float[]> embeddings;
  //private Usage usage;
}
