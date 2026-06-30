---
description: "The semantic firewall: intent-level boundary enforcement between Guardrails and Model-as-Judge, catching prohibited intent expressed in novel wording."
---

# Semantic Firewall

!!! tip "Part of the Golden Thread (7 of 15)"
    Previous: [Practical Guardrails](../../insights/practical-guardrails.md) · Next: [The Judge Detects, Not Decides](../../insights/judge-detects-not-decides.md) · [See the full sequence](../../reading-paths.md#the-golden-thread-guardrails-judges-and-why-they-work-together)

Intent-level boundary enforcement that sits between Guardrails and Model-as-Judge. Catches requests that are semantically equivalent to a prohibited intent even when the surface wording is novel.

## Why This Layer Exists

Guardrails block **known patterns**: regex, denylists, encoding checks. They miss semantic variations - the same prohibited intent expressed in wording the guardrail has never seen. Model-as-Judge catches this, but at Judge latency and Judge cost, applied to every request regardless of whether the request was ever close to a policy boundary.

The semantic firewall fills the gap between the two: faster and cheaper than a Judge call, but aware of meaning rather than just surface form. It does not replace either layer. It reduces how often the expensive layer needs to run, and catches a class of failure the cheap layer cannot.

| Layer | Catches | Mechanism | Speed |
| --- | --- | --- | --- |
| **Guardrails** | Known-bad patterns | Regex, denylists, encoding detection | ~10ms |
| **Semantic Firewall** | Known-bad *intent*, novel wording | Embedding similarity / intent classifier against a declared taxonomy | ~15-30ms |
| **Model-as-Judge** | Unknown-bad, context-dependent, novel | Independent LLM or distilled SLM reasoning | 10ms-5s by tier |

## What It Does

Classifies the **intent** of inbound (and optionally outbound) content against a fixed, declared set of authorised and prohibited topics or intents for the deployment - not the literal text. Two requests with different surface wording and equivalent intent are scored the same way.

| Function | Description |
| --- | --- |
| Intent classification | Does this request's *meaning* match a prohibited or out-of-scope category, regardless of phrasing? |
| Topic boundary enforcement | Is this request inside the declared domain for this deployment? |
| Paraphrase / obfuscation resistance | Catches rewordings, translations, and indirection that change wording but not intent |

## What It Does NOT Do

- Evaluate output quality, accuracy, or policy nuance - that's the Judge's job
- Make final block/allow decisions on ambiguous cases - escalate to Judge or HITL
- Replace topic-boundary configuration with model judgment - the taxonomy is declared, not inferred at runtime

**The semantic firewall narrows what reaches the Judge. It does not replace the Judge.**

## Architecture

Sits inline, immediately after deterministic guardrails and before the request reaches the model (or, in a multi-provider gateway, before routing to any backend):

```
Input → Guardrails (~10ms: regex, PII, encoding) → Semantic Firewall (~15-30ms: intent classification against taxonomy) → [pass] → model invocation → [flag] → Judge (inline SLM or async LLM, per risk tier) → [reject] → blocked, logged, optionally escalated to HITL
```

In a multi-backend deployment (e.g. routing across multiple model providers through a shared gateway), this is the natural place to enforce **one** topic-boundary policy across all backends, rather than relying on each provider's native guardrails to converge on the same boundary independently.

## Build Options

| Approach | Mechanism | Latency | Notes |
| --- | --- | --- | --- |
| Embedding similarity classifier | Encode declared intent exemplars, compare inbound request by cosine similarity | ~10-20ms | Lowest cost, no model call. Right default for Low/Medium risk tiers. |
| Distilled intent classifier (SLM) | Small model fine-tuned specifically for intent classification, not general evaluation | ~15-40ms | Narrower and cheaper at volume than a general-purpose Judge sidecar. |
| Reference implementations | LlamaFirewall-style intent classification patterns | varies | Useful as an architectural reference rather than a drop-in dependency. |

## Declared Taxonomy, Not Inferred Boundaries

Like the Judge's reliance on a clear OISpec, the semantic firewall is only as good as the intent taxonomy it's checking against. A vague taxonomy ("don't discuss harmful topics") degrades to generic safety filtering. A specific one ("this deployment handles benefits-enrolment queries only; flag anything resembling account credential requests, payment instrument changes, or requests for information about other applicants") gives the classifier something precise to score against.

The taxonomy is a configuration artefact, reviewed and versioned the same way guardrail rules and OISpecs are - not something the classifier model is left to infer from general training.

## Limitations

- Embedding classifiers can still be fooled by adversarial phrasing engineered specifically to sit just outside the declared exemplar space - this is a narrower version of the same adversarial-robustness problem the Judge has.
- A taxonomy that's too broad produces false positives at a rate that erodes trust in the layer; too narrow, and it misses genuine paraphrase attacks. Tune against real traffic, the same way guardrail thresholds are tuned.
- It is a cost/latency optimisation over running the Judge on every request, not a categorically different guarantee. Treat its output as routing logic (pass / escalate to Judge / reject), not as a final verdict on ambiguous cases.

## Going Deeper

| Topic | Document |
| --- | --- |
| Where this sits relative to Guardrails and Judge | [Controls: Guardrails, Judge, and Human Oversight](../controls.md) |
| Cost and latency budgeting across the full evaluation stack | [Cost & Latency](../../extensions/technical/cost-and-latency.md) |
| Injection detection at the logging layer | [Logging & Observability - LOG-06](../../infrastructure/controls/logging-and-observability.md#log-06-prompt-injection-detection) |
| Judge isolation in a multi-provider gateway | [AWS Bedrock - NET-03](../../infrastructure/reference/platform-patterns/aws-bedrock.md#net-03-judge-isolation) |
| Declared intent as the reference standard for evaluation | [MASO: Objective Intent](../../maso/controls/objective-intent.md) |
