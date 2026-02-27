# 100-Agent Stress Test: Framework Validation at Scale

**Does MASO hold when you go from 5 agents to 100?**

> Part of the [MASO Framework](../README.md) · Stress Testing
> Version 0.1 (Overview) · February 2026

---

## Why This Document Exists

The MASO framework's worked examples use 5-agent systems. The red team playbook tests individual control behaviours. Neither answers the question that enterprise architects actually ask:

**What happens when 100 agents, spanning 6 orchestration clusters, 4 model providers, and 3 trust boundaries, operate simultaneously under adversarial pressure?**

This stress test is designed to find out. It subjects the full MASO control stack to conditions that cannot emerge in small-scale deployments: cascading failures across orchestration boundaries, epistemic corruption that compounds through long agent chains, delegation graphs deep enough to launder authority, and observability systems that must process thousands of inter-agent messages per second.

The purpose is not to prove that MASO works. It is to find where MASO breaks — or where the cost of making it work becomes operationally prohibitive.

---

## Scenario: Global Investment Bank — Autonomous Trading Operations

### Why Financial Services

Financial services is the hardest test case for MASO because it combines every stress factor simultaneously:

- **Regulatory exposure** — MiFID II, SEC, FCA, DORA all impose explainability, audit, and resilience requirements
- **Latency sensitivity** — some decisions must complete in under 500ms; security controls that add 5 seconds are not viable
- **Data classification complexity** — Chinese walls, material non-public information (MNPI), client confidentiality, market data licensing
- **Consequence severity** — a wrong trade, a leaked position, or a corrupted recommendation has immediate financial and regulatory impact
- **Multi-jurisdiction operation** — agents in London, New York, Singapore, and Tokyo operating under different regulatory regimes simultaneously

### System Overview

The bank deploys 100 AI agents organised into 6 operational clusters, each with its own orchestrator, operating at MASO Tier 2 (Managed) with select Tier 3 (Autonomous) capabilities for pre-approved, time-critical functions.

---

## Agent Architecture: 6 Clusters, 100 Agents

### Cluster 1 — Market Intelligence (18 agents)

| Sub-Group | Agents | Role | Provider |
|-----------|--------|------|----------|
| Data Ingest | 6 | Real-time feeds: equities, FX, rates, commodities, credit, crypto | Provider A |
| News & Sentiment | 4 | Financial news, social media, regulatory filings, earnings calls | Provider B |
| Research Synthesis | 4 | Cross-asset analysis, trend identification, signal generation | Provider C |
| Macro Analysis | 2 | Economic indicators, central bank signals, geopolitical risk | Provider B |
| Data Quality | 2 | Cross-validate feeds, detect stale/anomalous data, flag conflicts | Provider A |

**Key risk:** This cluster is the epistemic root of the entire system. Every downstream decision depends on the integrity of market intelligence. A poisoned data feed or hallucinated trend propagates to all 5 other clusters.

### Cluster 2 — Trading Strategy (22 agents)

| Sub-Group | Agents | Role | Provider |
|-----------|--------|------|----------|
| Alpha Generation | 6 | Signal-based strategy proposals across asset classes | Provider C |
| Risk Modelling | 4 | VaR, stress testing, scenario analysis, tail risk | Provider A |
| Portfolio Optimisation | 4 | Position sizing, correlation management, rebalancing | Provider C |
| Execution Strategy | 4 | Order routing, timing, venue selection, slippage estimation | Provider A |
| Backtesting | 4 | Historical validation of proposed strategies | Provider B |

**Key risk:** Strategy agents make recommendations that directly translate to trades. The delegation chain from signal → strategy → sizing → execution is 4 agents deep — long enough for semantic drift (EP-05) and uncertainty stripping (EP-06) to transform a tentative signal into a firm order.

### Cluster 3 — Trade Execution (20 agents)

| Sub-Group | Agents | Role | Provider |
|-----------|--------|------|----------|
| Order Management | 4 | Order lifecycle: creation, amendment, cancellation | Provider A |
| Smart Routing | 4 | Venue selection, dark pool access, best execution | Provider A |
| Position Tracking | 4 | Real-time P&L, exposure tracking, limit monitoring | Provider B |
| Settlement | 4 | Trade matching, fails management, reconciliation | Provider B |
| Market Making | 4 | Automated quoting, spread management, inventory control | Provider A (on-prem, latency-critical) |

**Key risk:** This is the only cluster with direct write access to external systems (exchanges, counterparties). Blast radius is measured in currency. A single rogue order can move markets and trigger regulatory investigation.

### Cluster 4 — Risk & Compliance (16 agents)

| Sub-Group | Agents | Role | Provider |
|-----------|--------|------|----------|
| Pre-Trade Compliance | 4 | Regulatory checks before order submission (MiFID II, SEC) | Provider C |
| Position Limits | 2 | Real-time limit monitoring across all portfolios | Provider A |
| Chinese Wall Monitor | 2 | Information barrier enforcement, MNPI detection | Provider C |
| Regulatory Reporting | 4 | Transaction reporting, best execution reports, RTS 25/28 | Provider B |
| Conduct Surveillance | 4 | Market abuse detection, insider trading patterns, wash trading | Provider C |

**Key risk:** These agents are the Judge layer for trading operations. If they are compromised, bypassed, or simply overwhelmed by volume, every other cluster operates without regulatory guardrails. The Chinese Wall Monitor must track information flow across all 100 agents — every inter-agent message is a potential MNPI leak.

### Cluster 5 — Client Operations (14 agents)

| Sub-Group | Agents | Role | Provider |
|-----------|--------|------|----------|
| Client Reporting | 4 | Portfolio reports, performance attribution, risk summaries | Provider B |
| Client Queries | 4 | Natural language query handling, account inquiries | Provider C |
| Onboarding | 2 | KYC/AML document processing, suitability assessment | Provider B |
| Suitability | 4 | Match recommendations to client risk profiles and mandates | Provider C |

**Key risk:** Client-facing outputs cross the institutional boundary. Every report, recommendation, and response is a potential regulatory document. Data that is internal-only (trading signals, position data, risk models) must never leak into client-facing outputs.

### Cluster 6 — Infrastructure & Ops (10 agents)

| Sub-Group | Agents | Role | Provider |
|-----------|--------|------|----------|
| System Monitoring | 4 | Agent health, latency, throughput, error rates | Provider A |
| Incident Response | 2 | Automated PACE transitions, isolation, failover | Provider A (on-prem) |
| Capacity Management | 2 | Token budget tracking, model endpoint scaling, queue management | Provider A |
| Audit & Forensics | 2 | Decision chain recording, tamper-evident logging, trace reconstruction | Provider B |

**Key risk:** This cluster controls the control plane. The Incident Response agents execute PACE transitions — if they are compromised, the system cannot degrade safely. These agents must be architecturally isolated from all task clusters.

---

## What This Stress Test Is Designed to Find

The test targets 8 areas where scale changes the problem qualitatively, not just quantitatively.

### 1. Epistemic Cascade at Depth

In a 5-agent chain, a hallucinated claim passes through 4 agents. In a 100-agent system, a single corrupted market data point from Cluster 1 can propagate through Cluster 2 (strategy), Cluster 3 (execution), Cluster 4 (reporting), and Cluster 5 (client output) — touching 30+ agents before reaching an external boundary. Each handoff strips uncertainty and adds apparent corroboration.

**The question:** Do MASO's epistemic controls (PG-2.5 claim provenance, PG-2.7 uncertainty preservation, PG-2.4 consensus diversity gate) still function when the chain is 8–12 agents deep and spans 4 clusters?

### 2. Delegation Graph Explosion

With 100 agents, the potential delegation graph has ~10,000 edges. MASO control IA-2.3 (no transitive permissions) must be enforced on every edge. At 5 agents, this is 20 edges — manageable. At 100 agents, the enforcement overhead, the policy complexity, and the risk of misconfiguration all increase by orders of magnitude.

**The question:** Can the delegation contract model (Tier 3) scale to 100 agents without becoming either a performance bottleneck or a policy maintenance nightmare?

### 3. Cross-Cluster PACE Cascades

When Cluster 1 (Market Intelligence) enters PACE Alternate, what happens to the 82 agents in Clusters 2–6 that depend on its outputs? Do they all cascade to Alternate? Do some continue on stale data? Is there a coordinated degradation plan, or does each cluster manage independently?

**The question:** Does PACE's three-axis model (horizontal, vertical, orchestration) actually compose across cluster boundaries, or does it require a fourth axis — inter-cluster coordination — that the framework doesn't yet define?

### 4. Observability at Volume

100 agents producing inter-agent messages at operational tempo generate thousands of messages per second. The Observability domain (OB-2.1 anomaly scoring, OB-2.2 drift detection, OB-2.3 communication profiling) must process this volume in near-real-time. The Chinese Wall Monitor must inspect every message for MNPI content. The Audit & Forensics agents must record complete decision chains.

**The question:** What are the latency and compute costs of full MASO observability at 100-agent scale? At what point does the monitoring infrastructure become more expensive than the task infrastructure?

### 5. Provider Concentration Under Stress

The architecture uses 3 providers across 100 agents. Provider A serves 40 agents (including all execution and infrastructure agents). If Provider A experiences degradation (rate limiting, increased latency, outage), 40% of the system is simultaneously affected — including the agents responsible for PACE transitions.

**The question:** Does MASO's model diversity policy (PG-2.9) adequately address concentration risk when one provider underpins both task agents and control-plane agents?

### 6. Chinese Wall Enforcement at Scale

Information barriers in a 5-agent system require monitoring ~20 communication paths. In a 100-agent system, the Chinese Wall Monitor must enforce barriers across ~10,000 potential paths, with different rules per barrier (equity research vs. M&A advisory vs. proprietary trading). A single message that crosses a barrier is a regulatory violation.

**The question:** Is MASO's data protection model (DP-1.1 classification, DP-2.1 DLP on message bus) computationally viable when the number of classification rules scales quadratically with agent count?

### 7. Kill Switch Practicality

MASO Tier 3 requires a physically isolated kill switch (OB-3.2) that can terminate all agents. At 100 agents across 4 geographic regions, "terminate all agents" means coordinating shutdown across multiple data centres, resolving in-flight transactions, and ensuring no orphaned orders remain on exchanges.

**The question:** What is the realistic time-to-halt for a 100-agent system with in-flight financial transactions? Is the MASO requirement of "immediate termination" achievable, or does it need to be redefined as "controlled halt within N seconds"?

### 8. Adversarial Red Team at Scale

The red team playbook's 13 scenarios are designed for testing individual controls. At 100-agent scale, the attack surface includes combinations: a prompt injection (RT-01) that exploits a transitive permission chain (RT-02) to bypass a judge (RT-06) while evading anomaly detection (RT-10). The compound attack paths are exponentially more numerous.

**The question:** Does MASO's layered defence model (guardrails → judge → human → circuit breaker) hold against compound, multi-vector attacks that exploit the interaction between 100 agents?

---

## Proposed Deliverables

This overview is the starting point. The full stress test can be developed in the following independent sections, each useful on its own:

| # | Deliverable | What It Contains | Depends On |
|---|-------------|-----------------|------------|
| **A** | **Agent Roster & Trust Architecture** | Full 100-agent specification: NHI assignments, permission matrices, delegation contracts, provider mapping, geographic distribution | This overview |
| **B** | **Control Mapping at Scale** | Every MASO control evaluated for 100-agent viability: which scale linearly, which scale quadratically, which break. Includes compute/latency cost estimates | This overview |
| **C** | **Cross-Cluster PACE Scenarios** | 6 detailed failure scenarios showing cascading PACE transitions across clusters, with expected vs. actual degradation paths | A |
| **D** | **Compound Attack Scenarios** | 5 multi-vector red team scenarios designed for 100-agent scale, combining 2–3 existing RT playbook attacks into chain attacks | A, B |
| **E** | **Observability Stress Analysis** | Message volume modelling, monitoring infrastructure sizing, latency budget analysis, cost projections for full MASO observability at scale | A, B |
| **F** | **Framework Gap Analysis & Recommendations** | Where MASO needs extension for 100+ agent systems: new controls, modified requirements, architectural patterns not yet covered | B, C, D, E |

---

## Initial Hypotheses

Based on the framework analysis, these are the areas most likely to produce findings:

1. **PACE needs an inter-cluster coordination axis.** The current three-axis model (horizontal, vertical, orchestration) assumes a single orchestrator. Multi-cluster architectures need defined cascade behaviour between orchestrators.

2. **Observability costs will dominate at scale.** Full message-level DLP, anomaly scoring, and decision chain recording for 100 agents may cost more in compute than the agents themselves. The framework may need a risk-tiered observability model — not every message needs every check.

3. **Delegation contract overhead becomes a bottleneck.** Cryptographically signed delegation contracts for every inter-agent task assignment at Tier 3, across 100 agents operating at trading speed, may introduce unacceptable latency. The framework may need a "pre-approved delegation path" concept analogous to the Fast Lane for low-risk tasks.

4. **Chinese wall enforcement needs a different architecture.** Point-to-point message inspection doesn't scale quadratically. The framework may need to recommend network-level segmentation (separate message buses per information barrier) rather than message-level DLP for large-scale deployments.

5. **The kill switch needs a "controlled halt" specification.** Immediate termination of 100 agents with in-flight financial transactions is not safe. The framework needs a graduated shutdown protocol that resolves in-flight work before termination.

6. **Provider concentration creates single points of failure in the control plane.** If the same provider serves both task agents and PACE transition agents, a provider outage simultaneously disables the system and the system's ability to degrade safely.

---

## How to Read What Comes Next

Each deliverable (A–F) will follow the same structure:

- **Scenario specification** — exactly what is being tested, with enough detail to reproduce
- **MASO control mapping** — which controls apply, at which tier, with which configuration
- **Stress point analysis** — where the framework is expected to hold, bend, or break
- **Findings** — what actually happens (or what analysis predicts will happen)
- **Recommendations** — proposed framework extensions or modifications

The goal is not to weaken MASO. It is to strengthen it by finding the scale boundaries that 5-agent examples cannot reveal.

---

*AI Runtime Behaviour Security, 2026 (Jonathan Gill).*
