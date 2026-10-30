---
name: muse-image-and-wonder
description: "Use when generating images with Muse Image or Wonder."
version: 0.1.0
author: "Zoth / NullAI"
license: "MIT"
metadata:
  hermes:
    tags: [meta, muse-image, muse-wonder, image-generation, creative]
    related_skills: [meta-model-api-quickstart, muse-spark-multimodal-agents]
---

# Muse Image and Muse Wonder

Generate images and creative assets with Muse Image and Muse Wonder via the Meta
Model API, without inventing the request shape or shipping assets you have no
rights to.

## When to Use

- Generating images with Muse Image.
- Producing creative/artistic output with Muse Wonder.
- Turning a Muse Spark description into a rendered asset.
- Building a "creative" project and needing a rights-safe asset pipeline.

## 1. Confirm the request shape

Read the **Model list** for the exact model ID and the **API cookbook** for the
request/response schema. Prompt fields, size/aspect fields, and the response image
field are version-specific — copy them from the cookbook. Do not invent parameter
names.

## 2. Author the prompt

- State subject, style, composition, and constraints explicitly; leave out what you
  do not want.
- Keep one strong idea per request so a failure is diagnosable.
- Keep prompts in code/config, not scattered across the app, so they are diffable.

## 3. Call and store the asset

```python
# Fill in from the current API cookbook.
def generate(prompt):
    # resp = <call Muse Image / Muse Wonder per the Model list + API cookbook>
    # image_bytes = <decode the documented response image field>
    # return save_with_provenance(prompt, image_bytes)
    raise NotImplementedError("wire from the current API cookbook")
```

- Decode the response's image field exactly as the cookbook says; do not assume a
  URL vs. base64.
- Save the prompt and the model ID **with** the asset (a sibling `.json`) so every
  image is reproducible and attributable.

## 4. Verify

- A success is a decoded image with a valid header (e.g. the format's magic bytes),
  not an error object serialized to disk.
- Open the saved file; confirm it is not a zero-byte or placeholder asset.

## Pitfalls

- **Rights.** Only use and ship assets you have the right to use. Do not commit
  generated assets whose licensing you have not confirmed. Banned content and
  third-party IP are out of scope.
- **Error-as-image.** Writing the raw response body to a `.png` produces a corrupt
  file when the call failed. Check status/fields before decoding.
- **Lost provenance.** An asset without its prompt and model ID cannot be
  regenerated or debugged.
- **Guessed parameters.** Size/aspect/prompt field names are copy-from-docs, not
  from memory.

## Done when

A generated image decodes to a valid file, its prompt and model ID are stored
alongside it, and the asset's rights/provenance are recorded.
