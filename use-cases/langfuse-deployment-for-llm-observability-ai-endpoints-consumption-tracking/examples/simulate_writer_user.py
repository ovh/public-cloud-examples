# Use case: simulate a content writer user generating long-form output from a short prompt (intensive-OUTPUT)
# Model: OVHcloud AI Endpoints (Qwen3.6-27B)

# Run standalone: python3 simulate_writer_user.py

import re
import uuid

from dotenv import load_dotenv

load_dotenv()

from langfuse import Langfuse, get_client
from langfuse.api.commons.errors.not_found_error import NotFoundError
from langfuse.types import MaskOtelSpansParams, MaskOtelSpansResult, OtelSpanPatch

EMAIL_RE = re.compile(r"[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+")

SYSTEM_PROMPT_NAME = "content-generator"
SYSTEM_PROMPT_TEXT = (
    "You are a creative content strategist. You generate large batches of "
    "blog post ideas for a marketing team, each with a catchy title and a "
    "short description."
)


def get_or_create_prompt():
    """Fetch the Langfuse-managed system prompt, creating it on first run
    against a fresh Langfuse project."""
    lf = get_client()
    try:
        return lf.get_prompt(SYSTEM_PROMPT_NAME, label="production", type="chat")
    except NotFoundError:
        lf.create_prompt(
            name=SYSTEM_PROMPT_NAME,
            type="chat",
            prompt=[{"role": "system", "content": SYSTEM_PROMPT_TEXT}],
            labels=["production"],
        )
        return lf.get_prompt(SYSTEM_PROMPT_NAME, label="production", type="chat")


def mask_otel_spans(*, params: MaskOtelSpansParams) -> MaskOtelSpansResult:
    patches = {}
    for identifier, span in params.spans.items():
        changed = {}
        for key, value in span.attributes.items():
            if isinstance(value, str) and EMAIL_RE.search(value):
                changed[key] = EMAIL_RE.sub("[REDACTED_EMAIL]", value)
        if changed:
            patches[identifier] = OtelSpanPatch(set_attributes=changed)
    return MaskOtelSpansResult(span_patches=patches)


Langfuse(mask_otel_spans=mask_otel_spans)

from langfuse.openai import openai  # drop-in replacement for `import openai`

client = openai.OpenAI()  # OPENAI_API_KEY / OPENAI_BASE_URL -> OVHcloud AI Endpoints
MODEL = "Qwen3.6-27B"
USER_ID = "user-writer-01"


def chat_turn(*, messages, name, session_id, user_id, tags, prompt):
    content = ""
    with client.chat.completions.create(
        model=MODEL,
        messages=messages,
        stream=True,
        stream_options={"include_usage": True},
        name=name,
        langfuse_prompt=prompt,
        metadata={
            "langfuse_session_id": session_id,
            "langfuse_user_id": user_id,
            "langfuse_tags": tags,
        },
    ) as stream:
        for chunk in stream:
            if chunk.choices and chunk.choices[0].delta and chunk.choices[0].delta.content:
                content += chunk.choices[0].delta.content
            # Don't break on finish_reason=="stop": the usage-only chunk
            # arrives after it on this provider.
    get_client().flush()
    return content


def run_writer_user():
    session_id = f"session-{uuid.uuid4().hex[:8]}"
    tags = ["feature:content-generator", "persona:intensive-output"]
    prompt = get_or_create_prompt()

    messages = prompt.compile() + [
        {
            "role": "user",
            "content": (
                "Generate 40 blog post ideas about remote work "
                "productivity. For each idea: a catchy title and a "
                "3-sentence description."
            ),
        },
    ]
    print(f"[{USER_ID}] generating long-form content ({MODEL})...")
    chat_turn(messages=messages, name="content-generation",
              session_id=session_id, user_id=USER_ID, tags=tags, prompt=prompt)


if __name__ == "__main__":
    run_writer_user()
