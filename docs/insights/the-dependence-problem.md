---
description: "When a government takes an AI model offline for political reasons, dependent users lose a production dependency with no notice. Why vendor and model dependence is a runtime continuity risk, and what alternatives dependent organisations actually have."
---

# The Dependence Problem

*A model you did not build, hosted in a country whose politics you do not control, can be switched off without warning. If your runtime has no fallback, that is your outage too.*

## When a Model Is Taken Offline

In June 2026 the US government issued an export-control directive ordering Anthropic to suspend access to its **Fable 5** and **Mythos 5** models for any foreign national, whether inside or outside the United States, including Anthropic's own foreign-national employees. To comply with a directive scoped that broadly, Anthropic had to disable both models for **all** customers, abruptly and with no restoration date.

The stated justification was national security, tied to a reported jailbreak of Fable 5 triggered by the phrase *"fix this code"*, and to Mythos 5 being an autonomous exploit-finding model that the company had already judged too dangerous for open release. Anthropic said it received only verbal notice of a narrow, non-universal jailbreak and disagreed that it warranted recalling a commercial model used by hundreds of millions of people.

The merits of that dispute are not the point here. The point is what it did to the people downstream. Teams that had wired Fable 5 or Mythos 5 into production workflows lost them with zero notice and no estimated time of return. Some of those workflows were security tooling, so a control disappeared along with the model.

## This Is a Runtime Problem, Not a Procurement Problem

It is tempting to file this under vendor management. It belongs under runtime resilience.

**Availability is a security property.** A model that is suddenly gone is indistinguishable, from your application's perspective, from a model that has failed. If your pipeline hard-codes a single provider and a single model, then a policy decision made in a capital city you have no vote in becomes an unplanned outage in your stack. The [supply chain problem](the-supply-chain-problem.md) usually describes a model that *changes* underneath you. This is the sharper version: the model *vanishes* underneath you.

It also matters which way the system fails. A pipeline that fails open keeps serving with the safety component missing. A pipeline that fails closed stops serving altogether. Neither is acceptable as an unplanned default. Both should be a decision you made in advance, not a behaviour you discover during the incident.

## The Risk Lands Hardest Outside the Producing Country

Most frontier models are produced in a small number of countries. The export-control directive above was scoped by **nationality**: access turned on *who* was calling, not only on *what* they asked. That is the structural reason this risk is not evenly distributed.

If you build outside the country where your model is produced, you are depending on infrastructure governed by another government's foreign policy, sanctions regime, and export controls. You can be entirely compliant, entirely legitimate, and still lose access overnight because of a decision aimed at someone else. The mirror image is already familiar: when US federal agencies, several US states, and a number of Asian and European governments restricted China's **DeepSeek** in 2025 over data residency and espionage concerns, organisations that had standardised on it inherited the same problem from the opposite direction.

The lesson for any organisation depending on a foreign provider is uncomfortable but simple. Continuity of access is not something your vendor can fully guarantee, because your vendor does not control it either.

## What Alternatives Do You Actually Have

Dependence is not avoidable. Every serious AI system depends on components someone else builds. The goal is not independence, it is **substitutability**: making any single model replaceable fast enough that its removal is a degradation rather than an outage. The framework already has the machinery for this. Removal of a model is just another failure domain that [PACE resilience](../pace-resilience.md) is designed to absorb.

| Alternative | What it gives you | The trade-off to plan for |
|---|---|---|
| **Provider-abstraction gateway** | A model-agnostic layer so calls route through configuration, not hard-coded SDK calls. Switching providers becomes a config change, not a re-architecture. | You own the abstraction, and prompts and tool schemas rarely port perfectly between models. |
| **Pre-evaluated fallback model** | A warm standby on a different provider, ideally a different jurisdiction, already through your evaluation harness so it is ready to take traffic. | Cost of running and re-evaluating a second model you hope never to need. |
| **PACE fail posture** | A pre-defined Primary, Alternate, Contingency, Emergency path so loss of the primary model degrades gracefully to a known-safe response or a non-AI path. See [PACE Resilience](../pace-resilience.md). | Requires deciding, before the incident, what "degraded but safe" means for each use case. |
| **Sovereign or self-hosted option** | An open-weight model you run yourself cannot be switched off by a third party's export control. For some organisations this is the only durable answer. | You inherit every control the provider used to maintain. See [Open-Weight Models Shift the Burden](open-weight-models-shift-the-burden.md). |
| **Continuous evaluation (the Judge)** | When you are forced to swap models in a hurry, an independent evaluation layer catches the quality and safety drift the new model introduces. | An emergency migration still ships an unevaluated baseline unless the eval layer is already running. |
| **AI-BOM, allowlists, shadow AI discovery** | Knowing exactly which models are embedded where, so when one is banned you can find every place it lives. | Only useful if maintained before the event, not assembled during it. |

The thread running through all of these is the same: the work has to be done before the model disappears, not after. A fallback you have never tested is not a fallback. A second provider you have never evaluated is a fresh, unmeasured risk you are adopting under pressure, which is the worst possible moment to do it.

## The Forced-Migration Trap

There is a specific failure mode worth naming, because it is where dependent organisations get hurt twice. When a model is pulled, the instinct is to swap in whatever replacement is available and restore service. But the replacement has never been through your evaluation. You trade an availability incident for a silent quality and safety regression, and you may not notice the second problem until it produces a bad outcome in production. This is exactly the gap the [Judge layer](why-ai-security-is-a-runtime-problem.md) is meant to cover. Resilience is not only *having* a fallback. It is being able to trust the fallback the moment you switch to it.

## The Bottom Line

Models will come and go. Providers will be restricted, deprecated, sanctioned, and occasionally switched off by a government overnight. Treating any single model as permanent infrastructure is the actual mistake, and it is a mistake that costs the most for organisations building outside the handful of countries where frontier models are produced.

The defensible position is not to pick the one provider least likely to be banned. It is to design so that no single model's removal can take you down: abstraction so you can switch, a pre-evaluated alternate so the switch is safe, and a PACE fail posture so that even losing every model still degrades to something known and safe rather than to an outage.

Dependence is a given. Designing for the day a dependency disappears is a choice.

!!! info "References"
    - [Anthropic: Statement on the US directive to suspend access to Fable 5 and Mythos 5](https://www.anthropic.com/news/fable-mythos-access)
    - [TIME: Anthropic Pulls Its Most Powerful AI Models After U.S. Bars Foreign Access](https://time.com/article/2026/06/13/anthropic-fable-mythos-ban-US-security/)
    - [Fortune: Anthropic disables Fable and Mythos after U.S. bars foreign access](https://fortune.com/2026/06/13/anthropic-disables-fable-mythos-export-controls-national-security-threat/)
    - [Al Jazeera: US orders Anthropic to disable AI models for all foreign nationals](https://www.aljazeera.com/news/2026/6/13/us-orders-anthropic-to-disable-ai-models-for-all-foreign-nationals)
    - [Scientific American: What is Mythos and why are experts worried about Anthropic's AI model](https://www.scientificamerican.com/article/what-is-mythos-and-why-are-experts-worried-about-anthropics-ai-model/)
    - [NBC News: US lawmakers move to ban China's DeepSeek from government devices](https://www.nbcnews.com/business/business-news/us-lawmakers-move-ban-deepseek-government-devices-chinese-surveillance-rcna190965)
    - [Inside Global Tech: US Federal and State Governments Moving Quickly to Restrict Use of DeepSeek](https://www.insideglobaltech.com/2025/02/18/u-s-federal-and-state-governments-moving-quickly-to-restrict-use-of-deepseek/)
