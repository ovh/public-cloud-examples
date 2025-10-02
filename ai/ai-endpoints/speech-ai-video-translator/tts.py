# import dependencies
import os
from dotenv import load_dotenv
import riva.client
from moviepy.editor import *
from pydub import AudioSegment

inputs_path = "/workspace/inputs"
outputs_path = "/workspace/outputs"
directories = ["videos", "audios", "subtitles"]

# voice dubbing in the new language
def add_audio_on_video(translated_audio, video_input, video_title):

    videoclip = VideoFileClip(video_input)
    audioclip = AudioFileClip(translated_audio)

    new_audioclip = CompositeAudioClip([audioclip])
    new_videoclip = f"{outputs_path}/videos/{video_title}.mp4"
    
    videoclip.audio = new_audioclip
    videoclip.write_videofile(new_videoclip)
    
    return new_videoclip

# TTS function
def tts_transcription(output_nmt, video_input, video_title, voice_type, tts_client):
    
    # set up tts config
    sample_rate_hz = 16000
    req = { 
            "language_code"  : "en-US",
            "encoding"       : riva.client.AudioEncoding.LINEAR_PCM ,  
            "sample_rate_hz" : sample_rate_hz,                       
            "voice_name"     : f"English-US.{voice_type}"                    
    }

    output_audio = 0
    output_audio_file = f"{outputs_path}/audios/{video_title}.wav"
    for i in range(len(output_nmt)):
        
        # add silence between audio sample
        if i==0:
            duration_silence = output_nmt[i][1]
        else:
            duration_silence = output_nmt[i][1] - output_nmt[i-1][2]
        silent_segment = AudioSegment.silent(duration = duration_silence)
        output_audio += silent_segment
        
        # create tts transcription
        req["text"] = output_nmt[i][0]
        resp = tts_client.synthesize(**req)
        sound_segment = AudioSegment(
            resp.audio,
            sample_width=2,
            frame_rate=16000,
            channels=1,
        )

        output_audio += sound_segment
    
    # export new audio as wav file
    output_audio.export(output_audio_file, format="wav")
    
    # add new voice on video
    voice_dubbing = add_audio_on_video(output_audio_file, video_input, video_title)
    
    return voice_dubbing