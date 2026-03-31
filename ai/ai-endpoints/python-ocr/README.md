# Python OCR with AI Endpoints

Extract text from images using a vision-capable model via [OVHcloud AI Endpoints](https://endpoints.ai.cloud.ovh.net/).

The script sends a local image to a vision LLM and returns the extracted text, preserving the original layout (tables, columns, line breaks) in Markdown format.

## 🧰 Prerequisites

- Python 3.12.x installed
- An OVHcloud AI Endpoints API token
- A vision-capable model (e.g. a VLM served by vLLM)
- A sample image file named `doc.png` in the project directory

## ⚙️ Environment variables

| Variable | Description |
|---|---|
| `OVH_AI_ENDPOINTS_ACCESS_TOKEN` | API token — see [documentation](https://help.ovhcloud.com/csm/en-gb-public-cloud-ai-endpoints-getting-started?id=kb_article_view&sysparm_article=KB0065401#generating-your-first-api-access-key) to generate one |
| `OVH_AI_ENDPOINTS_MODEL_URL` | Base URL of the model — see [AI Endpoints](https://www.ovhcloud.com/en/public-cloud/ai-endpoints/) |
| `OVH_AI_ENDPOINTS_VLLM_MODEL` | Model name — see [AI Endpoints](https://www.ovhcloud.com/en/public-cloud/ai-endpoints/) |

## 🚀 How to use

1. Install the required dependencies:

   ```bash
   pip install -r requirements.txt
   ```

2. Export the environment variables:

   ```bash
   export OVH_AI_ENDPOINTS_ACCESS_TOKEN="your-token"
   export OVH_AI_ENDPOINTS_MODEL_URL="https://..."
   export OVH_AI_ENDPOINTS_VLLM_MODEL="model-name"
   ```

3. Place the image you want to process as `doc.png` in this directory.

4. Run the script:

   ```bash
   python ocr_demo.py
   ```

The extracted text will be printed to the console.
