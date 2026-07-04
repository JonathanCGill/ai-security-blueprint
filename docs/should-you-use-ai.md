---
title: Should You Use AI at All?
description: "Before you build runtime security, ask the cheaper question: does this task actually need a stochastic model? Misjudging that fit is the largest source of avoidable runtime risk. A short suitability screen and a funnel into the framework for when the answer is yes."
---

# Should You Use AI at All?

**The most effective runtime control is the one you never had to build.** Before you classify risk, deploy guardrails, or stand up a Judge, there is a cheaper question that comes first: does this task actually need a generative model?

A large language model is a stochastic system. It produces plausible output, not correct output, and the two only coincide on average. Most of the failures this framework exists to contain begin upstream of any attack, at the moment someone pointed a probabilistic tool at a problem that needed a deterministic one, to save time or because a model looked like the modern choice.

That misjudgement does not *cause* prompt injection or data leakage. The site's [central idea](what-is-ai-runtime-security.md) still holds: most attacks are untrusted content treated as an instruction instead of as data. But choosing a model for a task that never needed one is what puts you in the blast radius in the first place. It is the largest source of **avoidable** runtime risk: risk you took on without needing to, and now have to spend the rest of the framework containing.

## The screen

Run the task through these before you commit to a model. If the honest answer to any of them is yes, a generative model is probably the wrong *primary* tool.

<div class="grid cards" markdown>

-   **Does it need to be reproducible?**

    Same input, same output, every time. Tax calculations, pricing, eligibility rules, anything you would want to unit-test. A model that answers slightly differently on each call is the wrong foundation for work that has a single correct answer.

-   **Does it need exact accuracy?**

    Not "good on average", but right in the specific case in front of you. Account balances, dosages, legal thresholds, safety limits. Average-case fluency is no comfort when the one case that matters is the one it gets wrong.

-   **Does it need to be auditable?**

    Can you be required to explain *why* this output, and defend it later? Deterministic logic has a trace. A model's reasoning is a reconstruction after the fact, not the actual cause of the output.

-   **Is there no genuine language ambiguity?**

    If the task is fully specified by rules, a model adds variance without adding value. Models earn their place where the input is open-ended natural language, messy, ambiguous, human. Not where a lookup table would do.

</div>

If a task is deterministic and you solve it deterministically, you have not *mitigated* a class of runtime risk. You have **eliminated** it. There is no prompt-injection surface on a function that never calls a model. This is the framework's own logic of [containment over evaluation](insights/why-containment-beats-evaluation.md) taken to its conclusion: the cheapest containment is not introducing the risk.

!!! tip "Use a high-accuracy solution for a high-accuracy problem"
    If you need reproducibility and exactness, reach for the tool that gives them: rules, a database query, a constraint solver, a traditional model with a measured error bound. You save yourself the cost of building and operating runtime security for a problem that never needed it.

## This is not "don't use AI"

The point is fit, not abstinence. Reaching for a model is the right call whenever the value of the task genuinely lives in handling open-ended language or judgement that rules cannot capture: summarising free text, classifying unstructured input, drafting, answering questions over a messy corpus. The interesting systems are usually **hybrids**: a deterministic spine, with a model placed only where the ambiguity actually is, a router, an extractor, a ranker, wrapped so the deterministic layer constrains the stochastic one.

That hybrid shape is also exactly where runtime security goes. So the screen does not steer you away from the framework. It tells you where in your system the framework is needed, and where it is wasted effort.

## If the answer is yes

A model is the right tool, and now you owe it runtime security. Pick up the framework here:

<div class="grid cards" markdown>

-   **Classify the risk**

    The risk of a use case follows from what it does, not from the technology. Work out the tier before you build.

    [Risk Tiers](core/risk-tiers.md)

-   **Ship the minimum safely**

    Seven controls, one checklist. Enough runtime safety to go live and enough observability to learn.

    [AIRSLite](minimum-viable-airs.md)

</div>

!!! info "References"
    - [What AI Runtime Security is](what-is-ai-runtime-security.md)
    - [Why Containment Beats Evaluation](insights/why-containment-beats-evaluation.md)
    - [Risk Tier Is the Use Case](insights/risk-tier-is-use-case.md)
    - [Where to Begin](start.md)
    - [AI Secured by Design: Should You Use AI?](https://aisecuredbydesign.io/how-to/should-you-use-ai/)
