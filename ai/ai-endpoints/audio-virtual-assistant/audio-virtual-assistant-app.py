import os
import numpy as np
from openai import OpenAI
import riva.client
from dotenv import load_dotenv
import streamlit as st
from streamlit_mic_recorder import mic_recorder

# access the environment variables from the .env file
load_dotenv()
ai_endpoint_token = os.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN")

# automatic speech recognition - question transcription
def asr_transcription(question):

    asr_service = riva.client.ASRService(
                    
riva.client.Auth(uri=os.environ.get('ASR_GRPC_ENDPOINT'), use_ssl=True, 
metadata_args=[["authorization", f"bearer {ai_endpoint_token}"]])
                )
    
    # set up config
    asr_config = riva.client.RecognitionConfig(
        language_code="en-US",   # languages: en-US
        max_alternatives=1,
        enable_automatic_punctuation=True,
        audio_channel_count = 1,
    )  

    # get asr model response
    response = asr_service.offline_recognize(question, asr_config)

    return response.results[0].alternatives[0].transcript

# text to speech - answer synthesis
def tts_synthesis(response):
    
    tts_service = riva.client.SpeechSynthesisService(
                    
riva.client.Auth(uri=os.environ.get('TTS_GRPC_ENDPOINT'), use_ssl=True, 
metadata_args=[["authorization", f"bearer {ai_endpoint_token}"]])
                )
    
    # set up config
    sample_rate_hz = 48000
    req = {
            "language_code"  : "en-US",                                 # 
languages: en-US
            "encoding"       : riva.client.AudioEncoding.LINEAR_PCM ,
            "sample_rate_hz" : sample_rate_hz,                          # 
sample rate: 48KHz audio
            "voice_name"     : "English-US.Female-1"                    # 
voices: `English-US.Female-1`, `English-US.Male-1`
    }
    
    # return response
    req["text"] = response
    response = tts_service.synthesize(**req)

    return np.frombuffer(response.audio, dtype=np.int16), sample_rate_hz
    
# streamlit interface
with st.container():
    st.title("💬 Audio Virtual Assistant Chatbot")
    
with st.container(height=600):
    messages = st.container()
    
    if "messages" not in st.session_state:
        st.session_state["messages"] = [{"role": "system", "content": 
"Hello, I'm AVA!", "avatar":"🤖"}]
    
    for msg in st.session_state.messages:
        messages.chat_message(msg["role"], 
avatar=msg["avatar"]).write(msg["content"])

with st.container():

    placeholder = st.empty()
    _, recording = placeholder.empty(), mic_recorder(
            start_prompt="START RECORDING YOUR QUESTION ⏺️", 
            stop_prompt="STOP ⏹️", 
            format="wav",
            use_container_width=True,
            key='recorder'
        )
    
    if recording:  
        user_question = asr_transcription(recording['bytes'])
        
        if prompt := user_question:
            client = OpenAI(base_url=os.getenv("LLM_AI_ENDPOINT"), 
api_key=ai_endpoint_token)
            st.session_state.messages.append({"role": "user", "content": 
prompt, "avatar":"👤"})
            messages.chat_message("user", avatar="👤").write(prompt)
            response = client.chat.completions.create(
                model="Mixtral-8x22B-Instruct-v0.1", 
                messages=st.session_state.messages,
                temperature=0,
                max_tokens=1024,
            )
            msg = response.choices[0].message.content
            st.session_state.messages.append({"role": "system", "content": 
msg, "avatar": "🤖"})
            messages.chat_message("system", avatar="🤖").write(msg)

            if msg is not None:
                audio_samples, sample_rate_hz = tts_synthesis(msg)
                placeholder.audio(audio_samples, 
sample_rate=sample_rate_hz, autoplay=True)
