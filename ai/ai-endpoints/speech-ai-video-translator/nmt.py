# import dependencies
import os
from dotenv import load_dotenv
import requests

# env
load_dotenv()
NMT_AI_ENDPOINT = os.environ.get('NMT_AI_ENDPOINT')
AI_ENDPOINT_TOKEN = os.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN")
inputs_path = "/workspace/inputs"
outputs_path = "/workspace/outputs"
directories = ["videos", "audios", "subtitles"]

def nmt_translation(output_asr):
    # Define the headers for the API request
    headers = {
        "Content-Type": "text/plain",
        "Authorization": f"Bearer {AI_ENDPOINT_TOKEN}"
    }

    output_nmt = []
    
    # Iterate through each entry and perform translation
    for original_entry in output_asr:
        text_to_translate = original_entry[0]
        
        try:
            # Send translation request
            response = requests.post(
                url=NMT_AI_ENDPOINT,
                data=text_to_translate,
                headers=headers
            )

            # Handle response
            if response.status_code == 200:
                translated_text = response.text
            else:
                raise Exception(
                    f"Translation failed for: {text_to_translate}. Status: {response.status_code}, Response: {response.text}"
                )
            
        except Exception as e:
            # Optionally modify error handling (logging, default values, etc.)
            raise e

        # Construct a new entry with translated text
        new_entry = [translated_text] + original_entry[1:]
        
        output_nmt.append(new_entry)
    
    return output_nmt