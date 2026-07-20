# Use case: simulate an analyst user summarizing a long document (intensive-INPUT)
# Model: OVHcloud AI Endpoints (Qwen3.5-397B-A17B)

# Run standalone: python3 simulate_analyst_user.py

import re
import uuid

from dotenv import load_dotenv

load_dotenv()

from langfuse import Langfuse, get_client
from langfuse.api.commons.errors.not_found_error import NotFoundError
from langfuse.types import MaskOtelSpansParams, MaskOtelSpansResult, OtelSpanPatch

EMAIL_RE = re.compile(r"[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+")

SYSTEM_PROMPT_NAME = "document-summarizer"
SYSTEM_PROMPT_TEXT = (
    "You are a business analyst assistant. You summarize long documents "
    "into concise, actionable bullet points for busy executives."
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
MODEL = "Qwen3.5-397B-A17B"
USER_ID = "user-analyst-01"


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
    get_client().flush()
    return content


def _fake_quarterly_report():
    """Purely fictional company, generic business content, no real data."""
    sections = [
        """Quarterly Report - Cloud Infrastructure Division - Fictional Corp

Divisional revenue grew 18% year-over-year, driven mainly by increasing
adoption of managed compute offerings and object storage services. Demand
for dedicated GPU instances used for language model training more than
doubled compared to the previous quarter, reflecting the broader market
trend toward regional hosting of AI workloads.""",
        """Operating costs increased by 9%, mainly due to capacity expansion in
two new regional data centers and the growth of the reliability engineering
team responsible for managed database uptime. Three new availability zones
went live this quarter, adding forty-two thousand vCPU cores of additional
compute capacity to the fleet.""",
        """On the product side, the team shipped native support for a modern
ingress controller as the recommended default on managed Kubernetes
clusters, replacing an older option whose community support has been
shrinking. Automatic certificate provisioning was also simplified, with
public load balancers now provisioned automatically during cluster setup.""",
        """The managed AI inference service saw the strongest growth in the
portfolio, with eight new models added to the catalog this quarter,
including several large mixture-of-experts models and one openly licensed
general-purpose model. Monthly token throughput increased by a factor of
3.4 compared to the previous quarter. Customers using these endpoints for
observability workflows now represent 22% of total divisional traffic.""",
        """Customer satisfaction scores remained stable at 4.3 out of 5. The
main friction points reported by support concerned discovering the
non-standard ports assigned to managed database instances, as well as
configuring initial network access rules for some database services. A
revision of the onboarding documentation is planned for next quarter to
clarify these points.""",
        """On the security side, no major incidents were reported this quarter.
An external audit of default TLS configurations on public load balancers
confirmed compliance with current best practices. The automatic certificate
renewal success rate reached 99.7%, with the remaining 0.3% linked to DNS
zones that had not fully propagated at renewal time.""",
        """Looking ahead, next quarter's forecast anticipates continued growth
in managed AI inference usage, with a planned rollout of larger-scale
multimodal inference capacity (vision and audio), as well as the
introduction of more granular token-based billing to support internal
cost allocation for large enterprise customers.""",
    ]
    # Repeat/interleave to build a genuinely large document (2500+ words)
    return "\n\n".join(sections * 3)


def run_analyst_user():
    session_id = f"session-{uuid.uuid4().hex[:8]}"
    tags = ["feature:doc-summarizer", "persona:intensive-input"]
    prompt = get_or_create_prompt()

    report = _fake_quarterly_report()
    messages = prompt.compile() + [
        {
            "role": "user",
            "content": (
                f"Here is the full quarterly report:\n\n{report}\n\n"
                "Summarize this report in 5 key bullet points, one "
                "sentence each."
            ),
        },
    ]
    print(f"[{USER_ID}] summarizing ~{len(report.split())} word report ({MODEL})...")
    chat_turn(messages=messages, name="doc-summary",
              session_id=session_id, user_id=USER_ID, tags=tags, prompt=prompt)


if __name__ == "__main__":
    run_analyst_user()
