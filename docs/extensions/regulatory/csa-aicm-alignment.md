---
as_at: "2026-07-04"
description: "Alignment between this framework and the CSA AI Controls Matrix (AICM) v1.1: how the AICM's 18 domains map to existing coverage, how AICM relates to MASO multi-agent controls, and what the shared responsibility model and CBRA add."
---

# CSA AI Controls Matrix (AICM) Alignment

The **CSA AI Controls Matrix (AICM)** is the most directly comparable AI control framework to this one, so it is worth being explicit about how the two relate. AICM v1.1 is **247 control objectives across 18 domains**, built on top of CSA's Cloud Controls Matrix (CCM). It maps to ISO/IEC 42001, ISO/IEC 27001, NIST AI 600-1, and BSI AIC4, and ships with the **AI-CAIQ** assessment questionnaire and a pathway to STAR for AI certification.

The short version: this framework already covers AICM's AI-specific substance and goes deeper on runtime behaviour, while AICM contributes structure this framework borrows, principally its shared responsibility model.

## Where the two frameworks differ in purpose

AICM is an **assurance and compliance** framework. Most of its 247 controls are CCM cloud controls (cryptography, datacenter, endpoint, human resources) inherited unchanged, and its end goal is a certifiable posture: AI-CAIQ, STAR for AI. Only one of its 18 domains, **Model Security (MDS)**, is genuinely AI-specific.

This framework is a **runtime behavioural** framework. It is explicit that it is [not a certification or audit standard](../../about.md). It deliberately scopes out the traditional cloud controls AICM inherits, treating them as the job of your existing infrastructure, and concentrates on what is unique to non-deterministic AI behaviour at runtime: guardrails, the Judge, oversight, circuit breakers, PACE resilience, and the multi-agent failure modes that have no cloud-control equivalent.

The two are complementary. AICM tells an auditor the control exists. This framework tells an engineer how the control behaves when an adversary probes it in production.

## Domain mapping

How AICM's 18 domains land against existing coverage. AICM's single AI-specific domain (MDS) is well within scope here; the rest are either covered in greater depth or deliberately deferred to existing infrastructure.

| AICM domain | This framework |
|-------------|----------------|
| **Model Security (MDS)** | Covered: [Foundations](../../foundations/README.md), [Model Cognition Assurance](../../maso/controls/model-cognition-assurance.md), [Provenance & Attestation](../../core/controls/provenance-and-attestation.md) |
| Identity & Access Management (IAM) | Covered and deeper: [IAM Governance](../../core/iam-governance.md), [MASO (Multi-Agent Security Operations) Identity & Access](../../maso/controls/identity-and-access.md) |
| Supply Chain, Transparency & Accountability (STA) | Covered: [Supply Chain](../../maso/controls/supply-chain.md), AIBOM and signed manifests |
| Logging & Monitoring (LOG) | Covered: [Observability](../../maso/controls/observability.md), [Runtime Telemetry Reference](../../extensions/technical/runtime-telemetry-reference.md) |
| Data Security & Privacy (DSP) | Covered: [Data Protection](../../maso/controls/data-protection.md), [Data Provenance & Authority Boundaries](../../core/controls/data-provenance-and-authority-boundaries.md) |
| Governance, Risk & Compliance (GRC) | Covered: [Strategy](../../strategy/README.md), [Risk Tiers](../../core/risk-tiers.md) |
| Security Incident Management (SEF), Threat & Vuln Management (TVM) | Covered: [Incident Tracker](../../maso/threat-intelligence/incident-tracker.md), [Red Team Playbook](../../maso/red-team/red-team-playbook.md), [Risk Register](../../maso/controls/risk-register.md) |
| Business Continuity & Operational Resilience (BCR) | Covered and distinctive: [PACE Resilience](../../pace-resilience.md), circuit breaker |
| Application & Interface Security (AIS) | Covered: [Three-Layer Model](../../core/controls.md), [Semantic Firewall](../../core/controls/semantic-firewall.md) |
| Audit & Assurance (AAC), Change Control (CCC), Cryptography (CEK), Datacenter (DCS), Human Resources (HRS), Interoperability (IPY), Infrastructure & Virtualization (IVS), Universal Endpoint Management (UEM) | Traditional cloud controls deliberately deferred to existing infrastructure, per the framework's [scope statement](../../about.md) |

## AICM and MASO: different altitudes

The domain mapping above flattens AICM against the whole framework. The relationship with [MASO](../../maso/README.md), the multi-agent control set, is worth drawing out on its own, because it is where the two frameworks are most complementary and least overlapping.

AICM treats an AI system as a **single model or service in a supply chain**. MASO treats it as a **fleet of agents handing work to each other**. AICM is wide and assurance-oriented (18 domains, mostly inherited cloud controls); MASO is narrow and runtime-oriented (deep control depth concentrated on one slice AICM barely addresses). They meet at a few domains and diverge sharply on either side.

**Where they overlap.** A handful of AICM domains map onto MASO domains, with MASO far more granular:

| AICM domain | MASO equivalent |
|-------------|-----------------|
| Model Security (MDS) | [Model Cognition Assurance](../../maso/controls/model-cognition-assurance.md) |
| Identity & Access (IAM) | [Identity & Access](../../maso/controls/identity-and-access.md) + [Privileged Agent Governance](../../maso/controls/privileged-agent-governance.md) |
| Supply Chain (STA) | [Supply Chain](../../maso/controls/supply-chain.md) |
| Logging & Monitoring (LOG) | [Observability](../../maso/controls/observability.md) |
| Data Security & Privacy (DSP) | [Data Protection](../../maso/controls/data-protection.md) |
| Application & Interface Security (AIS) | [Execution Control](../../maso/controls/execution-control.md) + [Prompt, Goal & Epistemic Integrity](../../maso/controls/prompt-goal-and-epistemic-integrity.md) |

**Where MASO goes and AICM cannot.** Because AICM has no model for agents collaborating, several MASO domains have no AICM counterpart at all: [Extraction Integrity](../../maso/controls/extraction-integrity.md), [Objective Intent](../../maso/controls/objective-intent.md), [Agentic Task Mandate](../../maso/controls/agentic-task-mandate.md), [Environment Containment](../../maso/environment-containment.md), and the emergent epistemic risks in the [Risk Register](../../maso/controls/risk-register.md) (injection propagation, transitive privilege, groupthink, synthetic corroboration). Secure a multi-agent system to AICM alone and every one of these is a blind spot.

**Where AICM goes and MASO cannot.** MASO assumes you build and operate every agent. The moment a multi-agent system includes a vendor model or a third-party orchestration layer, you need AICM's [shared responsibility model](../../core/shared-responsibility.md) to say who owns which MASO control. In AICM's terms, **MASO is the control set for the Orchestrator and Application Provider roles, for the agents where those roles are you.**

**How they combine in practice.** Use CBRA to size the system (its autonomy axis maps onto MASO's Supervised to Managed to Autonomous tiers); use AICM's five actors to decide which agents you own versus consume; use MASO to actually implement the runtime controls for the parts you own; then map that MASO implementation back up to AICM domains when an auditor asks. AICM is the org chart and the audit checklist for the whole supply chain. MASO is the engineering manual for the multi-agent part you are responsible for.

## What this framework borrows from AICM

Two structural ideas from AICM are worth adopting, independent of its control content.

### Shared responsibility model

AICM assigns every control across five actors: Cloud Service Provider, Model Provider, Orchestrator, Application Provider, and AI Customer. This is the cleanest available vocabulary for the build-versus-consume distinction, and the framework adopts it directly in [Shared Responsibility for AI Systems](../../core/shared-responsibility.md). It is the missing axis that lets a consuming organisation work out which controls a vendor owns and which residual is theirs.

### Control-type lens

AICM tags each control as **AI-specific**, **AI & Cloud** (hybrid), or **Cloud** (inherited). This is the same argument the framework makes in [About This Framework](../../about.md) (an AI-specific layer, not a replacement for your existing DLP, IAM, and SIEM), expressed as a per-control tag. It is a useful way to see, at a glance, which controls are net-new for AI and which your existing programme already satisfies.

## CBRA: capabilities-based risk assessment

AICM's companion artifact, the **Capabilities-Based Risk Assessment (CBRA)**, scores an AI system on four dimensions, **System Criticality x Autonomy x Access Permissions x Impact Radius**, and calibrates the control set to the result. Its central insight is that autonomy alone is not the risk driver: Level 3 autonomy over reversible actions is a very different profile from Level 3 autonomy over financial transactions or production code.

That insight independently corroborates two models already in this framework: the six-dimension scoring in [Risk Tiers](../../core/risk-tiers.md) and the [MASO](../../maso/README.md) supervised-to-managed-to-autonomous tiers, both of which already pair autonomy with blast radius. CBRA is useful as external validation. It does not replace the framework's existing scoring, which is more granular and already in operational use.

!!! info "References"
    - [CSA AI Controls Matrix v1.1](https://cloudsecurityalliance.org/artifacts/ai-controls-matrix-v1-1)
    - [Introducing the CSA AI Controls Matrix](https://cloudsecurityalliance.org/blog/2025/07/10/introducing-the-csa-ai-controls-matrix-a-comprehensive-framework-for-trustworthy-ai)
    - [Capabilities-Based Risk Assessment (CBRA) for AI Systems](https://cloudsecurityalliance.org/artifacts/capabilities-based-risk-assessment-cbra-for-ai-systems)
    - [Shared Responsibility for AI Systems](../../core/shared-responsibility.md)
