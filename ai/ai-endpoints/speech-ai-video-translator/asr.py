inputs_path = "/workspace/inputs"
outputs_path = "/workspace/outputs"
directories = ["videos", "audios", "subtitles"]

# ASR function
def asr_transcription(audio_input, client):
    with open(audio_input, "rb") as audio_file:
        response = client.audio.transcriptions.create(
            model="whisper-large-v3",
            file=audio_file,
            language="fr",
            response_format="verbose_json",
            timestamp_granularities=["segment", "word"]
        )

    output_asr = []
    for segment in response.segments:
        # Format: [sentence, start_time, end_time]
        output_asr.append([
            segment.text.strip(),  # clean up whitespace
            round(segment.start, 4),  # start time in seconds
            round(segment.end, 4)     # end time in seconds
        ])
    
    return output_asr