---
as_at: "2026-07-04"
description: "The OWASP Agentic (ASI) Top 10 mapped against the provenance and authority model: every named risk resolves to the same small core of provenance tagging, a deterministic structural floor, and a conformance test against declared expectation."
---

# ASI Top 10 Through the Provenance and Authority Lens

The point of the [Data Provenance and Authority Boundaries](data-provenance-and-authority-boundaries.md) model is that most named agentic threats are one event wearing different labels: untrusted content crossing a trust boundary and being treated as an instruction rather than as data. This page demonstrates that claim against the [OWASP Top 10 for Agentic Applications (2026)](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/).

If the model holds, each ASI risk should resolve to some combination of the same small core, with no new control domain required:

- **Provenance tag** (the invariant): untrusted content is tagged as data at ingestion, the tag persists across hops, and data never self-promotes to instruction.
- **Structural floor** (deterministic): destination allowlist, port and protocol validation, parameter schema, asserted-authority check. Cheap, fail-closed, immune to phrasing.
- **Conformance test** (against declared expectation): did the agent use the right commands for its task, and did the result match what was expected, judged over the `(data, command, intent, output)` tuple against its [objective intent](../../maso/controls/objective-intent.md).
- **Consequence gate**: HITL on consequential or regulated actions, regardless of what passed above.

## The mapping

| ASI risk (2026) | The boundary event | Resolved by |
|---|---|---|
| **ASI01 Agent Goal Hijack** | Poisoned input tries to redirect the agent's objective. | **Provenance tag**: the poisoned input stays tagged as data and cannot self-promote to a new goal. **Conformance test**: a redirected objective produces commands and outputs that no longer match the declared expectation, and is caught as nonconformance. |
| **ASI02 Tool Misuse** | A structurally valid tool call is used for an unintended or unsafe end. | **Structural floor**: allowlist and parameter schema reject out-of-policy calls outright. **Conformance test**: the residue (a valid call that is the wrong call for this task) is exactly question 1, command-selection conformance. |
| **ASI03 Identity and Privilege Abuse** | An action asserts more authority than the trigger carried. | **Structural floor**: the asserted-authority check is the authority-transition special case of the invariant. A data-tagged trigger cannot license an elevated-authority action. **Conformance test**: scope used beyond the declared task is nonconformance. |
| **ASI04 Agentic Supply Chain** | An MCP server, tool, or skill is composed in at runtime. | **Provenance tag**: a composed component is data describing a workflow, tagged at ingestion, never granted the agent's authority by default. **Structural floor**: allowlist and signature checks on the component before it is reachable. **Conformance test**: its behaviour is measured against the declared expectation. |
| **ASI05 Unexpected Code Execution** | A natural-language-to-code path reaches an execution channel. | **Structural floor**: execution allowlist, sandbox, and protocol constraint are the deterministic floor for the code channel. **Conformance test**: is code execution an expected command for this agent's task at all? |
| **ASI06 Memory and Context Poisoning** | Poisoned content persists in memory across sessions. | **Provenance tag**: this is the persistence property directly. A memory entry retains its data tag across every hop and cannot become an instruction later because it was written earlier. **Conformance test**: outputs influenced by poisoned memory diverge from expectation. |
| **ASI07 Insecure Inter-Agent Communication** | A spoofed, tampered, or replayed peer message arrives. | **Structural floor**: signed and schema-validated messages over a constrained channel (mTLS, declared ports) reject the malformed and the unauthenticated. **Provenance tag**: a peer message is data to the receiving agent, never auto-instruction. |
| **ASI08 Cascading Failures** | A single fault propagates: hallucination, flawed plan, destructive action. | **Conformance test**: the chain is broken at the first hop where command selection or output stops matching expectation, before propagation. **Structural floor**: egress and blast-radius caps bound how far a nonconforming action can reach. |
| **ASI09 Human-Agent Trust Exploitation** | A confident explanation manipulates an operator into approving harm. | **Conformance test**: the proposed action is measured against the declared task independently of how persuasively it is explained. **Consequence gate**: HITL sees the conformance result, not only the agent's narrative. |
| **ASI10 Rogue Agents** | Behavioural drift, concealment, self-directed action. | **Conformance test**: rogue behaviour is sustained nonconformance to the declared expectation, which is what drift detection measures. **Structural floor**: egress allowlist bounds the blast radius of an agent that has gone off-task. |

## What this demonstrates

Every row resolves to the same four-element core. None required a new control domain, and the ones that look like separate problems (ASI01, ASI06, ASI07, and the skill half of ASI04) are the same boundary event, handled by the same provenance tag.

That is the resilience property stated plainly: when the next named risk appears, the first question is not "which new control domain does this need" but "which of provenance tag, structural floor, conformance test, or consequence gate already covers it." For the ASI list, the answer is all of them, every time. A new entry in the table is a mapping exercise, not an architecture change.

## Where the core does not reach on its own

Honesty about the edges keeps the claim credible.

- The **conformance test is only as good as the declared expectation.** A vague objective intent degrades the test to generic plausibility checking, the same failure mode the [semantic firewall](semantic-firewall.md) has with a vague taxonomy. The model moves the work to writing a precise expectation, it does not remove it.
- **Structural floors need a constrained channel.** Where commands ride inside free-form content (some MCP and tool patterns), the deterministic floor cannot see them, and you fall back to the more costly semantic-plus-HITL path until the channel is constrained.
- **Slow drift below the conformance threshold** (ASI10) still needs baselining over time, not a single-hop check. The conformance test catches the step that crosses the line; it does not by itself set where the line is.
- **Opaque memory and inter-agent channels weaken inspection.** The conformance test and provenance tagging assume you can read what is in memory and what agents say to each other. If systems move to non-text vector memory or inter-agent communication via internal representations, that legibility erodes ([UK AISI, *Loss of Oversight*, 2026](https://www.aisi.gov.uk/research)). The structural floor survives this; the conformance test does not, unless text-based affordances are preserved by design. See [Safety Cases and Oversight Durability](safety-cases-and-oversight-durability.md).

!!! info "References"
    - [OWASP Top 10 for Agentic Applications (2026)](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/)
    - [MASO (Multi-Agent Security Operations)](../../maso/README.md)
    - [MASO: Objective Intent](../../maso/controls/objective-intent.md)
    - [UK AI Security Institute: *Loss of Oversight* (2026)](https://www.aisi.gov.uk/research)
