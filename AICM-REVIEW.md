# CSA AI Controls Matrix (AICM v1.1): Review for Useful Imports

> A review of the Cloud Security Alliance **AI Controls Matrix (AICM) v1.1** against this framework, to isolate what is genuinely worth borrowing and what is not. No site content has been changed. This document exists for sign-off before any building starts.
>
> _Not part of the published site (lives outside `docs/`)._

## What AICM is

AICM is CSA's vendor-agnostic AI control framework, built on top of the **Cloud Controls Matrix (CCM)**. It is **243 control objectives across 18 domains**: the 17 traditional CCM cloud domains (Audit & Assurance, Application & Interface Security, Business Continuity, Change Control, Cryptography, Datacenter Security, Data Security & Privacy, GRC, Human Resources, IAM, Interoperability, Infrastructure & Virtualization, Logging, Incident Management, Supply Chain, Threat & Vulnerability Management, Universal Endpoint Management) plus one new AI-specific domain, **Model Security (MDS)**.

Three things make it more than "CCM with AI bolted on":

1. **Control Type classification.** Every control is tagged as **AI-specific**, **AI & Cloud** (hybrid), or **Cloud** (inherited). This tells you which controls are net-new for AI versus which your existing cloud programme already covers.
2. **Shared Security Responsibility Model (SSRM).** Every control assigns ownership across **five actors**: Cloud Service Provider, Model Provider, Orchestrated Service Provider (orchestrator), Application Provider, and AI Customer. A control can be owned by one actor, shared between named parties, or shared across the whole chain.
3. **Standards mapping and assurance pathway.** It maps to ISO/IEC 42001, ISO/IEC 27001, NIST AI 600-1, and BSI AIC4, and ships with the **AI-CAIQ** questionnaire and a pathway to **STAR for AI** certification.

A companion artifact, the **Capabilities-Based Risk Assessment (CBRA)**, scores an AI system on four dimensions, **System Criticality x Autonomy x Access Permissions x Impact Radius**, and maps the resulting risk band to a proportional subset of AICM controls (low risk gets lightweight controls, high risk gets full governance).

## Verdict

The framework already covers the **substance** of AICM's only AI-specific domain (Model Security) and far more besides: AICM has one AI domain, this framework has the foundation behavioural pattern, 11 MASO domains, 80 infrastructure controls, and a 34-item emergent risk register. We are not behind AICM on AI-specific depth.

Where AICM is **ahead of us is structure, not content**: it has a clean way to express *who owns each control* and *which controls are AI-specific versus inherited*. Those two lenses map directly onto a gap the README already admits: the framework is built for AI you *develop and operate*, and only gestures at AI you *consume from vendors*. AICM's SSRM is the missing vocabulary for that split.

So this is not "adopt AICM." It is "borrow three structural ideas, add a crosswalk, and skip the compliance machinery."

## What is genuinely useful

### 1. The Shared Responsibility Model (highest value)

| | |
|---|---|
| **What AICM has** | Five-actor SSRM (CSP, Model Provider, Orchestrator, Application Provider, AI Customer) with per-control ownership. |
| **Why it matters here** | The README states the framework targets AI you build, and that for consumed AI "the security questions and implementation details differ." Today that distinction has no formal model. AICM's five actors are exactly the missing axis: for any control, you can say which party is accountable when you are the AI Customer of a vendor copilot versus the Application Provider of your own agent. |
| **What exists already** | Shared responsibility is mentioned in passing in `stakeholders/compliance-and-legal.md`, `insights/the-mcp-problem.md`, and `insights/the-model-you-choose.md`, but there is no single page that names the actors or assigns ownership. |
| **Proposed action** | One concept page (working title *Shared Responsibility for AI Systems*), most likely under `core/` or `strategy/`. Define the five actors, give a worked example of the same control owned differently across build-vs-consume, and use it to make the existing "maturity levels two-track" guidance concrete. Light cross-links from the README architecture section and `maturity-levels.md`. |
| **Effort** | Low to medium (one page plus cross-links). |

### 2. The control-type lens (AI-specific vs hybrid vs inherited)

| | |
|---|---|
| **What AICM has** | Each control tagged AI-specific / AI & Cloud / Cloud. |
| **Why it matters here** | This is the same argument the README's "About This Framework" already makes ("an AI-specific layer, not a replacement for your DLP, IAM, SIEM"), but AICM turns it into a per-control tag. It directly supports the framework's "see where you already have coverage, do not buy something new" goal. |
| **Proposed action** | No new pages. Adopt the three-way tag as light metadata when the control catalogues are next revised, or simply cite the lens once in the architecture overview to reinforce the "AI-specific layer only" thesis. Optional and low priority. |
| **Effort** | Low (editorial, opportunistic). |

### 3. CBRA as corroboration for risk tiers and autonomy tiers

| | |
|---|---|
| **What AICM has** | CBRA scores Criticality x Autonomy x Permission x Impact and calibrates controls to the result. Its core insight: "Level 3 autonomy over reversible actions is a different risk profile than Level 3 autonomy over financial transactions or production code." |
| **Why it matters here** | This independently validates two of the framework's existing models: the six-dimension `core/risk-tiers.md` scored profile and the MASO supervised to managed to autonomous tiers. CBRA's autonomy-times-blast-radius framing is the same idea this framework uses to argue autonomy alone is not the risk driver. |
| **Proposed action** | Cite CBRA as external corroboration in `core/risk-tiers.md` and/or `maturity-levels.md`. Do **not** replace the existing six-dimension model with CBRA's four; ours is more granular and already in use. This is a one-line reinforcement, not a re-architecture. |
| **Effort** | Low (citation). |

### 4. AICM as a standards-alignment target

| | |
|---|---|
| **What exists already** | `extensions/regulatory/` has crosswalks for ISO 27001, ISO 42001, EU AI Act, and NIST IR 8596. AICM is mentioned only once, in `maturity-levels.md`. It is absent from the README "Standards Alignment" table. |
| **Genuine gap** | No AICM crosswalk, and no entry in the standards table, despite AICM being the most directly comparable AI control framework in existence. Anyone evaluating this framework against AICM has to do the mapping themselves. |
| **Proposed action** | (a) Add an **AICM row to the README standards table**. (b) Optionally, a crosswalk page mapping AICM's 18 domains (especially **MDS**) to this framework's coverage, in the same style as the existing ISO/NIST crosswalks. This doubles as proof that the framework already covers AICM's AI-specific substance. (c) The **AI-CAIQ** questionnaire is a natural reference for `extensions/templates/vendor-assessment-questionnaire.md`. |
| **Effort** | Low for the table row, medium for the full crosswalk page. |

## Domain coverage at a glance

How AICM's 18 domains land against existing coverage. The point is that AICM adds **structure**, not uncovered AI risk.

| AICM domain | This framework |
|---|---|
| Model Security (MDS, the AI-specific domain) | Covered: foundations, `maso/controls/model-cognition-assurance.md`, supply-chain and provenance pages |
| Identity & Access Management | Covered and deeper: `maso/controls/identity-and-access.md`, `core/iam-governance.md`, NHI lifecycle |
| Supply Chain, Transparency & Accountability | Covered: `maso/controls/supply-chain.md`, infrastructure supply-chain, AIBOM |
| Logging & Monitoring | Covered: `maso/controls/observability.md`, runtime telemetry reference, flight recorder |
| Data Security & Privacy | Covered: `maso/controls/data-protection.md`, data provenance and authority boundaries |
| GRC | Covered: `strategy/`, risk tiers, governance gates |
| Incident Management, Threat & Vuln Mgmt | Covered: incident tracker, red-team playbook, risk register |
| Business Continuity & Resilience | Covered and distinctive: PACE resilience, circuit breaker |
| Remaining CCM domains (AIS, BCR, CCC, CEK, DCS, HRS, IPY, IVS, UEM, AAC) | Traditional cloud controls the framework deliberately defers to existing infrastructure, per the README scope statement |

## What to skip

- **The CCM-inherited domains.** Most of AICM's 243 controls are CCM cloud controls (cryptography, datacenter, endpoint, HR). The framework explicitly scopes these out as the job of existing infrastructure. Do not absorb them.
- **The certification and audit machinery.** STAR for AI, CAIQ-as-audit, and the assurance pathway are compliance products. The framework is explicit that it is **not a certification or audit standard** ("you cannot be compliant with this framework"). Referencing AI-CAIQ as a vendor-question source is fine; reframing the framework around certification is not.
- **Replacing existing models.** Risk tiers and MASO autonomy tiers are more granular than CBRA and already in use. Borrow CBRA's framing as corroboration, not as a replacement.

## Recommended next steps, in priority order

1. **Shared Responsibility for AI Systems** concept page (the real gap AICM exposes). Low to medium effort.
2. **Add AICM to the README standards table**, with a short note on the five-actor SSRM. Low effort.
3. **Cite CBRA** as external corroboration in `risk-tiers.md` / `maturity-levels.md`. Low effort.
4. **AICM crosswalk page** under `extensions/regulatory/`, mapping the 18 domains (lead with MDS) to existing coverage. Medium effort.
5. Opportunistically adopt the **AI-specific / hybrid / inherited** control tag when catalogues are next revised. Low effort, low priority.

Each item is independent and can be approved or dropped on its own. All site content will follow `CLAUDE.md`: front matter with `description`, references admonition box, relative internal links, SVG-only diagrams, no em dashes.

## Sources

- [AI Controls Matrix v1.1 (CSA)](https://cloudsecurityalliance.org/artifacts/ai-controls-matrix-v1-1)
- [Introducing the CSA AI Controls Matrix (CSA blog)](https://cloudsecurityalliance.org/blog/2025/07/10/introducing-the-csa-ai-controls-matrix-a-comprehensive-framework-for-trustworthy-ai)
- [Strategic Implementation of the CSA AI Controls Matrix (CSA blog)](https://cloudsecurityalliance.org/blog/2025/08/08/strategic-implementation-of-the-csa-ai-controls-matrix-a-ciso-s-guide-to-trustworthy-ai-governance)
- [Capabilities-Based Risk Assessment (CBRA) for AI Systems (CSA)](https://cloudsecurityalliance.org/artifacts/capabilities-based-risk-assessment-cbra-for-ai-systems)
- [Calibrating AI Controls to Real Risk: the CBRA (CSA blog)](https://cloudsecurityalliance.org/blog/2025/10/27/calibrating-ai-controls-to-real-risk-the-upcoming-capabilities-based-risk-assessment-cbra-for-ai-systems)
- [The CSA AI Controls Matrix: A Framework for Trustworthy AI (Tripwire)](https://www.tripwire.com/state-of-security/csa-ai-controls-matrix-framework-trustworthy-ai)
