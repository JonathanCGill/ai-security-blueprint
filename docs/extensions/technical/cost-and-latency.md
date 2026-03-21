---
description: "Cost and latency analysis for the AI security pattern: per-layer budget impact at scale with optimisation strategies for guardrails, Judge, distilled SLMs, and human review."
---

# Cost and Latency

> The three-layer pattern is not free. Budget for it.

## The Problem

Each layer adds cost and latency:

| Layer | Latency Added | Cost Per Request | At 1M requests/month |
|-------|-------------|-----------------|---------------------|
| **Guardrails** (rule-based) | 5–20ms | ~$0 (compute only) | Negligible |
| **Guardrails** (ML classifier) | 20–100ms | $0.001–0.005 | $1K–5K |
| **Distilled SLM** (local model) | 10–50ms | ~$0 (compute only) | Infrastructure cost only |
| **Judge** (LLM evaluation) | 500ms–5s | $0.01–0.05 | $10K–50K |
| **Human Oversight** (per review) | Minutes–hours | $5–50 per review | Depends on sample rate |

For a Tier 3 system running the full pattern on every request, the Judge alone can cost more than the generator. A [distilled SLM](distill-judge-slm.md) can eliminate that cost for routine screening while maintaining 100% inline coverage.

## Sampling Strategies

You don't have to judge every request. Match evaluation density to risk.

### By Risk Tier

| Risk Tier | Guardrails | Judge | Human Review |
|-----------|-----------|-------|-------------|
| **Tier 1** (Low) | 100% of requests | 5–10% sample | 1% or anomaly-triggered |
| **Tier 2** (Medium) | 100% of requests | 25–50% sample | 5% + all judge flags |
| **Tier 3** (High) | 100% of requests | 100% of requests | 10% + all judge flags |

### Adaptive Sampling

Increase judge evaluation rate when signals indicate elevated risk:

| Trigger | Sampling Adjustment |
|---------|-------------------|
| Guardrail block rate above baseline | Increase judge rate by 2x |
| New user (first 50 requests) | Judge 100% |
| After-hours usage (if unusual for your environment) | Increase judge rate by 2x |
| Prompt attack detected | Judge 100% for that user for 24 hours |
| Model provider change notification | Judge 100% for 48 hours |

### Stratified Sampling

Not all requests carry equal risk. Sample by category:

| Request Type | Judge Rate | Rationale |
|-------------|-----------|-----------|
| FAQ / simple lookup | 5% | Low risk, repetitive |
| Creative generation | 25% | More variable, higher guardrail miss rate |
| Data analysis / summarisation | 50% | Accesses user data, exfiltration risk |
| Decision support | 100% | Consequential output |
| Actions / tool use | 100% | Real-world impact |

## Latency Budgets

Design your latency budget before adding controls.

### Example: Customer-Facing Chat (Tier 2, Streaming)

| Component | Budget | Actual |
|-----------|--------|--------|
| Input guardrails | 20ms | 15ms (rule-based) |
| LLM generation (first token) | 500ms | 400ms |
| Buffer evaluation (per chunk) | 50ms | 30ms (rule-based) |
| **Total to first visible token** | **570ms** | **445ms** |
| Post-stream judge evaluation | N/A (async) | 2s |

### Example: Document Processing (Tier 3, Non-Streaming)

| Component | Budget | Actual |
|-----------|--------|--------|
| Input guardrails | 100ms | 50ms |
| LLM generation (complete) | 10s | 8s |
| Output guardrails | 100ms | 60ms |
| Judge evaluation | 5s | 3s |
| **Total before delivery** | **15.2s** | **11.1s** |

### Example: Agentic Tool Calls (Tier 3, SLM Sidecar)

For agentic systems where a [distilled SLM](distill-judge-slm.md) screens every action inline:

| Component | Budget | Actual |
|-----------|--------|--------|
| Input guardrails | 20ms | 15ms |
| LLM generation (tool call) | 500ms | 400ms |
| SLM sidecar evaluation | 50ms | 25ms |
| Tool execution | 200ms | 150ms |
| **Total per action** | **770ms** | **590ms** |
| Large Judge (async, 1% sample) | N/A | 2s |

The SLM adds negligible latency compared to a cloud Judge call, making 100% inline evaluation feasible without breaking the latency budget.

### What Breaks the Budget

| Problem | Cause | Mitigation |
|---------|-------|-----------|
| Judge adds 5s to every request | Using large model for judge | Use smaller model (Haiku-class) for routine evaluation, or [distill into an SLM](distill-judge-slm.md) for sub-50ms inline checks |
| Guardrail latency spikes | ML classifier cold start | Pre-warm classifiers, use rule-based for latency-critical path |
| Multiple judge calls per request | Evaluating multiple dimensions separately | Batch evaluations into a single prompt |
| Human review blocks delivery | Synchronous human review on all flags | Async review for medium flags; synchronous only for high/critical |
| SLM cold start on first request | Model not loaded into memory | Pre-load the SLM at pod/process start, keep it resident |

## Cost Optimisation

### Judge Model Selection

| Judge Model Tier | Cost (per 1K eval tokens) | Accuracy | When to Use |
|-----------------|--------------------------|----------|-------------|
| **Small** (Haiku, GPT-4o-mini) | ~$0.001 | 80–85% | Tier 1, high-volume screening |
| **Medium** (Sonnet, GPT-4o) | ~$0.01 | 88–93% | Tier 2, balanced cost/accuracy |
| **Large** (Opus, GPT-4) | ~$0.05 | 93–97% | Tier 3, consequential decisions |

### Tiered Evaluation

Run cheap evaluation first; escalate to expensive evaluation only when needed:

```
Request → Rule-based guardrails (free, fast)
  ↓ (passed)
Request → Small model judge (cheap, fast)
  ↓ (flagged or uncertain)
Request → Large model judge (expensive, accurate)
  ↓ (flagged)
Request → Human review (most expensive)
```

This reduces cost by 60–80% compared to running the large model on everything.

For even greater savings, consider distilling the large Judge into a Small Language Model that runs locally.

### SLM Cost Profile

A [distilled SLM](distill-judge-slm.md) deployed as a sidecar fundamentally changes the cost model. Instead of paying per-token API costs for every evaluation, you pay a fixed infrastructure cost regardless of volume.

| Cost Component | Cloud Judge (API) | Distilled SLM (Local) |
|----------------|-------------------|----------------------|
| **Per-evaluation cost** | $0.01–0.05 | ~$0 (compute only) |
| **At 1M evaluations/month** | $10,000–$50,000 | Infrastructure only |
| **Infrastructure** | None (API) | ~$50–200/month per node (CPU, 1GB RAM for INT4 model) |
| **Teacher verification (1% sample)** | N/A | $100–500/month |
| **Initial distillation** | N/A | One-time: $500–2,000 (Teacher labelling + training compute) |
| **Retraining (monthly)** | N/A | $200–500 per cycle |

**Break-even point:** At roughly 50,000 evaluations per month, the SLM approach becomes cheaper than even the smallest cloud Judge model. Above 500,000 evaluations per month, the savings are substantial.

| Monthly Evaluations | Cloud Judge (Small Model) | SLM + 1% Teacher Verification |
|---------------------|--------------------------|-------------------------------|
| 100K | $100–500 | ~$250–400 (fixed) |
| 500K | $500–2,500 | ~$300–500 (fixed) |
| 1M | $1,000–5,000 | ~$350–700 (fixed) |
| 10M | $10,000–50,000 | ~$500–1,000 (fixed) |

The SLM cost stays nearly flat as volume grows because the marginal cost per evaluation is compute only. The cloud Judge cost scales linearly with volume.

!!! tip "When an SLM makes financial sense"
    If you need to evaluate more than 5% of requests with a Judge, and your volume exceeds 100K requests per month, model the cost of an SLM sidecar. For agentic systems that require 100% inline evaluation, the SLM is almost always the cheaper option at scale. See [Distilling the Judge into a Small Language Model](distill-judge-slm.md) for the full architecture.

### Caching

Judge evaluations on identical or near-identical inputs can be cached:

| Cache Type | Hit Rate | Risk |
|-----------|----------|------|
| Exact match (same input hash) | Low (5–10%) | None |
| Semantic similarity (embedding distance < threshold) | Medium (15–30%) | Adversarial inputs designed to be semantically similar but functionally different |

**Only cache for Tier 1.** For Tier 2–3, the risk of cache-based bypass outweighs the cost saving.

## Total Cost of Evaluation (Multi-Agent Workflows)

The per-layer costs above model a single judge. In a multi-agent workflow, the full evaluation stack includes multiple evaluation roles. This section models the compound cost so you can budget for the complete architecture, not just one layer.

### Evaluation Stack Components

| Component | What It Does | Evaluation Rate | Cost Driver |
|-----------|-------------|----------------|------------|
| **Tactical judge** | Evaluates each agent action against its OISpec | Per-action (100% at Tier 3) | Highest volume. Dominates cost unless using SLM. |
| **Domain judges** (fraud, security, compliance) | Evaluates actions from specific policy perspectives | Per-action or per-phase | Can be consolidated into a single multi-criteria evaluation call, or run as separate SLM sidecars. |
| **Strategic evaluator** | Assesses combined outputs against workflow intent | Per-phase + post-execution | Low volume. Single LLM call per evaluation. |
| **Meta-evaluator** | Monitors judge drift via calibration test cases | Scheduled (daily/weekly) | Negligible at scale. Fixed cost regardless of transaction volume. |
| **Observer** | Anomaly scoring, PACE triggers | Continuous (metrics pipeline) | Infrastructure cost. No per-evaluation LLM calls. |

### Compound Cost Model: Fraud Detection Example

A fraud detection workflow processing 1M transactions/month with 3 task agents:

**Scenario A: Cloud Judge (all evaluation via API)**

| Component | Volume | Cost per eval | Monthly cost |
|-----------|--------|--------------|-------------|
| Tactical judge (3 agents × 1M actions) | 3M | $0.01-0.05 | $30,000-150,000 |
| Domain judges (fraud + compliance, sampled 25%) | 750K | $0.01-0.03 | $7,500-22,500 |
| Strategic evaluator (per-phase, ~100K phases) | 100K | $0.01-0.05 | $1,000-5,000 |
| Meta-evaluator (daily calibration, 100 test cases) | 3K | $0.05 | $150 |
| Observer | Continuous | Infrastructure | $500-1,000 |
| **Total** | | | **$39,150-178,650** |

**Scenario B: SLM Sidecar + Sampled Cloud Judge**

| Component | Volume | Cost per eval | Monthly cost |
|-----------|--------|--------------|-------------|
| SLM tactical judge (3 agents × 1M actions) | 3M | ~$0 (compute) | $150-600 (infrastructure) |
| SLM domain evaluation (multi-criteria, 100%) | 3M | ~$0 (compute) | Included in SLM infra |
| Cloud Judge teacher verification (1% sample) | 30K | $0.05 | $1,500 |
| Strategic evaluator (per-phase, ~100K phases) | 100K | $0.01 | $1,000 |
| Meta-evaluator (daily calibration) | 3K | $0.05 | $150 |
| Observer | Continuous | Infrastructure | $500-1,000 |
| **Total** | | | **$3,300-4,250** |

The SLM approach reduces compound evaluation cost by **95-97%** at this volume. The break-even is even lower for multi-agent workflows than for single-agent systems because the evaluation volume multiplies with agent count.

!!! tip "Budget the full stack, not one layer"
    When presenting evaluation costs to finance, model the complete stack (tactical + domain + strategic + meta + observer), not just the tactical judge. Then show both cloud and SLM scenarios. The SLM scenario is almost always the right answer for high-volume multi-agent workflows.

## Critical-Path Latency for Time-Sensitive Workflows

The per-layer latency budgets above show each component in isolation. For time-sensitive workflows (fraud detection, trading, real-time safety), what matters is the **critical path**: the synchronous components that must complete before the action executes.

### Synchronous vs. Asynchronous Evaluation

Not every evaluation component sits on the critical path. Most run asynchronously, adding zero latency to the transaction.

| Component | On Critical Path? | Latency Added | Notes |
|-----------|-------------------|---------------|-------|
| **Input guardrails** | Yes (synchronous) | 5-20ms | Always inline. Rule-based is fastest. |
| **SLM tactical judge** | Yes (synchronous) | 10-50ms | Sidecar evaluation. Sub-50ms is achievable. |
| **Cloud tactical judge** | Usually no (async) | 500ms-5s | Only synchronous for CRITICAL risk at Tier 3. |
| **Domain judges (SLM)** | Yes if SLM (sync) | 10-50ms | Can be batched into the tactical SLM call. |
| **Domain judges (cloud)** | No (async) | 500ms-5s | Async with "most restrictive wins" default. |
| **Strategic evaluator** | No (async) | 1-5s | Runs at phase boundaries, not per-action. |
| **Meta-evaluator** | No (scheduled) | 0ms | Runs on a schedule. Not per-transaction. |
| **Observer** | No (background) | 0ms | Metrics pipeline. Non-blocking. |

### Example: Fraud Detection (Tier 2, SLM Sidecar)

```
Transaction arrives
  → Input guardrails                     5-20ms  [sync]
  → Agent processes transaction          50-200ms [sync]
  → SLM tactical + domain evaluation     10-50ms  [sync]
  → Action executes (flag/approve/block) 5-10ms   [sync]
                                         ─────────
  Total critical path:                   70-280ms

  → Cloud Judge (1% sample)              2-5s     [async, non-blocking]
  → Strategic evaluator (end of batch)   1-5s     [async, non-blocking]
```

**Critical-path overhead from evaluation: 10-50ms.** That is the SLM sidecar. Everything else is asynchronous.

### Example: Trading Compliance (Tier 3, CRITICAL Risk)

```
Trade request arrives
  → Input guardrails                     5-20ms   [sync]
  → Agent generates trade recommendation 100-500ms [sync]
  → SLM tactical evaluation              10-50ms  [sync]
  → Cloud Judge (synchronous, CRITICAL)  500ms-2s [sync, CRITICAL only]
  → Compliance domain judge (sync)       500ms-2s [sync, CRITICAL only]
                                         ──────────
  Total critical path:                   1.1-4.6s

  → Strategic evaluator (post-trade)     1-5s     [async]
```

For CRITICAL risk, the cloud judge runs synchronously. This is the cost of assured evaluation for irreversible, high-consequence actions.

!!! warning "Do not put the full stack on the critical path"
    The most common latency mistake is making every evaluation component synchronous. Only the tactical judge (SLM sidecar) and guardrails belong on the critical path for most workflows. Strategic evaluation, meta-evaluation, and observer scoring are asynchronous by design. If your workflow has a latency budget under 500ms, use the SLM approach and keep the cloud judge async.

## Budgeting Template

| Line Item | Monthly Estimate |
|-----------|-----------------|
| Generator LLM API costs | $ ___ |
| Input guardrails (if ML-based) | $ ___ |
| Output guardrails (if ML-based) | $ ___ |
| SLM infrastructure (if using distilled model) | $ ___ |
| SLM retraining (amortised monthly) | $ ___ |
| Judge LLM API costs (at sampling rate ___%) | $ ___ |
| Teacher verification of SLM (if applicable, ___% sample) | $ ___ |
| Human review (estimated ___ reviews × $___/review) | $ ___ |
| Monitoring infrastructure (SIEM, dashboards) | $ ___ |
| **Total security overhead** | **$ ___** |
| **As % of generator cost** | **____%** |

**Rule of thumb:** Security overhead is typically 15–40% of generator cost for Tier 2, and 40–100% for Tier 3. Replacing the cloud Judge with a distilled SLM for routine screening can reduce that overhead by 60–90% at high volumes, bringing Tier 3 costs closer to the Tier 2 range.

