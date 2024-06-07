import argparse
import time

import os
import requests
import logging

from langchain_core.embeddings import Embeddings
from typing import List


from langchain_mistralai import ChatMistralAI
from langchain_core.prompts import ChatPromptTemplate

from langchain_chroma import Chroma
from langchain_community.document_loaders import DirectoryLoader
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from langchain_text_splitters import RecursiveCharacterTextSplitter


class OVHcloudAIEEmbeddings(Embeddings):
    def __init__(self, api_key: str = os.environ.get("OVH_AI_ENDPOINTS_ACCESS_TOKEN", None), api_url: str = "https://multilingual-e5-base.endpoints.kepler.ai.cloud.ovh.net/api/text2vec"):
        self.api_key = api_key
        self.api_url = api_url

    def _generate_embedding(self, text: str) -> List[float]:
        """Generate embeddings from OVHCLOUD AIE.
        Args:
            text: str. An input text sentence or document.
        Returns:
            embeddings: a list of float numbers. Embeddings correspond to your given text.
        """
        headers = {
            "content-type": "text/plain",
            "Authorization": f"Bearer {self.api_key}",
        }

        session = requests.session()
        while True:
            response = session.post(
                self.api_url,
                headers=headers,
                data=text,
            )
            if response.status_code != 200:
                if response.status_code == 429:
                    """Rate limit exceeded, wait for reset"""
                    reset_time = int(response.headers.get("RateLimit-Reset", 0))
                    logging.info("Rate limit exceeded. Waiting %d seconds.", reset_time)
                    if reset_time > 0:
                        time.sleep(reset_time)
                        continue
                    else:
                        """Rate limit reset time has passed, retry immediately"""
                        continue

                """ Handle other non-200 status codes """
                raise ValueError(
                    f"Request failed with status code {response.status_code}: {response.text}"
                )
            #print(response.json())
            return response.json()

    def embed_documents(self, texts: List[str]) -> List[List[float]]:
        return [self._generate_embedding(text) for text in texts]

    def embed_query(self, text: str) -> List[float]:
        return self._generate_embedding(text)

# Function in charge to call the LLM model.
# Question parameter is the user's question.
# The function print the LLM answer.
def chat_completion(new_message: str):
  # no need to use a token
  model = ChatMistralAI(model="Mixtral-8x22B-Instruct-v0.1", 
                        api_key="foo",
                        endpoint='https://mixtral-8x22b-instruct-v01.endpoints.kepler.ai.cloud.ovh.net/api/openai_compat/v1', 
                        max_tokens=1500, 
                        streaming=True)

  prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a Nestor, a virtual assistant. Answer to the question."),
    ("human", "{question}"),
  ])

  loader = DirectoryLoader(
     glob="**/*",
     path="./rag-files/",
     show_progress=True,
  )
  docs = loader.load()

  text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
  splits = text_splitter.split_documents(docs)
  vectorstore = Chroma.from_documents(documents=splits, embedding=OVHcloudAIEEmbeddings())

  # Retrieve and generate using the relevant snippets of the blog.
  retriever = vectorstore.as_retriever()

  def format_docs(docs):
    return "\n\n".join(doc.page_content for doc in docs)

  rag_chain = (
    {"context": retriever | format_docs, "question": RunnablePassthrough()}
    | prompt
    | model
    | StrOutputParser()
  )

  print("🤖: ")
  print(rag_chain.invoke(new_message))

# Main entrypoint
def main():
  # User input
  parser = argparse.ArgumentParser()
  parser.add_argument('--question', type=str, default="What is the meaning of life?")
  args = parser.parse_args()
  chat_completion(args.question)

if __name__ == '__main__':
    main()
