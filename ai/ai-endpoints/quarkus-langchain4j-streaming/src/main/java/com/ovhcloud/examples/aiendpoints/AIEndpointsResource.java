package com.ovhcloud.examples.aiendpoints;

import org.jboss.resteasy.reactive.RestQuery;
import com.ovhcloud.examples.aiendpoints.services.ChatBotService;
import io.smallrye.mutiny.Multi;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;

@Path("/ovhcloud-ai")
public class AIEndpointsResource {
    // AI Service injection to use it later
    @Inject
    ChatBotService chatBotService;

    // ask resource exposition with POST method
    @Path("ask")
    @GET
    public Multi<String> ask(@RestQuery("question") String question) {
        // Call the Mistral AI chat model
        return chatBotService.askAQuestionStreamingMode(question);
    }
}
