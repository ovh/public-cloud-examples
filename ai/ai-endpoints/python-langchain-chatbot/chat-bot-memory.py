# 08-Imports
import os

from langchain_mistralai import ChatMistralAI
from langchain.chains import ConversationChain
from langchain.memory import ConversationBufferWindowMemory
from langchain_core.prompts import ChatPromptTemplate
from langchain.callbacks.streaming_stdout import StreamingStdOutCallbackHandler

## 09-Set the OVHcloud AI Endpoints token to use models
_OVH_AI_ENDPOINTS_ACCESS_TOKEN = os.environ.get('OVH_AI_ENDPOINTS_ACCESS_TOKEN') 
_OVH_AI_ENDPOINTS_MODEL_NAME = os.environ.get('OVH_AI_ENDPOINTS_MODEL_NAME') 
_OVH_AI_ENDPOINTS_MODEL_URL = os.environ.get('OVH_AI_ENDPOINTS_MODEL_URL') 

# 10-Output the tokens in a streaming way
streaming_handler = StreamingStdOutCallbackHandler()

# 11-Select the model
model = ChatMistralAI(model=_OVH_AI_ENDPOINTS_MODEL_NAME, 
                        api_key=_OVH_AI_ENDPOINTS_ACCESS_TOKEN,
                        endpoint=_OVH_AI_ENDPOINTS_MODEL_URL, 
                        max_tokens=1500,
                        streaming=True,
                        callbacks=[streaming_handler])

# 12-Define prompt template
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are Nestor, a virtual assistant. Answer to the question. The conversation history is {history}"),
    ("human", "{input}"),
  ])

# 13-Add Conversation Window Memory
memory = ConversationBufferWindowMemory(k=10)

# 14-Create the conversation chain
conversation = ConversationChain(llm=model, memory=memory, prompt=prompt)

# 15-Start the conversation
question = "Hello, my name is Stéphane"
print(f"👤: {question}")
print("🤖:")
conversation.predict(input=question)

question = "What is my name?"
print(f"👤: {question}")
print("🤖:")
conversation.predict(input=question)