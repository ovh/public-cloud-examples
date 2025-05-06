# 01-Imports
import os

from langchain_mistralai import ChatMistralAI
from langchain_core.prompts import ChatPromptTemplate

## 02-Set the OVHcloud AI Endpoints token to use models
_OVH_AI_ENDPOINTS_ACCESS_TOKEN = os.environ.get('OVH_AI_ENDPOINTS_ACCESS_TOKEN') 
_OVH_AI_ENDPOINTS_MODEL_NAME = os.environ.get('OVH_AI_ENDPOINTS_MODEL_NAME') 
_OVH_AI_ENDPOINTS_MODEL_URL = os.environ.get('OVH_AI_ENDPOINTS_MODEL_URL') 

# 03-Select the Mistral model
model = ChatMistralAI(model=_OVH_AI_ENDPOINTS_MODEL_NAME, 
                      api_key=_OVH_AI_ENDPOINTS_ACCESS_TOKEN,
                      endpoint=_OVH_AI_ENDPOINTS_MODEL_URL, 
                      max_tokens=1500)

# 04-Create the prompt
prompt = ChatPromptTemplate.from_messages([
  ("system", "You are Nestor, a virtual assistant. Answer to the question."),
  ("human", "{question}"),
])

# 05-Use the prompt with the model
chain = prompt | model

# 06-Call the model with the question
response = chain.invoke("What is OVHcloud?")

# 07-Print the response
print("👤: What is OVHcloud?")
print(f"🤖:{response.content}")