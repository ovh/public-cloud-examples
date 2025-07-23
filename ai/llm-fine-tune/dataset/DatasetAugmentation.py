import os
import json
import uuid
from pathlib import Path
from langchain_openai import ChatOpenAI
from langchain.schema import HumanMessage
from jsonschema import validate, ValidationError

# 🗺️ Define the JSON schema for the response 🗺️
message_schema = {
    "type": "object",
    "properties": {
        "role": {"type": "string"},
        "content": {"type": "string"}
    },
    "required": ["role", "content"]
}

response_format = {
    "type": "json_object",
    "json_schema": {
        "name": "Messages",
        "description": "A list of messages with role and content",
        "properties": {
            "messages": {
                "type": "array",
                "items": message_schema
            }
        }
    }
}

# ✅ JSON validity verification ❌
def is_valid(json_data):
    """
    Test the validity of the JSON data against the schema.
    Argument:
        json_data (dict): The JSON data to validate.  
    Raises:
        ValidationError: If the JSON data does not conform to the specified schema.  
    """
    try:
        validate(instance=json_data, schema=response_format["json_schema"])
        return True
    except ValidationError as e:
        print(f"❌ Validation error: {e}")
        return False

# ⚙️ Initialize the chat model with AI Endpoints configuration ⚙️
chat_model = ChatOpenAI(
    api_key=os.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN"),
    base_url=os.getenv("OVH_AI_ENDPOINTS_MODEL_URL"),
    model_name=os.getenv("OVH_AI_ENDPOINTS_MODEL_NAME"),
    temperature=0.0
)

# 📂 Define the directory path 📂
directory_path = "generated"
print(f"📂 Directory path: {directory_path}")
directory = Path(directory_path)

# 🗃️ Walk through the directory and its subdirectories 🗃️
for path in directory.rglob("*"):
    print(f"📜 Processing file: {path}")
    # Check if the current path is a valid file
    if path.is_file() and path.name.__contains__ ("endpoints"):
        # Read the raw data from the file
        with open(path, 'r', encoding='utf-8') as file:
            raw_data = file.read()

        try:
            json_data = json.loads(raw_data)
        except json.JSONDecodeError:
            print(f"❌ Failed to decode JSON from file: {path.name}")
            continue

        if not is_valid(json_data):
            print(f"❌ Dataset non valide: {path.name}")
            continue
        print(f"✅ Input dataset valide: {path.name}")

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

        chat_response = chat_model.invoke([user_message], response_format=response_format)

        output = chat_response.content

        # Replace unauthorized characters
        output = output.replace("\\t", " ")

        generated_file_name = f"{uuid.uuid4()}_{path.name}"
        with open(f"./generated/synthetic/{generated_file_name}", 'w', encoding='utf-8') as output_file:
            output_file.write(output)

        if not is_valid(json.loads(output)):
            print(f"❌ ERROR: File {generated_file_name} is not valid")
        else:
            print(f"✅ Successfully generated file: {generated_file_name}")