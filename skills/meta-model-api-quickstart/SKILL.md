---
name: meta-model-api-quickstart
description: "Use when making your first Meta Model API call."
version: 0.1.0
author: "Zoth / NullAI"
license: "MIT"
metadata:
  hermes:
    tags: [meta, model-api, quickstart, credits, auth]
    related_skills: [muse-spark-multimodal-agents, sam3-segmentation, meta-open-weight-models]
---

# Meta Model API quickstart

Get a Meta Model API call working end to end: account, credits, auth, choosing the
right model, a first request, and a spend guard.

## When to Use

- You are about to call a Meta Model API model for the first time.
- You need to set up auth, API keys, or base URLs for Meta's hosted models.
- You need to claim, track, or limit API credits and spend.
- You need the **correct, callable** model ID for a Meta Model API model.
- You keep getting 401 / 403 / 404 or "model not found" errors.

Do not use this for self-hosted serving of Meta's open weights — see
`meta-open-weight-models` instead.

## 1. Confirm the account prerequisites

- Credits must be claimed for the account. Each accepted participant claims their
  own allocation; it is non-transferable. Claim before the deadline.
- **A credit card must be on the account** — the API is not callable without it.
- Add a **spend-limit notification** immediately after the card is added, before
  the first call. Build loops later, not before the limit exists.

## 2. Get the real identifiers from the docs

Never invent the base URL, auth header, request body, or model ID. Read, in order:

1. **Overview** — what the API is and which models it serves.
2. **Quickstart** — base URL, authentication, and a minimal request.
3. **Model list** — the exact, callable model IDs.
4. **API cookbook** — request and response shapes per model.

Copy exact strings from those pages. A model ID on a marketing table is not
always the callable ID.

## 3. Make a first call

Keep credentials and identifiers in the environment, never in source:

```sh
export META_API_BASE_URL="<base URL from the Quickstart>"
export META_API_KEY="<your key>"
export META_MODEL_ID="<exact id from the Model list>"
```

Send the minimal request exactly as the Quickstart and Model list specify for the
model you picked. The request **path, auth header, and body field names are
model- and version-specific** — the ones below are placeholders:

```sh
curl -sS "$META_API_BASE_URL/<path from the Model list>" \
  -H "Authorization: Bearer $META_API_KEY" \
  -H "Content-Type: application/json" \
  --data "$(cat request.json)"
```

Replace `<path>`, `Authorization`, and the keys in `request.json` with the values
shown in the Model list / Quickstart for that model. Do not copy a path or field
name from a blog post or another model's example.

## 4. Verify the call

- Success is a **2xx response with a non-empty body** — not merely "the command
  exited 0".
- Log the response's request ID and any usage/cost fields; you need them for
  support and to attribute spend against the credit budget.
- On a model-not-found error, re-read the Model list: the ID is almost always the
  problem, not the endpoint.

## Pitfalls

- **Guessing model IDs.** IDs differ between a docs page and a partner/hackathon
  deployment. The same open weights can be exposed under a *different, suffixed*
  ID by a hosting partner. Take the ID from the surface you are actually calling.
- **No card, no call.** Credits alone are insufficient; the API returns auth
  errors without a payment method on the account.
- **No spend limit.** A runaway retry loop burns the allocation fast. Set the
  limit before you build the loop.
- **Secrets in git.** Projects are often public. Keep keys in environment
  variables or a git-ignored file — never commit them.

## Done when

A minimal request returns 2xx with a non-empty body, the request ID is captured,
and a spend limit/notification is configured.
