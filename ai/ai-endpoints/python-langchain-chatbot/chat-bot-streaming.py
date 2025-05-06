# 16-Imports
import time
import os

from langchain_mistralai import ChatMistralAI
from langchain_core.prompts import ChatPromptTemplate

## 17-Set the OVHcloud AI Endpoints token to use models
_OVH_AI_ENDPOINTS_ACCESS_TOKEN = os.environ.get('OVH_AI_ENDPOINTS_ACCESS_TOKEN') 
_OVH_AI_ENDPOINTS_MODEL_NAME = os.environ.get('OVH_AI_ENDPOINTS_MODEL_NAME') 
_OVH_AI_ENDPOINTS_MODEL_URL = os.environ.get('OVH_AI_ENDPOINTS_MODEL_URL') 

# 18-Select the Mistral model
model = ChatMistralAI(model=_OVH_AI_ENDPOINTS_MODEL_NAME, 
                      api_key=_OVH_AI_ENDPOINTS_ACCESS_TOKEN,
                      endpoint=_OVH_AI_ENDPOINTS_MODEL_URL, 
                      max_tokens=1500, 
                      streaming=True)

# 19-Create the prompt
prompt = ChatPromptTemplate.from_messages([
  ("system", "You are a Nestor, a virtual assistant. Answer to the question."),
  ("human", "{question}"),
])

# 20-Use the prompt with the model
chain = prompt | model

# 21-Display the response in a streaming way
print("👤: What is OVHcloud?")
print("🤖:")
for r in chain.stream({"question", "What is OVHcloud?"}):
  print(r.content, end="", flush=True)
  time.sleep(0.150)