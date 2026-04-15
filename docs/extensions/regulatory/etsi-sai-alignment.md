---
description: "How ETSI's Securing Artificial Intelligence (SAI) and Experiential Networked Intelligence (ENI) standards affect the Multi-Agent Security Operations (MASO) framework: standard-by-standard alignment with gap analysis."
---

# ETSI Standards Impact on MASO

**How European AI security and multi-agent standards shape MASO controls, and where MASO already meets or exceeds their requirements.**

> *Part of [Regulatory Alignment](README.md) · Review date: March 2026*

## Why ETSI Matters for MASO

ETSI has two groups directly relevant to multi-agent AI security. **ETSI TC SAI** (Securing Artificial Intelligence), which transitioned from an Industry Specification Group to a full Technical Committee in December 2023, defines the threat landscape, mitigation strategies, baseline security requirements, and testing methods for AI systems. **ETSI ISG ENI** (Experiential Networked Intelligence) studies multi-agent architectures, collaboration patterns, and agent topology design. Together, they form the most comprehensive European standards body for the security of AI agent systems.

The TC SAI transition matters. As a Technical Committee, SAI can now produce European Standards (ENs) with normative force, directly supporting EU standardisation requests for the EU AI Act and the Cyber Resilience Act.

For organisations operating multi-agent systems under European regulation, ETSI standards sit alongside the EU AI Act as the technical implementation layer. The EU AI Act says *what* must be achieved. ETSI standards say *how* to demonstrate it. MASO provides the operational controls that satisfy both.

## ETSI SAI: The AI Security Standards

ETSI SAI has produced Group Reports (GRs) from its ISG era, plus Technical Specifications (TSs), Technical Reports (TRs), and one European Standard (EN) since becoming a Technical Committee. The table below maps each to its MASO relevance.

### Normative Standards and Technical Specifications

| Standard | Title | Published | MASO Relevance |
|----------|-------|-----------|----------------|
| **EN 304 223** | Baseline Cyber Security Requirements for AI | Dec 2025 | <span class="tier-critical">Critical</span> |
| **TS 104 223** | Baseline Cyber Security Requirements for AI | Apr 2025 | <span class="tier-critical">Critical</span> |
| TS 104 008 | Continuous Auditing-Based Conformity Assessment (CABCA) | 2026 | <span class="tier-critical">Critical</span> |
| TS 104 158 | AI Common Incident Expression (AICIE) Framework | Mar 2026 | High |
| TR 104 159 | Securing AI from Generative AI Harm | Jan 2026 | <span class="tier-critical">Critical</span> |
| TR 104 128 | Implementation Guide for EN 304 223 | May 2025 | High |
| TR 104 048 | Data Supply Chain Security (updated) | Jan 2025 | High |

### Group Reports (ISG Era)

| Standard | Title | Published | MASO Relevance |
|----------|-------|-----------|----------------|
| GR SAI 001 | AI Threat Ontology | Jan 2022 | High |
| GR SAI 002 | Data Supply Chain Security | Aug 2021 | High |
| GR SAI 004 | Problem Statement on AI Threats | Dec 2020 | Medium |
| GR SAI 005 | Mitigation Strategy Report | Mar 2021 | High |
| GR SAI 006 | Role of Hardware in AI Security | Mar 2022 | Low |
| GR SAI 007 | Explicability and Transparency of AI | Mar 2023 | High |
| GR SAI 008 | Privacy Aspects of AI/ML Systems | 2023 | High |
| GR SAI 009 | AI Computing Platform Security Framework | Feb 2023 | Medium |
| GR SAI 010 | Traceability of AI Models | 2023 | High |

### EN 304 223 / TS 104 223: Baseline Cyber Security Requirements for AI

!!! abstract "The Cornerstone Standard"
    EN 304 223 is the world's first normative European Standard for AI cybersecurity. It carries legal weight within the EU standards ecosystem and is the standard most likely to be referenced in EU AI Act conformity assessments.

**Scope:** Defines 13 core principles expanding to 72 trackable principles across five AI lifecycle phases. Addresses data poisoning, model obfuscation, indirect prompt injection, and supply chain vulnerabilities. Defines three stakeholder roles: Developers, System Operators, and Data Custodians. Requires documented audit trails, clear role definitions, supply chain transparency, and least-privilege access controls.

**MASO alignment:**

| EN 304 223 Principle Area | MASO Control Domain | Coverage |
|---------------------------|---------------------|----------|
| Indirect prompt injection mitigation | Prompt, Goal & Epistemic Integrity (Domain 0) | Cross-agent input sanitisation, system prompt isolation |
| Least-privilege access controls | Identity & Access (Domain 1) | Per-agent NHI, scoped credentials, no inherited permissions |
| Audit trails | Observability (Domain 4) | Flight Recorder, immutable decision chain logs |
| Role definitions (Developer, Operator, Custodian) | Privileged Agent Governance (Domain 6) | Mandatory approval gates, delegation limits |
| Supply chain transparency | Supply Chain (Domain 5) | AIBOM, model provenance, signed manifests |
| Data integrity across lifecycle | Data Protection (Domain 2) | RAG integrity, cross-agent data fencing, DLP |

**Assessment:** EN 304 223 touches nearly every MASO control domain through its 72 principles. The standard was designed for AI systems generally, not multi-agent systems specifically. MASO's contribution is applying these principles at each agent boundary, across inter-agent communication, and through the orchestration layer. Organisations that implement MASO at Tier 2 or above will satisfy the majority of EN 304 223 requirements.

### TS 104 008: Continuous Auditing-Based Conformity Assessment (CABCA)

**Scope:** Provides a framework for continuous, automated conformity assessment of dynamic AI systems. Assessment runs in cycles triggered by schedules or events (model updates, data drift, performance anomalies). Translates regulatory requirements into measurable, machine-readable metrics. Aligned with EU AI Act post-market monitoring obligations.

**MASO alignment:**

| CABCA Concept | MASO Equivalent | Notes |
|---------------|-----------------|-------|
| Event-triggered assessment cycles | PACE escalation model | Both respond dynamically to system state changes |
| Machine-readable compliance metrics | OISpec contracts (Domain 7) | Both translate high-level requirements into measurable criteria |
| Continuous monitoring | Observability (Domain 4) | Flight Recorder, behavioural drift detection |
| Post-market surveillance | Tier progression model | MASO tiers define ongoing monitoring requirements that increase with autonomy |

**Assessment:** CABCA is essential for multi-agent systems because agents evolve independently. Point-in-time audits cannot capture the dynamic risk profile of a system where agents are updated, retrained, or adapted between assessments. MASO's Observability controls and PACE model provide the runtime infrastructure that CABCA's continuous assessment requires.

### TS 104 158: AI Common Incident Expression (AICIE)

**Scope:** Defines a global framework for AI incident reporting (Part 1) with an information container based on the OECD reporting model (Part 2). Standardises how AI incidents are described, categorised, and shared.

**MASO alignment:**

| AICIE Component | MASO Equivalent | Coverage |
|-----------------|-----------------|----------|
| Incident classification taxonomy | [Incident Tracker](../../maso/threat-intelligence/incident-tracker.md) | MASO tracks multi-agent incidents with root cause analysis |
| Standardised reporting format | Flight Recorder exports | Immutable logs capture full decision chains for incident reconstruction |
| Cross-organisation incident sharing | Observability (Domain 4) | SIEM/SOAR integration enables correlation with broader security operations |

**Assessment:** AICIE provides the reporting format. MASO provides the data. The Flight Recorder's immutable logs contain exactly the evidence that AICIE-format reports need: agent actions, Judge verdicts, tool invocations, inter-agent messages, and PACE state transitions.

### GR SAI 007: Explicability and Transparency

**Scope:** Defines explicability ("property of an action to be accounted for or understood") and transparency ("property of an action to be open to inspection with no hidden properties"). Identifies steps for designers and implementers to ensure both static and dynamic forms of explicability.

**MASO alignment:** Directly supports Observability (Domain 4) and Objective Intent (Domain 7). In multi-agent systems, the ability to explain and inspect each agent's decision-making process is critical for audit, debugging, and governance. The OISpec contract makes agent intent explicit and verifiable, satisfying SAI 007's transparency requirements. The Flight Recorder provides the dynamic explicability layer by capturing full reasoning chains.

### GR SAI 001: AI Threat Ontology

**Scope:** Catalogues threats to AI systems across the lifecycle, including data poisoning, model evasion, model inversion, and supply chain compromise.

**MASO alignment:**

| SAI 001 Threat Category | MASO Control Domain | MASO Coverage |
|--------------------------|---------------------|---------------|
| Data poisoning | Data Protection (Domain 2) | Memory poisoning detection, RAG integrity validation |
| Model evasion / adversarial inputs | Prompt, Goal & Epistemic Integrity (Domain 0) | Input sanitisation, epistemic controls |
| Model inversion / extraction | Execution Control (Domain 3) | Sandboxed execution, tool parameter allow-lists |
| Supply chain compromise | Supply Chain (Domain 5) | AIBOM, model provenance, MCP server vetting |
| Deployment environment attacks | Environment Containment (cross-cutting) | API hardening, opaque error responses |

**Assessment:** MASO's [Emergent Risk Register](../../maso/controls/risk-register.md) extends SAI 001's ontology with nine epistemic risks (EP-01 through EP-09) that have no equivalent in the ETSI taxonomy, including hallucination amplification, groupthink propagation, and uncertainty stripping across agent chains. SAI 001 was written for single-model systems. MASO fills the multi-agent gap.

### GR SAI 002: Data Supply Chain Security

**Scope:** Addresses risks in the data supply chain for AI, including training data integrity, data provenance, and third-party data sources.

**MASO alignment:**

| SAI 002 Requirement | MASO Control | Implementation |
|---------------------|-------------|----------------|
| Data provenance tracking | Supply Chain (Domain 5) | AIBOM generation, model provenance tracking |
| Training data integrity | Data Protection (Domain 2) | RAG integrity validation, cross-agent data fencing |
| Third-party data source vetting | Supply Chain (Domain 5) | A2A trust chain validation, signed manifests |
| Continuous data monitoring | Observability (Domain 4) | Behavioural drift detection, anomaly scoring |

**Assessment:** Strong alignment. SAI 002 focuses on training-time data risks. MASO extends this into runtime, where agents consume, transform, and pass data between themselves. The [Data Protection](../../maso/controls/data-protection.md) controls cover inter-agent data classification and DLP scanning on the message bus, which SAI 002 does not address.

### GR SAI 005: Mitigation Strategy Report

**Scope:** Provides a mitigation framework for AI security threats, organised by attack surface and lifecycle phase.

**MASO alignment:**

| SAI 005 Mitigation Area | MASO Equivalent | Notes |
|--------------------------|-----------------|-------|
| Input validation and sanitisation | Guardrails (Layer 1) | MASO applies this at every agent boundary, not just user-facing |
| Model hardening | Not in scope | MASO is a deployer framework; model training is upstream |
| Output filtering | Judge evaluation (Layer 2) | Model-as-Judge with measurable criteria |
| Human oversight | HITL (Layer 3) | PACE escalation model scales oversight to risk |
| Monitoring and logging | Observability (Domain 4) | Flight Recorder, immutable decision chain logs |
| Incident response | Environment Containment | Kill switches external to agent orchestration |

**Assessment:** SAI 005 is the closest ETSI standard to MASO's three-layer defence model. The key difference: SAI 005 treats mitigations as a flat list. MASO arranges them into layers (guardrails, Judge, human) and tiers (Supervised, Managed, Autonomous) that scale controls to demonstrated trustworthiness.

### GR SAI 008: Privacy Aspects of AI/ML Systems

**Scope:** Covers privacy-specific remedies, pre-emptive and reactive responses to adversarial activity targeting AI privacy. Addresses privacy attacks including model inversion, membership inference, and attribute inference.

**MASO alignment:**

| SAI 008 Requirement | MASO Control Domain | Coverage |
|---------------------|---------------------|----------|
| Privacy attack mitigation | Data Protection (Domain 2) | Cross-agent data fencing, output DLP scanning |
| Model access control | Identity & Access (Domain 1) | Per-agent NHI, scoped credentials, zero-trust |
| Data leakage prevention | Data Protection (Domain 2) | Message bus DLP, classification-level enforcement |
| Privacy monitoring | Observability (Domain 4) | Behavioural drift detection against baselines |

**Assessment:** SAI 008 does not address the multi-agent dimension where one agent could attempt to extract private information from another agent's context through inter-agent messaging. MASO's [Secure Inter-Agent Message Bus](../../maso/README.md) with signed, rate-limited communication and cross-agent data fencing addresses this gap.

### GR SAI 009: AI Computing Platform Security Framework

**Scope:** Describes a security framework for AI computing platforms, covering protection of models and data at runtime and at rest through platform-level security components and mechanisms.

**MASO alignment:** Maps to Execution Control (Domain 3) and Environment Containment. SAI 009 defines the platform security baseline that multi-agent orchestration environments must implement, including resource isolation, secure storage, and runtime protection. MASO's sandboxed execution, tool parameter allow-lists, and blast radius caps operate on top of these platform-level controls.

### GR SAI 010: Traceability of AI Models

**Scope:** Addresses model transferability (re-use across tasks and industries) and watermarking for traceability of AI models.

**MASO alignment:**

| SAI 010 Concept | MASO Equivalent | Tier Applicability |
|---------------------|-----------------|--------------------|
| Model provenance tracking | Supply Chain (Domain 5), AIBOM | All tiers |
| Model watermarking | Supply Chain (Domain 5), signed manifests | Tier 2+ |
| Transferability documentation | Observability (Domain 4), Flight Recorder | Tier 2+ |
| Traceability chain | Supply Chain (Domain 5), A2A trust chain validation | All tiers |

**Assessment:** SAI 010 provides a model-level traceability framework. MASO extends this into the multi-agent context where models are deployed across agent boundaries, and where the provenance chain must be verified not just for each model but for the agent system as a whole.

### TR 104 159: Securing AI from Generative AI Harm

**Scope:** Domain-specific application of EN 304 223 principles to generative AI. Covers deepfakes, misinformation, confidentiality risks, copyright/IPR concerns, hallucinations, and malicious code generation. Critically, this document explicitly states that threats and mitigations for generative AI are also relevant to **agentic AI**, which it describes as "an evolution of GenAI."

**MASO alignment:**

| TR 104 159 Risk | MASO Control | Domain |
|-----------------|-------------|--------|
| Prompt injection | Input sanitisation, system prompt isolation | Domain 0 |
| Hallucination | Epistemic controls, Judge evaluation | Domain 0 |
| Data leakage | Output DLP, cross-agent data fencing | Domain 2 |
| Jailbreaking | Guardrails (Layer 1), immutable task specs | Domain 0 |
| Insecure plugin/tool use | Tool parameter allow-lists, sandboxed execution | Domain 3 |
| Excessive agency | PACE escalation, blast radius caps | Domain 3 |
| Training data poisoning | RAG integrity validation | Domain 2 |

**Assessment:** This is the ETSI standard with the strongest overlap to MASO's scope. TR 104 159 addresses single-LLM risks that MASO amplifies into the multi-agent context. Where TR 104 159 warns about prompt injection on one model, MASO addresses prompt injection propagation across agent chains. Where TR 104 159 flags hallucination, MASO addresses hallucination amplification when multiple agents build on each other's outputs without independent verification.

## ETSI ENI: Multi-Agent Architecture Standards

ETSI's Experiential Networked Intelligence group has produced the only formal standards work on multi-agent system architecture. While ENI focuses on telecommunications networks, its architectural patterns and security considerations apply broadly to any multi-agent deployment.

### GR ENI 056: Study on Multi-Agent Systems (2025)

**Scope:** Studies multi-agent system architectures, covering agent topologies, conversation patterns, workflow orchestration, and closed-loop optimisation. Reviews existing open-source frameworks (LangGraph, AutoGen, CrewAI) and recommends architectural design principles.

This is the most directly relevant ETSI standard for MASO.

| ENI 056 Topic | MASO Equivalent | Alignment |
|---------------|-----------------|-----------|
| Agent topologies (hierarchical, flat, hybrid) | MASO tier architecture (Supervised, Managed, Autonomous) | **Complementary**: ENI 056 describes topology patterns; MASO prescribes security controls per topology |
| Agent-to-agent communication | Secure Inter-Agent Message Bus | **MASO extends**: ENI 056 describes communication models; MASO requires signed, rate-limited, validated messaging |
| Workflow orchestration | Execution Control (Domain 3), Privileged Agent Governance (Domain 6) | **MASO extends**: MASO adds security governance for orchestrators with elevated authority |
| Closed-loop optimisation | PACE resilience model | **Complementary**: ENI 056 optimises for performance; MASO optimises for safe degradation |
| Agent collaboration mechanisms | Objective Intent (Domain 7), OISpec contracts | **MASO extends**: ENI 056 describes how agents collaborate; MASO ensures they collaborate within declared intent boundaries |

**Assessment:** ENI 056 provides the architectural vocabulary. MASO provides the security controls. Organisations should use ENI 056 to inform their multi-agent architecture design and MASO to secure it. The two standards do not conflict, and ENI 056 explicitly acknowledges that security and trust mechanisms are needed but outside its scope.

### GR ENI 051: AI Agents for Network Slicing (2025)

**Scope:** Studies how AI agents can manage next-generation network slicing, including resource allocation, SLA enforcement, and autonomous network management.

| ENI 051 Concept | MASO Parallel | Notes |
|-----------------|---------------|-------|
| Autonomous resource allocation | Tier 3 (Autonomous) controls | Both address agents with authority to allocate resources without human approval |
| SLA enforcement by agents | OISpec as intent contract | Both define structured specifications that constrain agent behaviour |
| Agent delegation patterns | Privileged Agent Governance (Domain 6) | MASO applies mandatory approval gates and delegation limits |

**Assessment:** Domain-specific to telecoms, but the patterns are transferable. Any organisation deploying autonomous agents that allocate resources (cloud compute, API quotas, budget) faces the same governance challenges ENI 051 identifies for network slicing.

### GR ENI 055: AI-Core Network Architecture (2025)

**Scope:** Proposes use cases for AI-agent-based core network architecture, covering B2C, B2B, and internal operator scenarios.

**MASO relevance:** Lower direct relevance. The use cases are telecoms-specific, but the architectural principle of rebuilding core infrastructure around collaborating agents validates MASO's premise that multi-agent security requires a dedicated control framework, not just extensions to single-model controls.

## Gap Analysis: What ETSI Requires That MASO Addresses

| Gap in ETSI Standards | MASO Coverage |
|-----------------------|---------------|
| Multi-agent prompt injection propagation | Domain 0: cross-agent input sanitisation, system prompt isolation |
| Epistemic risks (groupthink, uncertainty stripping) | Domain 0: nine epistemic risks (EP-01 to EP-09) |
| Transitive privilege escalation | Domain 1: no inherited permissions, Domain 6: delegation limits |
| Inter-agent data leakage | Domain 2: cross-agent data fencing, message bus DLP |
| Orchestrator compromise | Domain 6: mandatory human approval gates, independent monitoring |
| Cascading failure across agent chains | PACE resilience model: Primary, Alternate, Contingency, Emergency |
| Agent identity and authentication | Domain 1: per-agent NHI, zero-trust mutual authentication |
| Runtime behavioural assurance | Domain 7: OISpec contracts, tactical and strategic evaluation |

## Gap Analysis: What ETSI Covers That MASO Does Not

| ETSI Coverage | MASO Position | Recommendation |
|---------------|---------------|----------------|
| EN 304 223 Developer role requirements | Partial | MASO is deployer-focused. Developer-side controls (model training, development security) are upstream. Reference EN 304 223 Developer obligations in vendor assessments. |
| Hardware-level AI security (SAI 006) | Out of scope | Correct scoping. MASO is a deployer framework. Hardware security is infrastructure. |
| AI model training security | Out of scope | Correct scoping. MASO secures deployed agents, not the training pipeline. |
| AI for cybersecurity operations | Out of scope | Correct scoping. MASO secures AI, not AI-for-security. |
| Telecoms-specific agent topology (ENI 055) | Not addressed | No action needed. Domain-specific applications do not require framework changes. |
| Deepfake detection (SAI 011, TR 104 159) | Partial | Relevant when agents process multimedia inputs. Addressed through Guardrails (Layer 1) input validation. |
| CABCA conformance testing (TS 104 216) | Not formalised | MASO's observability controls produce the data CABCA needs, but no formal CABCA test suite mapping exists yet. |

## Compliance Mapping Summary

For organisations needing to demonstrate ETSI alignment, the following table maps each MASO control domain to the ETSI standards it satisfies.

| MASO Control Domain | ETSI Standards Addressed | Primary Evidence |
|---------------------|--------------------------|------------------|
| 0. Prompt, Goal & Epistemic Integrity | EN 304 223, SAI 001, SAI 005, TR 104 159 | Input sanitisation logs, epistemic monitoring alerts, goal integrity reports |
| 1. Identity & Access | EN 304 223, SAI 008, ENI 056 | NHI registry, credential rotation logs, authentication audit trail |
| 2. Data Protection | EN 304 223, SAI 002, TR 104 048, SAI 008, TR 104 159 | DLP scan results, data classification tags, RAG integrity checks |
| 3. Execution Control | EN 304 223, SAI 001, SAI 005, SAI 009, TR 104 159 | Sandbox configurations, tool allow-lists, blast radius cap settings |
| 4. Observability | EN 304 223, SAI 005, SAI 007, SAI 010, TS 104 008, TS 104 158 | Flight Recorder exports, drift detection baselines, SIEM integration, AICIE reports |
| 5. Supply Chain | EN 304 223, SAI 002, TR 104 048, SAI 010 | AIBOM records, signed manifests, A2A trust chain validations |
| 6. Privileged Agent Governance | EN 304 223, TS 104 008, ENI 056, ENI 051 | Approval gate logs, delegation limit configurations, independent monitor reports |
| 7. Objective Intent | TS 104 008, SAI 007, ENI 056 | OISpec version history, tactical/strategic evaluation results |
| Environment Containment | EN 304 223, SAI 001, SAI 005, SAI 009, TR 104 159 | API hardening configs, kill switch test results, WAF/DLP rules |

## Practical Implications by MASO Tier

### Tier 1 (Supervised)

ETSI alignment is straightforward at this tier. Human-in-the-loop oversight satisfies most EN 304 223 and SAI 005 mitigation requirements without additional tooling. The main ETSI-driven additions:

- Document agent threat model against SAI 001 ontology
- Map roles to EN 304 223 stakeholder definitions (Developer, Operator, Data Custodian)
- Log all agent actions per EN 304 223 audit trail requirements
- Apply TR 104 159 prompt injection mitigations even for supervised agents

### Tier 2 (Managed)

ETSI requirements start to bite at this tier. Automated controls must compensate for reduced human oversight:

- Implement EN 304 223 least-privilege principles at every agent boundary
- Apply TR 104 048 data provenance controls to all inter-agent data flows
- Use ENI 056 topology patterns to validate your multi-agent architecture design
- Begin CABCA-aligned continuous assessment rather than point-in-time audits
- Adopt AICIE (TS 104 158) incident reporting format for multi-agent incidents

### Tier 3 (Autonomous)

Full ETSI alignment becomes essential. Autonomous agents operating without human approval need demonstrable compliance:

- Full EN 304 223 conformity across all 72 trackable principles
- Full SAI 001 threat ontology mapping in the risk register
- CABCA continuous assessment at runtime, event-triggered on model updates and drift
- ENI 056 architecture validation for all agent topologies
- TR 104 159 mitigations enforced at every agent boundary, including inter-agent
- SAI 007 explicability requirements met through OISpec contracts and Flight Recorder
- AICIE-format incident reporting integrated with SIEM/SOAR

!!! info "References"
    - [ETSI TC SAI: Securing Artificial Intelligence](https://www.etsi.org/committee/technical-committee-tc-securing-artificial-intelligence-sai)
    - [ETSI EN 304 223: Baseline Cyber Security Requirements for AI](https://www.etsi.org/deliver/etsi_en/304200_304299/304223/02.01.01_60/en_304223v020101p.pdf)
    - [ETSI TS 104 223: Baseline Cyber Security Requirements for AI](https://www.etsi.org/deliver/etsi_ts/104200_104299/104223/01.01.01_60/ts_104223v010101p.pdf)
    - [ETSI TR 104 128: Implementation Guide for EN 304 223](https://www.etsi.org/deliver/etsi_tr/104100_104199/104128/01.01.01_60/tr_104128v010101p.pdf)
    - [ETSI TR 104 159: Securing AI from Generative AI Harm](https://www.etsi.org/deliver/etsi_tr/104100_104199/104159/01.01.01_60/tr_104159v010101p.pdf)
    - [ETSI TS 104 158: AI Common Incident Expression (AICIE)](https://www.etsi.org/deliver/etsi_ts/104100_104199/10415801/01.01.01_60/ts_10415801v010101p.pdf)
    - [ETSI GR SAI 001: AI Threat Ontology](https://www.etsi.org/deliver/etsi_gr/SAI/001_099/001/01.01.01_60/gr_SAI001v010101p.pdf)
    - [ETSI GR SAI 005: Mitigation Strategy Report](https://www.etsi.org/deliver/etsi_gr/SAI/001_099/005/01.01.01_60/gr_SAI005v010101p.pdf)
    - [ETSI GR SAI 007: Explicability and Transparency](https://www.etsi.org/deliver/etsi_gr/SAI/001_099/007/01.01.01_60/gr_SAI007v010101p.pdf)
    - [ETSI GR ENI 056: Study on Multi-Agent Systems](https://www.etsi.org/deliver/etsi_gr/ENI/001_099/056/04.01.01_60/gr_ENI056v040101p.pdf)
    - [ETSI ENI: Experiential Networked Intelligence](https://www.etsi.org/technologies/experiential-networked-intelligence)
    - [NCSC: New ETSI Standard Protects AI Systems](https://www.ncsc.gov.uk/blog-post/new-etsi-standard-protects-ai-systems-from-evolving-cyber-threats)
    - [MASO Framework](../../maso/README.md)
