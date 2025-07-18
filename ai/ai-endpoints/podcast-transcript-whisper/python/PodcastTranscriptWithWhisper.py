import os
import json
from openai import OpenAI

# 🛠️ OpenAI client initialisation
client = OpenAI(base_url=os.environ.get('OVH_AI_ENDPOINTS_WHISPER_URL'), 
                api_key=os.environ.get('OVH_AI_ENDPOINTS_ACCESS_TOKEN'))

# 🎼 Audio file loading
with open("../resources/TdT20-trimed-2.mp3", "rb") as audio_file:
    # 📝 Call Whisper transcription API
    transcript = client.audio.transcriptions.create(
        model=os.environ.get('OVH_AI_ENDPOINTS_WHISPER_MODEL'),
        file=audio_file,
        temperature=0.0,
        response_format="verbose_json",
        extra_body={"diarize": True},
    )

# 🔀 Merge the dialog said by the same speaker     
diarizedTranscript = ''
speakers = ["Aurélie", "Guillaume", "Stéphane"]
previousSpeaker = -1
jsonTranscript = json.loads(transcript.model_dump_json())

# 💬 Only the diarization field is useful
for dialog in jsonTranscript["diarization"]:
    speaker = dialog.get("speaker")
    text = dialog.get("text")
    if (previousSpeaker == speaker):
        diarizedTranscript += f" {text}"
    else:
        diarizedTranscript += f"\n\n{speakers[speaker]}: {text}"
    previousSpeaker = speaker


print(f"\n📝 Diarized Transcript 📝:\n{diarizedTranscript}")



