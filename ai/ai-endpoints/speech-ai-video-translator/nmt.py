# import dependencies
import os
from dotenv import load_dotenv
import riva.client

# env
load_dotenv()
ai_endpoint_token = os.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN")
inputs_path = "/workspace/inputs"
outputs_path = "/workspace/outputs"
directories = ["videos", "audios", "subtitles"]

# NMT function
def nmt_translation(output_asr):
    
    # connect with nmt server
    nmt_service = riva.client.NeuralMachineTranslationClient(
                    riva.client.Auth(
                        uri=os.environ.get('NMT_ENDPOINT'), 
                        use_ssl=True, 
                        metadata_args=[["authorization", f"bearer {ai_endpoint_token}"]]
                    )
                )

    # set up config
    model_name = 'fr_en_24x6'
    
    output_nmt = []
    for s in range(len(output_asr)):
        output_nmt.append(output_asr[s])
        text_translation = nmt_service.translate([output_asr[s][0]], model_name, "fr", "en")
        output_nmt[s][0]=text_translation.translations[0].text
        
    # return response
    return output_nmt