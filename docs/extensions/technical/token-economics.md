---
description: "How token consumption compounds across multi-agent systems, where MASO adds overhead, where it prevents waste, and what good token economics look like in practice."
---

# AI Token Economics and MASO

> Tokens are not just a pricing unit. They are the resource budget every agent operates within. In multi-agent systems, how that budget is consumed, protected, and wasted determines whether your AI deployment is economically viable.

## The Unit of Cost

Every interaction with a language model is priced in tokens. Input tokens cover everything the model reads before responding: system prompts, conversation history, retrieved documents, tool call results, and inter-agent messages. Output tokens cover everything the model writes: responses, tool call parameters, reasoning chains, and inter-agent instructions.

Single-agent systems have predictable token economics. You send a prompt, you get a response, you pay for both. Agentic systems break that predictability in two ways.

First, **context accumulates**. Each step in an agent workflow adds to the context window: the original request, the plan, the tool results, the errors, the retries. A task that takes ten agent steps has ten times the context overhead of a single-step task, not counting the output tokens that each step generates.

Second, **agents spawn agents**. In a multi-agent workflow, the output of one agent becomes the input of the next. Agent A's response, which costs output tokens, becomes part of Agent B's context, which costs input tokens. The token cost of a message is paid twice: once when it is generated, once when it is read.

These two dynamics mean that multi-agent AI token costs are non-linear. A three-agent workflow does not cost three times a single-agent workflow. It costs more, because each agent inherits the full context of what came before it.

## Where MASO Adds Token Overhead

MASO is a security framework, and security is not free. Every control layer has a token footprint.

### Judge Evaluation

Each judge call is itself an LLM inference. The judge reads a structured prompt containing: its own system instructions, the OISpec it is evaluating against, the agent action or output being reviewed, and any relevant context. It produces a verdict and, at higher tiers, a reasoning chain explaining the ruling.

At Tier 3 with cloud judges on 100% of agent actions, the judge can consume more tokens than the agent it evaluates. A complex action requires a detailed evaluation. That evaluation requires a long output. For a 3-agent workflow with tactical, domain, and strategic judges, the evaluation stack can triple the total token consumption of the workflow.

### OISpec Injection

Every agent and judge operates against a declared Objective Intent Specification. That specification must be present in the model's context to be effective. Long, verbose OISpecs injected wholesale into every agent call add significant input token overhead, particularly when specifications include extensive examples, edge cases, and constraint lists.

### Inter-Agent Message Overhead

The secure inter-agent message bus adds structure to every agent-to-agent communication: signatures, metadata, routing information, and schema-validated payloads. That structure is verbose compared to raw text. In high-frequency multi-agent workflows, message overhead accumulates.

### Flight Recorder Retrieval

Agents that need to review prior actions for goal integrity monitoring or context continuity may query the flight recorder. Each query returns structured log entries: action records, judge verdicts, PACE state transitions. That context adds to input token consumption.

## Where MASO Saves Tokens

The honest framing is not whether MASO costs tokens. It does. The question is whether it saves more than it costs. In a well-implemented deployment, it usually does.

### Loop Prevention

Runaway agent loops are the single largest source of token waste in agentic AI. An agent stuck in a reformulation cycle, retrying a failed tool call, or pursuing a goal it cannot achieve will continue consuming tokens until something stops it. Without MASO's loop detection and iteration caps, that something is often a budget overrun or a system timeout.

MASO's execution controls place hard limits on iterations per task, tool calls per session, and token budgets per agent. An agent that would have made 200 API calls before timing out is stopped at ten. The token saving is proportionate to how bad the loop would have been without the control. For production agentic systems, this is often the largest single cost reduction the framework delivers.

### Blast Radius Containment

Without blast radius caps, a single misconfigured or manipulated agent can consume the full token budget of an entire workflow. A prompt injection that causes an agent to enter a reasoning spiral, or an adversarial input designed to maximise output verbosity, can exhaust the budget of a workflow before other agents have a chance to run.

Blast radius caps bound the damage. The token waste is still there, but it is bounded at the agent level rather than the workflow level.

### SLM Sidecars: Evaluation Without API Tokens

The most significant token economics decision in a MASO deployment is whether to run judge evaluation through a cloud LLM API or through a locally-deployed distilled SLM.

Cloud judges consume API tokens for every evaluation. At 1M agent actions per month, even a small judge model running at 500 tokens per evaluation consumes 500M tokens, paid at per-token API rates. That cost scales linearly with volume.

A distilled SLM sidecar runs locally. It does not consume API tokens. The evaluation cost is infrastructure rather than consumption: fixed compute for the model, scaling only with concurrency rather than volume. At 1M evaluations per month, the economics flip entirely: the cloud judge approach costs tens of thousands of dollars; the SLM approach costs hundreds.

The critical insight: **SLM evaluation is free at the token level**. It does not add to your API token bill. The security evaluation layer, which can represent 100% overhead in a cloud-judge deployment, approaches zero marginal token cost with an SLM sidecar. See [Distilling the Judge into a Small Language Model](distill-judge-slm.md) for the full architecture.

### Mandate Specificity Reduces Agent Verbosity

Agents operating against vague instructions produce exploratory, hedged, verbose outputs. An agent that knows it should "handle customer requests" has no basis for concision. It reasons about what the request might mean, hedges against multiple interpretations, and produces long outputs that cover every possibility.

An agent operating against a specific OISpec knows exactly what it should do. The narrower the mandate, the shorter the output needed to satisfy it. A well-specified OISpec does not just improve security evaluation quality. It improves token efficiency across the board, because agents that know what they are doing produce tighter outputs.

### FDoS Prevention

Adversarial token consumption is a real threat class. An attacker who can craft inputs that cause an agent to produce maximum-length outputs, trigger reasoning spirals, or enter retry loops can inflict economic harm without exfiltrating data or compromising systems. This is financial denial-of-service through token exhaustion.

MASO's input guardrails screen for characteristics associated with verbose-injection patterns before requests reach the model. The token cost of a blocked request is the guardrail evaluation. The token cost of an unblocked verbose injection is orders of magnitude higher. The economics of prevention are strongly favourable.

## Risk as the Evaluation Gate

Token spend on evaluation should track risk, not request volume. This is the structural principle that separates disciplined MASO from naive MASO, and it has direct consequences for token economics.

Every agent action carries a risk classification at runtime. That classification is a function of three things: the consequence if the action is wrong, whether the action is reversible, and the authority level the agent is exercising at this step. A read operation against a public knowledge base is low risk regardless of which agent performs it. A write operation that modifies access controls is high risk regardless of how confident the agent appears.

The risk classification is not a property of the agent. It is a property of the action. The same agent can perform low-risk and high-risk actions within a single session, and each should be evaluated accordingly.

### The Routing Decision

Risk classification routes each action to an evaluation path. The paths differ in token cost by orders of magnitude.

| Action Risk | Evaluation Path | Evaluation Token Cost | Notes |
|-------------|----------------|----------------------|-------|
| **Low:** read-only, no external state change, reversible | Guardrails only, async SLM sample | Near zero | Guardrails are rule-based. Async SLM sample adds no latency or API tokens. |
| **Medium:** writes to internal state, reversible, limited scope | SLM inline evaluation | Near zero (local inference) | SLM runs as a sidecar. No API token consumption. Adds 10-50ms latency. |
| **High:** external writes, difficult to reverse, broader scope | SLM inline + cloud judge | API tokens for cloud judge call | Cloud judge is synchronous. Adds 500ms-2s latency. Use a small model unless the action demands it. |
| **Critical:** irreversible, high blast radius, regulatory consequence | Synchronous cloud judge + human approval gate | Highest API token cost | Reserve this path. Every action routed here is expensive and slow by design. |

The economic logic: most actions in a well-designed agentic workflow are low-to-medium risk. They should consume no cloud judge tokens at all. The cloud judge is reserved for the minority of actions where the consequence of a wrong call justifies the cost.

### Why Naive MASO Violates This

Naive MASO applies the same evaluation intensity to every action. A read operation and an irreversible payment are evaluated by the same cloud judge, at the same cost. The result is that low-risk actions, which represent the bulk of volume in most workflows, consume the bulk of the evaluation budget.

The problem is not using a cloud judge. The problem is using it indiscriminately. A cloud judge on a read-only lookup is not more secure than guardrails plus an SLM sample. It is just more expensive.

### Why Action Risk Classification Is Not Optional

If risk classification is absent, the system has two choices: evaluate everything at the highest tier (expensive, slow) or evaluate everything at the lowest tier (cheap, inadequate). Neither is correct. Risk classification is what makes proportionate evaluation possible, and proportionate evaluation is what makes MASO economically viable.

This is also why the [Objective Intent](../../maso/controls/objective-intent.md) and [Execution Control](../../maso/controls/execution-control.md) domains exist. OISpecs declare not just what an agent should do but the risk profile of each action type it may take. Execution controls encode that risk profile into the routing logic. Without declared intent, there is no basis for classification. Without classification, there is no basis for routing. Without routing, every action costs as much as the worst action.

### What the Routing Logic Looks Like

```python
# Risk-gated evaluation routing
def route_evaluation(action, oispec):
    risk = classify_action_risk(action, oispec)

    # Guardrails run on everything, always
    guardrail_result = guardrails.evaluate(action)
    if guardrail_result.blocked:
        return block(action, guardrail_result)

    if risk == RiskLevel.LOW:
        # Async SLM sample only: no synchronous judge tokens
        async_slm_sample(action, sample_rate=0.05)
        return allow(action)

    if risk == RiskLevel.MEDIUM:
        # SLM inline: local inference, no API tokens
        slm_result = slm_sidecar.evaluate(action, oispec)
        if slm_result.flagged:
            return escalate(action, slm_result)
        return allow(action)

    if risk == RiskLevel.HIGH:
        # SLM inline first; cloud judge if SLM flags or action warrants it
        slm_result = slm_sidecar.evaluate(action, oispec)
        judge_result = cloud_judge.evaluate(action, oispec)
        if slm_result.flagged or judge_result.flagged:
            return escalate(action, judge_result)
        return allow(action)

    if risk == RiskLevel.CRITICAL:
        # Cloud judge synchronous + human gate
        judge_result = cloud_judge.evaluate(action, oispec)
        return human_approval_gate(action, judge_result)
```

The cloud judge is called for HIGH and CRITICAL risk actions only. For a typical workflow where 70% of actions are LOW or MEDIUM risk, this immediately eliminates cloud judge token consumption for the majority of the volume.

!!! tip "Classify at the action type level, not the session level"
    Risk classification should apply to each action individually, not to a session or agent as a whole. A session that starts with low-risk reads and escalates to high-risk writes should escalate its evaluation intensity at the point the writes begin, not retroactively from the start of the session. This keeps low-risk phases cheap and reserves evaluation cost for the actions that warrant it.

## The Compounding Factor

The relationship between MASO implementation quality and token economics is not linear. Naive MASO makes token costs significantly worse. Disciplined MASO keeps costs manageable while providing genuine security.

### Naive MASO: What It Looks Like

A naive MASO deployment applies controls without optimising their token footprint:

- Cloud judge on 100% of agent actions at every boundary
- Full OISpec injected into every context window, including sections irrelevant to the current action
- Strategic evaluator running per action rather than per phase boundary
- Multiple domain judges running sequentially, each receiving full context
- No SLM distillation
- No loop detection or iteration caps

The result: for a 3-agent workflow processing 1M actions per month, the evaluation stack alone (tactical, domain, and strategic judges, all cloud) can cost $30K-$150K per month. The generator cost for the same workflow might be $10K-$30K. Security overhead exceeds generator cost by 3-5x.

This is not MASO being expensive. This is MASO being applied without regard for token economics. The controls are real. The waste is also real.

### Disciplined MASO: What It Looks Like

A disciplined MASO deployment achieves the same security posture with substantially lower token cost:

- SLM sidecar for inline tactical evaluation (zero API tokens per evaluation)
- OISpec summary injected at runtime (50-100 tokens vs. 500-2,000 for full spec)
- Domain judges consolidated into a single multi-criteria SLM evaluation call
- Strategic evaluator triggered at phase boundaries (100K phases vs. 3M actions for the same workflow)
- Cloud judge at 1% sample for calibration and drift detection only
- Loop detection terminating runaway tasks at iteration 10 rather than 200
- Blast radius caps preventing any single agent from consuming more than its allocated share

The result: for the same 3-agent workflow at 1M actions per month, the evaluation stack costs $3K-$5K per month. Generator cost is unchanged. Security overhead is 10-15% of generator cost rather than 300-500%.

### The Numbers Side by Side

| Approach | Generator cost (1M actions/month) | Evaluation overhead | Total |
|----------|-----------------------------------|--------------------|----|
| No security controls | $10K-30K | $0 | $10K-30K |
| Naive MASO (cloud judge, 100%) | $10K-30K | $30K-150K | $40K-180K |
| Disciplined MASO (SLM + sampling) | $10K-30K | $3K-5K | $13K-35K |

Naive MASO is harder to justify to finance than no controls at all, because it makes the cost case against security. Disciplined MASO adds 10-15% overhead, which is a reasonable security cost that most organisations will accept.

## Token Ratios Worth Tracking

Standard cost dashboards track spend. Token economics requires tracking ratios, because spend alone does not reveal whether the token budget is being used well or wasted.

**Evaluation token ratio:** Judge tokens consumed divided by generator tokens consumed. With a well-implemented SLM sidecar, this ratio can approach zero for API billing purposes. With a naive cloud judge on 100% of requests, it can exceed 3.0. Target below 0.2 for API-billable evaluation.

**Loop amplification factor:** Actual agent iterations per task divided by the expected iterations for a correctly-functioning agent. A factor of 1.0 means no unnecessary iterations. A factor above 3.0 signals a loop problem that is costing real money.

**Context bloat coefficient:** Actual input tokens per agent call divided by the minimum input tokens necessary to complete the task. A coefficient of 1.0 means perfect efficiency. Coefficients above 2.0 often indicate OISpec injection of irrelevant content, accumulated context that could be summarised, or tool results being passed in full when summaries would suffice.

**Security token efficiency:** The cost of security controls divided by the number of confirmed policy violations detected. A security layer that catches no violations at high token cost should be reviewed. A security layer that catches frequent violations at low token cost is earning its keep.

## Practical Recommendations

**Distill the judge before you scale.** The token economics of cloud judge evaluation are manageable at low volumes and unsustainable at high volumes. If you are evaluating more than 5% of requests synchronously and processing more than 100K requests per month, model the SLM sidecar. The break-even is typically around 50,000 evaluations per month. Above that, local inference is almost always cheaper. See [Cost & Latency](cost-and-latency.md) for the detailed cost model.

**Summarise, don't inject in full.** OISpecs are detailed documents. They do not need to be present in their entirety for every agent call. Extract the constraints and evaluation criteria relevant to the current action type and inject only those. A targeted 80-token constraint summary achieves better evaluation focus than a 2,000-token full specification, and costs 96% fewer input tokens.

**Move strategic evaluation to phase boundaries.** The strategic evaluator assesses combined workflow outputs against the solution mandate. It does not need to run on every agent action. Trigger it at natural phase boundaries: end of research phase, end of drafting phase, before final output. This reduces strategic evaluation calls by 10-100x without reducing coverage of the cases that matter.

**Instrument loop detection before anything else.** Loop detection is the highest-ROI token governance control in agentic AI. It is cheap to implement, immediate in effect, and addresses the largest single source of runaway token consumption. Implement it before any other optimisation.

**Treat the token budget as a first-class agent input.** Google's Budget Tracker research demonstrated that agents given explicit budget awareness make more efficient decisions. Rather than enforcing budget limits as external constraints applied after the fact, pass remaining token budget as a runtime variable that agents can observe and reason about. Agents that know they are running low on budget shift behaviour accordingly, resolving tasks with fewer iterations. See [Economic Governance](economic-governance.md#the-agent-loop-problem) for the full treatment.

**Separate security token costs from generator token costs in your dashboards.** When token costs are reported as a single number, cost pressure lands on whatever is easiest to cut. Security controls are easy to cut and hard to justify in the abstract. When security token costs are reported separately, alongside the policy violations they detect and the incidents they prevent, the ROI becomes visible. This is not just good accounting. It is how security controls survive budget pressure.

!!! warning "Never cut security controls to meet a token budget"
    If the token budget does not support the required evaluation intensity for the risk tier, the correct response is to reduce the system's scope or autonomy, not to weaken controls. A Tier 3 system running without adequate evaluation is not a Tier 3 system. It is a Tier 1 system with Tier 3 consequences. See [Economic Governance](economic-governance.md#optimise-spend-effectively-not-less) for the governance decision framework.

!!! info "References"
    - Google Cloud AI Research et al., "Budget Aware Test-time Scaling" (BATS), arXiv: 2511.17006 (2025): [arxiv.org](https://arxiv.org/abs/2511.17006)
    - FinOps Foundation, "FinOps for AI Overview" (2025): [finops.org/wg/finops-for-ai-overview](https://www.finops.org/wg/finops-for-ai-overview/)
    - Mavvrik, "2025 State of AI Cost Governance Report": [mavvrik.ai](https://www.mavvrik.ai/state-of-ai-cost-governance-report/)
    - Galileo AI, "The Hidden Costs of Agentic AI": [galileo.ai](https://galileo.ai/blog/hidden-cost-of-agentic-ai)
    - O'Reilly Radar, "Control Planes for Autonomous AI" (2025): [oreilly.com](https://www.oreilly.com/radar/control-planes-for-autonomous-ai-why-governance-has-to-move-inside-the-system/)
