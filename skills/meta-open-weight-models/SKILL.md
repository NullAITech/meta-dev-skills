---
name: meta-open-weight-models
description: "Use when running Muse open-weight models yourself."
version: 0.1.0
author: "Zoth / NullAI"
license: "MIT"
metadata:
  hermes:
    tags: [meta, open-weights, muse-glimmer, muse-spark-open, baseten, modal, fireworks]
    related_skills: [meta-model-api-quickstart, muse-spark-multimodal-agents]
---

# Meta open-weight models

Deploy and call Meta's open-weight models — Muse Glimmer and Muse Spark Open — on
your own or a partner's infrastructure.

## When to Use

- Self-hosting or serving Meta's open-weight models (Muse Glimmer, Muse Spark
  Open) instead of calling hosted-only models.
- Deploying an open-weight endpoint on Baseten, Modal, or Fireworks.
- You hit a "model not found" error because the model ID on a partner differs from
  the public docs.
- You need to reason about throughput limits (e.g. TPM) for an open-weight
  endpoint.

## 1. Pick the host

| Host | What the guide offers | Notes |
|---|---|---|
| Baseten | $100 credits + 2M TPM, up to 2000 participants | Use model id `muse-spark-open-1026` |
| Modal | $100 to first 1000 | Meta open-weight endpoints + GPUs |
| Fireworks | $25 for select teams + workshop | — |

These are partner allocations, not guarantees — request them through the partner's
process. Read the **OSS cookbook** for the supported deployment path before you
start.

## 2. Get the right model ID

Open weights are published under Meta's names (Muse Glimmer, Muse Spark Open), but
a host may expose them under a **different, host-specific ID**:

- Baseten's hackathon ID is `muse-spark-open-1026`.
- The docs may show `muse-spark-open` (no suffix) — the IDs differ.

Always take the ID from the host's own model list / deployment output, not from a
docs page about a different surface.

## 3. Deploy and point a client at it

- Follow the OSS cookbook / host docs for the deploy step; copy the exact endpoint
  and request shape from the host's own API reference.
- Put the endpoint URL and API key in the environment:

```sh
export OPEN_WEIGHT_BASE_URL="<endpoint URL from the host>"
export OPEN_WEIGHT_API_KEY="<host key>"
export OPEN_WEIGHT_MODEL_ID="<host-specific id, e.g. muse-spark-open-1026>"
```

- Reuse the request shape the host documents — do not assume the hosted Meta Model
  API's field names carry over unchanged.

## 4. Verify

- A cold start can take time: poll the host's readiness signal before sending real
  traffic, and handle the warm-up window in the client.
- Confirm a minimal request returns 2xx with a non-empty body using the
  host-specific ID.
- Confirm the rate/TPM limit you were granted and keep concurrency under it.

## Pitfalls

- **Wrong ID.** Copying `muse-spark-open` when the host serves `...-1026` (or vice
  versa) yields model-not-found. Use the host's ID.
- **Assumed request shape.** A partner's endpoint may differ from the hosted Meta
  Model API; take the shape from the host's reference.
- **Cold starts.** Treating an unready endpoint as a failed request wastes budget
  on retries; poll readiness first.
- **Limit overrun.** Exceeding the granted TPM is rate-limited, not free; batch and
  throttle to the allowance.

## Done when

An open-weight endpoint on the chosen host serves a minimal request with the
host-specific model ID, readiness/limits are accounted for in the client, and the
endpoint URL/key live in the environment.
