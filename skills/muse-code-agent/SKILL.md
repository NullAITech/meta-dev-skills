---
name: muse-code-agent
description: "Use when delegating coding work to Muse Code."
version: 0.1.0
author: "Zoth / NullAI"
license: "MIT"
metadata:
  hermes:
    tags: [meta, muse-code, coding-agent, recipes, delegation]
    related_skills: [meta-model-api-quickstart, muse-spark-multimodal-agents]
---

# Muse Code agent

Delegate coding tasks to Muse Code, Meta's coding agent, and review its output
before it lands.

## When to Use

- Handing a scoped coding task to Muse Code (a feature, a refactor, a test).
- Working through the "Muse Code recipes" doc for a common workflow.
- Reviewing or integrating code that a coding agent produced.
- Setting up a reproducible task brief for an autonomous coding run.

## 1. Read the recipes first

Start from the **Muse Code recipes** doc for the workflow you actually want
(scaffold, edit, test, fix). The recipes define the supported invocation and
configuration; copy the exact commands/flags/field names from them rather than
inventing them. If a recipe does not cover your case, say so and adapt the closest
one — do not fabricate a new invocation.

## 2. Write a bounded task brief

- State the goal, the files/areas in scope, and the acceptance check.
- Give the minimal context needed (paths, existing conventions) — not the whole
  repo.
- Define done as a **verifiable** condition: a command that passes, a test that
  goes green, a diff that matches the spec.

```text
Goal:        <one sentence>
In scope:    <files/dirs>
Out of scope:<what must not change>
Acceptance:  <command + expected result>
```

## 3. Run and review the diff

- Run the task via the recipe's documented invocation.
- Review the produced diff line by line before accepting it; a coding agent's
  output is a proposal, not a merge.
- Check for: unrelated edits, dropped error handling, hardcoded secrets, and tests
  that assert nothing.

## 4. Verify

- Run the acceptance command from the brief. A green run is the evidence; "the
  agent said it worked" is not.
- Confirm the diff touches only in-scope files.
- Ensure the project remains buildable and public-ready (no secrets committed).

## Pitfalls

- **Unbounded scope.** A vague brief produces sprawling diffs; bound the files and
  the acceptance check.
- **Unreviewed merges.** Never commit agent output without reading it.
- **Invented invocations.** Use the recipes doc for commands/flags; do not guess.
- **Secret leakage.** Public repos: scrub keys and tokens from generated code.

## Done when

Muse Code produced a diff scoped to the brief, the acceptance command passes on
the merged result, and no secrets or out-of-scope edits remain.
