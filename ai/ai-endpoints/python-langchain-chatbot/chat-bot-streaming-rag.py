## 22-Imports
import argparse
import time
import os

from langchain import hub

from langchain_mistralai import ChatMistralAI

from langchain_chroma import Chroma

from langchain_community.document_loaders import TextLoader
from langchain_community.embeddings.ovhcloud import OVHCloudEmbeddings

from langchain_core.runnables import RunnablePassthrough
from langchain_text_splitters import RecursiveCharacterTextSplitter

## 23-Set the OVHcloud AI Endpoints configurations
_OVH_AI_ENDPOINTS_ACCESS_TOKEN = os.environ.get('OVH_AI_ENDPOINTS_ACCESS_TOKEN') 
_OVH_AI_ENDPOINTS_MODEL_NAME = os.environ.get('OVH_AI_ENDPOINTS_MODEL_NAME') 
_OVH_AI_ENDPOINTS_MODEL_URL = os.environ.get('OVH_AI_ENDPOINTS_MODEL_URL') 
_OVH_AI_ENDPOINTS_EMBEDDING_MODEL_NAME = os.environ.get('OVH_AI_ENDPOINTS_EMBEDDING_MODEL_NAME') 

# 24-Select the mistral model
model = ChatMistralAI(model=_OVH_AI_ENDPOINTS_MODEL_NAME, 
                      api_key=_OVH_AI_ENDPOINTS_ACCESS_TOKEN,
                      endpoint=_OVH_AI_ENDPOINTS_MODEL_URL, 
                      max_tokens=1500, 
                      streaming=True)

# 25-Load documents from a local directory
loader = TextLoader("./rag-files/content.txt")
docs = loader.load()

# 26-Split documents into chunks and vectorize them
text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
splits = text_splitter.split_documents(docs)
vectorstore = Chroma.from_documents(documents=splits, 
                                    embedding=OVHCloudEmbeddings(model_name=_OVH_AI_ENDPOINTS_EMBEDDING_MODEL_NAME, 
                                                                  access_token=_OVH_AI_ENDPOINTS_ACCESS_TOKEN))

# 27-Get a pre-configured prompt to do RAG
prompt = hub.pull("rlm/rag-prompt")

# 28-Create the RAG chain
rag_chain = (
  {"context": vectorstore.as_retriever(), "question": RunnablePassthrough()} |
  prompt
  | model
)

# Display the response in a streaming way
print("👤: What is AI Endpoints?")
print("🤖:")
for r in rag_chain.stream({"question", "What is AI Endpoints?"}):
  print(r.content, end="", flush=True)
  time.sleep(0.150)