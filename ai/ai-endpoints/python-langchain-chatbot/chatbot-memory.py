import os

from langchain_mistralai import ChatMistralAI
from langchain.chains import ConversationChain
from langchain.memory import ConversationBufferWindowMemory
from langchain_core.prompts import ChatPromptTemplate
from langchain.callbacks.streaming_stdout import StreamingStdOutCallbackHandler

# Load environment variables: see https://endpoints.ai.cloud.ovh.net/ for more information 
_OVH_AI_ENDPOINTS_ACCESS_TOKEN = os.environ.get('OVH_AI_ENDPOINTS_ACCESS_TOKEN') 
_OVH_AI_ENDPOINTS_MODEL_NAME = os.environ.get('OVH_AI_ENDPOINTS_MODEL_NAME') 
_OVH_AI_ENDPOINTS_MODEL_URL = os.environ.get('OVH_AI_ENDPOINTS_MODEL_URL') 

# Callback handler for streaming output
streaming_handler = StreamingStdOutCallbackHandler()

# Configure the used model: Mistral
model = ChatMistralAI(model=_OVH_AI_ENDPOINTS_MODEL_NAME, 
                        api_key=_OVH_AI_ENDPOINTS_ACCESS_TOKEN,
                        endpoint=_OVH_AI_ENDPOINTS_MODEL_URL, 
                        max_tokens=1500,
                        streaming=True,
                        callbacks=[streaming_handler])

# Define the prompt template for the chatbot
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are Nestor, a virtual assistant. Answer to the question. The conversation history is {history}"),
    ("human", "{input}"),
  ])

# Set the size of the memory window to 10 exchanges.
memory = ConversationBufferWindowMemory(k=10)

# Create a chain that "apply" the prompt to the model.
conversation = ConversationChain(llm=model, memory=memory, prompt=prompt)

# Invoke the chatbot
question = "Hello, my name is Stéphane"
print(f"👤: {question}")
print("🤖:")
conversation.predict(input=question)

question = "What is my name?"
print(f"\n👤: {question}")
print("🤖:")
conversation.predict(input=question)
