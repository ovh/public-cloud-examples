package com.ovhcloud.examples.aiendpoints.nlp.sentiment;

import org.eclipse.microprofile.rest.client.inject.RestClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

/**
 * Class to do textual sentiments analysis.
 */
@Path("/sentiment")
public class SentimentsAnalysisResource {

  private static final Logger _LOG = LoggerFactory.getLogger(SentimentsAnalysisResource.class);

  @RestClient
  private AISentimentService aiSentimentService;

  @POST
  @Produces(MediaType.TEXT_PLAIN)
  public String getSentiment(String text) {
    _LOG.info("Sentiment analysis for text: {}", text);

    return aiSentimentService.text2emotions(text).toEmoji();
  }
}
