## Langfuse tracing examples

Four standalone scripts, each simulating one usage profile against OVHcloud
AI Endpoints, traced with Langfuse:

| Script | Users | Model | Profile |
|---|---|---|---|
| `simulate_dev_users.py` | `user-dev-01..04` | `gpt-oss-120b` | multi-turn code gen/review, balanced tokens |
| `simulate_support_users.py` | `user-support-01/02` | `Mistral-Small-3.2-24B-Instruct-2506` | short FAQ Q&A, minimal tokens |
| `simulate_analyst_user.py` | `user-analyst-01` | `Qwen3.5-397B-A17B` | one long-document summary, input-heavy |
| `simulate_writer_user.py` | `user-writer-01` | `Qwen3.6-27B` | one short prompt -> long-form output, output-heavy |

- Each script is fully self-contained (own Langfuse setup, own OpenAI client)
and runs independently against a fresh Langfuse project with no prior setup.
- Each user gets `session_id`/`user_id`/`tags` (`feature:*`, `persona:*`) via
Langfuse's metadata convention, and fetches its system prompt from Langfuse
Prompt Management (`code-assistant`, `faq-bot`, `document-summarizer`,
`content-generator`), creating it automatically on first run if it doesn't
exist yet -- see "prompts and pricing" below.

All four were instrumented per the
[langfuse/skills](https://github.com/langfuse/skills) instrumentation guide,
using the OpenAI SDK drop-in integration pointed at OVHcloud AI Endpoints
(OpenAI-compatible) instead of OpenAI directly.

### Setup

```bash
cd examples
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
```

Fill in `OPENAI_API_KEY`/`OPENAI_BASE_URL` (your OVH AI Endpoints token +
`https://oai.endpoints.kepler.ai.cloud.ovh.net/v1`) and
`LANGFUSE_PUBLIC_KEY`/`LANGFUSE_SECRET_KEY`/`LANGFUSE_BASE_URL`.

### Run simulations

```bash
python3 simulate_dev_users.py
python3 simulate_support_users.py
python3 simulate_analyst_user.py
python3 simulate_writer_user.py
```

### Prompts and pricing

- **System prompts**: each script fetches its prompt from Langfuse Prompt
  Management (`code-assistant`, `document-summarizer`, `faq-bot`,
  `content-generator`, label `production`) and creates it on the spot,
  version 1, if the fetch 404s -- no separate setup script or manual step
  needed, on this Langfuse project or a brand new one. Linking traces to a
  versioned prompt (rather than an inline string) is what makes
  prompt-scoped dashboard widgets work, e.g. average time-to-first-token
  grouped by prompt name. Verified by deleting `faq-bot` from a live project
  and re-running `simulate_support_users.py`: it recreated the prompt and
  completed normally.
- **Model pricing**: this one is still a manual, one-time API call, not
  something the scripts do automatically. OVHcloud AI Endpoints models aren't
  in Langfuse's built-in price table, so cost shows `$0` on every trace until
  you register each model's price via `POST /api/public/models`. Prices come
  from `https://catalog.endpoints.ai.ovh.net/rest/v1/models_v2` (the AI Endpoints catalog page). See
  the **Reference Architecture** (the "cost tracking for AI Endpoints usage" section) for the
  exact snippet.

  > *Note:* that catalog's **pricing is in EUR**, not USD, despite Langfuse always
  rendering cost with a `$` sign (there's no currency setting in Langfuse).
  Read every `$` in this project's Langfuse costs as `€`.