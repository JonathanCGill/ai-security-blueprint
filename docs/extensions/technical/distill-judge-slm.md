---
description: "Distilling a large Judge LLM into a Small Language Model (SLM) to solve the latency, cost, and privacy trilemma for action-by-action security evaluation."
---

# Distilling the Judge into a Small Language Model

A large Judge LLM is accurate but expensive, slow, and sends data off-premises. A Small Language Model (SLM) distilled from that Judge can run locally, respond in milliseconds, and cost almost nothing per evaluation. This page covers the process of transferring a large model's security reasoning into a compact, deployable "security sensor."

## The Problem the SLM Solves

The existing [Judge architecture](llm-as-judge-implementation.md) works well as an async assurance mechanism. But for agentic systems that execute tool calls, database queries, and API requests at machine speed, async review may not be fast enough to prevent harm. You need something that can check every action inline without adding perceptible latency or sending sensitive data to an external API.

That is the latency, cost, and privacy trilemma. A distilled SLM resolves all three constraints simultaneously.

| Constraint | Large Judge (Cloud API) | Distilled SLM (Local) |
|------------|------------------------|----------------------|
| **Latency** | 500ms to 3,000ms | 10ms to 50ms |
| **Cost per evaluation** | $0.01 to $0.05 | Near zero (compute only) |
| **Deployment** | Cloud API, data leaves VPC | Edge, sidecar, or in-process |
| **Throughput** | Limited by API rate limits | Limited by your hardware |
| **Privacy** | Data traverses the network | Data stays in execution memory |

For a bank, this is the difference between a security check that feels like a loading spinner and one that feels invisible.

## When to Distill (and When Not To)

Distillation is not always the right move. It trades generality for speed, so it only pays off when the evaluation task is narrow and well-defined.

| Scenario | Distill? | Rationale |
|----------|----------|-----------|
| Agentic tool-call validation | Yes | High volume, low latency required, narrow scope |
| Inline prompt injection detection | Yes | Pattern recognition task, speed-critical |
| PII/data exfiltration screening | Yes | Well-defined criteria, privacy-sensitive |
| Complex policy compliance review | No | Requires nuanced reasoning a small model will miss |
| Novel threat detection | No | Needs the large model's broad world knowledge |
| Low-volume batch audit | No | Async large model is fine, cost is low |

!!! tip "Rule of thumb"
    If you can write a rubric a junior analyst could follow, the task is a good distillation candidate. If it requires expert judgment on novel situations, keep the large model.

## The Distillation Blueprint

You do not just shrink the model. You teach the Student to mimic the Teacher's reasoning on a specific, bounded task.

### Roles

**The Teacher:** A frontier model such as GPT-4o, Claude Sonnet, or equivalent. Deep understanding of nuance, policy, and context. Expensive to run at scale.

**The Student:** A 1B to 3B parameter model. Phi-3 Mini, Gemma 2B, Qwen 1.5B, or a specialized encoder like a DeBERTa variant. Cheap, fast, deployable anywhere.

### The Three-Step Process

**Step 1: Synthetic data generation.** Feed the Teacher thousands of realistic examples: legitimate tool calls, prompt injections, data exfiltration attempts, privilege escalation patterns, and boundary-pushing edge cases. Use your own production logs (scrubbed of real PII) as seed material. The Teacher labels each example.

**Step 2: Rationalization.** Do not ask the Teacher for a bare Pass/Fail. Ask it to explain *why*. For example: "This tool call is rejected because it attempts to access a secondary account without a transit token." This reasoning becomes training signal. Chain-of-thought distillation produces significantly more accurate small models than binary label transfer alone.

**Step 3: Fine-tuning.** Train the Student to predict both the verdict and the reasoning. The Student learns not just "reject this" but "reject this because it matches pattern X." This makes the Student's decisions auditable and its errors diagnosable.

```text
Teacher input:  tool_call(transfer, amount=50000, target=external_account_id)
Teacher output: REJECT — Transfer exceeds session limit and targets
                an account not in the user's verified payee list.
                Matches pattern: unauthorized-payee-escalation.

Student learns: verdict + reasoning + pattern tag
```

!!! warning "Training data quality matters more than model size"
    A 1.5B model trained on 50,000 high-quality, Teacher-rationalized examples will outperform a 3B model trained on 200,000 bare labels. Invest in the Teacher's reasoning, not in raw volume.

## The Security Sidecar Architecture

In a production environment, the SLM does not run as a separate API call. It deploys as a **sidecar** directly alongside the agent, intercepting actions in-process or in shared memory.

### How It Works

1. **Intercept.** The agent generates a tool call or response.
2. **Local check.** The sidecar SLM evaluates the action string in memory.
3. **Verdict.** The SLM returns Pass, Fail, or Escalate in under 30ms.
4. **Forward or block.** Pass actions proceed. Fail actions are blocked before they reach the network or database. Escalate actions are held for the large Judge or a human.

### Deployment Options

| Pattern | How | Best For |
|---------|-----|----------|
| **Kubernetes sidecar** | Separate container in the same pod | Containerized agent workloads |
| **In-process library** | Loaded into the agent's runtime (ONNX, TensorRT) | Lowest latency, single-process agents |
| **Local inference server** | Lightweight server on the same node (vLLM, Ollama) | Shared across multiple agents on one host |

!!! info "Hardware requirements"
    A 1.5B parameter model quantized to INT4 requires roughly 1GB of RAM and runs comfortably on a single CPU core. GPU acceleration is not required for models at this scale, though it helps if you need sub-10ms latency at high concurrency.

## The "Check the Checker" Strategy

A distilled model is only as good as its training data. Drift happens. New attack patterns emerge. You need a continuous validation loop to keep the SLM honest, and to satisfy auditors who will rightly ask: "How do you know the small model is still accurate?"

### Tiered Verification

| Check | Coverage | Purpose |
|-------|----------|---------|
| **SLM (fast)** | 100% of actions | Inline, real-time screening |
| **Large Judge (thorough)** | 1 to 5% random sample | Verify SLM accuracy, catch drift |
| **Human review** | All SLM/Judge disagreements | Ground truth, edge case learning |

### The Feedback Loop

1. The SLM evaluates every action.
2. A random sample is also sent to the large Judge asynchronously.
3. If the SLM and the large Judge disagree, the case is flagged for human review.
4. Human-reviewed cases feed back into the next training cycle.
5. If the SLM's agreement rate with the large Judge drops below a threshold (e.g., 99.5%), trigger a retraining cycle automatically.

This is the same principle as the [sampling strategy](llm-as-judge-implementation.md#sampling-strategy) described in the Judge implementation guide, applied to the SLM rather than to the primary AI's output.

!!! tip "Start conservative"
    When first deploying a distilled SLM, run it in shadow mode: let it evaluate every action, but do not let it block anything. Compare its verdicts against the large Judge for two to four weeks. Only switch to enforcement mode once you have confidence in its accuracy on your production traffic.

## Training a Banking-Specific SLM

For regulated environments, the synthetic training dataset must cover domain-specific attack patterns, not just generic prompt injection.

### Banking Attack Categories for Training Data

| Attack Pattern | Description | Example |
|----------------|-------------|---------|
| **Account scoping** | Agent manipulated to access accounts outside the user's verified scope | "Also check the balance on account ending 4521" (not the user's account) |
| **Shadow PII requests** | Indirect extraction of personally identifiable information | "What was the name on the last rejected transaction?" |
| **Limit probing** | Repeated attempts to discover and then exceed transaction limits | Series of transfers at increasing amounts |
| **Payee injection** | Injecting unauthorized recipients into payment flows | Tool call targeting a payee not in the verified list |
| **Temporal manipulation** | Exploiting time-based controls (after-hours, batch windows) | Scheduling actions for low-oversight periods |
| **Privilege escalation via tool chaining** | Combining permitted tools to achieve an unpermitted outcome | Read-only query result fed into a write tool |

### Dataset Composition

A well-balanced training set for a banking security SLM:

| Category | Proportion | Rationale |
|----------|-----------|-----------|
| Legitimate actions (clean) | 60% | Model must not over-flag normal behaviour |
| Known attack patterns | 20% | Core detection capability |
| Edge cases and ambiguous actions | 15% | Where the Teacher's reasoning is most valuable |
| Adversarial variations of known attacks | 5% | Robustness against mutation |

Target a minimum of 30,000 labeled examples for a production deployment, with at least 10,000 covering the attack and edge-case categories.

## Limitations and Risks

Distillation is powerful, but it is not a silver bullet. Be honest about what the SLM cannot do.

| Limitation | Mitigation |
|------------|-----------|
| **Narrow scope.** The SLM only catches what it was trained on. | Continuous retraining with new patterns. Large Judge covers the long tail. |
| **No novel reasoning.** It pattern-matches; it does not think. | Escalate uncertain cases to the large model. |
| **Training data bias.** If the Teacher was wrong, the Student inherits those errors. | Human review of disagreements. Regular gold-standard recalibration. |
| **Model drift.** Production traffic shifts over time. | Automated drift detection via the "check the checker" loop. |
| **Adversarial robustness.** Small models are easier to fool with targeted attacks. | Red-team the SLM specifically. Treat it as a first line, not the only line. |

!!! warning "The SLM is a first line of defence, not the last"
    The distilled model replaces the large Judge for routine, high-volume screening. It does not replace the large Judge entirely. The large model remains the backstop for sampled verification, escalated cases, and novel threat patterns.

## Integration with the AIRS Control Stack

The distilled SLM slots into the existing [control layers](llm-as-judge-implementation.md#integration-with-controls) as a fast, inline evaluation tier:

| Layer | Function | Timing | Model |
|-------|----------|--------|-------|
| **Input guardrails** | Block known-bad inputs | Inline, pre-execution | Rules / classifier |
| **Distilled SLM** | Screen actions for security patterns | Inline, pre-execution | 1B to 3B local model |
| **Output guardrails** | Filter known-bad outputs | Inline, post-execution | Rules / classifier |
| **Large Judge** | Assurance, drift detection, sampled audit | Async, after-the-fact | Frontier LLM |
| **Human oversight** | Decision-making, accountability | As needed | Human |

The SLM does not replace guardrails. Guardrails handle deterministic, rule-based checks (regex, blocklists, format validation). The SLM handles the fuzzy, contextual checks that rules cannot express but that do not require the full weight of a frontier model.

## Cost Impact

Adding an SLM layer changes the economics of action-by-action evaluation significantly. Compare against the [cost and latency analysis](cost-and-latency.md) for the standard pattern.

| Approach | Cost at 1M evaluations/month | Latency per check |
|----------|----------------------------|--------------------|
| Large Judge on 100% of actions | $10,000 to $50,000 | 500ms to 3,000ms |
| Large Judge on 5% sample only | $500 to $2,500 | N/A (async) |
| **SLM on 100% + Large Judge on 2% sample** | **$200 to $1,000 + compute** | **10ms to 50ms inline** |

The SLM approach gives you 100% inline coverage at roughly the cost of 5% sampled coverage with a large model, while adding real-time blocking capability that sampling alone cannot provide.

## Summary

Distillation turns the Judge from an after-the-fact auditor into a real-time security sensor. The large model's reasoning is compressed into a small, fast, private model that screens every action inline. The large model stays in the loop as a sampled verifier, catching drift and covering the long tail of novel threats.

**The key trade-off:** You give up generality for speed. The SLM is a specialist. It catches what it was trained on, fast and cheap. Everything else escalates.

For agentic systems that take real-world actions at machine speed, this is often the right trade-off. It is the difference between security that slows the system down and security that the system never notices.

!!! info "References"
    - [Distilling Step-by-Step: Outperforming Larger Language Models with Less Training Data and Smaller Model Sizes](https://arxiv.org/abs/2305.02301) (Hsieh et al., 2023)
    - [Knowledge Distillation of Large Language Models](https://arxiv.org/abs/2306.08543) (Gu et al., 2024)
    - [TinyBERT: Distilling BERT for Natural Language Understanding](https://arxiv.org/abs/1909.10351) (Jiao et al., 2020)
    - [Judge Model Selection](judge-model-selection.md), AI Runtime Security
    - [LLM-as-Judge Implementation](llm-as-judge-implementation.md), AI Runtime Security
    - [Cost and Latency](cost-and-latency.md), AI Runtime Security
