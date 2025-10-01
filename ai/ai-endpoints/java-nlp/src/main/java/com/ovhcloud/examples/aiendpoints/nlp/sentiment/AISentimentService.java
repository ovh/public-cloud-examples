package com.ovhcloud.examples.aiendpoints.nlp.sentiment;

import org.eclipse.microprofile.rest.client.annotation.ClientHeaderParam;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;

@Path("/api")
@RegisterRestClient(baseUri = "https://roberta-base-go-emotions.endpoints.kepler.ai.cloud.ovh.net")
@ClientHeaderParam(name = "Authorization", value = "Bearer ${ovhcloud.ai-endpoints.token}")
@ClientHeaderParam(name = "Content-Type", value = "application/json")
public interface AISentimentService {

  @POST
  @Path("text2emotions")
  EmotionEvaluation text2emotions(String text);

}
