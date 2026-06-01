# AI Endpoints - Batch mode (Python)

This project illustrates how to use the [AI Endpoints](https://www.ovhcloud.com/en/public-cloud/ai-endpoints/catalog/) Batch API
(`/v1/batches`) from Python with the official [OpenAI](https://pypi.org/project/openai/) client.

The Batch API lets you submit a large number of inference requests in a single
asynchronous job, instead of sending them one by one through synchronous
endpoints such as `/v1/chat/completions`. Results are delivered within a maximum
of 24 hours after the batch is submitted.

Reference documentation: [AI Endpoints - Batch mode](https://docs.ovhcloud.com/en/guides/public-cloud/ai-machine-learning/ai-endpoints-batch-mode).

## 🧰 Pre requisites 🧰

- Python 3.10+ installed
- An AI Endpoints API key (anonymous mode is **not** supported on the batch and files endpoints)
- The following environment variable created:
  - `AI_ENDPOINT_API_KEY`: your AI Endpoints API token. See the [Getting started guide](https://docs.ovhcloud.com/en/guides/public-cloud/ai-machine-learning/ai-endpoints-getting-started#generating-your-first-api-access-key)
    to know how to generate it.
- Optionally, `AI_ENDPOINT_BASE_URL` if you want to override the default base URL
  (`https://oai.endpoints.kepler.ai.cloud.ovh.net/v1`).

## 📁 Files

- `requests.jsonl`: example input file in [JSON Lines](https://jsonlines.org/) format.
  Each line describes one independent request (`custom_id`, `method`, `url`, `body`).
  `custom_id` values must be unique within a batch; they are the only reliable
  way to correlate outputs to their inputs.
- `batch_mode.py`: end-to-end example that uploads the input file, creates the
  batch, polls its status and downloads the result/error files.
- `requirements.txt`: Python dependencies.

## ▶️ How to use the project

1. Install the required dependencies:

    ```bash
    pip install -r requirements.txt
    ```

2. Export your API key:

    ```bash
    export AI_ENDPOINT_API_KEY='your_api_key'
    ```

3. (Optional) Edit `requests.jsonl` to add your own prompts. Make sure each
   `custom_id` is unique and that the targeted `model` exists in the
   [AI Endpoints catalog](https://www.ovhcloud.com/en/public-cloud/ai-endpoints/catalog/).

4. Run the example:

    ```bash
    python batch_mode.py
    ```

Once the batch is `completed`, results are written to `results.jsonl` (and
`errors.jsonl` if at least one request failed). Each output line mirrors the
response of the synchronous endpoint and echoes back the `custom_id` so you can
map it to the original request.
