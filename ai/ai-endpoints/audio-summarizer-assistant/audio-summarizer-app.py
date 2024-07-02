import gradio as gr
import io
import os
import requests
from pydub import AudioSegment
from dotenv import load_dotenv
from openai import OpenAI


# access the environment variables from the .env file
load_dotenv()
asr_ai_endpoint_url = os.environ.get('ASR_AI_ENDPOINT') 
llm_ai_endpoint_url = os.getenv("LLM_AI_ENDPOINT")
ai_endpoint_token = os.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN")


# automatic speech recognition
def asr_transcription(audio):
    
    if audio is None:
        return " "

    else:
        # preprocess audio 
        processed_audio = "/tmp/my_audio.wav"
        audio_input = AudioSegment.from_file(audio, "mp3")
        process_audio_to_wav = audio_input.set_channels(1)
        process_audio_to_wav = process_audio_to_wav.set_frame_rate(16000)
        process_audio_to_wav.export(processed_audio, format="wav")
    
        # headers
        headers = headers = {
            'accept': 'application/json',
            "Authorization": f"Bearer {ai_endpoint_token}",
        }

        # put processed audio file as endpoint input
        files = [
            ('audio', open(processed_audio, 'rb')),
        ]

        # get response from endpoint
        response = requests.post(
            asr_ai_endpoint_url, 
            files=files, 
            headers=headers
        )

        # return complete transcription
        if response.status_code == 200:
            # Handle response
            response_data = response.json()
            resp=''
            for alternative in response_data:
                resp+=alternative['alternatives'][0]['transcript']
        else:
            print("Error:", response.status_code)
            
        return resp


# ask Mixtral 8x22b for summarization
def chat_completion(new_message):

    if new_message==" ":
        return "Please, send an input audio to get its summary!"
    
    else:
        # auth
        client = OpenAI(
            base_url=llm_ai_endpoint_url,
            api_key=ai_endpoint_token
        )

        # prompt
        #history_openai_format = [{"role": "user", "content": f"Summarize the following text in a few words: {new_message}"}]
        history_openai_format = [{"role": "user", "content": f"Summarize the following text in a few words: {new_message}"}]
        # return summary
        return client.chat.completions.create(
            model="Mixtral-8x22B-Instruct-v0.1",
            messages=history_openai_format,
            temperature=0,
            max_tokens=1024
        ).choices.pop().message.content


# gradio
with gr.Blocks(theme=gr.themes.Default(primary_hue="blue"), fill_height=True) as demo:

    # add title and description
    with gr.Row():
        gr.HTML(
            """
            <div align="center">
                <h1>Welcome on Audio Summarizer web app 💬!</h1>
                <i>Transcribe and summarize your broadcast, meetings, conversations, potcasts and much more...</i>
            </div>
            <br>
            """
        )
        
    # audio zone for user question
    gr.Markdown("## Upload your audio file 📢")
    with gr.Row():
        inp_audio = gr.Audio(
            label = "Audio file in .wav or .mp3 format:",
            sources = ['upload'],
            type = "filepath",
        )

    # written transcription of user question
    with gr.Row():
        inp_text = gr.Textbox(
            label = "Audio transcription into text:",
        )
        
    # chabot answer
    gr.Markdown("## Chatbot summarization 🤖")
    with gr.Row():
        out_resp = gr.Textbox(
            label = "Get a summary of your audio:",
        )

    with gr.Row():
        
        # clear inputs
        clear = gr.ClearButton([inp_audio, inp_text, out_resp])
  
    # update functions
    inp_audio.change(
        fn = asr_transcription,
        inputs = inp_audio,
        outputs = inp_text
      )
    inp_text.change(
        fn = chat_completion,
        inputs = inp_text,
        outputs = out_resp
      )
    
if __name__ == '__main__':
 
    demo.launch(server_name="0.0.0.0", server_port=8000)
    
