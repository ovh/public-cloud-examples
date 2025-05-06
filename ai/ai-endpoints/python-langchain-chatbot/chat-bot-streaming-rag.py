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

## Set the OVHcloud AI Endpoints configurations
_OVH_AI_ENDPOINTS_ACCESS_TOKEN = os.environ.get('OVH_AI_ENDPOINTS_ACCESS_TOKEN') 
_OVH_AI_ENDPOINTS_MODEL_NAME = os.environ.get('OVH_AI_ENDPOINTS_MODEL_NAME') 
_OVH_AI_ENDPOINTS_MODEL_URL = os.environ.get('OVH_AI_ENDPOINTS_MODEL_URL') 
_OVH_AI_ENDPOINTS_EMBEDDING_MODEL_NAME = os.environ.get('OVH_AI_ENDPOINTS_EMBEDDING_MODEL_NAME') 

# Function in charge to call the LLM model.
# Question parameter is the user's question.
# The function print the LLM answer.
def chat_completion(new_message: str):
  # no need to use a token
  model = ChatMistralAI(model=_OVH_AI_ENDPOINTS_MODEL_NAME, 
                        api_key=_OVH_AI_ENDPOINTS_ACCESS_TOKEN,
                        endpoint=_OVH_AI_ENDPOINTS_MODEL_URL, 
                        max_tokens=1500, 
                        streaming=True)

  # Load documents from a local directory
  loader = TextLoader("./rag-files/content.txt")
  docs = loader.load()

  # Split documents into chunks and vectorize them
  text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
  splits = text_splitter.split_documents(docs)
  vectorstore = Chroma.from_documents(documents=splits, 
                                      embedding=OVHCloudEmbeddings(model_name=_OVH_AI_ENDPOINTS_EMBEDDING_MODEL_NAME, 
                                                                   access_token=_OVH_AI_ENDPOINTS_ACCESS_TOKEN))

  # Get a pre-configured prompt to do RAG
  prompt = hub.pull("rlm/rag-prompt")

  # Create the RAG chain
  rag_chain = (
    {"context": vectorstore.as_retriever(), "question": RunnablePassthrough()}
    | prompt
    | model
  )

  # Display the response in a streaming way
  print("🤖: ")
  for r in rag_chain.stream({"question", new_message}):
    print(r.content, end="", flush=True)
    time.sleep(0.150)

# Main entrypoint
def main():
  # User input
  parser = argparse.ArgumentParser()
  parser.add_argument('--question', type=str, default="What is AI Endpoints?")
  args = parser.parse_args()
  chat_completion(args.question)

if __name__ == '__main__':
    main()
