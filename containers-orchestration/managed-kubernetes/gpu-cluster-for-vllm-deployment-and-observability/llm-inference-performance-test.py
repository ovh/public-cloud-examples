import time
import threading
import random
from statistics import mean
from openai import OpenAI
from tqdm import tqdm

APP_URL = "http://<EXTERNAL_IP>/v1"
MODEL = "qwen3-vl-8b"

CONCURRENT_WORKERS = 500          # concurrency
REQUESTS_PER_WORKER = 10
MAX_TOKENS = 200                  # generation pressure

# some random prompts
SHORT_PROMPTS = [
    "Summarize the theory of relativity.",
    "Explain what a transformer model is.",
    "What is Kubernetes autoscaling?"
]

MEDIUM_PROMPTS = [
    "Explain how attention mechanisms work in transformer-based models, including self-attention and multi-head attention.",
    "Describe how vLLM manages KV cache and why it impacts inference performance."
]

LONG_PROMPTS = [
    "Write a very detailed technical explanation of how large language models perform inference, "
    "including tokenization, embedding lookup, transformer layers, attention computation, KV cache usage, "
    "GPU memory management, and how batching affects latency and throughput. Use examples.",
]

PROMPT_POOL = (
    SHORT_PROMPTS * 2 +
    MEDIUM_PROMPTS * 4 +
    LONG_PROMPTS * 6    # bias toward long prompts
)

# openai compliance
client = OpenAI(
    base_url=APP_URL,
    api_key="foo"
)

# basic metrics
latencies = []
errors = 0
lock = threading.Lock()

# worker
def worker(worker_id):
    global errors
    for _ in range(REQUESTS_PER_WORKER):
        prompt = random.choice(PROMPT_POOL)

        start = time.time()
        try:
            client.chat.completions.create(
                model=MODEL,
                messages=[{"role": "user", "content": prompt}],
                max_tokens=MAX_TOKENS,
                temperature=0.7,
            )
            elapsed = time.time() - start

            with lock:
                latencies.append(elapsed)

        except Exception as e:
            with lock:
                errors += 1

# run
threads = []
start_time = time.time()

print("\n-> STARTING PERFORMANCE TEST:")
print(f"Concurrency: {CONCURRENT_WORKERS}")
print(f"Total requests: {CONCURRENT_WORKERS * REQUESTS_PER_WORKER}")

for i in range(CONCURRENT_WORKERS):
    t = threading.Thread(target=worker, args=(i,))
    t.start()
    threads.append(t)

for t in threads:
    t.join()

total_time = time.time() - start_time

# results
print("\n-> BENCH RESULTS:")
print(f"Total requests sent: {len(latencies) + errors}")
print(f"Successful requests: {len(latencies)}")
print(f"Errors: {errors}")
print(f"Total wall time: {total_time:.2f}s")

if latencies:
    print(f"Avg latency: {mean(latencies):.2f}s")
    print(f"Min latency: {min(latencies):.2f}s")
    print(f"Max latency: {max(latencies):.2f}s")
    print(f"Throughput: {len(latencies)/total_time:.2f} req/s")
