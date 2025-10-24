This project illustrate how to use Automatic Speech Recognition (ASR) and Large Language Models (LLM) to build an **Audio Summarizer Assistant** with [AI Endpoints](https://endpoints.ai.cloud.ovh.net/).

## How to use the project

- install the required dependencies: `pip install -r requirements.txt`
- install `ffmpeg` and `ffprob`

- create the `.env` file:
```
ASR_AI_ENDPOINT=https://whisper-large-v3.endpoints.kepler.ai.cloud.ovh.net/api/openai_compat/v1
LLM_AI_ENDPOINT=https://mixtral-8x7b-instruct-v01.endpoints.kepler.ai.cloud.ovh.net/api/openai_compat/v1
OVH_AI_ENDPOINTS_ACCESS_TOKEN=<ai-endpoints-api-token>
```  

- launch the Gradio app: `python audio-summarizer-app.py`

![image](audio-summarizer-web-app.png)
