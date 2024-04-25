package com.ovhcloud.examples.aiendpoints;

import com.ovhcloud.examples.aiendpoints.services.ChatBotService;
import io.smallrye.mutiny.Multi;
import jakarta.inject.Inject;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;

@Path("/ovhcloud-ai")
public class AIEndpointsResource {
    // AI Service injection to use it later
    @Inject
    ChatBotService chatBotService;

    // ask resource exposition with POST method
    @Path("ask")
    @POST
    public Multi<String> ask(String question) {
        // Call the Mistral AI chat model
        return chatBotService.askAQuestionStreamingMode(question);
    }
}
