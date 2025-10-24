import gradio as gr
import io
import os
import requests
from pydub import AudioSegment
from dotenv import load_dotenv
from openai import OpenAI
import functools


# access the environment variables from the .env file
load_dotenv()
asr_ai_endpoint_url = os.environ.get('ASR_AI_ENDPOINT') 
llm_ai_endpoint_url = os.getenv("LLM_AI_ENDPOINT")
ai_endpoint_token = os.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN")

 # client defintions & authentication
asr_client = OpenAI(
    base_url=asr_ai_endpoint_url,
    api_key=ai_endpoint_token
)

llm_client = OpenAI(
    base_url=llm_ai_endpoint_url,
    api_key=ai_endpoint_token
)

# automatic speech recognition
def asr_transcription(asr_client, audio):
    
    if audio is None:
        return " "

    else:
        # preprocess audio 
        processed_audio = "/tmp/my_audio.wav"
        audio_input = AudioSegment.from_file(audio, "mp3")
        process_audio_to_wav = audio_input.set_channels(1)
        process_audio_to_wav = process_audio_to_wav.set_frame_rate(16000)
        process_audio_to_wav.export(processed_audio, format="wav")
    
        with open(processed_audio, "rb") as audio_file:
            response = asr_client.audio.transcriptions.create(
                model="whisper-large-v3",
                file=audio_file,
                response_format="verbose_json",
                timestamp_granularities=["segment"]
            )

        # return complete transcription
        return response.text


# ask Mixtral 8x7b for summarization
def chat_completion(llm_client, new_message):

    if new_message==" ":
        return "Please, send an input audio to get its summary!"
    
    else:
        # prompt
        history_openai_format = [{"role": "user", "content": f"Summarize the following text in a few words: {new_message}"}]
        # return summary
        return llm_client.chat.completions.create(
            model="Mixtral-8x7B-Instruct-v0.1",
            messages=history_openai_format,
            temperature=0,
            max_tokens=1024
        ).choices.pop().message.content

# create partial functions with bound client instances
asr_transcribe_fn = functools.partial(asr_transcription, asr_client)
chat_completion_fn = functools.partial(chat_completion, llm_client)


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
        fn = asr_transcribe_fn,
        inputs = inp_audio,
        outputs = inp_text
      )
    inp_text.change(
        fn = chat_completion_fn,
        inputs = inp_text,
        outputs = out_resp
      )
    
if __name__ == '__main__':
 
    demo.launch(server_name="0.0.0.0", server_port=8000)