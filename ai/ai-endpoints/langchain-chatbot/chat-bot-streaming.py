import argparse
import time

from langchain_mistralai import ChatMistralAI
from langchain_core.prompts import ChatPromptTemplate

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

  chain = prompt | model

  print("🤖: ")
  for r in chain.stream({"question", new_message}):
    print(r.content, end="", flush=True)
    time.sleep(0.150)

# Main entrypoint
def main():
  # User input
  parser = argparse.ArgumentParser()
  parser.add_argument('--question', type=str, default="What is the meaning of life?")
  args = parser.parse_args()
  chat_completion(args.question)

if __name__ == '__main__':
    main()
