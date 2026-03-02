---
description: Honest answers to the questions practitioners actually ask about AI runtime security - cost, resources, practicality, and scale.
---

# Frequently Asked Questions

Honest answers to the questions we hear most.

---

## "This feels expensive."

It can be. But it doesn't have to start that way.

Guardrails can be enabled in managed services like AWS Bedrock, Azure AI Content Safety, or Databricks with minimal configuration. You're not building from scratch - you're turning on capabilities that already exist in the platforms you're paying for. On Bedrock, for example, you can enable content filtering and PII detection without writing new code. These filters run inline with model invocations and generate logs you can route to CloudWatch automatically.

A Judge layer doesn't need to evaluate every interaction. Sample 5% of traffic on a medium-risk system and you've got meaningful oversight at a fraction of the cost of 100% coverage. Scale up only where the risk justifies it.

The real cost question isn't "how much does this cost?" - it's "what does it cost when something goes wrong without it?"

---

## "We don't have the resources."

You don't need a dedicated AI security team to start.

Turn on platform guardrails. That's configuration, not engineering. Enable logging through CloudTrail, CloudWatch, or your platform's equivalent - most of this telemetry is already being generated, you just need to look at it. Assign a system owner to review flagged interactions for 30 minutes a week.

That's a starting point. Not the finish line, but a defensible one.

Think of it as a progression. Start with guardrails and basic logging. Over time, introduce sampled judge evaluations and human edge-case reviews as your adoption and risk appetite grow. You don't need full maturity on day one - you need a direction of travel.

The Quick Start guide is designed to get you from zero to working controls in 30 minutes with what you already have.

---

## "Does this work in practice?"

The three-layer pattern - Guardrails, Judge, Human Oversight - is where the industry is converging. Guardrails block known-bad patterns in real time. Judges catch what guardrails miss through asynchronous evaluation. Humans decide the edge cases that machines shouldn't.

Does every layer work perfectly? No. Guardrails need tuning to reduce false positives. Judges need calibration against your specific use case. Humans need clear escalation paths or they become a bottleneck.

Concretely: a guardrail that blocks prompt injection patterns will catch the obvious attacks on day one. After a week of reviewing logs, you tune it to reduce false positives on legitimate queries that happen to contain code snippets. That iteration cycle is exactly how these controls mature in production.

The pattern is sound. It gives you defence in depth without requiring perfection from any single layer. Start with guardrails, add a sampling judge, and put a human review process in place. Iterate from there.

---

## "Do we really need judges everywhere?"

No. You don't.

Judges add latency and cost. Put them where the **risk of errors outweighs the cost of evaluation** - not everywhere.

A low-risk internal FAQ bot? Guardrails and logging are probably enough. A system making credit decisions or generating customer-facing communications at scale? That's where judge evaluation earns its keep.

Match the control to the risk. The [Risk Tiers](core/risk-tiers.md) framework exists precisely to help you make this call.

---

## "When do we actually need humans in the loop?"

At minimum, where regulations require it. The EU AI Act, financial services regulations, and sector-specific rules increasingly mandate human oversight for high-risk AI systems. That's your compliance baseline.

Beyond that, humans are needed where the consequences of errors are serious and irreversible - decisions affecting people's rights, health, or finances. Humans don't scale, so use them where they matter most: reviewing edge cases, calibrating controls, and making decisions that carry accountability.

The framework's [Human Factors](strategy/human-factors.md) page goes deeper on where human oversight adds genuine value versus where it becomes theatre.

---

## "Is this a compliance checklist?"

No. This framework is designed to **provoke thought** about AI runtime risks, not prescribe a rigid set of mandatory controls.

Realistically, only the most high-risk AI use cases need a full set of controls. A low-risk internal tool doesn't need the same governance as an autonomous agent making financial decisions. Treating everything the same wastes resources and creates compliance fatigue.

Adopt a **risk-aligned approach**. Look at your use cases, assess the risks, and enable what's needed and practical for your organisation. The controls exist as a menu, not a mandate.

---

## "How do we know what's actually happening in our AI systems?"

Use the data your AI systems already provide.

CloudTrail logs API calls. CloudWatch captures metrics and operational data. Bedrock provides invocation logging. Azure AI has diagnostic logs. Databricks has audit logs and model serving metrics. Your platform is generating telemetry - the question is whether anyone is looking at it.

Start by turning on what's available. Establish baselines. Look for anomalies. You don't need a custom observability platform on day one. You need eyes on the data your systems are already producing.

The [Logging & Observability](infrastructure/controls/logging-and-observability.md) controls and [Runtime Telemetry Reference](extensions/technical/runtime-telemetry-reference.md) provide practical starting points.

---

## "Does this scale?"

Honestly? I don't know yet. I believe it can.

The patterns - guardrails as automated first-line defence, sampling-based judge evaluation, risk-tiered human oversight - are designed to scale. Guardrails operate at the request level with minimal latency. Judges can be asynchronous and sampled. Human review focuses on the long tail of edge cases, not every interaction.

But the evidence base for AI runtime security at true enterprise scale is still emerging. We're all learning.

---

## "Is this framework finished?"

No. And it may never be in the traditional sense.

The threat landscape for AI systems is evolving rapidly. New model capabilities, new attack patterns, and new regulatory requirements emerge regularly. A finished framework would be an outdated one.

What exists today is a practitioner-tested structure for thinking about and implementing AI runtime controls. It's being actively developed, and it's designed to evolve as the field matures.

---

## "I've solved some of these problems. Should I share?"

Yes. Please.

This framework doesn't have all the answers. If you've found practical solutions to AI runtime security challenges - monitoring patterns that work, judge configurations that catch real issues, human review processes that don't become bottlenecks - the community benefits from your experience.

There are plenty of ways to get involved:

- **Clone the repo** and explore the framework in your own environment
- **Raise an issue** when something doesn't make sense or doesn't match your reality
- **Add comments** on existing discussions
- **Give your opinion** - agreement and disagreement are both valuable
- **Submit a PR** with your better idea, a correction, or a new pattern you've seen work
- **Point out where this doesn't match reality** - that's how the framework improves

See the [Contributing](CONTRIBUTING.md) guide or open an issue on [GitHub](https://github.com/JonathanCGill/ai-runtime-behaviour-security). The problems we're all facing are similar. The solutions don't need to be discovered independently by every organisation.

---

## "Can I use this for my own work?"

Absolutely. This framework is [MIT licensed](https://github.com/JonathanCGill/ai-runtime-behaviour-security). You can copy it, fork it, adapt it, build on it, or use any of the ideas in your own work - no permission needed.

Want to build your own site with your own take on AI runtime security? Go for it. Want to take one section and expand it for your industry? Do that. Want to disagree with the entire approach and publish something better? Even better - the field needs more voices and more perspectives.

The ideas here are shared openly because AI security is too important to gatekeep. If something in this framework helps you build safer AI systems, that's the point.

---

## Where to Go Next

| Question | Start Here |
|----------|-----------|
| How do I get started quickly? | [Quick Start](QUICK_START.md) |
| What controls do I actually need? | [Risk Tiers](core/risk-tiers.md) |
| What does implementation look like? | [Worked Examples](extensions/examples/README.md) |
| How do guardrails work in practice? | [Practical Guardrails](insights/practical-guardrails.md) |
| What about multi-agent systems? | [MASO Framework](maso/README.md) |

---

*AI Runtime Behaviour Security, 2026 (Jonathan Gill).*
