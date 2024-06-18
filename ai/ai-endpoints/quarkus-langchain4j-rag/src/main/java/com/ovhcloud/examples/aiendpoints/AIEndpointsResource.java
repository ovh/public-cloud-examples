package com.ovhcloud.examples.aiendpoints;

import org.jboss.resteasy.reactive.RestQuery;
import com.ovhcloud.examples.aiendpoints.services.ChatbotService;
import io.smallrye.mutiny.Multi;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;


@Path("/ovhcloud-ai")
public class AIEndpointsResource {
    @Inject
    ChatbotService chatbot;

    @Path("ask")
    @GET
    public Multi<String> ask(@RestQuery("question") String question) throws Exception {
        // Call the Mistral AI chat model
        return chatbot.askAQuestionStreamingMode(question);
    }
}
