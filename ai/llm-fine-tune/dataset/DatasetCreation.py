import os
from pathlib import Path
from langchain_openai import ChatOpenAI
from langchain.schema import HumanMessage

# Define the JSON schema for the response
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

def main():
    # Initialize the chat model
    chat_model = ChatOpenAI(
        api_key=os.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN"),
        base_url=os.getenv("OVH_AI_ENDPOINTS_MODEL_URL"),
        model_name=os.getenv("OVH_AI_ENDPOINTS_MODEL_NAME"),
        temperature=0.0
    )

    # Define the directory path, data from https://github.com/ovh/docs
    directory_path = "docs/pages/public_cloud/ai_machine_learning"

    # Create a Path object for the directory
    directory = Path(directory_path)

    # Walk through the directory and its subdirectories
    for path in directory.rglob("*"):
        # Check if the current path is a directory
        if path.is_dir():
            # Get the name of the subdirectory
            sub_directory = path.name

            # Construct the path to the "guide.en-gb.md" file in the subdirectory
            guide_file_path = path / "guide.en-gb.md"

            # Check if the "guide.en-gb.md" file exists in the subdirectory
            if "endpoints" in sub_directory and guide_file_path.exists():
                print(f"Guide processed: {sub_directory}")
                with open(guide_file_path, 'r', encoding='utf-8') as file:
                    raw_data = file.read()
    
                user_message = HumanMessage(content=f"""
With the markdown following, generate a JSON file composed as follows: a list named "messages" composed of tuples with a key "role" which can have the value "user" when it's the question and "assistant" when it's the response. To split the document, base it on the markdown chapter titles to create the question, seems like a good idea.
Keep the language English.
I don't need to know the code to do it but I want the JSON result file.
For the "user" field, don't just repeat the title but make a real question, for example "What are the requirements for OVHcloud AI Endpoints?"
Be sure to add OVHcloud with AI Endpoints so that it's clear that OVHcloud creates AI Endpoints.
Generate the entire JSON file.
An example of what it should look like: messages [{{"role":"user", "content":"What is AI Endpoints?"}}]
There must always be a question followed by an answer, never two questions or two answers in a row.
The source markdown file:
{raw_data}
""")
                chat_response = chat_model.invoke([user_message], response_format=response_format)
                
                with open(f"./generated/{sub_directory}.json", 'w', encoding='utf-8') as output_file:
                    output_file.write(chat_response.content)
                    print(f"Dataset generated: ./generated/{sub_directory}.json")

if __name__ == "__main__":
    main()