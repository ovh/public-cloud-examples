# Use case: simulate 4 developer users doing multi-turn code generation/review
# Model: OVHcloud AI Endpoints (gpt-oss-120b)

# Run standalone: python3 simulate_dev_users.py

import re
import uuid

from dotenv import load_dotenv

load_dotenv()

from langfuse import Langfuse, get_client
from langfuse.api.commons.errors.not_found_error import NotFoundError
from langfuse.types import MaskOtelSpansParams, MaskOtelSpansResult, OtelSpanPatch

EMAIL_RE = re.compile(r"[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+")

SYSTEM_PROMPT_NAME = "code-assistant"
SYSTEM_PROMPT_TEXT = (
    "You are a senior software engineer. You write clean, well-tested "
    "Python code, explain your reasoning briefly, and always consider edge "
    "cases."
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
MODEL = "gpt-oss-120b"


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


# Each dev has a different task so traces aren't literal duplicates.
CODE_TASKS = {
    "user-dev-01": (
        "Write a Python function that checks whether a given string is a "
        "palindrome, ignoring case and spaces.",
        "Now also ignore punctuation, handle empty strings as an edge "
        "case, and add 3 pytest unit tests.",
    ),
    "user-dev-02": (
        "Write a Python function that merges two already-sorted lists of "
        "integers into a single sorted list.",
        "Now make it remove duplicates from the merged result, and add "
        "pytest unit tests covering empty-list inputs.",
    ),
    "user-dev-03": (
        "Write a Python function that flattens a nested list of arbitrary "
        "depth into a single flat list.",
        "Add type hints, a docstring, and handle the case where the input "
        "contains non-list, non-int elements.",
    ),
    "user-dev-04": (
        "Write a Python function that counts word frequency in a block of "
        "text and returns the top N most common words.",
        "Make it case-insensitive, strip punctuation, and add a pytest "
        "test with a short sample text.",
    ),
}


def run_dev_user(user_id):
    session_id = f"session-{uuid.uuid4().hex[:8]}"
    tags = ["feature:code-assistant", "persona:code"]
    task, followup = CODE_TASKS[user_id]
    prompt = get_or_create_prompt()

    messages = prompt.compile() + [{"role": "user", "content": task}]
    print(f"[{user_id}] turn 1 ({MODEL})...")
    reply = chat_turn(messages=messages, name="code-generation",
                       session_id=session_id, user_id=user_id, tags=tags,
                       prompt=prompt)
    messages.append({"role": "assistant", "content": reply})

    messages.append({"role": "user", "content": followup})
    print(f"[{user_id}] turn 2 ({MODEL})...")
    chat_turn(messages=messages, name="code-review-followup",
              session_id=session_id, user_id=user_id, tags=tags, prompt=prompt)


if __name__ == "__main__":
    for uid in CODE_TASKS:
        run_dev_user(uid)
