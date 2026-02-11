# Framework Map

Navigate the framework like a transit system. Each line represents a reading path. Interchanges show where topics connect.

[![Enterprise AI Security Framework — Tube Map](images/ai-security-tube-map.svg)](images/ai-security-tube-map.svg)

---

## Lines

| Line | Theme | Stations |
|------|-------|----------|
| 🔴 **Runtime Controls** | The three-layer pattern | Risk Tiers → Guardrails → Judge → Judge Assurance → Human Oversight → Checklist |
| 🔵 **Insights** | Why this pattern exists | The First Control → Why Guardrails Aren't Enough → Judge Detects → Infrastructure Beats Instructions → Risk Tier Is Use Case → Humans Remain Accountable |
| 🟢 **Emerging Challenges** | Where the pattern meets its limits | Verification Gap → Behavioral Anomaly Detection → Multimodal Breaks Guardrails → When AI Thinks → When Agents Talk to Agents → The Memory Problem → Can't Validate What Hasn't Finished |
| 🟠 **Agentic Security** | Agent-specific controls | Agentic Controls → Multi-Agent Controls → NHI Lifecycle |
| 🟣 **Pipeline & Data** | RAG, supply chain, memory security | RAG Security → Supply Chain → Memory & Context |
| 🟡 **Operations** | SOC integration, monitoring, cost | Metrics → SOC Integration → Anomaly Detection Ops → Cost & Latency |
| ⚪ **Regulatory** | Compliance mapping | ISO 42001 → EU AI Act → Checklist |
| 🔵 **Getting Started** | Onboarding paths | Quick Start → Implementation Guide → Risk Tiers → Controls |

---

## Reading Paths

### "I need to explain this to leadership"

Follow the **Insights** line left to right. Start with [The First Control](insights/the-first-control.md), which frames the design-thinking question. Then [Why Guardrails Aren't Enough](insights/why-guardrails-arent-enough.md) and [Humans Remain Accountable](insights/humans-remain-accountable.md) give you the business case. Skip the technical stations — come back to them when your team needs implementation detail.

After that, jump to the two **Operational Gaps** articles: [The Supply Chain Problem](insights/the-supply-chain-problem.md) and [RAG Is Your Biggest Attack Surface](insights/rag-is-your-biggest-attack-surface.md). These are the risks most boards haven't heard about yet.

### "I'm implementing controls for a new AI system"

Start on the **Getting Started** line: [Quick Start](QUICK_START.md) → [Implementation Guide](IMPLEMENTATION_GUIDE.md). These feed directly into the **Runtime Controls** line.

On the red line, work left to right: [Risk Tiers](core/risk-tiers.md) tells you which controls you actually need. [Controls](core/controls.md) is the implementation core. [Judge Assurance](core/judge-assurance.md) covers calibrating and testing your evaluation layer. [Checklist](core/checklist.md) tracks your progress.

If you're building agents, take the **Agentic** branch down from Judge: [Agentic](core/agentic.md) → [Multi-Agent Controls](core/multi-agent-controls.md) → [NHI Lifecycle](extensions/technical/nhi-lifecycle.md).

### "I'm an architect designing the pipeline"

Follow the **Emerging Challenges** line to find which challenges affect your architecture:

- Deploying multimodal? → [Multimodal Breaks Guardrails](insights/multimodal-breaks-guardrails.md) → [Multimodal Controls](core/multimodal-controls.md)
- Using reasoning models? → [When AI Thinks](insights/when-ai-thinks.md) → [Reasoning Model Controls](core/reasoning-model-controls.md)
- Building agents? → [When Agents Talk to Agents](insights/when-agents-talk-to-agents.md) → [Multi-Agent Controls](core/multi-agent-controls.md)
- Streaming responses? → [Can't Validate What Hasn't Finished](insights/you-cant-validate-unfinished.md) → [Streaming Controls](core/streaming-controls.md)

Then drop to the **Pipeline & Data** line for the data-layer controls: [RAG Security](extensions/technical/rag-security.md), [Supply Chain](extensions/technical/supply-chain.md), [Memory & Context](core/memory-and-context.md).

### "I run a SOC and need to operationalise AI monitoring"

Start with [Behavioral Anomaly Detection](insights/behavioral-anomaly-detection.md) on the green line — it explains what you're looking for and why traditional detection logic doesn't apply.

Then go straight to the **Operations** line: [SOC Integration](extensions/technical/soc-integration.md) gives you alert taxonomy, SIEM rules, and triage procedures. [Anomaly Detection Ops](extensions/technical/anomaly-detection-ops.md) covers baselining and detection engineering. [Cost & Latency](extensions/technical/cost-and-latency.md) helps you budget the evaluation layer without blowing your inference costs.

### "I need regulatory alignment"

Follow the **Regulatory** line: [ISO 42001 Mapping](extensions/regulatory) and [EU AI Act](extensions/regulatory) connect back to the [Checklist](core/checklist.md) on the red line, showing which controls satisfy which requirements.

---

## How the Map Works

The map uses London Underground visual conventions:

- **Stations** (white circles) are individual documents
- **Interchanges** (larger circles with black borders) are documents where multiple themes connect — Risk Tiers, Guardrails, Judge, Human Oversight, and Checklist are all interchanges
- **Dashed lines** show where an insight article connects to its corresponding solution document
- **The river** (pale blue band labelled DATA FLOW) separates the understanding/implementation zone above from the operational zone below
- **Red NEW badges** mark content added in the latest release
- **Grey branch lines** are extensions — supplementary material you can follow if needed

The three zone labels across the top — UNDERSTAND, IMPLEMENT, OPERATE — describe the journey left to right. Most readers won't traverse every line. Pick the line that matches your role, follow it, and branch when the map shows a connection to something relevant.

---

## Station Index

Every station on the map, with its document link.

### Runtime Controls (Red Line)

| Station | Document |
|---------|----------|
| Risk Tiers | [core/risk-tiers.md](core/risk-tiers.md) |
| Guardrails | [core/controls.md](core/controls.md) |
| Judge | [core/controls.md](core/controls.md) |
| Judge Assurance | [core/judge-assurance.md](core/judge-assurance.md) |
| Human Oversight | [core/controls.md](core/controls.md) |
| Checklist | [core/checklist.md](core/checklist.md) |

### Insights (Blue Line)

| Station | Document |
|---------|----------|
| The First Control | [insights/the-first-control.md](insights/the-first-control.md) |
| Why Guardrails Aren't Enough | [insights/why-guardrails-arent-enough.md](insights/why-guardrails-arent-enough.md) |
| Judge Detects. It Doesn't Decide. | [insights/judge-detects-not-decides.md](insights/judge-detects-not-decides.md) |
| Infrastructure Beats Instructions | [insights/infrastructure-beats-instructions.md](insights/infrastructure-beats-instructions.md) |
| Risk Tier Is Use Case | [insights/risk-tier-is-use-case.md](insights/risk-tier-is-use-case.md) |
| Humans Remain Accountable | [insights/humans-remain-accountable.md](insights/humans-remain-accountable.md) |

### Emerging Challenges (Green Line)

| Station | Document |
|---------|----------|
| The Verification Gap | [insights/the-verification-gap.md](insights/the-verification-gap.md) |
| Behavioral Anomaly Detection | [insights/behavioral-anomaly-detection.md](insights/behavioral-anomaly-detection.md) |
| Multimodal Breaks Guardrails | [insights/multimodal-breaks-guardrails.md](insights/multimodal-breaks-guardrails.md) |
| When AI Thinks Before It Answers | [insights/when-ai-thinks.md](insights/when-ai-thinks.md) |
| When Agents Talk to Agents | [insights/when-agents-talk-to-agents.md](insights/when-agents-talk-to-agents.md) |
| The Memory Problem | [insights/the-memory-problem.md](insights/the-memory-problem.md) |
| Can't Validate What Hasn't Finished | [insights/you-cant-validate-unfinished.md](insights/you-cant-validate-unfinished.md) |

### Agentic Security (Orange Line)

| Station | Document |
|---------|----------|
| Agentic Controls | [core/agentic.md](core/agentic.md) |
| Multi-Agent Controls | [core/multi-agent-controls.md](core/multi-agent-controls.md) |
| NHI Lifecycle | [extensions/technical/nhi-lifecycle.md](extensions/technical/nhi-lifecycle.md) |

### Pipeline & Data (Purple Line)

| Station | Document |
|---------|----------|
| RAG Security | [extensions/technical/rag-security.md](extensions/technical/rag-security.md) |
| Supply Chain | [extensions/technical/supply-chain.md](extensions/technical/supply-chain.md) |
| Memory & Context | [core/memory-and-context.md](core/memory-and-context.md) |

### Operations (Yellow Line)

| Station | Document |
|---------|----------|
| Metrics | [extensions/technical/metrics.md](extensions/technical/metrics.md) |
| SOC Integration | [extensions/technical/soc-integration.md](extensions/technical/soc-integration.md) |
| Anomaly Detection Ops | [extensions/technical/anomaly-detection-ops.md](extensions/technical/anomaly-detection-ops.md) |
| Cost & Latency | [extensions/technical/cost-and-latency.md](extensions/technical/cost-and-latency.md) |

### Regulatory (Silver Line)

| Station | Document |
|---------|----------|
| ISO 42001 Mapping | [extensions/regulatory/](extensions/regulatory) |
| EU AI Act | [extensions/regulatory/](extensions/regulatory) |

### Insight Articles (Purple Dashed)

| Station | Document |
|---------|----------|
| The Supply Chain Problem | [insights/the-supply-chain-problem.md](insights/the-supply-chain-problem.md) |
| RAG Is Your Biggest Attack Surface | [insights/rag-is-your-biggest-attack-surface.md](insights/rag-is-your-biggest-attack-surface.md) |

### Extensions (Grey Branches)

| Station | Document |
|---------|----------|
| Bypass Prevention | [extensions/technical/bypass-prevention.md](extensions/technical/bypass-prevention.md) |
| Infrastructure | [extensions/technical/infrastructure.md](extensions/technical/infrastructure.md) |
| Current Solutions | [extensions/technical/current-solutions.md](extensions/technical/current-solutions.md) |
| Playbooks & Templates | [extensions/templates/](extensions/templates) |
| Threat Model | [extensions/templates/threat-model-template.md](extensions/templates/threat-model-template.md) |
| Emerging Controls | [core/emerging-controls.md](core/emerging-controls.md) |
