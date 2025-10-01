///usr/bin/env jbang "$0" "$@" ; exit $?
//JAVA 21+
//PREVIEW
//DEPS dev.langchain4j:langchain4j:1.0.1 dev.langchain4j:langchain4j-mistral-ai:1.0.1-beta6

import com.fasterxml.jackson.databind.ObjectMapper;
import dev.langchain4j.data.message.UserMessage;
import dev.langchain4j.model.chat.request.ChatRequest;
import dev.langchain4j.model.chat.request.ResponseFormat;
import dev.langchain4j.model.chat.request.ResponseFormatType;
import dev.langchain4j.model.chat.request.json.JsonObjectSchema;
import dev.langchain4j.model.chat.request.json.JsonSchema;
import dev.langchain4j.model.chat.response.ChatResponse;
import dev.langchain4j.model.mistralai.MistralAiChatModel;
import dev.langchain4j.model.chat.ChatModel;

record Person(String name, int age, double height, boolean married) {
}

void main() throws Exception {
    ResponseFormat responseFormat = ResponseFormat.builder()
            .type(ResponseFormatType.JSON)
            .jsonSchema(JsonSchema.builder()
                    .name("Person")
                    .rootElement(JsonObjectSchema.builder()
                            .addStringProperty("name")
                            .addIntegerProperty("age")
                            .addNumberProperty("height")
                            .addBooleanProperty("married")
                            .required("name", "age", "height", "married")
                            .build())
                    .build())
            .build();

    UserMessage userMessage = UserMessage.from("""
            John is 42 years old.
            He stands 1.75 meters tall.
            Currently unmarried.
            """);

    ChatRequest chatRequest = ChatRequest.builder()
            .responseFormat(responseFormat)
            .messages(userMessage)
            .build();

    ChatModel chatModel = MistralAiChatModel.builder()
            .apiKey(System.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN"))
            .baseUrl(System.getenv("OVH_AI_ENDPOINTS_MODEL_URL"))
            .modelName(System.getenv("OVH_AI_ENDPOINTS_MODEL_NAME"))
            .logRequests(false)
            .logResponses(false)
            .build();

    ChatResponse chatResponse = chatModel.chat(chatRequest);

    System.out.println("Prompt: \n" + userMessage.singleText());
    String output = chatResponse.aiMessage().text();
    System.out.println("Response: \n" + output); // {"name":"John","age":42,"height":1.75,"married":false}

    Person person = new ObjectMapper().readValue(output, Person.class);
    System.out.println(person); // Person[name=John, age=42, height=1.75, married=false]
}
