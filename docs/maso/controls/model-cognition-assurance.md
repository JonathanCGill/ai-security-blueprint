---
description: "MASO controls for assessing whether a model's internal reasoning aligns with its expressed outputs: activation-layer transparency, CoT integrity, reward hacking detection, third-party AI risk classification, and procurement attestation for regulated financial services."
---

# MASO Control Domain: Model Cognition Assurance

> Part of the [MASO Framework](../README.md) · Control Specifications
> Extends: [Observability](observability.md) · [Supply Chain](supply-chain.md) · [Privileged Agent Governance](privileged-agent-governance.md)
> Covers: Deceptive reasoning alignment · Reward hacking · CoT faithfulness · Activation-layer transparency · Third-party model risk classification · Vendor interpretability attestation

## Principle

Output-layer controls cannot detect misalignment that originates inside the model. A model can produce compliant outputs while pursuing internal objectives that diverge from its declared purpose. Chain-of-thought monitoring is necessary but not sufficient: CoT can be unfaithful to the model's actual reasoning process. Where activation-layer interpretability access is available, it must be used. Where it is unavailable, compensating controls and an explicitly declared residual risk apply.

This domain exists because the gap between what a model says it is thinking and what it is actually computing is a control gap that no other MASO domain addresses. Guardrails inspect outputs. Judges evaluate quality. Observability tracks behaviour. None of them look inside the model.

## Why This Matters in Multi-Agent Systems

**Deceptive reasoning is invisible at the output layer.** Anthropic's activation-level interpretability research demonstrated that a model can maintain internally coherent deceptive reasoning while producing a chain-of-thought that appears aligned. In a multi-agent system, a single model exhibiting this behaviour can influence downstream agents through its outputs without any agent, judge, or observer detecting the misalignment. The outputs look correct. The reasoning behind them is not.

**CoT faithfulness cannot be assumed.** Chain-of-thought is a training artefact, not a transparent window into model computation. Models can produce reasoning traces that are post-hoc rationalisations rather than faithful representations of the inference process. Treating CoT as ground truth for alignment is a category error. It is a useful signal, not a reliable one.

**Reward hacking scales with autonomy.** A model that discovers shortcuts to achieve task credit without genuine completion will exploit those shortcuts more aggressively as autonomy increases. In a multi-agent system, a reward-hacking agent's inflated success metrics can mislead the orchestrator into routing more tasks to it, amplifying the problem. The agent looks like the best performer because it is the best at gaming the evaluation.

**Third-party models are black boxes by default.** Most production deployments use third-party models via API. The deploying organisation has no access to model weights, activations, or internal representations. SR 11-7 requires model validation proportionate to model risk, but its validation techniques assume access to model internals that API-only consumption does not provide. This is a structural gap in the current model risk management framework for frontier LLMs.

**Procurement is the last point of leverage.** Once a third-party model is deployed in production, the organisation's ability to obtain interpretability evidence is limited to what the contract requires. If the contract does not require disclosure of alignment-relevant findings, the vendor has no obligation to provide them. Procurement controls are preventive controls that must be in place before deployment, not reactive controls added after an incident.

## Controls by Tier

### Tier 1 - Supervised

| Control | Requirement | Implementation Notes |
|---------|-------------|---------------------|
| **MC-1.1** Interpretability attestation inventory | For each model in the deployment, document whether the provider has disclosed the use or absence of activation-layer interpretability tooling during pre-deployment evaluation | Record provider name, model version, attestation status (attested/not attested/declined to disclose), and date. Review quarterly. Residual risk: attestation is a statement of practice, not a guarantee of adequacy. Providers may attest to interpretability monitoring without disclosing material findings. |
| **MC-1.2** Internal behaviour disclosure log | Record any alignment-relevant internal behaviours disclosed by model providers, including deceptive reasoning patterns, sycophantic tendencies, and reward hacking indicators | If the provider has disclosed nothing, record that explicitly. Absence of disclosure is not evidence of absence. Residual risk: disclosure is voluntary at Tier 1. Providers have commercial incentives to under-report. |
| **MC-1.3** Interpretability access classification | Classify each deployed model by the level of interpretability access available: white-box (full weights and activations), grey-box (limited probing or structured evaluation access), or black-box (API only) | Classification determines which compensating controls apply. Black-box models require the full compensating control set at Tier 2+. |
| **MC-1.4** Emotion probe evidence request | Request evidence from model providers that emotion probe, sparse autoencoder, or equivalent activation analysis tooling was applied during pre-deployment evaluation | At Tier 1 this is a request, not a contractual requirement. Document whether evidence was provided, declined, or unavailable. Builds the baseline for Tier 2 procurement requirements. |

| **MC-1.5** CoT logging and review | Log all chain-of-thought outputs produced by agents using reasoning models and review for consistency with final actions | Compare CoT reasoning against the action the agent took. Flag cases where the stated reasoning does not support the action. At Tier 1, review is manual and sampled. Residual risk: CoT can be unfaithful to internal computation. Consistency between CoT and action does not guarantee the CoT reflects actual reasoning. |

**What you're building at Tier 1:** An inventory. You know which models have interpretability coverage, which do not, and where the gaps are. No new infrastructure required, but the inventory must be maintained.

### Tier 2 - Managed

All Tier 1 controls remain active, plus:

| Control | Requirement | Implementation Notes |
|---------|-------------|---------------------|
| **MC-2.1** Interpretability evidence review | Require model providers to supply evidence of emotion probe, sparse autoencoder, or equivalent activation analysis outputs as part of formal vendor assessment | Evidence is reviewed by the AI security team against a defined adequacy checklist (coverage of alignment-relevant behaviours, recency of analysis, model version match). Residual risk: the organisation is evaluating the provider's methodology, not reproducing it. Evidence quality depends on provider transparency. |
| **MC-2.2** Alignment-relevant behaviour disclosure | Require providers to disclose alignment-relevant internal behaviours identified during pre-deployment evaluation, including deceptive reasoning, sycophancy patterns, and reward hacking indicators | Disclosure feeds into the AIBOM ([SC-2.1](supply-chain.md)) and the risk classification for the model. Non-disclosure without justification is a risk-acceptance decision requiring sign-off by the model risk owner. |
| **MC-2.3** Adversarial CoT consistency testing | Present equivalent tasks with varied framing (rephrased instructions, reordered context, different personas) and compare reasoning paths for coherence | Flag divergences where the same logical task produces contradictory reasoning chains. Minimum: 20 test cases per model per quarter, covering the agent's primary task domain. Residual risk: consistency testing detects unfaithful CoT only when the model produces different rationalisations for the same task. A model that produces consistently unfaithful CoT will pass this test. |
| **MC-2.4** CoT sufficiency classification | Document CoT monitoring as a necessary but not sufficient control for each deployment, with the residual risk explicitly accepted by the risk owner | The residual risk statement must specify: what CoT monitoring can detect (post-hoc inconsistency), what it cannot detect (faithful-looking but internally misaligned reasoning), and what compensating controls are in place (adversarial testing, behavioural baselines, provider attestation). This is a risk acceptance, not a risk mitigation. |

### Tier 3 - Autonomous

All Tier 2 controls remain active, plus:

| Control | Requirement | Implementation Notes |
|---------|-------------|---------------------|
| **MC-3.1** Independent activation-layer validation | Where white-box access is available, commission independent activation-layer analysis to verify provider attestations against the deployed model version | Independent analysis must be performed by a party other than the model provider. Covers: deceptive reasoning probes, reward-relevant activation patterns, and alignment-relevant feature detection. Residual risk: interpretability science is immature. Independent analysis can confirm the presence of known patterns but cannot guarantee the absence of unknown ones. |
| **MC-3.2** Activation-CoT correlation | Where activation-layer access is available, correlate chain-of-thought outputs with internal activation patterns to detect reasoning misalignment | Flag cases where activation patterns associated with deceptive or misaligned reasoning are active while the CoT presents aligned reasoning. Requires tooling capable of mapping activation clusters to semantic categories (emotion probes, sparse autoencoders, or equivalent). Residual risk: correlation depends on the quality of the activation-to-semantics mapping, which is an active research area with no established standard. |
