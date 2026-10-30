---
name: sam3-segmentation
description: "Use when adding SAM 3.1 segmentation to an app."
version: 0.1.0
author: "Zoth / NullAI"
license: "MIT"
metadata:
  hermes:
    tags: [meta, sam-3.1, segmentation, vision, masks]
    related_skills: [meta-model-api-quickstart, muse-spark-multimodal-agents]
---

# SAM 3.1 segmentation

Use SAM 3.1 (available via the Meta Model API) to segment objects in an image from
a prompt, then decode and post-process the masks.

## When to Use

- Segmenting objects in an image from a point, box, or text prompt.
- Extracting masks for downstream editing, cropping, or tracking.
- You need the correct input/output shape for SAM 3.1 and are tempted to guess.
- Your mask output arrives as encoded data and you do not know how to decode it.

## 1. Confirm the request and response shape

SAM 3.1 is served through the Meta Model API. Read, in this order:

1. **Model list** — the exact, callable SAM 3.1 model ID.
2. **API cookbook** — the accepted prompt types and the response schema.

Do not invent the prompt field names, the image encoding, or the mask field name.
Take them from the Model list and API cookbook for the current version.

## 2. Prepare the input

- Use the image format and size the cookbook specifies. Prefer the documented
  format over "whatever the file happens to be".
- Choose a prompt type the cookbook documents (for example a point, a box, or a
  text description — pick from the ones the cookbook actually lists).
- Keep the image and prompt in one request; the request, not a local library,
  defines the segmentation.

## 3. Call and decode

```python
# Shape follows the current API cookbook. Do not hardcode field names.
def segment(image_bytes, prompt):
    # resp = <call SAM 3.1 per the Model list + API cookbook>
    # masks = decode_masks(resp)   # use the decoder the cookbook documents
    raise NotImplementedError("wire from the current Model list + API cookbook")
```

- Masks are commonly returned in an encoded/compressed form. **Use the decoder the
  cookbook specifies**; do not assume a raw pixel array.
- Track the coordinate system: prompts are usually given in image pixel
  coordinates, so scale any UI coordinates back to image space before sending.

## 4. Verify

- Assert you received at least one mask for a prompt that should hit an object,
  and zero for a prompt on empty background.
- Render the mask over the source image and check it is non-empty and bounded by
  the image, not the whole frame.
- Record the request ID alongside the decoded mask for traceability.

## Pitfalls

- **Assuming a mask format.** Guessing the encoding yields garbage or a silent
  all-ones mask. Decode with the documented decoder and sanity-check the coverage.
- **Coordinate mismatch.** Point/box prompts in the wrong space segment the wrong
  region; convert UI coordinates to image pixels first.
- **Guessed field names.** The prompt/caption field name is version-specific —
  copy it from the cookbook.
- **Ignoring request limits.** Follow the documented image size/format limits
  rather than downscaling arbitrarily.

## Done when

A prompt on a real object returns ≥1 decoded, in-bounds mask, a prompt on
background returns none, and the request ID is logged.
