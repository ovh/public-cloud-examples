import argparse
import os

from langchain_mistralai import ChatMistralAI
from langchain_core.prompts import ChatPromptTemplate

## Set the OVHcloud AI Endpoints token to use models
_OVH_AI_ENDPOINTS_ACCESS_TOKEN = os.environ.get('OVH_AI_ENDPOINTS_ACCESS_TOKEN') 
_OVH_AI_ENDPOINTS_MODEL_NAME = os.environ.get('OVH_AI_ENDPOINTS_MODEL_NAME') 
_OVH_AI_ENDPOINTS_MODEL_URL = os.environ.get('OVH_AI_ENDPOINTS_MODEL_URL') 

# Function in charge to call the LLM model.
# Question parameter is the user's question.
# The function print the LLM answer.
def chat_completion(question: str):
  model = ChatMistralAI(model=_OVH_AI_ENDPOINTS_MODEL_NAME, 
                        api_key=_OVH_AI_ENDPOINTS_ACCESS_TOKEN,
                        endpoint=_OVH_AI_ENDPOINTS_MODEL_URL, 
                        max_tokens=1500)

  # Create the prompt
  prompt = ChatPromptTemplate.from_messages([
    ("system", "You are Nestor, a virtual assistant. Answer to the question."),
    ("human", "{question}"),
  ])

  # Use the prompt with the model
  chain = prompt | model

  # Call the model with the question
  response = chain.invoke(question)

  print(f"🤖: {response.content}")

# Main entrypoint
def main():
  # User input
  parser = argparse.ArgumentParser()
  parser.add_argument('--question', type=str, default="What is OVHcloud?")
  args = parser.parse_args()
  chat_completion(args.question)

if __name__ == '__main__':
    main()
