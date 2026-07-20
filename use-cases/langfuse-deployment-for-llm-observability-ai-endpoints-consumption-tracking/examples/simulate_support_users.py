# Use case: simulate 2 support users doing short FAQ-style Q&A
# Model: OVHcloud AI Endpoints (Mistral-Small-3.2-24B-Instruct-2506)

# Run standalone: python3 simulate_support_users.py

import re
import uuid

from dotenv import load_dotenv

load_dotenv()

from langfuse import Langfuse, get_client
from langfuse.api.commons.errors.not_found_error import NotFoundError
from langfuse.types import MaskOtelSpansParams, MaskOtelSpansResult, OtelSpanPatch

EMAIL_RE = re.compile(r"[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+")

SYSTEM_PROMPT_NAME = "faq-bot"
SYSTEM_PROMPT_TEXT = (
    "You are a friendly customer support assistant for a retail store. "
    "Answer questions briefly and politely, in at most two sentences."
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
MODEL = "Mistral-Small-3.2-24B-Instruct-2506"


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


FAQ_QUESTIONS = {
    "user-support-01": ("What are your opening hours?", "Thanks, and on weekends?"),
    "user-support-02": (
        "Do you offer international shipping?",
        "How long does that usually take?",
    ),
}


def run_support_user(user_id):
    session_id = f"session-{uuid.uuid4().hex[:8]}"
    tags = ["feature:faq-bot", "persona:basic"]
    q1, q2 = FAQ_QUESTIONS[user_id]
    prompt = get_or_create_prompt()

    messages = prompt.compile() + [{"role": "user", "content": q1}]
    print(f"[{user_id}] turn 1 ({MODEL})...")
    reply = chat_turn(messages=messages, name="faq-answer",
                       session_id=session_id, user_id=user_id, tags=tags,
                       prompt=prompt)
    messages.append({"role": "assistant", "content": reply})

    messages.append({"role": "user", "content": q2})
    print(f"[{user_id}] turn 2 ({MODEL})...")
    chat_turn(messages=messages, name="faq-answer-followup",
              session_id=session_id, user_id=user_id, tags=tags, prompt=prompt)


if __name__ == "__main__":
    for uid in FAQ_QUESTIONS:
        run_support_user(uid)
