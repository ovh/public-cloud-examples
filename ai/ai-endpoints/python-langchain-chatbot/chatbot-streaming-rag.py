import time
import os

from langchain import hub

from langchain_mistralai import ChatMistralAI

from langchain_chroma import Chroma

from langchain_community.document_loaders import TextLoader
from langchain_community.embeddings.ovhcloud import OVHCloudEmbeddings

from langchain_core.runnables import RunnablePassthrough
from langchain_text_splitters import RecursiveCharacterTextSplitter

# Load environment variables: see https://endpoints.ai.cloud.ovh.net/ for more information 
_OVH_AI_ENDPOINTS_ACCESS_TOKEN = os.environ.get('OVH_AI_ENDPOINTS_ACCESS_TOKEN') 
_OVH_AI_ENDPOINTS_MODEL_NAME = os.environ.get('OVH_AI_ENDPOINTS_MODEL_NAME') 
_OVH_AI_ENDPOINTS_MODEL_URL = os.environ.get('OVH_AI_ENDPOINTS_MODEL_URL') 
_OVH_AI_ENDPOINTS_EMBEDDING_MODEL_NAME = os.environ.get('OVH_AI_ENDPOINTS_EMBEDDING_MODEL_NAME') 

# Configure the used model: Mistral
model = ChatMistralAI(model=_OVH_AI_ENDPOINTS_MODEL_NAME, 
                      api_key=_OVH_AI_ENDPOINTS_ACCESS_TOKEN,
                      endpoint=_OVH_AI_ENDPOINTS_MODEL_URL, 
                      max_tokens=1500, 
                      streaming=True)

# Load and split the documents
loader = TextLoader("./rag-files/content.txt")
docs = loader.load()

text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
splits = text_splitter.split_documents(docs)

# Create the vector thanks to OVHcloud embedding model
vectorstore = Chroma.from_documents(documents=splits, 
                                    embedding=OVHCloudEmbeddings(model_name=_OVH_AI_ENDPOINTS_EMBEDDING_MODEL_NAME, 
                                                                  access_token=_OVH_AI_ENDPOINTS_ACCESS_TOKEN))

# Define the prompt template for the chatbot
prompt = hub.pull("rlm/rag-prompt")

# Create a chain that "apply" the prompt to the model.
rag_chain = (
  {"context": vectorstore.as_retriever(), "question": RunnablePassthrough()} |
  prompt
  | model
)

# Invoke the chatbot
print("👤: Which company created AI Endpoints?")
print("🤖:")
for r in rag_chain.stream({"question", "Which company created AI Endpoints?"}):
  print(r.content, end="", flush=True)
  time.sleep(0.150)