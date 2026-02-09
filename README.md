# Enterprise AI Security Framework

A practical guide to implementing behavioral controls for custom-developed AI systems.

[![Enterprise AI Security Framework](/images/ai-security-tube-map.svg)](/images/ai-security-tube-map.svg)

---

## Scope: What This Framework Covers (and What It Doesn't)

This framework applies to **custom-developed AI systems** — applications your organization builds, integrates, or deploys using LLMs, embedding models, agentic architectures, or AI-powered decision pipelines.

**In scope:**
- Custom LLM applications (RAG pipelines, document processing, internal tools)
- AI decision support systems built on foundation models
- Agentic AI systems with tool-calling, autonomous action, or multi-step reasoning
- AI-powered workflows integrated into business processes

**Out of scope:**
- **Vendor AI products** (Microsoft Copilot, Google Gemini, GitHub Copilot, Salesforce Einstein, etc.) — these are SaaS products with their own security models, shared responsibility boundaries, and vendor-managed controls. Your risk posture for these is governed by procurement due diligence, data classification policy, and vendor security assessments — not by runtime behavioral monitoring you control.
- **Shadow AI** — employees using public AI tools without authorization. This is a data governance and acceptable use policy problem, not a controls architecture problem. IBM's 2025 data shows 1 in 5 organizations have suffered a shadow AI breach. Address it, but with DLP and policy, not guardrails.
- **Model training and fine-tuning** — see MLOps security guidance.
- **Pre-deployment testing** — this framework is about production monitoring.

> **Why the distinction matters:** A Copilot or SaaS AI tool runs in the vendor's environment under the vendor's controls. You configure policies; they enforce them. A custom-developed AI system runs in *your* environment with *your* controls — or with no controls at all. The gap between these two postures is where this framework operates.

---

## The Problem

Software assurance has always involved trade-offs between design-time testing and runtime monitoring. Traditional deterministic software leans heavily on the former. Complex systems — distributed architectures, event-driven pipelines, concurrent processes — have always required some runtime verification because not all failure modes are predictable at design time.

**AI systems push this balance further along the continuum**, not into entirely new territory.

| Property | Traditional Software | Complex Distributed Systems | AI Systems |
| --- | --- | --- | --- |
| **Determinism** | High | Reduced (race conditions, network partitions) | Low (same input, different outputs) |
| **Predictability** | High | Moderate (emergent failure modes) | Low (emergent behavior from training data) |
| **Adversarial exposure** | Input validation | API abuse, injection attacks | Prompt injection, jailbreaking, data poisoning |
| **Testability** | High pre-deployment coverage | Requires chaos engineering, runtime monitoring | Cannot fully test before deployment |

AI doesn't break the assurance model. It **accelerates failures that already existed in complex systems**. The difference is degree, speed, and attack surface. The controls needed are proportionally stronger, not categorically different.

---

## Before You Proceed

> **[The First Control: Choosing the Right Tool](/insights/the-first-control.md)**
>
> The most effective way to reduce AI risk is to not use AI where it doesn't belong. Before guardrails, judges, or human oversight — ask whether AI is the right tool for this problem. Design thinking should precede technology selection.

Everything in this Framework assumes you've already answered "yes" to that fundamental question.

---

## The State of Reality

> **[→ State of Reality: What the Data Actually Shows](/insights/state-of-reality.md)**

Before implementing controls, understand what the threat intelligence actually says:

- **233 documented AI incidents in 2024**, growing 56% year-on-year (Stanford AI Index 2025).
- **35% of real-world AI security incidents were caused by simple prompts** — no code, no exploits (Adversa AI, 2025).
- **97% of organizations that experienced AI-related breaches lacked basic access controls** (IBM, 2025).
- The dominant enterprise failure modes are **hallucination, data leakage via prompts, and prompt injection** — not sophisticated adversarial attacks.

The primary risk today is not advanced attack. It is the absence of basic controls on systems already in production.

---

## The Pattern

The industry is converging on an answer: **runtime behavioral monitoring**.

Instead of proving correctness at design time, you continuously verify behavior in production.

| Layer | Function | Timing |
| --- | --- | --- |
| **Guardrails** | Prevent known-bad inputs/outputs | Real-time (~10ms) |
| **Judge** | Detect unknown-bad via LLM evaluation | Async (~500ms–5s) |
| **Human Oversight** | Decide edge cases, remain accountable | As needed |

**Guardrails prevent. Judge detects. Humans decide.**

> Design reviews prove intent. Behavioral monitoring proves reality.

---

## This Pattern Exists — Adoption Is Another Story

This pattern is implemented in production tooling. What's been missing is a clear explanation of *why* it's necessary and *how* to implement it proportionate to risk.

### Platforms Implementing This Pattern

| Platform | Implementation |
| --- | --- |
| [NVIDIA NeMo Guardrails](https://github.com/NVIDIA/NeMo-Guardrails) | 5 rail types: input, dialog, retrieval, execution, output |
| [LangChain](https://docs.langchain.com/) | Middleware + human-in-the-loop |
| [Guardrails AI](https://www.guardrailsai.com/) | Open-source validator framework |
| [Galileo](https://www.rungalileo.io/) | Eval-to-guardrail lifecycle |
| [Confident AI / DeepEval](https://github.com/confident-ai/deepeval) | LLM-as-judge evaluation framework |
| AWS Bedrock Guardrails | Managed input/output filtering |
| Azure AI Content Safety | Content filtering and moderation |

### The Maturity Gap

These tools exist. Enterprise adoption lags significantly behind:

- Only **20% of firms** feel confident securing generative AI, despite 72% integrating AI into business functions.
- **63% of breached organizations** don't have an AI governance policy or are still developing one.
- **Over 50%** of enterprise AI app adoption is estimated to be shadow AI.

If your organization is starting from zero, that's normal. The framework is designed for incremental adoption — start with [Risk Tiers](/core/risk-tiers.md), implement controls proportionate to your highest-risk systems first, and expand.

### Standards Describing the Risks

| Standard | Focus |
| --- | --- |
| [OWASP LLM Top 10](https://owasp.org/www-project-top-10-for-large-language-model-applications/) | Security vulnerabilities in LLM applications |
| [OWASP Top 10 for Agentic Applications](https://genai.owasp.org/) | Risks specific to autonomous AI agents |
| [NIST AI RMF](https://www.nist.gov/itl/ai-risk-management-framework) | Risk management framework |
| [ISO 42001](https://www.iso.org/standard/81230.html) | AI management system standard |

---

## What This Guide Provides

A practical synthesis: how to understand the pattern, select appropriate controls, and implement them proportionate to risk.

**[→ Implementation Guide](/IMPLEMENTATION_GUIDE.md)** — Working code. Copy, adapt, ship.

**[→ Quick Start](/QUICK_START.md)** — Conceptual overview in 30 minutes.

---

## Core Content

| Document | Purpose |
| --- | --- |
| [Risk Tiers](/core/risk-tiers.md) | Classify your system, determine control requirements |
| [Controls](/core/controls.md) | Guardrails, Judge, Human Oversight implementation |
| [Agentic](/core/agentic.md) | Additional controls for AI agents |
| [Checklist](/core/checklist.md) | Track your implementation |
| [Emerging Controls](/core/emerging-controls.md) | Multimodal, reasoning, streaming *(theoretical)* |

---

## Extensions

Reference material for specific needs.

| Folder | Contents |
| --- | --- |
| [extensions/regulatory/](/extensions/regulatory) | ISO 42001, EU AI Act mapping |
| [extensions/technical/](/extensions/technical) | Bypass prevention, infrastructure, metrics |
| [extensions/technical/current-solutions.md](/extensions/technical/current-solutions.md) | **Industry solutions reference** — guardrails, evaluators, safety models |
| [extensions/templates/](/extensions/templates) | Incident playbooks, threat models |
| [extensions/examples/](/extensions/examples) | Worked examples by use case |

---

## Insights

Articles explaining the thinking behind the pattern.

### Grounding

| Article | Summary |
| --- | --- |
| [State of Reality: What the Data Actually Shows](/insights/state-of-reality.md) | Incident data, threat intelligence, and proportionate control prioritization |
| [What's Working: Where Controls Are Reducing Harm](/insights/what-works.md) | Evidence that runtime monitoring delivers measurable results |

### Why This Pattern?

| Article | Summary |
| --- | --- |
| [The First Control: Choosing the Right Tool](/insights/the-first-control.md) | Design thinking before technology selection |
| [Why Your AI Guardrails Aren't Enough](/insights/why-guardrails-arent-enough.md) | Guardrails block known-bad; you need detection for unknown-bad |
| [The Judge Detects. It Doesn't Decide.](/insights/judge-detects-not-decides.md) | Async evaluation beats real-time blocking for nuance |
| [Infrastructure Beats Instructions](/insights/infrastructure-beats-instructions.md) | You can't secure systems with prompts alone |
| [Risk Tier Is Use Case, Not Technology](/insights/risk-tier-is-use-case.md) | Classification is about deployment, not capability |
| [Humans Remain Accountable](/insights/humans-remain-accountable.md) | AI assists decisions; humans own outcomes |

### Scaling and Limits

| Article | Summary |
| --- | --- |
| [When the Pattern Breaks](/insights/when-the-pattern-breaks.md) | Where the three-layer pattern strains and fails in multi-agent systems |
| [What Scales](/insights/what-scales.md) | Security patterns with viable scaling properties for complex AI architectures |
| [The Intent Layer](/insights/the-intent-layer.md) | Post-execution semantic evaluation — the behavioral layer above technical controls |

### Emerging Challenges

| Article | Summary |
| --- | --- |
| [The Verification Gap](/insights/the-verification-gap.md) | Why current safety approaches can't confirm ground truth |
| [Behavioral Anomaly Detection](/insights/behavioral-anomaly-detection.md) | Aggregating signals to detect drift from normal |
| [Multimodal AI Breaks Your Text-Based Guardrails](/insights/multimodal-breaks-guardrails.md) | Images, audio, video create new attack surfaces |
| [When AI Thinks Before It Answers](/insights/when-ai-thinks.md) | Reasoning models need reasoning-aware controls |
| [When Agents Talk to Agents](/insights/when-agents-talk-to-agents.md) | Multi-agent systems have accountability gaps |
| [The Memory Problem](/insights/the-memory-problem.md) | Long context and persistent memory risks |
| [You Can't Validate What Hasn't Finished](/insights/you-cant-validate-unfinished.md) | Real-time streaming AI challenges |

---

## Framework Currency

This framework addresses the **2024–2026 generation** of enterprise AI systems: text-dominant LLM applications, early agentic systems, and RAG-based architectures.

It will need material revision as:
- **Agentic AI matures** — agent-to-agent communication, autonomous multi-step workflows, and MCP-based tool ecosystems are already surfacing failure modes (cross-tenant data leaks, unauthorized transactions) that strain the guardrail → judge → human pattern. See [When the Pattern Breaks](/insights/when-the-pattern-breaks.md), [What Scales](/insights/what-scales.md), and [The Intent Layer](/insights/the-intent-layer.md) for an honest assessment of where the framework's architecture holds, where it requires augmentation, and how post-execution semantic evaluation fills the gap between mechanical controls and behavioral assurance.
- **Multimodal AI becomes standard** — text-based guardrails don't inspect images, audio, or video. New attack surfaces require new control types.
- **AI systems gain persistent memory** — long-context and stateful systems introduce temporal risks that session-scoped controls don't address.

Review this framework against current incident data annually. The threat landscape is moving fast enough that a two-year-old control architecture may have significant gaps.

---

## Status

This is a **synthesis and practical guide**, not a standard.

- Combines existing patterns with implementation guidance
- Grounded in observed incident data and threat intelligence, not projected worst cases
- Feedback welcome — see [CONTRIBUTING.md](/CONTRIBUTING.md)
- Will evolve as the field matures

---

## Quick Links

| Need | Go To |
| --- | --- |
| Understand the threat landscape | [State of Reality](/insights/state-of-reality.md) |
| See what's working | [What's Working](/insights/what-works.md) |
| Understand scaling limits | [When the Pattern Breaks](/insights/when-the-pattern-breaks.md) |
| See what scales | [What Scales](/insights/what-scales.md) |
| Understand the intent layer | [The Intent Layer](/insights/the-intent-layer.md) |
| Get started | [Quick Start](/QUICK_START.md) |
| Classify a system | [Risk Tiers](/core/risk-tiers.md) |
| Implement controls | [Controls](/core/controls.md) |
| Deploy an agent | [Agentic](/core/agentic.md) |
| Test your controls | [Testing Guidance](/extensions/templates/testing-guidance.md) |
| Threat model | [Threat Model Template](/extensions/templates/threat-model-template.md) |
| Map to ISO 42001 | [Regulatory Extensions](/extensions/regulatory) |
