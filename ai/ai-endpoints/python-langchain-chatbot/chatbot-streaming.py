import time
import os

from langchain_mistralai import ChatMistralAI
from langchain_core.prompts import ChatPromptTemplate

# Load environment variables: see https://endpoints.ai.cloud.ovh.net/ for more information 
_OVH_AI_ENDPOINTS_ACCESS_TOKEN = os.environ.get('OVH_AI_ENDPOINTS_ACCESS_TOKEN') 
_OVH_AI_ENDPOINTS_MODEL_NAME = os.environ.get('OVH_AI_ENDPOINTS_MODEL_NAME') 
_OVH_AI_ENDPOINTS_MODEL_URL = os.environ.get('OVH_AI_ENDPOINTS_MODEL_URL') 

# Configure the used model: Mistral
model = ChatMistralAI(model=_OVH_AI_ENDPOINTS_MODEL_NAME, 
                      api_key=_OVH_AI_ENDPOINTS_ACCESS_TOKEN,
                      endpoint=_OVH_AI_ENDPOINTS_MODEL_URL, 
                      max_tokens=1500, 
                      streaming=True)

# Define the prompt template for the chatbot
prompt = ChatPromptTemplate.from_messages([
  ("system", "You are a Nestor, a virtual assistant. Answer to the question."),
  ("human", "{question}"),
])

# Create a chain that "apply" the prompt to the model.
chain = prompt | model

# Invoke the chatbot
print("👤: What is OVHcloud?")
print("🤖:")
for r in chain.stream({"question", "What is OVHcloud?"}):
  print(r.content, end="", flush=True)
  time.sleep(0.150)
