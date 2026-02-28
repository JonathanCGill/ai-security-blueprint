---
title: AI Runtime Behaviour Security
description: A practitioner's reference for runtime AI security. Guardrails, LLM-as-Judge, human oversight, and PACE resilience — from single-model deployments to autonomous multi-agent orchestration. Take what's useful, adapt it, ignore what doesn't fit.
hide:
  - toc
  - path
---

# AI Runtime Behaviour Security

A practitioner's reference for runtime AI security. Take what's useful, adapt it, ignore what doesn't fit.

AI systems break quietly. The failures that matter most — hallucinated data, leaked context, unauthorised actions — appear to be normal responses. Your testing can't catch them all. **This reference gives you the runtime controls that do.**

For architects, security leaders, and risk owners of AI-driven systems. Single-agent and multi-agent. Because silent failures are already happening in production.

[See the Architecture](ARCHITECTURE.md){ .md-button .md-button--primary }
[Quick Start Guide](QUICK_START.md){ .md-button }

**Executives** — [2-minute overview](CHEATSHEET.md)<br>
**Architects** — [Control architecture](ARCHITECTURE.md)<br>
**Practitioners** — [Quick start guide](QUICK_START.md)

---

## Built on Best Practices and Real World Incidents

173 controls across single-agent and multi-agent systems. 10 real-world AI incidents mapped to specific controls. Aligned with OWASP LLM Top 10, OWASP Agentic Top 10, NIST AI RMF, ISO 42001, EU AI Act, and DORA. MIT licensed. One practitioner's synthesis of what actually works — not a standard, not a product pitch, not a slide deck.

---

## What You Get

- **Classify risk and right-size controls** — not every AI system needs the same governance. Tier your deployments from [fast-lane self-certification](FAST-LANE.md) to full human-in-the-loop oversight.
- **Controls that work at runtime** — [guardrails](ARCHITECTURE.md#single-agent-architecture) for known threats, LLM-as-Judge for unknown threats, human oversight for edge cases, circuit breakers for when everything else fails.
- **Resilience when controls fail** — every control has a defined failure mode and a predetermined safe state. [PACE methodology](PACE-RESILIENCE.md): Primary, Alternate, Contingency, Emergency.

Use the parts that fit your environment. Skip the parts that don't. If your existing tools already satisfy a control, you don't need new ones.

---

## Navigate

| I want to... | Go to |
| --- | --- |
| **See how the layers work** | [Architecture Overview](ARCHITECTURE.md) — single-agent and multi-agent patterns |
| **Secure a single-model AI system** | [Foundation Controls](foundations/) — 80 controls, risk tiers, PACE resilience |
| **Secure a multi-agent system** | [Multi-Agent Controls (MASO)](maso/) — 93 controls, 6 domains, 3 tiers |
| **Deploy low-risk AI fast** | [Fast Lane](FAST-LANE.md) — self-certification for internal, read-only, no regulated data |
| **Classify a system by risk** | [Risk Tiers](core/risk-tiers.md) — six-dimension scored profile |
| **Map to compliance requirements** | [Compliance & Legal](stakeholders/compliance-and-legal.md) — ISO 42001, EU AI Act, DORA |

??? question "Common questions — cost, Judge reliability, supply chain, human factors"

    | I'm asking about... | Start here |
    | --- | --- |
    | What these controls cost and how to manage latency | [Cost & Latency](extensions/technical/cost-and-latency.md) — sampling strategies, latency budgets, tiered evaluation cascade |
    | What happens when the Judge is wrong | [Judge Assurance](core/judge-assurance.md) — accuracy metrics, calibration, adversarial testing, fail-safe mechanisms |
    | How the Judge can be attacked | [When the Judge Can Be Fooled](core/when-the-judge-can-be-fooled.md) — output crafting, judge manipulation, mitigations by tier |
    | Securing the AI supply chain | [Supply Chain Controls](maso/controls/supply-chain.md) — AIBOM, signed manifests, MCP vetting, model provenance |
    | Human operator fatigue and automation bias | [Human Factors](strategy/human-factors.md) — skill development, alert fatigue, challenge rate testing |
    | Risks that emerge when agents collaborate | [Emergent Risk Register](maso/controls/risk-register.md) — 33 risks across 9 categories, with coverage assessment |

??? example "More paths — strategy, red teaming, worked examples, full reference"

    | I want to... | Start here |
    | --- | --- |
    | Get the one-page reference | [Cheat Sheet](CHEATSHEET.md) — classify, control, fail posture, test |
    | Quantify AI risk for board reporting | [Risk Assessment](core/risk-assessment.md) |
    | Align AI with business strategy | [From Strategy to Production](strategy/) |
    | See everything on one map | [Tube Map](TUBE-MAP.md) |
    | Understand PACE resilience | [PACE Methodology](PACE-RESILIENCE.md) |
    | Run adversarial tests on agents | [Red Team Playbook](maso/red-team/red-team-playbook.md) |
    | Implement in LangGraph, AutoGen, CrewAI, or Bedrock | [Integration Guide](maso/integration/integration-guide.md) |
    | See one transaction end-to-end with every log event | [Runtime Telemetry Reference](extensions/technical/runtime-telemetry-reference.md) |
    | Enforce controls at infrastructure level | [Infrastructure Controls](infrastructure/) |
    | See real incidents mapped to controls | [Incident Tracker](maso/threat-intelligence/incident-tracker.md) |
    | See MASO applied in finance, healthcare, or energy | [Worked Examples](maso/examples/worked-examples.md) |
    | Navigate by role | [Framework Map](FRAMEWORK-MAP.md) |
    | Understand what's validated and what's not | [Maturity & Validation](MATURITY.md) |
    | See all references and further reading | [References & Sources](REFERENCES.md) |

---

## See Inside

> *Your AI system returns a confident, well-formatted answer. It's wrong. Your guardrail didn't catch it — it looked normal. Your test suite didn't cover it — the input was novel. Now what?*

That's the problem this reference addresses. The [Architecture Overview](ARCHITECTURE.md) shows the four-layer pattern. The [Quick Start](QUICK_START.md) gets you from zero to working controls. The [Incident Tracker](maso/threat-intelligence/incident-tracker.md) shows where real systems failed — and which controls would have caught it.

---

## Standards Alignment

OWASP LLM Top 10 · OWASP Agentic Top 10 · NIST AI RMF · ISO 42001 · NIST SP 800-218A · MITRE ATLAS · EU AI Act · DORA

→ [Full standards mapping](infrastructure/mappings/controls-to-three-layers.md)

---

## How to Use This

??? abstract "What it provides, what it doesn't, and how to approach it"

    This is a practitioner's reference — not a standard, not a certification, not a product pitch. Take what's useful, adapt it to your environment, ignore what doesn't fit.

    **What it provides:**

    - **A way of thinking about controls, not a prescription for them.** It describes *what* needs to be true and *why* it matters. It does not mandate a specific product, vendor, or architecture. If your existing tools already satisfy a control, you don't need new ones.
    - **Help deciding where to invest.** Not every control matters equally. Risk tiers, PACE resilience levels, and the distinction between foundation and multi-agent controls exist so you can reason about priority.
    - **Defence in depth as a design principle.** The layered approach exists because each layer covers gaps in the others. The question isn't "which layer do we need?" but "what happens when each layer fails?"
    - **Resilience thinking for AI products.** Traditional security asks "how do we prevent bad things?" This reference also asks "what happens when prevention fails?"
    - **Clarity on when tools are *not* needed.** Some controls are already handled by your existing infrastructure. This should help you see where you already have coverage, not convince you to buy something new.
    - **An AI-specific layer, not a replacement for everything else.** This addresses the controls unique to non-deterministic AI behaviour. It does not replace your existing DLP, API validation, database access controls, IAM, SIEM, secure coding practices, or incident response capabilities. Those controls still matter — arguably more than ever, because they are your safety net when AI-specific controls miss something.

    **What it is not:**

    - Not a certification or audit standard. You cannot be "compliant with" this reference.
    - Not a product recommendation. Tool and vendor references are illustrative, not endorsements.
    - Not a substitute for professional security assessment of your specific deployment.
    - Not a finished document. AI security is moving fast. This will evolve as the landscape does.

---

## Repository Structure

??? info "Repository structure"

    ```
    ├── README.md                          # This document — start here
    ├── TUBE-MAP.md                        # Complete framework tube map with guide
    ├── foundations/
    │   └── README.md                      # Single-model AI security framework
    ├── maso/
    │   ├── README.md                      # Multi-Agent Security Operations
    │   ├── controls/                      # 6 domain specifications + risk register
    │   ├── implementation/                # 3 tier guides (supervised, managed, autonomous)
    │   ├── threat-intelligence/           # Incident tracker + emerging threats
    │   ├── red-team/                      # Adversarial test playbook (13 scenarios)
    │   ├── integration/                   # LangGraph, AutoGen, CrewAI, AWS Bedrock patterns
    │   └── examples/                      # Financial services, healthcare, critical infrastructure
    ├── stakeholders/                      # Role-based entry points (security, risk, architecture, product, engineering, compliance)
    ├── images/                            # All SVGs (tube map, architecture, OWASP coverage, stakeholder map)
    ├── core/                              # Risk tiers, controls, IAM governance, checklists
    ├── infrastructure/                    # 80 technical controls, 11 domains
    ├── extensions/                        # Regulatory, templates, worked examples
    ├── insights/                          # Analysis articles and emerging challenges
    └── strategy/                          # AI strategy — alignment, data, human factors, progression
    ```

---

## About the Author

**Jonathan Gill** is a cybersecurity practitioner with over 30 years in information technology and 20+ years in enterprise cybersecurity. His career spans UNIX system administration, building national-scale ISP infrastructure, enterprise security architecture at major financial institutions, and diplomatic IT service.

His current focus is AI security governance: designing control architectures that address the unique challenges of securing non-deterministic systems at enterprise scale, and translating complex technical risk into actionable guidance for engineering teams and executive leadership.

- GitHub: [@JonathanCGill](https://github.com/JonathanCGill)
- LinkedIn: [Jonathan Gill](https://www.linkedin.com/in/jonathancgill/)

---

## Disclaimer

This reference is provided as-is under the [MIT License](../LICENSE). As described in [How to Use This](#how-to-use-this), it is a thinking tool — not a standard, certification, or guarantee of security. It reflects one practitioner's synthesis of industry patterns, regulatory requirements, and operational experience.

If you adopt any part of this, you are responsible for validating it against your own threat model, environment, and regulatory obligations.

This framework was written with AI assistance (Claude and ChatGPT) for drafting, structuring, and research synthesis. Architecture, control design, risk analysis, and editorial judgment are the author's.

This is a personal project. It is not affiliated with, endorsed by, or representative of any employer, organisation, or other entity. The views and opinions expressed are the author's own and should not be construed as reflecting the position or policy of any company or institution with which the author is or has been associated.

---

*AI Runtime Behaviour Security, 2026 (Jonathan Gill).*
