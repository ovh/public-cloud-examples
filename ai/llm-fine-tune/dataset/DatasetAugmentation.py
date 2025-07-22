import os
import json
import time
import uuid
from pathlib import Path
from langchain_openai import ChatOpenAI
from langchain.schema import HumanMessage
from jsonschema import validate, ValidationError
from jsonschema.exceptions import SchemaError

# Define the JSON schema for the response
schema = {
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "properties": {
        "messages": {
            "type": "array",
            "items": [
                {
                    "type": "object",
                    "properties": {
                        "content": {
                            "type": "string"
                        },
                        "role": {
                            "type": "string"
                        }
                    },
                    "required": [
                        "content",
                        "role"
                    ]
                }
            ]
        }
    },
    "required": [
        "messages"
    ]
}

def is_valid(json_data):
    try:
        validate(instance=json_data, schema=schema)
    except (ValidationError, SchemaError) as e:
        print(f"JSON validation error: {e}")
        return False
    return True

def main():
    # Initialize the chat model
    chat_model = ChatOpenAI(
        api_key=os.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN"),
        base_url=os.getenv("OVH_AI_ENDPOINTS_MODEL_URL"),
        model_name=os.getenv("OVH_AI_ENDPOINTS_MODEL_NAME")
    )

    # Define the directory path
    directory_path = "generated"
    print(f"Directory path: {directory_path}")

    # Create a Path object for the directory
    directory = Path(directory_path)

    # Walk through the directory and its subdirectories
    for path in directory.rglob("*"):
        print(f"Processing file: {path}")
        # Check if the current path is a file and not a .DS_Store file
        if path.is_file() and not path.name.startswith(".DS_Store"):
            # Read the raw data from the file
            with open(path, 'r', encoding='utf-8') as file:
                raw_data = file.read()

            try:
                json_data = json.loads(raw_data)
            except json.JSONDecodeError:
                print(f"Failed to decode JSON from file: {path.name}")
                continue

            if not is_valid(json_data):
                print(f"Dataset non valide : {path.name}")
                continue
            print(f"Dataset valide : {path.name}")

            user_message = HumanMessage(content=f"""
            Given the following JSON, generate a similar JSON file where you paraphrase each question in the content attribute
            (when the role attribute is user) and also paraphrase the value of the response to the question stored in the content attribute
            when the role attribute is assistant.
            The objective is to create synthetic datasets based on existing datasets.
            I do not need to know the code to do this, but I want the resulting JSON file.
            It is important that the term OVHcloud is present as much as possible, especially when the terms AI Endpoints are mentioned
            either in the question or in the response.
            There must always be a question followed by an answer, never two questions or two answers in a row.
            It is IMPERATIVE to keep the language in English.
            The source JSON file:
            {raw_data}
            """)

            #chat_response = chat_model.invoke([user_message])
            chat_response = chat_model.invoke([user_message], response_format=schema)

            output = chat_response.content

            # Replace unauthorized characters
            output = output.replace("\\t", " ")

            generated_file_name = f"{uuid.uuid4()}_{path.name}"
            with open(f"./generated/synthetic/{generated_file_name}", 'w', encoding='utf-8') as output_file:
                output_file.write(output)

            if not is_valid(json.loads(output)):
                print(f"ERROR: File {generated_file_name} is not valid")
            else:
                print(f"Successfully generated file: {generated_file_name}")

if __name__ == "__main__":
    main()