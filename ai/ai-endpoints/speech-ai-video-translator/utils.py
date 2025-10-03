# /// Import dependencies \\\
import os
import re
import pysrt
import subprocess
import gradio as gr
from pydub import AudioSegment
from moviepy.editor import *
from pathlib import Path
from openai import OpenAI
import riva.client

# /// Import Speech AI functions \\\
from asr import asr_transcription
from nmt import nmt_translation
from tts import tts_transcription


# env
from dotenv import load_dotenv
load_dotenv()

ASR_AI_ENDPOINT = os.environ.get('ASR_AI_ENDPOINT')
NMT_AI_ENDPOINT = os.environ.get('NMT_AI_ENDPOINT')
TTS_GRPC_ENDPOINT = os.environ.get('TTS_GRPC_ENDPOINT')
AI_ENDPOINT_TOKEN = os.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN")

# Initialize clients
asr_client = OpenAI(base_url=ASR_AI_ENDPOINT, api_key=AI_ENDPOINT_TOKEN)
nmt_client = OpenAI(base_url=NMT_AI_ENDPOINT, api_key=AI_ENDPOINT_TOKEN)
tts_client = riva.client.SpeechSynthesisService(
    riva.client.Auth(
        uri=TTS_GRPC_ENDPOINT,
        use_ssl=True,
        metadata_args=[["authorization", f"bearer {AI_ENDPOINT_TOKEN}"]]
    )
)

# /// Directory creation \\\
inputs_path = "/workspace/inputs"
outputs_path = "/workspace/outputs"
directories = ["videos", "audios", "subtitles"]

# create directories function
def create_directories(inputs_path, outputs_path, directories):

    for d in range(len(directories)):
        in_dir = f"{inputs_path}/{directories[d]}"
        if not os.path.exists(in_dir):
            os.makedirs(in_dir)
            print("The following directory has been created:", in_dir)

        out_dir = f"{outputs_path}/{directories[d]}"
        if not os.path.exists(out_dir):
            os.makedirs(out_dir)
            print("The following directory has been created:", out_dir)

    return


# /// Video and audio processing functions \\\
# create SRT file with subtitles
def generate_str_file(output_nmt):
    lines = []
    for t in range(len(output_nmt)):
        lines.append("%d" % t)
        lines.append(
            "%s --> %s" %
            (
                s_to_timecode(output_nmt[t][1]),
                s_to_timecode(output_nmt[t][2])
            )
        )
        lines.append(output_nmt[t][0])
        lines.append('')
    return '\n'.join(lines)

# convert seconds into timecode
def s_to_timecode(x):
    hour, x = divmod(x, 3600)
    minute, x = divmod(x, 60)
    second, millisecond = divmod(x, 1)
    millisecond = int(millisecond * 1000)
    return '%.2d:%.2d:%.2d,%.3d' % (int(hour), int(minute), int(second), millisecond)

# video processings
def process_video(video_input, translation_mode, voice_type):
    
    create_dir = create_directories(inputs_path, outputs_path, directories)
    video_title = Path(video_input).stem

    # extract audio from video
    video_to_audio_mp4 = AudioSegment.from_file(video_input, "mp4")
    video_to_audio_wav = video_to_audio_mp4.set_channels(1)
    video_to_audio_wav = video_to_audio_wav.set_frame_rate(16000)
    video_to_audio_wav.export(f"{inputs_path}/audios/{video_title}.wav", format="wav")
    print(f"Extraction completed for audio {video_title}.wav")

    # ASR (audio -> text) in source language
    audio_input = f"{inputs_path}/audios/{video_title}.wav"
    audio_to_text = asr_transcription(audio_input, asr_client)
    print(f"Speech to Text synthesis done for video {video_title}.mp4")
    print(audio_to_text)
    
    # NMT (text -> text) in target language
    text_to_text_translation = nmt_translation(audio_to_text, nmt_client)
    print(f"Text translation done for video {video_title}.mp4")
    output_subtitles_file = f"{outputs_path}/subtitles/{video_title}.srt"
    with open(output_subtitles_file, 'w') as f:
        f.write(generate_str_file(text_to_text_translation))
    if translation_mode=="Subtitles":
        video_output = gr.Video(
                value=[video_input,
                       f'{outputs_path}/subtitles/{video_title}.srt'],
                label="Translated video",
                visible=True,
                show_download_button=True,
                interactive=False,
        )
        
    # TTS (text -> audio) in target language
    else:
        text_to_audio = tts_transcription(text_to_text_translation, video_input, video_title, voice_type, tts_client)
        print(f"Voice dubbing done for video {video_title}.mp4")

        video_output = gr.Video(
                value=f'{outputs_path}/videos/{video_title}.mp4',
                label="Translated video",
                visible=True,
                show_download_button=True,
                interactive=False,
            )
    print("---------------------------------------------------------------------")
        
    return video_output