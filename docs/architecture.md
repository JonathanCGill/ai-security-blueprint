---
description: "AIRS Framework architecture: risk-proportionate, layered runtime controls for single-agent and multi-agent AI systems."
---

# Architecture Overview

<!-- golden-thread-nav -->
!!! tip "Part of the Golden Thread (13 of 14)"
    Previous: [The Feedback Loops That Make It Work](insights/feedback-loops.md) · Next: [What Works](insights/what-works.md) · [See the full sequence](reading-paths.md#the-golden-thread-guardrails-judges-and-why-they-work-together)
<!-- golden-thread-nav -->

The goal of this architecture is to reduce harm caused by AI systems in production through layered controls that are proportionate to risk. Not every AI use case needs every control. The architecture provides risk-oriented paths so that AI product owners can quickly identify the controls they need and apply them, or consciously deselect the ones they do not need.

## The Pattern

![Three-layer runtime security: Guardrails, Reviewing Controls, Human Oversight](images/three-layer-simple.svg){ .arch-diagram }

The industry is converging on the same answer independently. NVIDIA NeMo, AWS Bedrock, Azure AI, LangChain, Guardrails AI: all implement variants of four independent layers.

| Layer | What It Does | Speed |
| --- | --- | --- |
| **Guardrails** | Block known-bad inputs and outputs: PII, injection patterns, policy violations | Real-time (~10ms) |
| **Reviewing Controls** | Detect unknown-bad through a combination of controls: deterministic scanners, a [semantic firewall](core/controls/semantic-firewall.md) (an intent classifier that flags requests whose *meaning* matches a prohibited topic, even when the wording is novel), policy compliance checks against declared intent, and Model-as-Judge (SLM or LLM, optionally [distilled](extensions/technical/distill-judge-slm.md)) for the cases the others cannot resolve | <5ms (scanners), 15-30ms (semantic firewall), 10-50ms (SLM Judge) inline; 500ms-5s (LLM Judge) async, or held for high-risk actions |
| **Human Oversight** | Decide genuinely ambiguous cases that automated layers cannot resolve | As needed |
| **Circuit Breaker** | Stop all AI traffic and activate a safe fallback when controls themselves fail | Immediate |

**Guardrails prevent. Judge detects. Humans decide. Circuit breakers contain.**

"Judge detects" is shorthand for the whole reviewing-controls layer, not just the Model-as-Judge component. Each control inside it catches a different class of failure: deterministic scanners catch what is mechanically wrong, the semantic firewall catches a prohibited intent reworded to slip past the scanners, policy compliance checks catch requests outside declared intent, and Model-as-Judge catches what is genuinely novel, each at the cost and latency appropriate to what it catches. None is a pre-filter for the others.

### The Four Reviewing Controls

Before the table of when each applies, here is what each control *is* in one line:

- **Deterministic scanners** are fixed-rule checks: schema validation, secrets and PII pattern matching, encoding detection. No model involved.
- **[Semantic firewall](core/controls/semantic-firewall.md)** is an intent classifier. It scores a request's *meaning* against a declared taxonomy of allowed and prohibited topics, so a prohibited intent reworded, translated, or disguised is caught even though no scanner pattern matches. It is not a Judge: it routes (pass, escalate, or reject), it does not deliver a final verdict on ambiguous cases.
- **Policy compliance check** verifies a privileged action stays inside the declared intent for the deployment ([OISpec](maso/controls/objective-intent.md)), even when the action is individually well-formed.
- **[Model-as-Judge](core/controls.md#2-model-as-judge)** is an independent model, a [distilled SLM](extensions/technical/distill-judge-slm.md) inline or a large LLM async, that reasons about the genuinely novel or ambiguous cases the other three escalate to it.

### When Is Which Reviewing Control Appropriate?

| Reviewing control | What it catches | Latency | When it's appropriate |
| --- | --- | --- | --- |
| **Deterministic scanners** | Schema violations, malformed payloads, known secrets and PII patterns | <5ms | Always on. The cheapest check, runs on every output before anything else does. |
| **Semantic firewall** | A prohibited or out-of-scope intent expressed in novel wording: reworded, translated, or disguised to evade the scanners | 15-30ms | Always on for any system that processes untrusted input: user prompts, retrieved documents, tool results. |
| **Policy compliance check** | Actions outside the declared intent ([OISpec](maso/controls/objective-intent.md)), even when individually well-formed | <50ms | Privileged actions: a tool call, a data write, a delegation to another agent or system. |
| **Model-as-Judge** | Genuinely novel or ambiguous cases the other three cannot resolve | 10-50ms (distilled SLM, inline) or 500ms-5s (LLM, async) | Escalations from the other controls, or held synchronously for HIGH/CRITICAL risk-tier actions. |

The first three run on every output at near-zero marginal cost. Model-as-Judge is the expensive one, so the other three exist to keep it off the critical path for everything except the cases that genuinely need it. For how this breakdown adapts when each control runs at a different point in a multi-agent mesh, see [Distributed Security Architecture](maso/distributed-architecture.md).

Each layer catches what the others miss. Remove any layer and you have a gap. Together they form a **closed-loop control system**: containment boundaries define the desired state, the reviewing controls continuously measure actual behaviour, drift detection computes the error, and human oversight applies corrective action. Unlike open-loop approaches that evaluate once and deploy, this architecture self-corrects continuously. See [Why Containment Beats Evaluation](insights/why-containment-beats-evaluation.md) and [The Feedback Loops That Make It Work](insights/feedback-loops.md). For how this combination operates across a multi-agent mesh, see [Distributed Security Architecture](maso/distributed-architecture.md).

## Single-Agent Architecture

![Single-Agent Security Architecture](images/single-agent-architecture.svg){ .arch-diagram }

For a single AI model, a chatbot, a document processor, an assistant, the four layers wrap the model's input and output. What matters in practice is not the existence of each layer but the choices inside each one:

- **Guardrails are a [constrain-regardless](insights/why-containment-beats-evaluation.md) architecture.** Action-space constraints that leave the model's reasoning unconstrained. Permissions derive from **business intent**, what the use case requires, not from evaluation of the model's capabilities. Necessary but insufficient alone: you cannot write a regex for every possible failure of a system that generates natural language.

- **Reviewing controls must be independent.** Deterministic scanners, a [semantic firewall](core/controls/semantic-firewall.md), policy compliance checks, and Model-as-Judge, whether a [distilled SLM](extensions/technical/distill-judge-slm.md) sidecar for real-time screening or a large LLM running asynchronously, run on a different model and, where possible, a different provider, **enterprise-owned and configured**, not vendor-side safeguards. If the primary model is compromised, the reviewing controls must not be compromised with it. This is where within-bounds adversarial behaviour is caught, which containment alone cannot address.

- **Human oversight scales with risk, not with volume.** Only genuinely ambiguous cases reach reviewers. Low-risk systems get spot checks, high-risk systems get human approval before execution. If every output goes to a reviewer, the reviewers stop reading, and oversight degrades to theatre.

- **Circuit breakers are not a degradation.** When detection confirms compromise or the layers themselves fail, AI traffic stops and a non-AI fallback takes over. No half-measures, no partial service. The Emergency state is a predetermined safe state, not a guess.

Controls scale to risk tier. A low-risk internal tool needs minimal guardrails and self-certification ([Fast Lane](fast-lane.md)). A customer-facing agent handling regulated data needs the full architecture with mandatory human approval. The framework respects that every organisation has its own way of working, and lets you match controls to context rather than imposing a single mandate.

**→ [Foundation Framework](foundations/README.md)** · the three-layer behavioural pattern with risk tiers and implementation checklists, backed by 80 [infrastructure controls](infrastructure/README.md) across 11 domains.

## Multi-Agent Architecture

The four-layer pattern holds for single models. When multiple LLMs collaborate, delegate, and take autonomous actions, new failure modes emerge that single-agent controls cannot catch:

- **Prompt injection propagates** across agent chains: one poisoned document becomes instructions for every downstream agent.
- **Hallucinations compound**: Agent A hallucinates a claim, Agent B cites it as fact, Agent C elaborates with high confidence.
- **Delegation creates transitive authority**: permissions transfer implicitly through delegation chains nobody designed.
- **Failures look like success**: the most dangerous outputs are well-formatted, confident, unanimously agreed, and wrong.

Multi-agent security requires per-agent identity, per-agent permissions, and per-agent evaluation, plus controls for the interactions between agents: message bus security, epistemic integrity, kill switch architecture. Same principles as the single-agent pattern, extended to the space between models.

**→ [MASO Framework](maso/README.md)** · controls across 11 domains, 3 implementation tiers, full OWASP dual coverage.

## When Layers Fail: PACE Resilience

Every control has a defined failure mode. Detection catches most of them, but not all. The [PACE methodology](pace-resilience.md) ensures that when a layer degrades, and it will, the system transitions to a predetermined safe state rather than failing silently.

| State | What's happening |
| --- | --- |
| **Primary** | All layers operational. Normal production. |
| **Alternate** | One layer degraded. Backup active. Scope tightened. |
| **Contingency** | Multiple layers degraded. Supervised-only mode. Human approves every action. |
| **Emergency** | Confirmed compromise. Circuit breaker fired. AI stopped. Non-AI fallback active. |

Even at the lowest risk tier, there is a fallback plan. At the highest, there is a structured degradation path from full autonomy to full stop. The architecture does not assume the layers are perfect; it assumes they will each fail at some point, and designs for that.

!!! info "References"
    - [Controls: Guardrails, Judge, and Human Oversight](core/controls.md)
    - [Semantic Firewall](core/controls/semantic-firewall.md)
    - [Foundation Framework](foundations/README.md)
    - [MASO Framework](maso/README.md)
    - [PACE Resilience](pace-resilience.md)
    - [Why Containment Beats Evaluation](insights/why-containment-beats-evaluation.md)
    - [The Feedback Loops That Make It Work](insights/feedback-loops.md)
