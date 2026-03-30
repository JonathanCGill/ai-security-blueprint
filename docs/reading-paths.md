---
description: "Curated reading paths through the AI Runtime Security framework, organised by goal."
---

# Reading Paths

This site covers a lot of ground. These curated paths help you find what matters most based on what you are trying to achieve. Each path is a suggested sequence, not a strict order. Skip what you already know, dive deeper where you need to.

!!! tip "Looking for role-based guidance?"
    The [Stakeholder Views](stakeholders/) pages provide tailored entry points for security leaders, risk teams, architects, engineers, product owners, and more. Each one includes a starting path, concrete first actions, and answers to common objections.

## The Golden Thread: Guardrails, Judges, and Why They Work Together

This is the core reading path. It takes you from "why do I need runtime security at all?" through each control layer, how they reinforce each other, and the evidence that the approach works. Each article answers a question the previous one raises.

**Start here if you are new to the framework, or if you want to understand the reasoning behind the architecture before diving into controls and checklists.**

The path has three acts. **Act I** builds the case for layered controls. **Act II** explains what the Judge needs to work well: declared intent, behavioural traces, and outcome signals. **Act III** shows how the whole system self-improves and what the evidence says.

### Act I: Why you need layers

| # | Article | What it argues | What it sets up |
|---|---------|---------------|-----------------|
| 1 | [Why AI Security Is a Runtime Problem](insights/why-ai-security-is-a-runtime-problem.md) | AI is non-deterministic. Pre-deployment testing cannot prove future safety. Security must be continuous. | If testing is insufficient, what does continuous security actually look like? |
| 2 | [Why Your Guardrails Aren't Enough](insights/why-guardrails-arent-enough.md) | Guardrails catch known-bad patterns. Three classes of failure walk past them: novel attacks, semantic violations, emergent behaviour at scale. | If guardrails are necessary but insufficient, what fills the gap? |
| 3 | [Practical Guardrails](insights/practical-guardrails.md) | Guardrails work in two classes (security, data protection) at five pipeline points. They need to be well-built, not dismissed. | Guardrails are solid for what they do. What catches everything else? |
| 4 | [The Judge Detects. It Doesn't Decide.](insights/judge-detects-not-decides.md) | The Judge runs asynchronously, detecting unknown-bad without blocking. It informs human decisions rather than replacing them. | If the Judge is this important, how do we know it actually works? |
| 5 | [Judge Assurance](core/judge-assurance.md) | Validate the Judge against human ground truth. Track agreement, false negatives, drift. Different model family from the generator. Calibrate continuously. | The Judge can be validated, but can it be attacked? |
| 6 | [When the Judge Can Be Fooled](core/when-the-judge-can-be-fooled.md) | The Judge is itself an LLM. It can be manipulated through output crafting, prompt injection, and shared blind spots. Mitigations exist but perfection does not. | If no single layer is reliable, what holds the system together? |
| 7 | [Humans Remain Accountable](insights/humans-remain-accountable.md) | Humans own outcomes. The Judge makes oversight scalable, not optional. Regulation requires it. | We have guardrails, a judge, and human oversight. But the Judge needs more than just the output to evaluate. What does it need? |

### Act II: What the Judge needs to work

A judge that only sees the final output is half-blind. These three articles explain the inputs that make evaluation meaningful: what the agent was supposed to do (intent), how it got there (behaviour), and whether the action actually worked (outcomes).

| # | Article | What it argues | What it sets up |
|---|---------|---------------|-----------------|
| 8 | [Containment Through Declared Intent](insights/containment-through-intent.md) | An agent without declared purpose is uncontrollable. Intent gives the Judge alignment criteria, gives guardrails purpose-specific rules, and gives humans a basis for escalation. Without it, controls are arbitrary. | Intent tells the Judge what "good" looks like. But how does the Judge know whether the agent got there honestly? |
| 9 | [Process-Aware Evaluation](insights/process-aware-evaluation.md) | Evaluating what an agent produced matters less than evaluating how it got there. The Judge needs the full trace: tool calls, data accessed, reasoning steps, delegation decisions. Correct outputs from compromised processes are still failures. | The Judge now has intent and behaviour. But some failures only reveal themselves after the action lands. |
| 10 | [The Feedback Loops That Make It Work](insights/feedback-loops.md) | Four feedback loops at different speeds feed downstream outcomes, human labels, and judge signals back into every layer. Outcome signals are the only way to validate that "pass" verdicts were truly correct. The loops are the system. | Intent, behaviour, and outcomes give the Judge what it needs. But how do we prevent over-constraining the agent? |

### Act III: How the system holds together

| # | Article | What it argues | What it sets up |
|---|---------|---------------|-----------------|
| 11 | [Infrastructure Beats Instructions](insights/infrastructure-beats-instructions.md) | Telling agents what not to do fails. Make violations technically impossible through network controls, access restrictions, and action allowlists enforced outside the agent. | We have layers and infrastructure. How do we avoid over-constraining? |
| 12 | [The Constraint Curve](insights/the-constraint-curve.md) | Early constraints deliver outsized security at minimal cost. Late constraints destroy the value that justified using AI. Proportionality is the design principle. | We know what to build. How does it all fit together? |
| 13 | [Architecture Overview](ARCHITECTURE.md) | Guardrails prevent. Judge detects. Humans decide. Circuit breakers contain. Single-agent and multi-agent variants with PACE resilience for graceful degradation. | Does it actually work in practice? |
| 14 | [What Works](insights/what-works.md) | Organisations using runtime controls detect breaches 108 days faster. Guardrails block millions of attacks daily. Judges catch hallucination in production. The evidence is clear, but adoption is low. | *You are now ready to implement. Start with the [Quick Start](QUICK_START.md) or [Implementation Checklist](core/checklist.md).* |

!!! tip "Reading time"
    The full path is roughly two hours. **Act I** (articles 1 through 7) covers the core argument in about 40 minutes. **Act II** (articles 8 through 10) explains what makes the Judge effective in about 20 minutes. If you stop after Act II, you will understand why the architecture works and what it depends on.

---

## By goal

### "I need to understand the threat landscape"

1. [Why Guardrails Aren't Enough](insights/why-guardrails-arent-enough.md)
2. [RAG Is Your Biggest Attack Surface](insights/rag-is-your-biggest-attack-surface.md)
3. [The MCP Problem](insights/the-mcp-problem.md)
4. [When Agents Talk to Agents](insights/when-agents-talk-to-agents.md)
5. [You Don't Know What You're Deploying](insights/you-dont-know-what-youre-deploying.md)
6. [State of Reality](insights/state-of-reality.md)

### "I need to secure multi-agent systems"

1. [MASO Framework overview](maso/)
2. [Prompt, Goal & Epistemic Integrity](maso/controls/prompt-goal-and-epistemic-integrity.md)
3. [Identity & Access](maso/controls/identity-and-access.md)
4. [Execution Control](maso/controls/execution-control.md)
5. [Privileged Agent Governance](maso/controls/privileged-agent-governance.md)
6. [Multi-Agent Controls](core/multi-agent-controls.md)
7. [Worked Examples](maso/examples/worked-examples.md)

### "I need templates and practical artefacts"

1. [Implementation Checklist](core/checklist.md)
2. [Threat Model Template](extensions/templates/threat-model-template.md)
3. [AI Incident Playbook](extensions/templates/ai-incident-playbook.md)
4. [Vendor Assessment Questionnaire](extensions/templates/vendor-assessment-questionnaire.md)
5. [Model Card Template](extensions/templates/model-card-template.md)
6. [Use Case Examples](extensions/examples/)

### "I want to see real-world examples"

1. [Customer Service AI](extensions/examples/01-customer-service-ai.md)
2. [Internal Doc Assistant](extensions/examples/02-internal-doc-assistant.md)
3. [Credit Decision Support](extensions/examples/03-credit-decision-support.md)
4. [High-Volume Customer Comms](extensions/examples/04-high-volume-customer-communications.md)
5. [Fraud Analytics](extensions/examples/05-fraud-analytics.md)
6. [Red Team Playbook](maso/red-team/red-team-playbook.md)

!!! tip "Still not sure where to start?"
    The [Quick Start](QUICK_START.md) guide gives you a condensed overview you can read in a few minutes. The [FAQ](FAQ.md) answers common questions about scope, applicability, and how the framework relates to existing standards.

!!! info "References"
    - [What is AI Runtime Security?](what-is-ai-runtime-security.md)
    - [Quick Start](QUICK_START.md)
    - [FAQ](FAQ.md)
