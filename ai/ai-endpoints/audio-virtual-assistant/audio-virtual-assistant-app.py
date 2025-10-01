import os
import numpy as np
from openai import OpenAI
import riva.client
from dotenv import load_dotenv
import streamlit as st
from streamlit_mic_recorder import mic_recorder

# access the environment variables from the .env file
load_dotenv()

ASR_AI_ENDPOINT = os.environ.get('ASR_AI_ENDPOINT')
TTS_GRPC_ENDPOINT = os.environ.get('TTS_GRPC_ENDPOINT')
LLM_AI_ENDPOINT = os.environ.get('LLM_AI_ENDPOINT')
OVH_AI_ENDPOINTS_ACCESS_TOKEN = os.environ.get('OVH_AI_ENDPOINTS_ACCESS_TOKEN')

llm_client = OpenAI(
    base_url=LLM_AI_ENDPOINT,
    api_key=OVH_AI_ENDPOINTS_ACCESS_TOKEN
)

tts_client = riva.client.SpeechSynthesisService(
    riva.client.Auth(
        uri=TTS_GRPC_ENDPOINT,
        use_ssl=True,
        metadata_args=[["authorization", f"bearer {OVH_AI_ENDPOINTS_ACCESS_TOKEN}"]]
    )
)

asr_client = OpenAI(
    base_url=ASR_AI_ENDPOINT,
    api_key=OVH_AI_ENDPOINTS_ACCESS_TOKEN
)

def asr_transcription(question, asr_client):
    return asr_client.audio.transcriptions.create(
        model="whisper-large-v3",
        file=question
    ).text

def llm_answer(input, llm_client):
    response = llm_client.chat.completions.create(
                model="Mixtral-8x7B-Instruct-v0.1", 
                messages=input,
                temperature=0,
                max_tokens=1024,
            )
    msg = response.choices[0].message.content

    return msg

def tts_synthesis(response, tts_client):
    # Split response into chunks of max 1000 characters
    max_chunk_length = 1000
    words = response.split()
    chunks = []
    current_chunk = ""

    for word in words:
        if len(current_chunk) + len(word) + 1 <= max_chunk_length:
            current_chunk += " " + word if current_chunk else word
        else:
            chunks.append(current_chunk)
            current_chunk = word
    if current_chunk:
        chunks.append(current_chunk)

    all_audio = np.array([], dtype=np.int16)
    sample_rate_hz = 16000

    # Process each chunk and concatenate the resulting audio
    for text in chunks:
        req = {
            "language_code": "en-US",
            "encoding": riva.client.AudioEncoding.LINEAR_PCM,
            "sample_rate_hz": sample_rate_hz,
            "voice_name": "English-US.Female-1",
            "text": text.strip(),
        }
        synthesized = tts_client.synthesize(**req)
        audio_segment = np.frombuffer(synthesized.audio, dtype=np.int16)
        all_audio = np.concatenate((all_audio, audio_segment))

    return all_audio, sample_rate_hz


# streamlit interface
with st.container():
    st.title("💬 Audio Virtual Assistant Chatbot")

with st.container(height=600):
    messages = st.container()

    if "messages" not in st.session_state:
        st.session_state["messages"] = [{"role": "system", "content": "Hello, I'm AVA!", "avatar":"🤖"}]

    for msg in st.session_state.messages:
        messages.chat_message(msg["role"], avatar=msg["avatar"]).write(msg["content"])

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
        user_question = asr_transcription(recording['bytes'], asr_client)

        if prompt := user_question:
            st.session_state.messages.append({"role": "user", "content": prompt, "avatar":"👤"})
            messages.chat_message("user", avatar="👤").write(prompt)
            msg = llm_answer(st.session_state.messages, llm_client)
            st.session_state.messages.append({"role": "assistant", "content": msg, "avatar": "🤖"})
            messages.chat_message("system", avatar="🤖").write(msg)

            if msg is not None:
                audio_samples, sample_rate_hz = tts_synthesis(msg, tts_client)
                placeholder.audio(audio_samples, sample_rate=sample_rate_hz, autoplay=True)