---
name: rayban-meta-wearables-dat
description: "Use when building apps for Ray-Ban Meta glasses."
version: 0.1.0
author: "Zoth / NullAI"
license: "MIT"
metadata:
  hermes:
    tags: [meta, ray-ban-meta, wearables, dat, glasses, camera, audio]
    related_skills: [meta-model-api-quickstart, muse-spark-multimodal-agents, sam3-segmentation]
---

# Ray-Ban Meta / Wearables DAT apps

Build an app that reaches Ray-Ban Meta glasses through Meta's Wearables Device
Access Toolkit (DAT): camera frames and audio from the glasses, driven by a
companion app on the phone.

## When to Use

- Building an iOS or Android companion app for Ray-Ban Meta glasses.
- Streaming camera frames or audio from the glasses into your app.
- Wiring a glasses feed into a Meta model (vision, segmentation, transcription).
- You need the register/pair/session flow and are about to guess SDK names.

> **Namespace caution.** DAT SDK class names, method names, and manifest entries
> are version-specific. This skill describes the **flow**; take the actual
> identifiers from the current Meta Wearables DAT developer docs. See
> [references/dat-overview.md](references/dat-overview.md). Do not invent an SDK
> symbol — look it up.

## 1. Register and set up the app

- Register the app as a developer app for the Wearables platform and get the
  credentials the DAT docs require (per-platform app registration). Read the
  docs for the exact registration fields — do not guess them.
- Add the DAT SDK dependency for your platform (iOS or Android) **as the docs
  name it**; copy the dependency coordinate from the setup guide.
- Declare only the capabilities/permissions you actually use (camera, audio).

## 2. Pair and start a session

- The glasses pair with the phone; your companion app requests a session with the
  connected device.
- Flow (names per the docs): register developer app -> request device access /
  permission -> create a session with the paired glasses -> start the stream(s)
  you need -> end the session cleanly.
- Handle the not-paired, permission-denied, and disconnected states explicitly;
  they are the common failure modes, not edge cases.

## 3. Consume the streams

- Camera: consume frames from the stream the docs expose; do not assume a raw
  frame format — use the documented frame type.
- Audio: consume the audio stream the docs expose; if you transcribe, feed it to
  Muse Voice Transcribe (`muse-voice-transcribe`).
- Forward frames to a Meta vision model (e.g. SAM 3.1 for `sam3-segmentation`, or
  the Muse Spark series for reasoning) the same way you would any image input.

```text
Glasses (camera/audio)  ->  DAT session on phone  ->  your pipeline  ->  Meta model
```

## 4. Verify

- Confirm a session is established before reading frames; log the device/session
  state transitions.
- Verify at least one real frame and one audio buffer arrive (non-empty, expected
  shape) before wiring them to a model.
- Verify the session ends and resources release when the app backgrounds or the
  user stops the stream — no dangling stream.

## Pitfalls

- **Invented SDK symbols.** The single biggest failure: guessing class or method
  names. Look each one up in the current DAT docs.
- **Skipped permission/consent.** Camera and audio require explicit user consent;
  build the request+denied paths.
- **Ignoring device state.** Handling only the happy path hides dropped
  connections and never-recovers sessions.
- **Leaking streams.** Not releasing the session on background burns battery and
  can lock the glasses to your app.

## Done when

Paired glasses establish a session, deliver a real frame and audio buffer into
the app, feed at least one Meta model call, and release cleanly on stop.
