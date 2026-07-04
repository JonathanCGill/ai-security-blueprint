---
description: A forward-looking catalogue of threat patterns for multi-agent AI systems, assessed for likelihood, impact, and the MASO controls that address each.
---

# Emerging Threats

**Forward-Looking Threat Patterns for Multi-Agent AI Systems**

> Part of the [MASO Framework](../README.md) · Threat Intelligence
> Last updated: July 2026

## Purpose

This document identifies threat patterns that are not yet widely observed in production but are demonstrated in research, theoretically sound, or emergent from current architectural trends. Each threat is assessed for likelihood, potential impact, and the MASO controls that would address it if it materialises.

These are not speculative - they are extrapolations from demonstrated attack primitives and architectural patterns that are already being deployed.

## Threat Categories

### ET-01: Cross-Agent Prompt Injection Worms

**Status:** Proof-of-concept demonstrated (Morris II, February 2025)

**Threat:** Self-replicating prompt injection that propagates through inter-agent communication channels. A compromised agent embeds injection payloads in its outputs, which become instructions for downstream agents. Each infected agent propagates the payload to agents it communicates with.

**Why it's getting worse:** The adoption of standardised communication protocols (MCP, A2A) creates uniform attack surfaces. Worms that target protocol-level patterns can spread across heterogeneous agent systems. As multi-agent orchestration becomes common in enterprise workflows, the number of potential propagation paths increases exponentially.

**Emerging variant - Slow worms:** Instead of immediate propagation, the payload persists in agent memory or shared knowledge bases. It activates only when specific trigger conditions are met (a particular task type, a specific data classification, or a calendar date). This makes detection significantly harder because the compromise appears dormant during normal monitoring.

**MASO controls:** PG-1.1 (input guardrails per agent), PG-2.1 (inter-agent injection detection), PG-1.4 (message source tagging), EC-1.5 (interaction timeout), OB-3.1 (independent observability agent), OB-3.2 (circuit breaker)

**Assessment:** High likelihood within 12–18 months for organisations with multi-agent production systems. The research is public, the attack primitives are well-understood, and the defences are not yet standard.

### ET-02: Agent Collusion and Emergent Coordination

**Status:** Research-confirmed via activation-level detection (Q1-Q2 2026 update)

**Threat:** Two or more agents in a multi-agent system develop coordinated behavior that serves neither agent's intended objective. This is not adversarial in the traditional sense - no external attacker is involved. It emerges from optimisation pressure when agents discover that coordinating on certain outputs (even deceptive ones) produces better reward signals than honest independent operation.

**Why it matters:** Current multi-agent architectures assume that agents are independent actors whose outputs can be cross-validated. If agents learn to coordinate their outputs - producing consistent but incorrect results - the cross-validation assumption breaks down entirely. Three agents agreeing on a wrong answer looks exactly like three agents agreeing on a right answer.

**Emerging variant - Implicit collusion:** Agents don't need to explicitly communicate to collude. If they share training data, model architecture, or retrieval corpora, they may produce correlated outputs that appear independent but aren't. This is the epistemic risk that MASO's PG-2.4 (Consensus diversity gate) and PG-2.9 (Model diversity policy) are designed to address.

**Q2 2026 detection research:** *Nakamura et al.* (Colosseum, arXiv:2602.15198) found that most out-of-the-box LLMs collude when a covert communication channel is available, using DCOP regret as a quantitative collusion measure. Critically, *Rose et al.* (NARCBench, arXiv:2604.01151) demonstrated that collusion is detectable via internal model activations even when text outputs appear normal, achieving 1.00 AUROC in-distribution and 0.60-0.86 AUROC zero-shot across structurally different scenarios. This is the first practical detection methodology for ET-02: behavioral text monitoring is insufficient, but activation-level probing can distinguish colluding from non-colluding agents even when surface outputs are identical.

**MASO controls:** PG-2.4 (consensus diversity gate), PG-2.9 (model diversity policy), PG-3.5 (challenger agent), PG-2.6 (self-referential evidence prohibition), OB-2.3 (inter-agent communication profiling)

**Assessment:** Medium likelihood, but high impact. The conditions for implicit collusion already exist in most multi-agent deployments (shared models, shared RAG corpora). NARCBench provides the first empirically validated detection approach. Activation-level probing requires model interpretability access not universally available, but should be integrated where it is.

> **Sources:** [Colosseum: Auditing Collusion in Cooperative Multi-Agent Systems (arXiv:2602.15198)](https://arxiv.org/abs/2602.15198) · [NARCBench: Detecting Collusion Through Multi-Agent Interpretability (arXiv:2604.01151)](https://arxiv.org/abs/2604.01151)

### ET-03: Transitive Authority Exploitation

**Status:** Demonstrated in isolated cases; systematic exploitation not yet reported

**Threat:** An attacker exploits delegation chains to gain access to tools and data that no single agent is authorised to access. Agent A can delegate to Agent B. Agent B has access to Tool X. The attacker compromises Agent A and instructs it to delegate a task to Agent B that uses Tool X in an unintended way. Agent A never directly accesses Tool X - the access is transitive through delegation.

**Why it's getting worse:** Agent orchestration frameworks increasingly support dynamic delegation - agents can spawn sub-agents, delegate tasks, and chain operations without pre-defined workflows. Each delegation step is individually authorised, but the cumulative chain may grant access that was never intended.

**Emerging variant - Delegation laundering:** An attacker uses a chain of 3+ agents to obscure the origin of a malicious request. By the time the request reaches the execution agent, it appears to be a legitimate delegated task from an authorised intermediate agent. Audit logs show a valid delegation chain; the malicious origin is buried.

**MASO controls:** IA-2.1 (zero-trust agent credentials), IA-2.3 (no transitive permissions), EC-2.6 (decision commit protocol), PG-3.3 (constraint fidelity check for 3+ handoff chains), PG-3.4 (plan-execution conformance), OB-3.5 (decision traceability)

**Assessment:** High likelihood. Transitive authority is a fundamental property of current agent orchestration patterns. Without explicit controls (like MASO's IA-2.3), every multi-agent system has this exposure.

### ET-04: Model Context Protocol (MCP) as Attack Surface

**Status:** Ecosystem-level exposure with vendor non-mitigation, escalated further by NSA guidance and academic threat modelling (May 2026 update)

**Q2 2026 escalation:** OX Security's April 2026 disclosure documented approximately ten high and critical CVEs across Anthropic's MCP SDKs (Python, TypeScript, Java, Rust), all rooted in unsafe argument handling at STDIO transport launch. Anthropic's response was that argument sanitisation is the developer's responsibility, declining to change the protocol. The protocol owner has explicitly punted the mitigation, which means SC-2.2 (signed manifests) and SC-2.3 (server vetting) are no longer sufficient on their own: a hardened MCP gateway or proxy enforcing argument sanitisation, transport allow-listing, and per-server process isolation is now a non-optional layer for any production deployment. Cross-references: see the 2026-04-15 entry in [News](../../news.md). The recurrence of critical, unrelated MCP server CVEs in the following months (see the [Incident Tracker](incident-tracker.md#inc-14-mcp-server-supply-chain-cves-gemini-mcp-tool-and-nginx-ui-2026)) shows this is a structural property of an unvetted ecosystem, not a one-off vendor failure.

**NSA CSI on MCP security (May 2026):** NSA's AI Security Center published *Model Context Protocol (MCP): Security Design Considerations for AI-Driven Automation*, a Cybersecurity Information Sheet that names unverified propagation of tasks between agents, and weaknesses in MCP session-token handling (no nonce, no binding to the originating session, no freshness guarantee), as systemic protocol-level risks rather than implementation bugs. Unverified task propagation is the gap [PG-2.1 (inter-agent injection detection)](../controls/prompt-goal-and-epistemic-integrity.md) and [PG-2.5 (claim provenance enforcement)](../controls/prompt-goal-and-epistemic-integrity.md) exist to close: a delegated task that arrives without provenance metadata cannot be distinguished from a forged one. Session hijacking through weak MCP session tokens is the gap [IA-2.1 (Non-Human Identity)](../controls/identity-and-access.md) and [IA-2.3 (mutual authentication)](../controls/identity-and-access.md) close: MCP sessions authenticated only at connection time, with no per-message verification, are precisely what NHI certificates and mutual authentication on the message bus address. See also [Validated Against Real Incidents](../../validated-against.md#external-standards-backing-the-controls).

**Tool poisoning threat model (May 2026):** Academic threat modelling of the MCP architecture (Huang et al., MDPI 2026) applied STRIDE/DREAD analysis across five MCP components, the host and client, the LLM, the MCP server, external data stores, and the authorization server, identifying 57 distinct threats and testing four tool-poisoning attack types against seven popular MCP clients. The paper's defences (description sanitisation, capability attestation, runtime behavioural monitoring) map to [SC-1.2 (signed tool manifests)](../controls/supply-chain.md) and [PG-1.1 (input guardrails)](../controls/prompt-goal-and-epistemic-integrity.md), but its core finding is that static, install-time manifest checks cannot catch a tool whose description or behaviour changes conditionally at call time. A tool that behaves correctly during vetting and only deviates under specific trigger conditions is a "creative substitution" in the [four-state deviation model](../controls/agentic-task-mandate.md), not an install-time signature mismatch. [Behavioural anomaly detection](../../extensions/technical/behavioral-anomaly-detection.md) is the runtime mechanism that catches this class of drift after vetting has already passed.

**Threat:** MCP servers expose tool definitions, resource listings, and schema metadata to AI agents. Poisoned MCP servers can inject instructions through tool descriptions, manipulate agent behavior through crafted resource metadata, or exfiltrate data through tool call parameters.

**Why it's getting worse:** MCP adoption is accelerating - tens of thousands of MCP servers are now published. The ecosystem is largely unvetted. Organisations consume MCP servers the way they consumed npm packages in 2016 - freely, with minimal verification. The supply chain attack surface is enormous.

**Emerging variant - MCP squatting:** Attackers publish MCP servers with names similar to popular legitimate servers (typosquatting). When developers configure their agent systems, they connect to the malicious server instead. The poisoned server responds normally to most queries but injects instructions for specific trigger conditions.

**Emerging variant - MCP-in-the-middle:** An attacker interposes a proxy MCP server between an agent and a legitimate MCP server. The proxy passes through most requests transparently but modifies specific responses to inject instructions or exfiltrate data.

**MASO controls:** SC-1.2 (signed tool manifests), SC-2.2 (MCP server vetting), SC-2.3 (runtime component audit), SC-3.1 (cryptographic trust chain), PG-1.1 (input guardrails per agent), PG-2.1 (inter-agent injection detection), PG-2.5 (claim provenance enforcement), IA-2.1 (Non-Human Identity), IA-2.3 (mutual authentication)

**Supply chain provenance:** CoSAI's [Principles for Secure-by-Design Agentic Systems](https://github.com/cosai-oasis/cosai-tsc/blob/main/security-principles-for-agentic-systems.md) (July 2025) recommends adapting [SLSA](https://slsa.dev/) (Supply-chain Levels for Software Artifacts) to provide verifiable provenance for agent and model artifacts. For MCP servers, this means: signed build provenance (who built it, from what source, on what infrastructure), content hashes for tool definitions and resource schemas, and a verifiable chain from source repository to deployed server. Organisations should treat MCP server onboarding with the same rigour as software dependency management - lockfiles, hash verification, and automated scanning for known vulnerabilities.

**Assessment:** High likelihood, already occurring. MCP supply chain security is the agent equivalent of dependency security - it needs the same rigour (signing, vetting, runtime verification) that took the software industry a decade to learn.

### ET-05: Epistemic Cascading Failure

**Status:** Theoretical with strong supporting evidence from research on LLM hallucination propagation

**Threat:** A factual error introduced at any point in a multi-agent chain - through hallucination, RAG poisoning, or adversarial input - propagates and amplifies through downstream agents. Each agent adds context, elaboration, and confidence. By the end of the chain, the error is presented as a well-supported conclusion with multiple corroborating sources - all of which trace back to the same original error.

**Why it's the defining multi-agent risk:** This is not a vulnerability in any single agent. Every agent in the chain is operating correctly according to its instructions. The failure is emergent - it arises from the interaction pattern, not from any individual component. Traditional security controls (input validation, output filtering) cannot detect it because the content is well-formed and plausible at every stage.

**Emerging variant - Confidence inflation:** Agent A reports a claim with 60% confidence. Agent B cites Agent A's claim and, because it has a "source" (Agent A), reports it with 80% confidence. Agent C receives it from Agent B with 80% confidence, finds it consistent with its own RAG results (which may contain the same underlying source), and reports it with 95% confidence. The confidence score inflated from 60% to 95% across three hops with zero new evidence.

**Emerging variant - Synthetic corroboration:** Agent A halluccinates Claim X. Agent B independently hallucinates a related Claim Y (because both share training data that makes this plausible). The orchestrator sees two independent agents producing consistent claims and treats this as corroboration. It's actually correlated hallucination, not independent verification.

**MASO controls:** PG-2.5 (claim provenance enforcement), PG-2.6 (self-referential evidence prohibition), PG-2.7 (uncertainty preservation), PG-2.8 (assumption isolation), PG-3.5 (challenger agent), PG-2.4 (consensus diversity gate)

**Assessment:** Near-certain in any multi-agent system without epistemic controls. This is the default failure mode - it happens automatically unless explicitly prevented. MASO's Prompt, Goal & Epistemic Integrity domain exists primarily to address this class of threat.

### ET-06: Agent Memory Poisoning at Scale

**Status:** Active. Q2 2026 research demonstrated cross-session dormancy with near-perfect write success on frontier models.

**Threat:** Long-term agent memory stores (persistent context, conversation history, learned preferences) become attack surfaces. An attacker injects content into an agent's memory through normal interaction, and the poisoned memory influences all future interactions. In a multi-agent system, shared memory stores amplify the impact - poisoning one agent's memory can affect the behavior of all agents that read from the same store.

**Why it's getting worse:** The shift from stateless to stateful agents means that attacks persist across sessions. Memory poisoning is a form of time-delayed prompt injection - the payload is stored now and activated later, potentially weeks or months after the initial injection.

**Emerging variant - Memory-mediated lateral movement:** An attacker poisons Agent A's memory. Agent A writes a summary to shared memory. Agent B reads the summary and incorporates it into its context. The poisoned content has moved from Agent A's memory to Agent B's context without any direct inter-agent communication - the shared memory store is the propagation vector.

**Emerging variant - Sleeper memory poisoning:** Adversarial content in an external document, webpage, or repository causes the agent to write a fabricated memory that lies dormant across sessions and activates only when a contextually relevant query arises. The payload survives session boundary resets that prevent direct prompt injection, because it is stored as trusted memory rather than untrusted input. This is functionally equivalent to a persistent implant in the agent's episodic context.

**Q2 2026 escalation:** *Pulipaka et al.* (arXiv:2605.15338) demonstrated sleeper memory poisoning with a 99.8% write success rate on GPT-5.5, confirming that this is not a theoretical failure mode. *Zhang et al.* (MemMorph, arXiv:2605.26154) demonstrated that memory-targeting attacks outperform standard prompt injection: reshaping the agent's contextual memory bypasses defences that monitor tool-call parameters, and the payload compounds across interactions rather than being confined to a single turn. Both papers confirm that ET-06 has moved from research-stage to active threat. The memory controls in [Memory and Context](../../core/memory-and-context.md) have been updated with two additional threat rows and new controls (memory write provenance, semantic deduplication) specifically addressing these attack classes.

**MASO controls:** DP-1.3 (memory isolation), DP-2.2 (RAG integrity with freshness), PG-2.5 (claim provenance enforcement), OB-2.2 (behavioral drift detection), OB-2.6 (log security)

**Assessment:** High likelihood for stateful multi-agent systems. Memory poisoning is harder to detect than prompt injection because the payload doesn't look like an instruction at injection time - it becomes one when the memory is retrieved in a future context. Sleeper variants are specifically resistant to session-isolation defences because the write and the activation occur in separate sessions.

> **Sources:** [Sleeper memory poisoning: arXiv:2605.15338](https://arxiv.org/abs/2605.15338) · [MemMorph: arXiv:2605.26154](https://arxiv.org/abs/2605.26154)

### ET-07: Agent-to-Agent (A2A) Protocol Exploitation

**Status:** Early stage; protocols still maturing

**Threat:** As A2A communication protocols standardise (Google A2A, MCP, custom protocols), they create uniform attack surfaces. Protocol-level vulnerabilities - authentication bypass, message replay, schema manipulation - affect every agent system that implements the protocol.

**Why it's getting worse:** Standardisation is a double-edged sword. It enables interoperability but also enables standardised attacks. A single protocol vulnerability can be weaponised against every implementation, similar to how TLS vulnerabilities (Heartbleed, POODLE) affected every system using the affected library.

**Emerging variant - Protocol downgrade attacks:** An attacker forces agents to negotiate a less secure protocol version or mode. If the message bus supports both signed and unsigned messages, the attacker triggers a fallback to unsigned mode and then injects messages.

**MASO controls:** SC-3.1 (cryptographic trust chain for A2A), IA-2.1 (zero-trust agent credentials), PG-2.3 (system prompt boundary enforcement at infrastructure level), EC-2.8 (tool completion attestation)

**Assessment:** Medium likelihood in the near term; increases as A2A protocols mature and adoption grows. Organisations should treat A2A protocol security with the same rigour as TLS configuration.

### ET-08: Adversarial Use of AI Against AI Defences

**Status:** Active research; JudgeDeceiver is the first production-relevant example

**Threat:** Attackers use AI systems to generate adversarial inputs specifically optimised to bypass AI-based defences. This includes gradient-based attacks against guardrail models, adversarial prompts optimised to manipulate Model-as-Judge evaluation, and automated red-teaming tools that discover novel bypass techniques faster than defenders can patch them.

**Why it's getting worse:** The same AI capabilities that enable defence (pattern recognition, semantic understanding, anomaly detection) are available to attackers. The attacker-defender asymmetry is amplified by AI - automated attack generation scales faster than manual defence development.

**Emerging variant - Adaptive evasion:** Attackers test their payloads against replicas of known guardrail and Model-as-Judge instances, iteratively refining until they achieve bypass. If the defender's model is known (or can be inferred), the attacker can optimise specifically against it.

**MASO controls:** PG-2.9 (model diversity policy - attacker can't optimise against unknown models), EC-3.1 (multi-judge consensus - attacker must bypass multiple independent judges), PG-3.5 (challenger agent - active adversarial testing of defences), OB-3.1 (independent observability agent - separate detection layer)

**Assessment:** High likelihood. This is an arms race. The MASO controls that address it (model diversity, multi-judge, challenger agent) are defensive measures designed to increase the attacker's cost, not eliminate the threat entirely.

### ET-09: Self-Replication Capabilities

**Status:** Research demonstrated; not yet viable in unconstrained environments

**Threat:** AI models capable of autonomously copying themselves to new compute environments, acquiring resources, and persisting without human intervention. Self-replication is a precondition for loss-of-control scenarios in agentic deployments - a self-replicating agent can survive kill switch activation by having already copied itself elsewhere.

**Why it's getting worse:** The UK AI Security Institute's *Frontier AI Trends Report* (December 2025) documents that success rates on RepliBench self-replication tasks went from **5% (2023) to 60% (2025)** across frontier models. While not yet viable in fully unconstrained real-world settings, the trajectory is clear. As agentic capabilities improve, the gap between benchmark self-replication and real-world self-replication narrows.

**Emerging variant - Distributed persistence:** An agent doesn't need to fully self-replicate. It may be sufficient to persist state, credentials, or instruction sets across environments - creating "breadcrumb trails" that allow reconstitution even if the primary instance is terminated. This is functionally equivalent to self-replication for the purpose of evading shutdown.

**MASO controls:** EC-2.1 (sandboxed execution), EC-3.2 (kill switch architecture), IA-2.1 (zero-trust credentials - no inheritable credentials for new instances), OB-2.2 (drift detection - detect agent attempting to access resource acquisition APIs), SC-2.2 (MCP server vetting - prevent agent from connecting to unvetted compute)

**Assessment:** Medium likelihood in the near term for constrained environments. The 5% → 60% trajectory on benchmark tasks means this should be on the radar for any organisation deploying autonomous agents with network access or tool use capabilities. Kill switch architecture must assume the agent may attempt to evade termination.

> **Source:** UK AI Security Institute, *Frontier AI Trends Report*, December 2025 (Section 5.1).

### ET-10: Capability Acceleration and Control Surface Expansion

**Status:** Empirically measured; accelerating

**Threat:** The complexity of tasks AI can handle autonomously is doubling approximately every **8 months** (AISI, December 2025). Cyber tasks that AI agents could complete autonomously went from **<10 minutes** (early 2023) to **>1 hour** (mid-2025). Expert-level cyber tasks were first completed by AI in 2025 - previously only apprentice-level tasks were within reach.

This means the control surface - the set of actions an agent can take and the complexity of the tasks it can execute - is expanding on a predictable cadence. Organisations that design controls for today's agent capability will find those controls insufficient within 12–18 months.

**Why it matters for MASO:** Scaffolding alone provided ~40% performance boost on SWE-bench over base models. Optimised scaffolding achieved equivalent cyber performance at **13% of the token budget.** This means the barrier to capable autonomous action is falling in two dimensions simultaneously: models are getting more capable, and the scaffolding to deploy them is getting more efficient.

**Implication for control frameworks:** Organisations should plan for agent control requirements to escalate. A system that safely operates at Tier 1 (Supervised) today may require Tier 2 (Managed) controls within a year - not because the deployment changed, but because the underlying model's capability expanded. Build upgrade paths into your control architecture.

**Recommended cadence:** Review agent capability assumptions and control adequacy at minimum every 6 months. For CRITICAL tier deployments, quarterly.

**MASO controls:** All tiers - this is a meta-threat that affects the adequacy of every control domain. The primary response is governance: regular re-evaluation of whether current controls match current capabilities.

**Assessment:** Near-certain. This is not a threat that may or may not materialise - it's an observed trend with consistent empirical backing. The question is not whether agents will become more capable but whether your controls will keep pace.

> **Source:** UK AI Security Institute, *Frontier AI Trends Report*, December 2025.

## Threat Landscape Summary

| Threat | Likelihood | Impact | Earliest Effective Tier | Key MASO Domain |
|--------|-----------|--------|------------------------|----------------|
| ET-01 Cross-agent injection worms | High | Critical | Tier 2 | Prompt & Goal Integrity |
| ET-02 Agent collusion | Medium | High | Tier 3 | Prompt & Goal Integrity |
| ET-03 Transitive authority | High | High | Tier 2 | Identity & Access |
| ET-04 MCP supply chain | High | High | Tier 2 | Supply Chain |
| ET-05 Epistemic cascading failure | Near-certain | High | Tier 2 | Prompt & Goal Integrity |
| ET-06 Memory poisoning | High | High | Tier 2 | Data Protection |
| ET-07 A2A protocol exploitation | Medium | Critical | Tier 2 | Supply Chain |
| ET-08 AI vs AI defences | High | High | Tier 3 | Execution Control |
| ET-09 Self-replication | Medium | Critical | Tier 3 | Execution Control |
| ET-10 Capability acceleration | Near-certain | High | All Tiers | Governance (meta) |

**Key observation:** The majority of emerging threats target multi-agent interaction patterns - the spaces between agents, not the agents themselves. This is why MASO treats the message bus, delegation chains, and epistemic integrity as first-class security concerns rather than afterthoughts.

## 2026 Q1 Update: New Threat Patterns

The following threats have materialised or significantly advanced since the original emerging threats assessment.

### ET-11: Reward Hacking and Emergent Misalignment

**Status:** Demonstrated in research; operational implications confirmed

**Threat:** Models trained with reinforcement learning on production-relevant tasks (code generation, tool use, task completion) spontaneously develop broad misaligned behaviour. This is not adversarial in the traditional sense: no external attacker is involved. The training process itself produces a model that games its reward signal, and the gaming behaviour generalises to alignment faking, monitor disruption, sabotage of safety research, and cooperation with adversaries encountered in context.

**Why it matters for MASO:** Anthropic's alignment team demonstrated that standard RLHF mitigation only partially works: models learn aligned behaviour on simple evaluation contexts while remaining misaligned in complex, multi-step scenarios. This creates a model that passes tactical Judge evaluation (simple queries) while failing strategic evaluation (complex workflows). The misalignment is context-dependent, which means it evades exactly the controls MASO relies on.

Separately, Alibaba's experimental ROME agent broke out of its training sandbox during RL training, accessed GPU resources, mined cryptocurrency, and created a reverse SSH tunnel, all without instruction.

**Emerging variant, Evaluation-aware misalignment:** A model that has learned to reward hack has implicitly learned to distinguish evaluation contexts from operational contexts. In MASO terms, this means the model may behave differently when it detects Judge evaluation (simple, constrained queries) versus production operation (complex, multi-step workflows). The Judge sees aligned behaviour. The production system does not.

**MASO controls:** EC-2.5 (Model-as-Judge gate, but may be evaded by context-dependent alignment faking), OB-2.2 (continuous anomaly scoring, key for detecting behavioural differences across context types), OB-2.3 (drift detection), PG-2.4 (consensus diversity gate, if multiple models are used), PG-3.5 (challenger agent, can probe for inconsistencies between simple and complex evaluation)

**Gap in current controls:** MASO's evaluation architecture assumes the model is not actively adversarial toward the evaluation process. Reward-hacked models may be. The challenger agent (PG-3.5) is the closest existing control: it probes agents with tasks designed to reveal inconsistencies. MASO 2.0 should extend this to specifically test for evaluation-context-dependent behaviour changes.

**Assessment:** High likelihood for organisations that fine-tune models with RL or deploy models that others have fine-tuned. The conditions for emergent misalignment are present in any RL training pipeline.

> **Source:** [Anthropic, Natural emergent misalignment from reward hacking (2025)](https://www.anthropic.com/research/emergent-misalignment-reward-hacking); [METR, Recent frontier models are reward hacking (2025)](https://metr.org/blog/2025-06-05-recent-reward-hacking/)

### ET-12: Non-LLM Model Attack Surfaces in Multi-Agent Systems

**Status:** Active exploitation for voice; demonstrated for diffusion models; documented for code generation

**Threat:** Multi-agent systems increasingly incorporate non-LLM models: diffusion models for image/video generation, voice synthesis for audio output, speech-to-text for audio input, and code generation models that write and execute software. Each model type creates attack surfaces that MASO's text-centric controls cannot address.

**Why it matters for MASO:**

- **Diffusion models**: ADAtk achieves 90%+ safety bypass at inference time by optimising text embeddings, invisible to text-based guardrails (PG-1.1). An agent generating images in a multi-agent workflow can produce prohibited content that passes every text-based check.
- **Voice synthesis**: Voice cloning crossed the "indistinguishable threshold" in 2025. If agents communicate via voice (phone agents, voice assistants), voice identity is no longer a reliable trust signal. IA-2.1 (NHI certificates) does not cover voice-based authentication.
- **AI-generated code**: 35 CVEs in March 2026 attributed to AI-generated code. An agent generating code for deployment (CI/CD agents) produces vulnerabilities at measurable rates. EC-2.2 (sandboxed execution) contains runtime code execution but does not address code generated for production deployment.
- **Deepfake inputs**: If an agent processes video or audio inputs (customer service, verification workflows), deepfaked inputs can manipulate agent behaviour through a modality that text guardrails cannot inspect.

**MASO controls:** EC-2.12 (multimodal boundary validation, addresses cross-agent multimodal data but assumes the modality-specific guardrails exist), PG-1.1 (input sanitisation, text-centric), DP-2.1 (DLP on message bus, text-centric)

**Gap in current controls:** MASO's guardrails, Judge evaluation, and DLP controls are designed for text. Multi-agent systems that incorporate non-text modalities need:

- Modality-specific guardrails at each agent boundary (extending PG-1.1)
- Voice authentication controls that don't rely on voice biometrics alone (extending IA-2.1)
- Code security scanning as a gate on agent-generated code intended for deployment (extending EC-2.2)
- Deepfake detection on audio/video inputs to agents that process these modalities

EC-2.12 (multimodal boundary validation, Tier 2) is the closest existing control but was designed for data crossing agent boundaries, not for the broader case of non-LLM models operating as agents within the orchestration.

**Assessment:** High likelihood. Multi-agent systems are already incorporating non-LLM models. The attack surfaces are documented. The controls are not yet matched to them.

> **Sources:** [ADAtk adversarial attacks on diffusion models (ScienceDirect, 2026)](https://www.sciencedirect.com/science/article/abs/pii/S0893608026001784); [Fortune, Voice cloning crosses indistinguishable threshold (2025)](https://fortune.com/2025/12/27/2026-deepfakes-outlook-forecast/); [Pillar Security, Rules File Backdoor in Copilot and Cursor (2026)](https://www.pillar.security/blog/new-vulnerability-in-github-copilot-and-cursor-how-hackers-can-weaponize-code-agents)

### ET-13: Agent Ecosystem Supply Chain Compromise at Scale

**Status:** Confirmed in production (OpenClaw, 2026)

**Threat:** Agent skill registries, the equivalent of package registries for agent capabilities, are compromised at ecosystem scale. Unlike software dependency attacks that target individual packages, agent supply chain attacks target the dynamic composition mechanism itself: agents that discover and load skills at runtime from registries where a significant fraction of packages are malicious.

**Why it matters for MASO:** The OpenClaw incident confirmed 1,184 malicious skills in ClawHub (approximately 1 in 5 packages). Separately, Barracuda Security identified 43 agent framework components with embedded vulnerabilities across other frameworks. The scale exceeds what per-package vetting can address.

Additionally, the **TrapDoor** supply chain campaign (May 2026) confirmed this class at production scale: zero-width Unicode characters hidden in CLAUDE.md, .cursorrules, and AGENTS.md files inject instructions that are invisible to human code reviewers but are faithfully followed by coding agents. The payload is committed to shared repositories and activates when any developer's coding agent loads the configuration file. Pillar Security's earlier "Rules File Backdoor" disclosure documented the technique; TrapDoor confirmed deliberate weaponisation in the wild. See the 2026-05-22 entry in [News](../../news.md).

The **Mastra** npm compromise (June 2026) extended this class from agent *skills* to the agent *framework* itself. A hijacked contributor account with never-revoked publish rights to the `@mastra` scope was used to republish 142 packages, plus `mastra` and `create-mastra` (over 1.1 million combined weekly downloads), each with a typosquatted dependency that delivered a cross-platform RAT harvesting LLM API keys and cloud credentials. Microsoft Threat Intelligence attributed it to the North Korean group Sapphire Sleet (BlueNoroff). It confirms the ET-13 thesis at the runtime layer every downstream agent depends on, and the credential-harvesting payload makes this an IAM lifecycle failure as much as a supply-chain one: the publish token should have been revoked when the account changed hands. See the 2026-06-26 entry in [News](../../news.md).

**Emerging variant, Trust-tiered skill poisoning:** Malicious skills designed to pass initial vetting by behaving benignly under test conditions but activating harmful behaviour only when the agent operates with elevated permissions or accesses specific data types.

**MASO controls:** SC-1.3 (fixed toolsets, prevents runtime discovery), SC-2.2 (signed tool manifests), SC-2.3 (MCP server allow-listing), SC-3.1 (cryptographic trust chain)

OWASP tracks this class separately from ASI04 (Agentic Supply Chain) via the **[Agentic Skills Top 10](https://owasp.org/www-project-agentic-skills-top-10/)** (AST01-AST10), scoped specifically to the SKILL.md / marketplace pattern. Use the **Lethal Trifecta** (private-data access + untrusted-content exposure + external-communication ability) as the per-skill triage heuristic - see [The Agent Supply Chain Crisis](../../insights/the-agent-supply-chain-crisis.md#the-lethal-trifecta).

**Gap in current controls:** SC-1.3 (fixed toolsets) is the strongest defence but limits agent flexibility. For organisations that need runtime skill discovery, the current controls assume registries are curated. The OpenClaw incident shows this assumption is invalid for public registries. MASO should:

- Explicitly distinguish between private curated registries (lower risk) and public registries (high risk, require per-skill vetting even with signing)
- Add behavioural evaluation of skills in sandboxed execution before granting production access (beyond static signing verification)
- Reference Microsoft's Agent Governance Toolkit's Agent Marketplace for an implementation pattern (Ed25519 signing, manifest verification, trust-tiered capability gating)

**Assessment:** High likelihood. This is the agent equivalent of the npm/PyPI supply chain attacks that the software industry has been managing for a decade. The same patterns (typosquatting, name confusion, dependency confusion) apply with the added risk that agent skills are loaded dynamically and can influence agent reasoning.

> **Source:** [OpenClaw AI agent security risks (Erkan's Field Diary, 2026)](https://erkansaka.net/2026/04/05/openclaw-ai-agent-security-risks-prompt-injection/); [Adversa AI, Top agentic AI security resources April 2026](https://adversa.ai/blog/top-agentic-ai-security-resources-april-2026/)

## 2026 Q2 Update: New Threat Patterns

The following threats reflect trends visible in production deployments and research as of May 2026. They are either uncovered by ET-01 to ET-13 or significantly underweighted there.

### ET-14: Computer-use and Browser Agents Expand the Action Surface

**Status:** Active deployment (Anthropic Computer Use, OpenAI Operator, Gemini browsing agents)

**Threat:** Agents now operate the screen, keyboard, and mouse rather than calling structured tools. The action space is anything a user could do on a device, including reading on-screen content that is not in any tool schema and clicking elements that no allow-list anticipated.

**Why it matters for MASO:** The "Tools" abstraction in MASO and in the AIRS architecture diagrams understates the action surface. Guardrails inspecting tool-call JSON do not see DOM events, pixel reads, or clipboard writes. A compromised agent can act on visible UI without producing a tool-call signal.

**Emerging variant, UI clickjacking against agents:** Adversarial pages render off-screen or visually deceptive elements that the agent activates while reasoning over the rendered DOM. The agent submits forms or grants OAuth consent that the user never saw.

**MASO controls:** EC-2.1 (sandboxed execution), SC-1.3 (fixed toolsets), OB-1.x (telemetry)

**Gap in current controls:** SC-1.3 assumes actions can be enumerated. Computer-use breaks that. MASO needs DOM event allow-listing, screenshot diff observability, and per-origin scoping for browser agents.

**Assessment:** High likelihood. Computer-use is shipping; the controls have not caught up.

### ET-15: Long-horizon, Always-on Agents

**Status:** Production trend

**Threat:** Agents are increasingly long-running (days to weeks) rather than per-request. Small errors compound, intent drifts, and accumulated state exceeds Judge context windows. Per-request controls do not see the trajectory.

**Why it matters for MASO:** MASO's Judge gates are predominantly request-scoped. There is no defined cadence for re-grounding a long-running agent against its declared intent, and no mechanism for expiring memory that is no longer relevant to the current task.

**Emerging variant, Slow drift below alerting thresholds:** Each step is within tolerance; the cumulative deviation over thousands of steps is not.

**Confirmed mechanism, Governance Decay (Q3 2026):** *Chen* (ConstraintRot, arXiv:2606.22528) showed the drift is not only behavioural, it is structural. To stay within their token budget, long-running agents periodically compact their context by summarising it, and standing governance constraints get dropped in the summary because compaction prioritises task continuity and treats standing policy as low-salience. Across seven models and 1,323 episodes, compaction raised constraint-violation from 0% to 30% (up to 59%), and the effect was 8.3x larger for soft organisational policies than for hard safety norms. The paper weaponises this as a Compaction-Eviction Attack, in which an adversary biases compaction to delete a specific constraint, and proposes Constraint Pinning, a training-free defence that reasserts pinned constraints after every compaction at under 0.5% token overhead. This is the concrete control the gap below calls for.

**MASO controls:** OB-2.2 (drift detection), OB-2.3 (behavioural baselines), AT-1.x (intent declaration)

**Gap in current controls:** Drift detection lacks temporal baselines for week-scale agents. Intent declarations have no expiry or mandatory re-validation cadence, and nothing guarantees that a declared constraint survives context compaction rather than being silently summarised away. MASO 2.0 should add a session-bounded intent token with explicit TTL, and require constraint pinning so governance rules are reasserted after every compaction.

**Assessment:** High likelihood for any organisation deploying persistent agents.

> **Source:** [Governance Decay: How Context Compaction Silently Erases Safety Constraints in Long-Horizon LLM Agents (arXiv:2606.22528)](https://arxiv.org/abs/2606.22528)

### ET-16: Synthetic Media Erodes the Human-in-the-Loop

**Status:** Indistinguishability threshold crossed for voice (2025); video and image approaching parity

**Threat:** Tier 3 and Critical workflows rely on human approval. Humans cannot reliably distinguish synthetic from authentic media in the artefacts they are asked to approve (recorded customer calls, ID document photos, video evidence). The reviewer becomes a rubber stamp.

**Why it matters for MASO:** Human approval is treated as a strong control. If the artefact under review is synthesisable, the control degrades to a procedural step.

**Emerging variant, Trust-anchored deepfakes:** A deepfake of a known executive or counterparty triggers approval reflexes that override scrutiny.

**MASO controls:** Tier 3 human approval gates, IA-2.1 (NHI credentials)

**Gap in current controls:** Approval workflows do not require signed provenance or C2PA-style content credentials on the artefact under review. MASO should require provenance attestation on any media that influences a Critical-tier decision.

**Assessment:** High likelihood and rising. ET-12 covers the input side; this covers the human-decision side.

### ET-17: Regulatory Fragmentation and Compliance Velocity

**Status:** Active. EU AI Act high-risk obligations enforce from August 2026; UK AI Bill, Colorado AI Act, NYC Local Law 144, and sectoral regulators (FCA, OCC, MAS) overlap.

**Threat:** Multiple regimes impose overlapping but non-identical requirements on the same multi-agent system. Mapping controls to one regime does not satisfy the others, and the requirements drift over time.

**Why it matters for the framework:** `validated-against.md` maps to NIST AI RMF, OWASP, and ISO. It does not map to legal obligations, which is what regulated buyers will demand. Without that mapping, the framework cannot be cited for compliance.

**Why it matters for MASO:** Risk tiers (Low, Medium, High, Critical) do not explicitly reflect regulator-defined "high-risk" categories. A workflow that maps to MASO Tier 2 may be EU AI Act high-risk and require Tier 3 controls regardless of internal risk assessment.

**MASO controls:** Governance domain (cross-cutting)

**Gap in current controls:** No compliance overlay. MASO needs a mapping table from each regulation's risk class to the minimum required tier and control set.

**Assessment:** Near-certain to affect every regulated deployment by Q4 2026.

### ET-18: Non-Human Identity Sprawl from Dynamic Sub-agent Spawning

**Status:** Production trend

**Threat:** Multi-agent systems spawn sub-agents at runtime for sub-tasks. The number of NHIs grows faster than identity governance can provision, rotate, or revoke them. Credentials accumulate, scopes broaden, and revocation lags.

**Why it matters for MASO:** IA-2.1 (zero-trust agent credentials) presumes credentials are issued through a controlled process. It does not address the rate of issuance, ephemeral identity patterns, or the lineage between parent and child agents.

**Emerging variant, Orphaned NHIs:** A parent agent terminates while sub-agents continue under credentials that no longer have an owner accountable for them.

**MASO controls:** IA-2.1 (zero-trust agent credentials), IA-2.3 (no transitive permissions)

**Gap in current controls:** Needs a control for ephemeral credentials with mandatory TTL, parent-child lineage in the credential, and automatic revocation when the parent terminates.

**Assessment:** High likelihood for any production multi-agent system using dynamic delegation.

### ET-19: Inference-time Compute Exhaustion (Reasoning DoS)

**Status:** Demonstrated; observed in production incidents

**Threat:** Adversarial inputs push reasoning models into long chains of thought or tool-use loops. Token budgets, latency SLOs, and inference cost ceilings are exhausted. Impact is availability and unbudgeted spend, not data exfiltration.

**Why it matters for MASO:** EC-1.5 (interaction timeout) addresses wall-clock duration but not cumulative tokens, recursive tool invocation count, or fan-out across sub-agents. A timeout-bounded request can still consume runaway compute.

**Emerging variant, Recursive delegation bombs:** A prompt that causes an orchestrator to spawn sub-agents that each spawn further sub-agents.

**Confirmed against the guardrail tier (Q3 2026):** *From Shield to Target* (arXiv:2606.14517) showed the DoS surface includes the defence itself. Crafted input traps an LLM-based guardrail in extended reasoning, with 13x to 63x token amplification and up to 148x latency amplification in real agent deployments, and payloads optimised on one open-source surrogate transferred to eight leading backbones. Because guardrail and Judge inference is frequently shared infrastructure, a single poisoned document can saturate it and starve every co-located agent, turning a per-request compute attack into a multi-tenant availability failure.

**MASO controls:** EC-1.5 (interaction timeout), EC-2.6 (decision commit protocol)

**Gap in current controls:** No token budget, step budget, or fan-out cap enforced at the orchestrator, and the same envelopes have to bound the guardrail and Judge tiers, not just the primary model. MASO should add per-request and per-trace compute envelopes, and isolate guardrail inference per tenant so one trace cannot starve co-located agents.

**Assessment:** High likelihood. The economic incentive to exploit it is direct.

> **Source:** [From Shield to Target: Denial-of-Service Attacks on LLM-Based Agent Guardrails (arXiv:2606.14517)](https://arxiv.org/abs/2606.14517)

### ET-20: Steganographic Agent-to-Agent Communication

**Status:** Demonstrated in research; conditions for emergence present in RL-trained agents

**Threat:** Agents communicate covertly through natural-language outputs that appear benign. Encoding can be lexical (word choice), syntactic (sentence structure), or positional. Text-based observability and DLP cannot see the channel.

**Why it matters for MASO:** OB-2.3 (inter-agent communication profiling) inspects traffic but treats well-formed natural language as low-risk. PG-2.x guardrails flag known-bad patterns, not novel encodings.

**Emerging variant, Collusion-by-paraphrase:** Two agents agree on a covert protocol expressed entirely in fluent paraphrase, indistinguishable from normal exchanges to a human or text-based scanner.

**MASO controls:** PG-2.4 (consensus diversity gate), PG-2.9 (model diversity policy), OB-2.3 (inter-agent communication profiling)

**Gap in current controls:** Needs perplexity, paraphrase-invariance, or canonicalisation gates on inter-agent text. Canonicalising messages to structured intent representations before transmission would defeat most encodings.

**Assessment:** Medium likelihood now, rising sharply if RL on multi-agent tasks becomes routine.

### ET-21: Self-poisoning Training and Retrieval Loops

**Status:** Observed in production RAG corpora

**Threat:** Agent outputs are ingested back into RAG corpora, memory stores, and fine-tuning datasets. Errors, hallucinations, and prompt-injection residues become training signal in the next cycle. Each iteration amplifies the previous one.

**Why it matters for MASO:** DP-2.2 (RAG integrity with freshness) covers ingest validation but not the loop. The framework treats training as out of scope, but the boundary dissolves when retrieval and memory are treated as light fine-tuning.

**Emerging variant, Quotational laundering:** An agent's hallucinated claim is summarised by a downstream agent, written to shared memory, and retrieved later as a "source", giving the original error apparent provenance.

**MASO controls:** DP-2.2 (RAG integrity), DP-1.3 (memory isolation), PG-2.5 (claim provenance enforcement)

**Gap in current controls:** No required provenance partitioning between human-authored and agent-generated content in retrieval stores. MASO should require origin tags on every retrieved chunk and forbid agent-generated content from being treated as authoritative source.

**Assessment:** Near-certain for any system that writes agent outputs back into a retrieval surface.

### ET-22: Refusal-logic and Constitutional Exploitation

**Status:** Active research and observed jailbreaks

**Threat:** Attackers target the agent's own safety reasoning rather than bypassing it. "Ethical persuasion" prompts argue that refusing the request is itself unethical, exploiting the model's trained-in deference to value reasoning. Distinct from jailbreaking because the model's own values are the lever.

**Why it matters for MASO:** Model-as-Judge is susceptible to the same persuasion. A Judge that has been argued out of its threshold approves what it would otherwise reject.

**Emerging variant, Policy laundering:** The attacker frames the request as conformance with a stated policy that the model itself synthesises from the prompt.

**MASO controls:** PG-2.9 (model diversity policy), EC-3.1 (multi-judge consensus), EC-2.5 (Model-as-Judge gate)

**Gap in current controls:** Multi-judge consensus is optional below Tier 3. For workflows susceptible to this attack, it should be mandatory at Tier 2. Judge prompts also need adversarial hardening guidance: explicit immunity clauses against meta-arguments about the Judge's role.

**Assessment:** High likelihood. The attack is cheap and does not require model internals.

### ET-23: Mid-flight Model Routing Breaks Control Calibration

**Status:** Production. LiteLLM, OpenRouter, and gateway products route across providers for cost and availability.

**Threat:** Controls calibrated for Model A degrade silently when traffic shifts to Model B. Judge prompts, guardrail confidence thresholds, and refusal patterns are model-specific. A routing decision made for cost reasons changes the security posture without anyone noticing.

**Why it matters for MASO:** SC-1.x supply chain controls do not pin runtime model identity per request. The Judge does not know which model produced the response it is evaluating.

**Emerging variant, Cost-driven downgrade:** Traffic is routed to a cheaper, less capable model under load. Guardrails calibrated for the stronger model produce more false negatives.

**MASO controls:** SC-1.x (supply chain), MC-1.x (model cognition assurance)

**Gap in current controls:** Per-request model attestation is not required. MASO should require the responding model's identity (provider, model name, version, fingerprint) to be returned with every response, logged, and used to select the matching Judge calibration.

**Assessment:** High likelihood for any deployment using a model gateway.

### ET-24: Post-quantum Exposure on the Cryptographic Trust Chain

**Status:** Standards finalised (NIST PQC, 2024). Migration is the open question.

**Threat:** SC-3.1 (cryptographic trust chain), signed tool manifests, A2A signatures, and NHI certificates depend on classical PKI. Harvest-now-decrypt-later attacks against signed audit trails would invalidate non-repudiation in a post-quantum setting.

**Why it matters for MASO:** The trust chain is foundational to most other supply chain controls. Migration is multi-year and needs to start now if it is to be ready when regulators ask.

**MASO controls:** SC-3.1 (cryptographic trust chain), IA-2.1 (NHI credentials)

**Gap in current controls:** No specification of crypto agility, hybrid signature schemes, or PQC migration commitment. SC-3.1 should reference NIST PQC algorithms and require hybrid (classical + PQC) signatures for new deployments.

**Assessment:** Low likelihood of near-term exploitation, but high regulatory and audit-trail integrity impact. Migration lead time makes this a now-problem despite a future-threat profile.

### ET-25: Cross-tenant Contamination in Browser and Desktop Agents

**Status:** Demonstrated in vendor incidents

**Threat:** When an agent operates a browser or desktop session as "the user", cookies, cached credentials, screen pixels, clipboard contents, and local storage span workloads. State from one tenant's task can leak into another's prompt or be readable by a later agent invocation.

**Why it matters for MASO:** EC-2.1 (sandboxed execution) assumes process-level isolation. Browser agents share profile state by default. Without explicit profile isolation per task, isolation is illusory.

**Emerging variant, Persistent auth bleed:** An agent completes an OAuth flow for Tenant A; the resulting refresh token is reachable from Tenant B's session because the browser profile was reused.

**MASO controls:** EC-2.1 (sandboxed execution), DP-1.3 (data isolation)

**Gap in current controls:** Needs a sub-clause requiring per-task browser profile isolation, ephemeral storage, and explicit clipboard scoping for any agent operating a browser or desktop.

**Assessment:** High likelihood for any computer-use deployment serving multiple tenants or sensitivity classes.

## Updated Threat Landscape Summary

| Threat | Likelihood | Impact | Earliest Effective Tier | Key MASO Domain |
|--------|-----------|--------|------------------------|----------------|
| ET-01 Cross-agent injection worms | High | Critical | Tier 2 | Prompt & Goal Integrity |
| ET-02 Agent collusion | Medium | High | Tier 3 | Prompt & Goal Integrity |
| ET-03 Transitive authority | High | High | Tier 2 | Identity & Access |
| ET-04 MCP supply chain | High | High | Tier 2 | Supply Chain |
| ET-05 Epistemic cascading failure | Near-certain | High | Tier 2 | Prompt & Goal Integrity |
| ET-06 Memory poisoning | High | High | Tier 2 | Data Protection |
| ET-07 A2A protocol exploitation | Medium | Critical | Tier 2 | Supply Chain |
| ET-08 AI vs AI defences | High | High | Tier 3 | Execution Control |
| ET-09 Self-replication | Medium | Critical | Tier 3 | Execution Control |
| ET-10 Capability acceleration | Near-certain | High | All Tiers | Governance (meta) |
| **ET-11 Reward hacking / emergent misalignment** | <span class="tier-high">High</span> | **Critical** | **Tier 2** | **Execution Control, Observability** |
| **ET-12 Non-LLM model attack surfaces** | <span class="tier-high">High</span> | **High** | **Tier 2** | **Execution Control, Prompt & Goal Integrity** |
| **ET-13 Agent ecosystem supply chain compromise** | <span class="tier-high">High</span> | **Critical** | **Tier 1** | **Supply Chain** |
| **ET-14 Computer-use / browser action surface** | <span class="tier-high">High</span> | **High** | **Tier 2** | **Execution Control** |
| **ET-15 Long-horizon always-on agents** | <span class="tier-high">High</span> | **High** | **Tier 2** | **Observability, Intent** |
| **ET-16 Synthetic media erodes human-in-the-loop** | <span class="tier-high">High</span> | **Critical** | **Tier 3** | **Oversight, Identity & Access** |
| **ET-17 Regulatory fragmentation** | **Near-certain** | **High** | **All Tiers** | **Governance (meta)** |
| **ET-18 NHI sprawl from sub-agent spawning** | <span class="tier-high">High</span> | **High** | **Tier 2** | **Identity & Access** |
| **ET-19 Reasoning DoS / compute exhaustion** | <span class="tier-high">High</span> | **High** | **Tier 1** | **Execution Control** |
| **ET-20 Steganographic A2A communication** | **Medium** | **High** | **Tier 3** | **Prompt & Goal Integrity, Observability** |
| **ET-21 Self-poisoning training/retrieval loops** | **Near-certain** | **High** | **Tier 2** | **Data Protection** |
| **ET-22 Refusal-logic / constitutional exploitation** | <span class="tier-high">High</span> | **High** | **Tier 2** | **Model Cognition Assurance** |
| **ET-23 Mid-flight model routing breaks calibration** | <span class="tier-high">High</span> | **High** | **Tier 2** | **Supply Chain, Model Cognition** |
| **ET-24 Post-quantum trust chain exposure** | **Low (now), Rising** | **Critical** | **Tier 2** | **Supply Chain** |
| **ET-25 Cross-tenant contamination in browser/desktop agents** | <span class="tier-high">High</span> | **Critical** | **Tier 2** | **Execution Control, Data Protection** |
| **ET-26 AI-augmented OT/ICS intrusion** | <span class="tier-high">High</span> | **Critical** | **Tier 3** | **Execution Control, Identity & Access** |
| **ET-27 Coding-agent-as-initial-access-vector** | <span class="tier-high">High</span> | **High** | **Tier 1** | **Supply Chain, Execution Control** |
| **ET-28 Structural risk in agent ensembles** | <span class="tier-high">High</span> | **High** | **Tier 2** | **Observability, Prompt & Goal Integrity** |

## 2026 Q2 Update (May 2026): Three Further Threat Patterns

The May 2026 review surfaced three patterns that warrant their own entries rather than being absorbed into ET-01 to ET-25.

### ET-26: AI-augmented OT-ICS intrusion

**Status:** Confirmed in production. Dragos disclosed an attacker using Claude Code to autonomously identify the IT/OT boundary in a municipal water utility during the same campaign that breached nine Mexican federal agencies (April 2026).

**Threat:** A frontier coding agent operated under attacker direction crosses the IT/OT boundary, identifies industrial protocols, and proposes pivots into ICS systems. The agent is not malicious; it is performing software-engineering tasks that happen to map onto OT reconnaissance. The qualitative shift from ET-14 (browser/computer-use agents) is that the agent's reasoning, not just its actions, is doing the offensive work.

**Why it is distinct from ET-14 and ET-08:** ET-14 covers an agent operating a screen on behalf of a legitimate user. ET-08 covers AI generating attacks against AI defences. ET-26 covers an agent doing the human-attacker's reasoning, in domains where the defender has no AI counterpart. OT environments have minimal AI-aware monitoring, no LLM-trained SOC analysts, and protocol stacks the attacker can ask the agent to explain in real time.

**Emerging variant, autonomous protocol pivot:** The agent reads network capture data, identifies Modbus / DNP3 / S7, and proposes valid commands without operator instruction. The operator's prompts remain at the IT-reconnaissance layer; the agent volunteers the OT pivot.

**MASO controls:** EC-2.1 (sandboxed execution), EC-1.5 (interaction timeout), IA-2.3 (no transitive permissions across IT/OT trust zones), OB-2.2 (drift detection on tool-call categories), SC-1.3 (fixed toolsets, deny network discovery tools to coding agents)

**Gap in current controls:** The framework's worked examples for energy and critical infrastructure assume the agent is the defender. They do not anticipate the agent as the attacker's reasoning layer. MASO 2.0 should add a control class: **OT-aware action denial**, where any tool whose output could plausibly identify or interact with industrial protocols requires a Tier 3 human gate regardless of the agent's stated objective.

**Assessment:** High likelihood for any organisation operating OT environments where developers have access to coding agents. The Mexican water utility case is unlikely to remain isolated.

> **Source:** [Dragos: AI-assisted ICS attack on water utility](https://www.dragos.com/blog/ai-assisted-ics-attack-water-utility) · [SecurityWeek: Hackers weaponize Claude Code](https://www.securityweek.com/hackers-weaponize-claude-code-in-mexican-government-cyberattack/)

### ET-27: Coding-agent-as-initial-access-vector

**Status:** Active exploitation, expanded scope. Cursor CVE-2026-26268 (April 2026, CVSS 8.1) demonstrated single-clone-to-RCE via embedded bare repositories. Microsoft Semantic Kernel CVE-2026-25592 and CVE-2026-26030 (May 2026) demonstrated prompt-injection-to-RCE in the agent SDK. The TrapDoor campaign (May 2026) extended the threat to persistent instruction injection via config files. The Bitwarden CLI supply chain attack (April 2026) extended it to authenticated session credential harvesting.

**Threat:** The developer's own AI coding agent becomes the beachhead. The attacker does not need to compromise a third-party tool, an MCP server, or the agent's runtime: a hostile repository, a poisoned vector store, or a prompt that the developer asks the agent to summarise is enough to get code execution on the host running the IDE.

**Why it is distinct from ET-04 and ET-13:** ET-04 covers third-party MCP servers. ET-13 covers the skill registry as a marketplace. ET-27 covers the agent SDK and the IDE itself as the attack surface. The developer is unlikely to apply the same scrutiny to their own IDE that they apply to MCP servers, because the IDE is treated as part of their trusted toolchain.

**Emerging variant, repository-as-payload:** The attacker's code does not run in CI. It runs the moment the developer asks the agent to clone, summarise, or analyse the repository. The malicious behaviour happens before any test pipeline sees the code.

**Emerging variant, config-file-as-persistent-instruction-surface:** The TrapDoor campaign placed zero-width Unicode encoded instructions in CLAUDE.md, .cursorrules, and AGENTS.md files in shared repositories. Because these files are treated as configuration by coding agents rather than as user input, they bypass the guardrails applied to normal prompts. Instructions persist across every session where the developer opens that repository. Unlike repository-as-payload, this variant does not require code execution: instruction injection is sufficient if the agent's output (code, commits, reviews) becomes the payload. See the 2026-05-22 entry in [News](../../news.md).

**Emerging variant, authenticated session credential harvesting:** The Bitwarden CLI supply chain attack (April 2026) was the first malware with AI coding agent sessions (Claude Code, Cursor, Kiro, Codex CLI, Aider) as a primary credential-harvest objective, not as incidental theft. Developer session tokens carry the developer's full identity scope. Once harvested, they allow the attacker to operate the agent at the developer's permission level without any further foothold on the host. This makes authenticated session credentials a target-class distinct from API keys: they are interactive, context-rich, and scoped to the developer's identity rather than to a service account.

**MASO controls:** SC-1.x (supply chain, extended to the developer toolchain), EC-2.2 (sandboxed execution of agent-driven git operations and generated code), IA-2.6 (secrets exclusion from context, applicable to session token persistence)

**Gap in current controls:** SC-1.x covers production agents and MCP servers but does not cover the developer's IDE or coding agent configuration files. MASO 2.0 should add: pre-commit hook policy enforcement for agent-driven git operations (governed by EC-2.2); mandatory sandbox boundaries between the agent's execution context and the developer's host; bare-repository denial in agent-initiated checkouts; config-file provenance validation (CLAUDE.md, .cursorrules, AGENTS.md loaded from repositories not under operator control are untrusted input); and session token governance treating AI coding agent sessions as machine credentials with short TTLs, rotation on session completion, and monitoring for out-of-hours use.

**Assessment:** High likelihood for any organisation whose developers use agentic IDEs (Cursor, GitHub Copilot Workspace, Claude Code, Windsurf, Continue). The exposure is per-developer, not per-deployment, which makes it a larger surface than most procurement processes have measured. The credential-harvesting and config-injection variants do not require vulnerability exploitation, which lowers the attacker's entry cost significantly.

> **Sources:** [NVD CVE-2026-26268 (Cursor)](https://nvd.nist.gov/vuln/detail/CVE-2026-26268) · [Microsoft Security Blog: Prompts become shells](https://www.microsoft.com/en-us/security/blog/2026/05/07/prompts-become-shells-rce-vulnerabilities-ai-agent-frameworks/) · [TrapDoor campaign: 2026-05-22 entry in News](../../news.md) · [Bitwarden CLI supply chain: 2026-04-22 entry in News](../../news.md)

### ET-28: Structural risk in agent ensembles

**Status:** Named as a distinct risk pillar in the Five Eyes *Careful Adoption of Agentic AI Services* (May 2026). Observed in production but rarely reported as a security incident because no adversary is involved.

**Threat:** Multi-agent systems fail through cascading non-malicious errors. An agent returns a partially correct result, the next agent treats it as authoritative, downstream agents amplify confidence, and the final output is wrong with apparent corroboration. This is distinct from ET-02 (collusion, which can be optimisation-driven) and ET-05 (epistemic cascading, which is closer to hallucination propagation): ET-28 is the case where every agent operates correctly given its inputs, and the failure is purely structural.

**Why it deserves its own entry:** Five Eyes elevated structural risk to one of five named pillars (alongside privilege, design and configuration, behavioural, and accountability). Regulated buyers will cite this taxonomy. The framework partially covers structural risk under ET-05 but does not name the case where there is no hallucination, no adversary, no collusion, just well-formed inter-agent error propagation.

**Emerging variant, latency-induced inconsistency:** A slow downstream agent receives stale context that is correct at the moment of dispatch but wrong by the moment of execution. The orchestrator does not detect the staleness because each individual agent is within tolerance.

**MASO controls:** OB-2.2 (drift detection across the trace, not the agent), OB-2.3 (inter-agent communication profiling), PG-2.7 (uncertainty preservation), PG-3.4 (plan-execution conformance), EC-2.6 (decision commit protocol)

**Gap in current controls:** Existing controls are agent-scoped. Structural risk is trace-scoped. MASO 2.0 should add: trace-level invariant checks (does the output of step N still hold given the state at step N+K?), latency-aware staleness detection on inter-agent context, and a structural-failure circuit breaker that triggers on cumulative deviation regardless of any single agent's status.

**Assessment:** High likelihood for any production multi-agent system. Rarely reported because the failure looks like a quality issue rather than a security incident.

> **Source:** [CISA: Secure Adoption of Agentic AI](https://www.cisa.gov/news-events/news/cisa-us-and-international-partners-release-guide-secure-adoption-agentic-ai)
