This project illustrate how to master Speech AI and create a **Video Translator** with [AI Endpoints](https://endpoints.ai.cloud.ovh.net/).
Subtitle and dub voices of any video using Automatic Speech Recognition (ASR), Neural Machine Translation (NMT) and Text To Speech (TTS) inside a powerful web app.

## How to use the project

- install the required dependencies: `pip install -r requirements.txt`

- create the `.env` file:
```
ASR_ENDPOINT=nvr-asr-fr-fr.endpoints-grpc.kepler.ai.cloud.ovh.net:443
NMT_ENDPOINT=nvr-nmt-en-fr.endpoints-grpc.kepler.ai.cloud.ovh.net:443
TTS_ENDPOINT=nvr-tts-en-us.endpoints-grpc.kepler.ai.cloud.ovh.net:443
OVH_AI_ENDPOINTS_ACCESS_TOKEN=<ai-endpoints-api-token>
```

- launch the Gradio app: `python3 main.py`

![image](video-translator-web-app.png)
