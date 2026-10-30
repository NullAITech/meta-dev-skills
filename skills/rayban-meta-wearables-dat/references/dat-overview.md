# Ray-Ban Meta / Wearables DAT — deeper reference

Companion reference for the `rayban-meta-wearables-dat` skill. It explains the
**shape** of a Wearables Device Access Toolkit (DAT) integration so you can plan
the app before you open the docs, and it tells you exactly which identifiers you
must look up rather than guess.

> **Verify everything named here.** DAT SDK classes, methods, manifest keys, and
> permission strings are version-specific and change. This file deliberately uses
> role names ("the session type", "the frame type") instead of pretending to know
> the current symbols. Open the current Meta Wearables DAT developer docs and
> substitute the real identifiers before writing code.

## What DAT is for

The Wearables Device Access Toolkit (DAT) is Meta's way for a phone app (iOS or
Android) to reach the sensors on Ray-Ban Meta glasses — principally the **camera**
and the **microphone/audio** — through a paired connection. Your app runs on the
phone; the glasses provide the streams.

## The integration has four phases

1. **Register** — you register a developer app for the Wearables platform and
   obtain the credentials your platform's setup requires. Do this on the Meta
   developer surface, following the DAT setup guide.
2. **Permission / device access** — the user grants the app access to the paired
   glasses. Treat this as a consent flow with a real "denied" branch.
3. **Session** — the app opens a session against the paired, connected glasses.
   A session is the unit you start and stop; streams belong to it.
4. **Streams** — inside the session you consume the camera stream and/or the
   audio stream. You read frames/buffers of the types the SDK documents.

## Look these up — do not guess

| You need | Where it comes from |
|---|---|
| SDK dependency coordinate(s) | DAT setup guide for your platform |
| The type/class that represents a device or session | DAT SDK reference |
| The start/stop session calls | DAT SDK reference |
| The camera frame type and its fields | DAT SDK reference |
| The audio buffer type and its fields | DAT SDK reference |
| Permission/capability strings for the manifest | DAT setup guide |
| Registration fields and credential names | DAT registration guide |

If a symbol is not in the above sources, it does not exist yet — do not invent it.

## Wiring glasses output into Meta models

- **Camera -> vision model.** The frame you read from the camera stream is an
  image input. Send it to a Meta vision model the same way you send any image:
  SAM 3.1 for segmentation (see `sam3-segmentation`), or the Muse Spark series for
  reasoning (see `muse-spark-multimodal-agents`).
- **Audio -> speech.** Feed the audio buffer to Muse Voice Transcribe (see
  `muse-voice-transcribe`) to get text, then reason over the text.

Keep the model IDs and endpoints in config/env (`meta-model-api-quickstart`), and
never hardcode a stream's pixel/buffer format — use the SDK's documented types.

## State machine to handle

Every one of these is a normal state, not an edge case:

```
unregistered -> registered -> no-device-paired -> permission-pending
             -> permission-denied | connected -> session-active
             -> session-ended | device-disconnected -> (recover)
```

Drive the UI from this state machine and log transitions; most "the glasses don't
work" reports are an unhandled transition, not a broken SDK call.

## Acceptance test for a fresh integration

1. A registered developer app launches on the phone.
2. The app detects paired glasses and requests permission (and shows a working
   denied path).
3. A session opens against the connected glasses.
4. At least one non-empty camera frame and one audio buffer arrive.
5. One model call consumes the frame or the audio and returns a result.
6. Stopping the session releases resources; re-starting works.
