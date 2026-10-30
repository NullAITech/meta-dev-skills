---
name: muse-spark-multimodal-agents
description: "Use when building multimodal agents on Muse Spark."
version: 0.1.0
author: "Zoth / NullAI"
license: "MIT"
metadata:
  hermes:
    tags: [meta, muse-spark, agents, multimodal, tool-calling]
    related_skills: [meta-model-api-quickstart, sam3-segmentation, muse-voice-transcribe]
---

# Muse Spark multimodal agents

Build agents that mix text, images, and audio on the Muse Spark series, routing
each modality to the right Meta model and making every step verifiable.

## When to Use

- Building a multimodal agent (text + image + audio) on the Muse Spark series.
- Routing a request to the correct Meta model per modality.
- Designing a multi-step, tool-calling agent loop for a Meta-powered app.
- Making agent behavior **verifiable** — each step produces evidence you can show.

## 1. Map modalities to models

The Muse Spark series is Meta's multimodal family. Pair it with the specialist
models instead of forcing one model to do everything:

| Task | Model family |
|---|---|
| Text / image / audio reasoning | Muse Spark series |
| Speech-to-text | Muse Voice Transcribe |
| Segmentation / masks | SAM 3.1 |
| Image & creative generation | Muse Image / Muse Wonder |

Confirm the exact model ID and request fields for each in the **Model list** and
**API cookbook** before writing the router. Do not assume one model handles every
modality.

## 2. Design the loop

- Keep the loop explicit: assemble context -> choose model/tool -> call -> record
  result -> decide next step.
- Read every model ID and endpoint from config/env; never hardcode them.
- Give each tool a strict schema and validate the model's tool call against that
  schema **before** executing it.
- Emit evidence per step — request ID, input, output — so the final answer is
  auditable. The "verifiable agents" guidance is the standard to hit.

```python
import os

ROUTER = {
    "reason":  os.environ["META_SPARK_MODEL_ID"],
    "stt":     os.environ["META_VOICE_MODEL_ID"],
    "segment": os.environ["META_SAM_MODEL_ID"],
}

def run_step(modality, payload):
    """One agent step. Fill in the call from the API cookbook."""
    model = ROUTER[modality]
    # resp = <call per the API cookbook for `model`>
    # return {"model": model, "request_id": resp.id, "output": resp.output}
    raise NotImplementedError("wire the call from the current API cookbook")
```

## 3. Keep it verifiable

- A tool call is not "done" until the tool returned and its result was recorded.
- The final answer must cite the recorded step outputs, not restate the prompt.
- Log enough to replay the turn: ordered steps, model IDs, request IDs.

## 4. Verify

Run a two-turn loop with a stubbed tool. Assert the tool was actually invoked
(once, with a schema-valid argument) and that the final answer references the
tool's recorded output. If either assertion fails, the loop is narrating rather
than acting.

## Pitfalls

- **One-model-for-everything.** Forcing a single model to cover speech and
  segmentation as well as reasoning produces worse results and fragile prompts.
- **Unvalidated tool calls.** Executing a model's tool call without checking it
  against the schema turns a prompt error into a real side effect.
- **Hardcoded IDs.** IDs differ across surfaces (docs vs partner deployments), so
  config-driven IDs are the only portable choice.
- **Unverified turns.** An agent that reports success without a recorded tool
  result is the classic "looks done, isn't" failure.

## Done when

Each modality resolves to a config-driven model, tool calls are schema-validated
before execution, and a stubbed two-turn loop demonstrates the tool was invoked
and its output cited.
