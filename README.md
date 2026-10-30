# Meta dev skills

**Meta dev skills** is a public, reusable pack of AI-optimized, modular instructions
(open-standard agent skills) for building on Meta's AI developer stack. It grounds
coding agents — Claude Code, OpenAI Codex, Cursor, Muse Code, and Hermes — with the
workflows, constraints, and gotchas that come up when you build with Meta's models,
Meta's open weights, the Muse Code coding agent, and Ray-Ban Meta / Wearables glasses.

Each skill is one `SKILL.md` with YAML frontmatter and a `## When to Use` section,
following the open-standard agent skills format (<https://agentskills.io/home>).
Skills are picked up automatically when a task matches their triggers.

Part of the Zoth / NullAI skills collection. MIT licensed.

## What the stack covers

- **Meta Model API models** — Muse Spark series, Muse Wonder, Muse Image,
  Muse Voice Transcribe, SAM 3.1.
- **Meta open-weight models** — Muse Glimmer and Muse Spark Open.
- **Muse Code** — Meta's coding agent.
- **Ray-Ban Meta / Wearables** — apps built with the Wearables Device Access
  Toolkit (DAT).

## Skills

| Slug | What it covers |
|---|---|
| `meta-model-api-quickstart` | First API call: account, credits, auth, model IDs, spend limits |
| `muse-spark-multimodal-agents` | Multimodal, tool-calling agents on the Muse Spark series |
| `sam3-segmentation` | Promptable segmentation with SAM 3.1 |
| `muse-image-and-wonder` | Image and creative generation, asset rights |
| `muse-voice-transcribe` | Speech-to-text and captioning |
| `muse-code-agent` | Delegating coding work to Muse Code |
| `meta-open-weight-models` | Self-hosting Muse Glimmer / Muse Spark Open |
| `rayban-meta-wearables-dat` | Ray-Ban Meta / Wearables DAT apps |

## Install

### Hermes

```
./INSTALL.sh                       # copies skills/ into ~/.hermes/skills/
./INSTALL.sh /path/to/skills_dir   # or an explicit target
HERMES_SKILLS_DIR=/x ./INSTALL.sh  # or via env var
```

`INSTALL.sh` is idempotent: it replaces an existing skill directory of the same
name and prints what it did. It never uses `sudo` and never touches the network.

Manual equivalent: copy each `skills/<slug>/` directory into `~/.hermes/skills/`.
For a named profile, use `~/.hermes/profiles/<name>/skills/`. Reload the session
for the skills to register.

### Claude Code

Copy each `skills/<slug>/` into `.claude/skills/` in your project (or
`~/.claude/skills/` to apply to all projects). Or, once the repo is published,
install it as a plugin marketplace:

```
/plugin marketplace add NullAITech/meta-dev-skills
/plugin install meta-dev-skills@meta-dev-skills
```

### Cursor

Copy each `skills/<slug>/` into `.cursor/skills/` in your project (or the
user-level equivalent). Cursor also reads a root `AGENTS.md`; referencing the
skills there improves routing.

### Codex

Copy each `skills/<slug>/` into `~/.codex/skills/`. Or install as a plugin
marketplace:

```
codex plugin marketplace add NullAITech/meta-dev-skills
codex plugin add meta-dev-skills@meta-dev-skills
```

### Muse Code

Point Muse Code at the `skills/` tree (or wherever you copied it) the same way as
the other agents: add the skill directories to the location Muse Code reads
skills from in your setup.

> Exact skill directory paths vary by tool version — check your tool's own skill
> documentation. The `skills/<slug>/` layout is what every tool consumes.

## Credits, hosting, and partner facts

Taken from the participant guide for the Meta Global AI Developer Hackathon:

- **$150 Meta Model API credits** per accepted participant. Claimed individually
  (non-transferable) via the Meta Global AI Hackathon Model API Credit Claims
  form, by the submission deadline. **A credit card must be on the account to
  call the API.** Set a spend-limit notification so you do not exceed the budget.
- **Partner hosting** (not guaranteed, select participants):
  - **Baseten** — $100 credits + 2M TPM (up to 2000 participants). Use model id
    `muse-spark-open-1026`; the docs may say `muse-spark-open` — the hackathon ID
    differs.
  - **Modal** — $100 to the first 1000, for Meta open-weight endpoints + GPUs.
  - **Fireworks** — $25 for select teams, plus a workshop.
- **Meta docs referenced by the guide** — Overview, Quickstart, Model list, API
  cookbook, Muse Code recipes, OSS cookbook.

## Disclaimer

This pack describes **workflows and constraints, not the current API surface.**
Model IDs, endpoints, parameter names, and SDK class names change. **Always verify
exact identifiers against the current Meta documentation** (Overview, Quickstart,
Model list, API cookbook, Muse Code recipes, OSS cookbook) before writing code.
Where a skill names an identifier, treat it as a pointer to check, not a guarantee.
AI can make mistakes — double-check the results against the live docs.

## Contributing

Issues and pull requests are welcome: new skills, corrections, and better
pitfalls.

## License

MIT — see [LICENSE](LICENSE). Copyright (c) 2026 Zoth / NullAI.
