---
description: "Alignment between this framework and the CSA AI Controls Matrix (AICM) v1.1: how the AICM's 18 domains map to existing coverage, what the shared responsibility model and CBRA add, and where the two frameworks differ in purpose."
---

# CSA AI Controls Matrix (AICM) Alignment

The **CSA AI Controls Matrix (AICM)** is the most directly comparable AI control framework to this one, so it is worth being explicit about how the two relate. AICM v1.1 is **243 control objectives across 18 domains**, built on top of CSA's Cloud Controls Matrix (CCM). It maps to ISO/IEC 42001, ISO/IEC 27001, NIST AI 600-1, and BSI AIC4, and ships with the **AI-CAIQ** assessment questionnaire and a pathway to STAR for AI certification.

The short version: this framework already covers AICM's AI-specific substance and goes deeper on runtime behaviour, while AICM contributes structure this framework borrows, principally its shared responsibility model.

## Where the two frameworks differ in purpose

AICM is an **assurance and compliance** framework. Most of its 243 controls are CCM cloud controls (cryptography, datacenter, endpoint, human resources) inherited unchanged, and its end goal is a certifiable posture: AI-CAIQ, STAR for AI. Only one of its 18 domains, **Model Security (MDS)**, is genuinely AI-specific.

This framework is a **runtime behavioural** framework. It is explicit that it is [not a certification or audit standard](../../about.md). It deliberately scopes out the traditional cloud controls AICM inherits, treating them as the job of your existing infrastructure, and concentrates on what is unique to non-deterministic AI behaviour at runtime: guardrails, the Judge, oversight, circuit breakers, PACE resilience, and the multi-agent failure modes that have no cloud-control equivalent.

The two are complementary. AICM tells an auditor the control exists. This framework tells an engineer how the control behaves when an adversary probes it in production.

## Domain mapping

How AICM's 18 domains land against existing coverage. AICM's single AI-specific domain (MDS) is well within scope here; the rest are either covered in greater depth or deliberately deferred to existing infrastructure.

| AICM domain | This framework |
|-------------|----------------|
| **Model Security (MDS)** | Covered: [Foundations](../../foundations/README.md), [Model Cognition Assurance](../../maso/controls/model-cognition-assurance.md), [Provenance & Attestation](../../core/controls/provenance-and-attestation.md) |
| Identity & Access Management (IAM) | Covered and deeper: [IAM Governance](../../core/iam-governance.md), [MASO Identity & Access](../../maso/controls/identity-and-access.md) |
| Supply Chain, Transparency & Accountability (STA) | Covered: [Supply Chain](../../maso/controls/supply-chain.md), AIBOM and signed manifests |
| Logging & Monitoring (LOG) | Covered: [Observability](../../maso/controls/observability.md), [Runtime Telemetry Reference](../../extensions/technical/runtime-telemetry-reference.md) |
| Data Security & Privacy (DSP) | Covered: [Data Protection](../../maso/controls/data-protection.md), [Data Provenance & Authority Boundaries](../../core/controls/data-provenance-and-authority-boundaries.md) |
| Governance, Risk & Compliance (GRC) | Covered: [Strategy](../../strategy/README.md), [Risk Tiers](../../core/risk-tiers.md) |
| Security Incident Management (SEF), Threat & Vuln Management (TVM) | Covered: [Incident Tracker](../../maso/threat-intelligence/incident-tracker.md), [Red Team Playbook](../../maso/red-team/red-team-playbook.md), [Risk Register](../../maso/controls/risk-register.md) |
| Business Continuity & Operational Resilience (BCR) | Covered and distinctive: [PACE Resilience](../../pace-resilience.md), circuit breaker |
| Application & Interface Security (AIS) | Covered: [Three-Layer Model](../../core/controls.md), [Semantic Firewall](../../core/controls/semantic-firewall.md) |
| Audit & Assurance (AAC), Change Control (CCC), Cryptography (CEK), Datacenter (DCS), Human Resources (HRS), Interoperability (IPY), Infrastructure & Virtualization (IVS), Universal Endpoint Management (UEM) | Traditional cloud controls deliberately deferred to existing infrastructure, per the framework's [scope statement](../../about.md) |

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
