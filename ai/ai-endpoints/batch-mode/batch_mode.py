import os
import time

from openai import OpenAI

# Load environment variables: see https://endpoints.ai.cloud.ovh.net/ for more information
_OVH_AI_ENDPOINTS_ACCESS_TOKEN = os.environ["OVH_AI_ENDPOINTS_ACCESS_TOKEN"]
_OVH_AI_ENDPOINTS_BASE_URL = os.environ["OVH_AI_ENDPOINTS_BASE_URL"]

# Initialize the OpenAI-compatible client targeting OVHcloud AI Endpoints
client = OpenAI(
    base_url=_OVH_AI_ENDPOINTS_BASE_URL,
    api_key=_OVH_AI_ENDPOINTS_ACCESS_TOKEN,
)

# 1. Upload the input JSONL file with purpose="batch"
print("📤 Uploading input file...")
batch_input_file = client.files.create(
    file=open("requests.jsonl", "rb"),
    purpose="batch",
)
print(f"✅ Uploaded file id: {batch_input_file.id}")

# 2. Create the batch referencing the uploaded file
print("🚀 Creating batch...")
batch = client.batches.create(
    input_file_id=batch_input_file.id,
    endpoint="/v1/chat/completions",
    completion_window="24h",
    metadata={"description": "Batch mode example - OVHcloud AI Endpoints"},
)
print(f"✅ Batch created: {batch.id} (status: {batch.status})")

# 3. Poll the batch status until it reaches a terminal state
print("⏳ Polling batch status...")
while True:
    current = client.batches.retrieve(batch.id)
    print(f"   status={current.status} counts={current.request_counts}")
    if current.status in ("completed", "failed", "expired", "cancelled"):
        break
    time.sleep(30)

# 4. Download the results (and errors if any)
final = client.batches.retrieve(batch.id)

if final.output_file_id:
    print("📥 Downloading results.jsonl...")
    output = client.files.content(final.output_file_id)
    with open("results.jsonl", "wb") as f:
        f.write(output.read())
    print("✅ Results written to results.jsonl")

if final.error_file_id:
    print("🐛  Downloading errors.jsonl...")
    errors = client.files.content(final.error_file_id)
    with open("errors.jsonl", "wb") as f:
        f.write(errors.read())
    print("🐛 Errors written to errors.jsonl")

print(f"🏁 Final batch status: {final.status}")
