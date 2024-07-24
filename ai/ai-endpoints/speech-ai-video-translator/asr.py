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

# ASR function
def asr_transcription(audio_input):

    # connect with asr server
    asr_service = riva.client.ASRService(
                    riva.client.Auth(
                        uri=os.environ.get('ASR_GRPC_ENDPOINT'), 
                        use_ssl=True, 
                        metadata_args=[["authorization", f"bearer {ai_endpoint_token}"]]
                    )
                )

    # set up config
    asr_config = riva.client.RecognitionConfig(
    language_code="fr-FR",
        max_alternatives=1,
        enable_automatic_punctuation=True,
        enable_word_time_offsets=True,
        audio_channel_count = 1,
    )
    
    # open and read audio file
    with open(audio_input, 'rb') as fh:
        audio = fh.read()
    
    riva.client.add_audio_file_specs_to_config(asr_config, audio)

    # return response
    resp = asr_service.offline_recognize(audio, asr_config)
    output_asr = []
    
    # extract sentence information
    for s in range(len(resp.results)):
        output_sentence = []
        sentence = resp.results[s].alternatives[0].transcript
        output_sentence.append(sentence)
        
        for w in range(len(resp.results[s].alternatives[0].words)):
            start_sentence = resp.results[s].alternatives[0].words[0].start_time
            end_sentence = resp.results[s].alternatives[0].words[w].end_time
        
        # add sart time and stop time of the sentence
        output_sentence.append(start_sentence)
        output_sentence.append(end_sentence)
       
        # final asr transcription and time sequences
        output_asr.append(output_sentence)
        
    # return response
    return output_asr