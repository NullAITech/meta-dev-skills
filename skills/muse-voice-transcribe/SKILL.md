---
name: muse-voice-transcribe
description: "Use when transcribing speech with Muse Voice Transcribe."
version: 0.1.0
author: "Zoth / NullAI"
license: "MIT"
metadata:
  hermes:
    tags: [meta, muse-voice-transcribe, speech-to-text, audio, transcription]
    related_skills: [meta-model-api-quickstart, muse-spark-multimodal-agents]
---

# Muse Voice Transcribe

Turn audio into text with Muse Voice Transcribe via the Meta Model API, then use
the transcript safely downstream.

## When to Use

- Transcribing speech — meeting audio, voice notes, recordings, captions.
- Building a pipeline that feeds a transcript into Muse Spark for reasoning.
- You need the correct audio format/limits and are about to guess them.
- You need timestamps/segments and must confirm what the response actually returns.

## 1. Confirm the shape

Read the **Model list** for the exact model ID and the **API cookbook** for the
accepted audio formats, size/duration limits, and the transcript response schema
(plain text vs. segments with timestamps is version-specific). Copy field names
from the cookbook — do not invent them.

## 2. Prepare the audio

- Match the documented container/codec and sample rate; re-encode locally if the
  input does not match, rather than sending an unsupported format.
- Respect the documented size/duration limit — chunk longer audio at boundaries
  the cookbook supports, and keep chunk order in metadata.
- Strip or redact sensitive audio you do not need to send.

## 3. Call and capture

```python
# Fill in from the current API cookbook.
def transcribe(audio_bytes):
    # resp = <call Muse Voice Transcribe per the Model list + API cookbook>
    # return {"text": <documented text field>,
    #         "segments": <documented segments field, if any>,
    #         "request_id": resp.id}
    raise NotImplementedError("wire from the current API cookbook")
```

- Decode the documented text/segment field; if the model returns only raw text,
  do not fabricate timestamps.
- Store the request ID with the transcript.

## 4. Verify

- Feed a short clip with known words and confirm the transcript contains them.
- If you chunked audio, assert the concatenated transcript covers the whole
  recording in order (no dropped chunk, no duplicated boundary).
- Confirm that any timestamps you surface come from the model, not from a guess.

## Pitfalls

- **Unsupported audio.** Sending a format/codec outside the cookbook produces
  errors or empty transcripts — re-encode to the documented one.
- **Chunk boundaries.** Splitting mid-word or dropping a chunk silently corrupts
  the transcript; keep ordered metadata and verify coverage.
- **Invented timestamps.** Only surface timings the model returned.
- **Leaking audio.** Do not send recordings you have no right to process.

## Done when

A known clip transcribes to text containing the expected words, chunked audio
concatenates in order without loss, and the request ID is logged with the result.
