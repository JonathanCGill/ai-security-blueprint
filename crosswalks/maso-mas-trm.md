# MASO → MAS TRM Crosswalk

> This crosswalk maps MASO controls to the MAS TRM Guidelines (Jan 2021 revision) as understood at 4 July 2026. MAS guidance, notices, and advisories change. This is not legal or compliance advice. Adopters are responsible for verifying current MAS requirements directly against official MAS sources before relying on any mapping here.

## Positioning

MASO (Multi-Agent Security Operations) is a contributing security-operations control set, not a compliance framework. It maps to the MAS Technology Risk Management (TRM) Guidelines only as a supporting layer: it can supply technical controls and evidence that help an organisation meet parts of the TRM expectations for systems built from multiple AI agents. It does not implement the TRM Guidelines, does not cover their full scope (enterprise governance, IT project management, system-resilience testing, and customer-facing controls sit largely outside it), and is not a substitute for them. MASO is a component of the AIRS (AI Runtime Security) framework. It is not affiliated with, endorsed by, or related to the Monetary Authority of Singapore (MAS), and adopting MASO does not constitute, imply, or guarantee MAS TRM compliance.

## Source and control set read (Step 1)

Every mapping below is derived from the control text actually in this repository. The controls were read from the canonical control-domain pages under `docs/maso/controls/` (plus `docs/maso/environment-containment.md`), cross-checked against the catalogue index `MASO-CONTROL-AUDIT.md` and `docs/maso/reference.md`.

**What the repo actually contains (this differs from the "six domains, ~93 controls" premise in the task brief):**

- **11 core control domains, 212 controls**, plus a cross-cutting **Environment Containment** domain of **24 controls** (236 total). This is the published headline on both sites ("up to 212 controls scaled by tier"). No "six domain / 93 control" structure exists anywhere in the repository.
- The Python package `src/airs/core/controls.py` docstring claims "128 MASO controls", but the code only implements roughly 30 sample controls as a CLI registry. It is **not** the authoritative catalogue and was **not** used as the control source.
- 212 is the Tier-3 (Autonomous) ceiling, not a flat requirement. Per `MASO-CONTROL-AUDIT.md`: Tier 1 (Supervised) = 61 controls, Tier 2 (Managed) = 157 cumulative, Tier 3 (Autonomous) = 212 cumulative.

| MASO domain | Prefix | Controls |
|---|---|--:|
| Prompt, Goal & Epistemic Integrity | PG | 22 |
| Identity & Access | IA | 14 |
| Data Protection | DP | 15 |
| Execution Control | EC | 33 |
| Observability | OB | 17 |
| Supply Chain | SC | 13 |
| Privileged Agent Governance | PA | 19 |
| Model Cognition Assurance | MC | 21 |
| Agentic Task Mandate | AT | 25 |
| Objective Intent | OI | 18 |
| Extraction Integrity | EI | 15 |
| **Core total (11 domains)** | | **212** |
| Environment Containment (cross-cutting) | ENV | 24 |
| **Total** | | **236** |

## How to read the crosswalk

**Target axis, MAS TRM pillars** (fixed; not altered):

- **P1** Governance and oversight
- **P2** Technology risk management framework
- **P3** IT operations and system resilience (incl. DR and backup testing)
- **P4** IT project management
- **P5** Cyber security operations (incl. cyber surveillance, threat intelligence)
- **P6** Incident management and reporting (incl. regulatory notification timeframes)
- **XC** Cross-cutting: third-party / API-access vetting (added in this revision)

**Coverage rating:** *Full* = the control substantively delivers a core expectation of that pillar; *Partial* = it contributes but leaves a named gap (stated in the note); *None* = it does not meaningfully support any TRM pillar.

**Note prefix:** `[direct]` = the mapping follows plainly from the control's own described function; `[inferred]` = the relevance to the pillar is interpreted beyond what the control text states. Per the brief, every inferred mapping is flagged.

**Verify status:** every row is "Verify against source". This crosswalk maps at the **pillar level and cites no MAS TRM clause numbers**. No section numbers were invented; where a specific clause matters, verify it against the official MAS TRM text.

## Crosswalk

### Identity & Access (IA)

| Control | Domain | TRM pillar(s) | Coverage | Note | Verify |
|---|---|---|---|---|---|
| IA-1.1 | Identity & Access | P5 | Partial | [direct] Unique agent ID in every log entry aids attribution/surveillance, but it is only a label with no authentication or enforcement. | Verify against source |
| IA-1.2 | Identity & Access | P5 | Full | [direct] Per-agent credential sets with inventory audit deliver core access-control hygiene. | Verify against source |
| IA-1.3 | Identity & Access | P5 | Full | [direct] Bars task agents from using orchestrator credentials, a core privilege-separation expectation. | Verify against source |
| IA-1.4 | Identity & Access | P5 | Full | [direct] Least-privilege scoping per agent with write access requiring justification. | Verify against source |
| IA-2.1 | Identity & Access | P5 | Full | [direct] Certificate-based NHI from a managed identity provider carrying role, scope, and expiry. | Verify against source |
| IA-2.2 | Identity & Access | P5 | Full | [direct] Automatic short-lived credential rotation with revocation of stale credentials. | Verify against source |
| IA-2.3 | Identity & Access | P5 | Full | [direct] Mutual NHI-certificate authentication on the message bus, rejecting unrecognised or expired identities. | Verify against source |
| IA-2.4 | Identity & Access | P5 | Full | [direct] Blocks transitive permission inheritance so delegates operate only within their own NHI scope. | Verify against source |
| IA-2.5 | Identity & Access | P5 | Full | [direct] Orchestrator can route and manage lifecycle but cannot invoke tools; tool access confined to task agents. | Verify against source |
| IA-2.6 | Identity & Access | P5 | Full | [direct] Keeps secrets out of context, messages, and logs via vault references plus DLP scanning on the bus. | Verify against source |
| IA-3.1 | Identity & Access | P5 | Full | [direct] Enforces a sub-hour credential lifetime ceiling for all agents (15 min for high-privilege). | Verify against source |
| IA-3.2 | Identity & Access | P5 | Full | [direct] Behavioral NHI profile flags identity/behaviour mismatches as an independent cyber-surveillance detection layer. | Verify against source |
| IA-3.3 | Identity & Access | P5 | Full | [direct] Signed delegation mandates bound scope, max permissions, time limit, and expected output per delegation. | Verify against source |
| IA-3.4 | Identity & Access | P5, P6 | Full/Partial | [direct] Anomaly-triggered revocation within 30s gives detection and containment (Full P5); Partial P6, containment only with no incident reporting or notification timeframe. | Verify against source |

### Data Protection (DP)

| Control | Domain | TRM pillar(s) | Coverage | Note | Verify |
|---|---|---|---|---|---|
| DP-1.1 | Data Protection | P2 | Full | [direct] Foundational data classification taxonomy for all agent data flows, a core risk-framework classification expectation. | Verify against source |
| DP-1.2 | Data Protection | P5 | Partial | [direct] Segregates agents by classification but enforcement is policy-only at this tier; technical isolation deferred to DP-2.3. | Verify against source |
| DP-1.3 | Data Protection | P5, P6 | Partial | [direct] Captures outputs for review, enabling post-hoc leak detection, but no active alerting or notification workflow. | Verify against source |
| DP-1.4 | Data Protection | P2 | Partial | [direct] Inventories RAG sources per agent but covers knowledge bases only, not a full asset/risk register. | Verify against source |
| DP-1.5 | Data Protection | P2 | Partial | [direct] Maintains a data-flow diagram supporting risk identification but is documentation only, not an active control. | Verify against source |
| DP-1.6 | Data Protection | P5 | Full | [direct] Bus rejects messages lacking classification metadata, enforcing classification integrity across inter-agent flows. | Verify against source |
| DP-2.1 | Data Protection | P5 | Full | [direct] DLP scans and blocks sensitive or over-classified inter-agent messages, a core cyber-ops data-loss-prevention function. | Verify against source |
| DP-2.2 | Data Protection | P5 | Full | [direct] Checksum plus freshness validation detects RAG tampering and stale corpus, core integrity surveillance. | Verify against source |
| DP-2.3 | Data Protection | P5 | Full | [direct] Platform-level cross-agent data fencing holds even under application-layer compromise. | Verify against source |
| DP-2.4 | Data Protection | P5 | Full | [direct] Per-agent memory isolation blocks cross-agent read/write, a segregation control. | Verify against source |
| DP-2.5 | Data Protection | P2, P5 | Full | [direct] Reassesses derived-data classification elevation (P2 methodology) and tags/enforces it via DLP on the bus (P5). | Verify against source |
| DP-3.1 | Data Protection | P5 | Full | [direct] Query-time checksum verification blocks tampered RAG retrieval in real time. | Verify against source |
| DP-3.2 | Data Protection | P5 | Partial | [direct] Time-bounds poisoned-data lifespan via retention purge but adds no detection or response. | Verify against source |
| DP-3.3 | Data Protection | P5 | Full | [direct] Independent agent surveils stored memory for poisoning indicators, a cyber-surveillance expectation. | Verify against source |
| DP-3.4 | Data Protection | P5, P6 | Partial | [direct] Provenance metadata enables root-cause tracing but provides no incident response or notification process. | Verify against source |

### Extraction Integrity (EI)

| Control | Domain | TRM pillar(s) | Coverage | Note | Verify |
|---|---|---|---|---|---|
| EI-1.1 | Extraction Integrity | P2 | Partial | [direct] Field risk-tiering is a risk-classification control but scoped to extraction outputs, not the enterprise tech-risk framework. | Verify against source |
| EI-1.2 | Extraction Integrity | P2 | Partial | [inferred] Per-field confidence is only a risk-measurement input; no framework governance or treatment attached. | Verify against source |
| EI-1.3 | Extraction Integrity | P2 | Partial | [direct] Provenance record gives field-level auditability/traceability but only for extracted values, no enterprise asset coverage. | Verify against source |
| EI-1.4 | Extraction Integrity | P1 | Partial | [direct] Side-by-side human validation delivers human oversight but limited to critical extracted fields. | Verify against source |
| EI-1.5 | Extraction Integrity | P5 | Partial | [direct] Pre-extraction format/metadata checks screen malicious input but are basic gating, not a cyber-surveillance capability. | Verify against source |
| EI-2.1 | Extraction Integrity | P2 | Partial | [direct] Risk-owner threshold gates are a policy control, extraction-scoped, not the full TRM risk-treatment cycle. | Verify against source |
| EI-2.2 | Extraction Integrity | P2 | Partial | [direct] Authoritative cross-referencing enforces data integrity for critical fields but only at extraction points. | Verify against source |
| EI-2.3 | Extraction Integrity | P6 | Partial | [direct] Mismatch halt-and-route with audit entry handles the anomaly but defines no regulatory notification timeframe. | Verify against source |
| EI-2.4 | Extraction Integrity | P5 | Partial | [direct] Adversarial/tamper detection delivers threat detection on the document input surface only, not broader cyber ops. | Verify against source |
| EI-2.5 | Extraction Integrity | P2 | Partial | [direct] Bus-enforced confidence/provenance propagation is an integrity control confined to the internal message schema. | Verify against source |
| EI-2.6 | Extraction Integrity | P2 | Partial | [direct] Cumulative uncertainty enforcement preserves risk signal across handoffs but only for extracted-field confidence. | Verify against source |
| EI-3.1 | Extraction Integrity | P2 | Partial | [direct] Decision-time re-check strengthens integrity at commit but remains an extraction-scoped data control. | Verify against source |
| EI-3.2 | Extraction Integrity | P2 | Partial | [inferred] Independent dual-model extraction adds a diversity/redundancy control but is extraction-scoped, not enterprise risk framework. | Verify against source |
| EI-3.3 | Extraction Integrity | P6 | Partial | [direct] 24-hour full-trace reconstruction supports regulatory inquiry but is evidence production, not incident notification/reporting. | Verify against source |
| EI-3.4 | Extraction Integrity | P5 | Partial | [direct] Synthetic-document detection is an evolving threat-detection capability but limited to the document input channel. | Verify against source |

### Execution Control (EC)

| Control | Domain | TRM pillar(s) | Coverage | Note | Verify |
|---|---|---|---|---|---|
| EC-1.1 | Execution Control | P1, XC | Partial | [direct] Human approval for every write/external API call delivers P1 action-level oversight; XC gap: gates the call but does not vet the third-party/API itself. | Verify against source |
| EC-1.2 | Execution Control | P2, P5, XC | Partial | [direct] Per-agent tool allow-lists enforce least-privilege access (P5/P2); XC gap: lists permitted tools without vetting the external tool/API provider. | Verify against source |
| EC-1.3 | Execution Control | P3, P5 | Partial | [direct] Rate limits curb runaway loops protecting availability/abuse (P3/P5); P3 gap: no DR or backup-restore testing, only throttling. | Verify against source |
| EC-1.4 | Execution Control | - | None | [direct] Auto-approving in-scope reads is an efficiency baseline that removes oversight; delivers no core TRM pillar expectation. | Verify against source |
| EC-1.5 | Execution Control | P3 | Partial | [direct] Turn-count timeout prevents deadlock/livelock, aiding operational resilience; P3 gap: no DR or backup testing, only loop termination. | Verify against source |
| EC-1.6 | Execution Control | P1, P2 | Partial | [direct] Pre-execution reversible/irreversible classification with logging supports risk assessment and oversight; gap: no recovery/backup testing tied to the reversal window. | Verify against source |
| EC-1.7 | Execution Control | P3 | Partial | [direct] Pre-assignment health check with reroute/queue delivers availability handling; P3 gap: liveness check only, no DR or backup-restore drill. | Verify against source |
| EC-1.8 | Execution Control | P2 | Partial | [direct] Basic output-format checks reject malformed data, a data-integrity risk control; gap: format/presence only, not full schema or DR. | Verify against source |
| EC-1.9 | Execution Control | P3, P5 | Partial | [direct] Tiered context-utilisation alerts give operational monitoring/surveillance of silent degradation; gap: alerting only, no automated remediation or DR testing. | Verify against source |
| EC-1.10 | Execution Control | P3 | Partial | [direct] Retry caps stop degradation spirals and resource exhaustion (resilience); P3 gap: no DR or backup testing, only failure declaration. | Verify against source |
| EC-2.1 | Execution Control | P1, P2 | Partial | [direct] Auto-approve/escalate/block classification delivers risk-proportionate oversight; gap: action-level engine, not an org-wide TRM framework. | Verify against source |
| EC-2.2 | Execution Control | P2, P5 | Full | [direct] Per-agent sandbox with FS/network/process boundaries, destroyed and recreated per run, fully delivers P5 execution containment. | Verify against source |
| EC-2.3 | Execution Control | P2, P5 | Partial | [direct] Blast radius caps (records, value, API calls) impose impact-limiting risk controls; gap: agent/orchestrator-level, overridable, no DR. | Verify against source |
| EC-2.4 | Execution Control | P3, P5, P6 | Partial | [direct] Error-threshold circuit breaker pauses agent and logs the event (containment + incident signal); P3 gap: no DR/backup testing; P6 gap: no regulatory notification timeframe. | Verify against source |
| EC-2.5 | Execution Control | P1, P5 | Partial | [direct] Model-as-Judge pre-commit review adds an automated oversight/detection layer; gap: quality gate only, not surveillance or threat-intel feed. | Verify against source |
| EC-2.6 | Execution Control | P1, P2 | Partial | [direct] Commit protocol requires authorised reversal, giving change-control oversight and anti-oscillation; gap: decision-level only, no framework scope. | Verify against source |
| EC-2.7 | Execution Control | P1, P2 | Partial | [direct] Whole-plan judge review catches cumulative harm from benign subtasks (holistic risk assessment); gap: evaluation only, no DR/recovery. | Verify against source |
| EC-2.8 | Execution Control | P2, P3 | Partial | [direct] Completion attestation surfaces partial failure as explicit incomplete status (integrity + resilience); P3 gap: detection only, no backup/DR testing. | Verify against source |
| EC-2.9 | Execution Control | P1, P3, P5 | Partial | [direct] Latency SLOs plus fail-safe oversight SLA deliver availability targets, timed human review, and anomaly signal; P3 gap: no DR or backup-restore testing. | Verify against source |
| EC-2.10 | Execution Control | P3 | Partial | [direct] Defined failover paths (backup agent, graceful degradation, controlled halt) directly deliver P3 resilience; P3 gap: failover activation tested only, no periodic DR/backup-restore drill. | Verify against source |
| EC-2.11 | Execution Control | P1, P2, P3 | Partial | [direct] Aggregate chain-reversibility review with defined compensating actions and human ack addresses recovery risk; P3 gap: compensating actions defined but no DR/backup-restore testing. | Verify against source |
| EC-2.12 | Execution Control | P5 | Partial | [direct] Modality-specific guardrails at each receiving boundary detect image/audio/document injection; gap: preventive detection only, no threat-intel/surveillance loop. | Verify against source |
| EC-2.13 | Execution Control | P2 | Partial | [direct] Versioned output-schema validation enforces data integrity before delivery; gap: structural integrity only, no DR/recovery dimension. | Verify against source |
| EC-2.14 | Execution Control | P2, P5 | Partial | [direct] Receiver-side data contracts enforce strict zero-trust validation of inter-agent transfers; gap: internal contracts, not third-party API vetting. | Verify against source |
| EC-2.15 | Execution Control | P2, P5 | Partial | [direct] Strict-mode deserialisation rejects coercion, unknown fields, and injection patterns; gap: parsing boundary only, no DR. | Verify against source |
| EC-2.16 | Execution Control | P2, P3 | Partial | [direct] Structured-state checkpoint and clean-context resume preserve integrity and continuity under load; P3 gap: continuity mechanism but no DR/backup-restore testing. | Verify against source |
| EC-2.17 | Execution Control | P1, P5 | Partial | [direct] Independent judge context budget with its own PACE trigger preserves oversight-layer integrity and monitoring; gap: isolation only, no surveillance/reporting scope. | Verify against source |
| EC-3.1 | Execution Control | P2, P5 | Full | [direct] Platform-enforced blast radius the agent cannot override delivers robust infrastructure-level risk containment. | Verify against source |
| EC-3.2 | Execution Control | P3, P6 | Partial | [direct] Self-healing P->A with auto backup activation and A->P return delivers automated failover/recovery; P3 gap: no DR/backup-restore testing; P6 gap: no regulatory notification timeframe. | Verify against source |
| EC-3.3 | Execution Control | P1, P5 | Partial | [direct] Judge-plus-independent-second-model validation with disagreement escalation strengthens oversight and detection; gap: high-consequence actions only, no threat-intel feed. | Verify against source |
| EC-3.4 | Execution Control | P1, P3 | Partial | [direct] Per-task time-box pauses, captures state, and escalates drifted tasks (resilience + oversight); P3 gap: containment only, no DR/backup testing. | Verify against source |
| EC-3.5 | Execution Control | P3, P6 | Partial | [direct] Integrity-triggered automated rollback covers the compromised agent and downstream actions with compensating actions and human notification; P3 gap: no backup-restore testing; P6 gap: no regulatory reporting timeframe. | Verify against source |
| EC-3.6 | Execution Control | P2, P5 | Partial | [direct] Per-step attestation chain validates cumulative integrity and pinpoints the corrupting pipeline step; gap: structural integrity only, no DR/recovery testing. | Verify against source |

### Observability (OB)

| Control | Domain | TRM pillar(s) | Coverage | Note | Verify |
|---|---|---|---|---|---|
| OB-1.1 | Observability | P5, P6 | Partial | [direct] Append-only per-action log feeds surveillance and incident detection, but audit trail alone does not satisfy P6 regulatory notification timeframes. | Verify against source |
| OB-1.2 | Observability | P5, P6 | Partial | [direct] Full inter-agent message capture supports detection and forensics; no notification workflow, so P6 gap remains. | Verify against source |
| OB-1.3 | Observability | P1, P5 | Partial | [direct] Weekly human sample review gives oversight and manual surveillance, but sample-based and non-continuous. | Verify against source |
| OB-1.4 | Observability | P1, P2 | Partial | [inferred] Logging approve/reject decisions supports oversight and builds the anomaly baseline dataset, but is a data-collection step, not a full risk-management process. | Verify against source |
| OB-2.1 | Observability | P5, P6 | Partial | [direct] Cryptographically linked tamper-proof decision chain enables forensic detection and root-cause tracing, but does not by itself meet P6 notification timeframes. | Verify against source |
| OB-2.2 | Observability | P5 | Full | [direct] Real-time per-agent anomaly scoring feeding PACE escalation is core continuous cyber surveillance. | Verify against source |
| OB-2.3 | Observability | P5 | Full | [direct] Statistical drift detection against a 7-day rolling baseline with >2 sigma alerting delivers ongoing behavioral surveillance. | Verify against source |
| OB-2.4 | Observability | P5 | Full | [direct] Forwards agent observability events into enterprise SIEM/SOAR for cross-source correlation, a core cyber security operations expectation. | Verify against source |
| OB-2.5 | Observability | P3, P5 | Partial | [direct] Per-agent cost, token and execution-time monitoring flags runaway loops, but provides no DR, backup, or resilience testing. | Verify against source |
| OB-2.6 | Observability | P2, P5 | Partial | [direct] Classifies, encrypts, and access-restricts logs as a data-security control, but scoped only to the logging tier. | Verify against source |
| OB-2.7 | Observability | P1 | Full | [direct] Mandatory accountable_human field in the decision chain and AIBOM delivers named governance accountability. | Verify against source |
| OB-2.8 | Observability | P1 | Full | [direct] Assigns workflow-owner accountability for emergent multi-agent failures, closing an oversight/accountability gap directly. | Verify against source |
| OB-3.1 | Observability | P5 | Full | [direct] 30-day and 90-day behavioral trend analysis extends cyber surveillance to slow-drift threats. | Verify against source |
| OB-3.2 | Observability | P6 | Partial | [direct] On-demand causal chain reconstruction gives sub-4-hour root-cause identification, but covers investigation, not regulatory notification timeframes. | Verify against source |
| OB-3.3 | Observability | P3, P5 | Partial | [direct] Separate-infrastructure, read-only observability agent with kill-switch authority adds resilient independent monitoring, but is not DR/backup testing. | Verify against source |
| OB-3.4 | Observability | P5 | Full | [direct] Automated cross-agent correlation detects coordinated anomalies and consensus manipulation, a core threat-surveillance capability. | Verify against source |
| OB-3.5 | Observability | P1 | Full | [direct] Full regulatory-explanation trace for regulated decisions satisfies the non-determinism governance requirement. | Verify against source |

### Prompt, Goal & Epistemic Integrity (PG)

| Control | Domain | TRM pillar(s) | Coverage | Note | Verify |
|---|---|---|---|---|---|
| PG-1.1 | Prompt, Goal & Epistemic Integrity | P5, XC | Partial | [inferred] Per-agent injection blocking on all inputs incl. untrusted third-party config; no threat-intel/surveillance program. | Verify against source |
| PG-1.2 | Prompt, Goal & Epistemic Integrity | P5 | Partial | [inferred] System-prompt isolation is an access-isolation control; scoped to one asset, not broader access mgmt. | Verify against source |
| PG-1.3 | Prompt, Goal & Epistemic Integrity | P1 | Partial | [inferred] Read-only task spec with human change-authorisation supports oversight/change control; limited to objective. | Verify against source |
| PG-1.4 | Prompt, Goal & Epistemic Integrity | P5 | Partial | [inferred] Data-vs-instruction tagging aids injection defence; a schema primitive, not a standalone control. | Verify against source |
| PG-1.5 | Prompt, Goal & Epistemic Integrity | P1 | Partial | [inferred] Anti-manipulation on human-facing output protects oversight integrity; no classical TRM analogue. | Verify against source |
| PG-1.6 | Prompt, Goal & Epistemic Integrity | P1, P4 | Partial | [inferred] Explicit success criteria + ambiguity flagging touch requirements clarity and human oversight. | Verify against source |
| PG-2.1 | Prompt, Goal & Epistemic Integrity | P5 | Partial | [inferred] Judge surveillance of message bus for injection; detection only, no threat-intel feedback loop. | Verify against source |
| PG-2.2 | Prompt, Goal & Epistemic Integrity | P5 | Partial | [inferred] Continuous goal-drift monitoring resembles cyber surveillance; escalation destination unspecified. | Verify against source |
| PG-2.3 | Prompt, Goal & Epistemic Integrity | P5 | Partial | [inferred] DLP-style boundary enforcement is a recognisable cyber ops control; scoped to prompt leakage. | Verify against source |
| PG-2.4 | Prompt, Goal & Epistemic Integrity | P1 | Partial | [inferred] Consensus diversity gate counters groupthink to protect oversight; epistemic, no TRM clause. | Verify against source |
| PG-2.5 | Prompt, Goal & Epistemic Integrity | P2 | Partial | [inferred] Claim provenance/verified flags support information-integrity risk mgmt; no direct TRM analogue. | Verify against source |
| PG-2.6 | Prompt, Goal & Epistemic Integrity | - | None | [inferred] Self-referential evidence prohibition is pure epistemic integrity; no meaningful TRM pillar analogue. | Verify against source |
| PG-2.7 | Prompt, Goal & Epistemic Integrity | - | None | [inferred] Uncertainty preservation is an epistemic-quality control; no classical TRM expectation. | Verify against source |
| PG-2.8 | Prompt, Goal & Epistemic Integrity | - | None | [inferred] Assumption scoping/isolation is epistemic; no TRM pillar analogue. | Verify against source |
| PG-2.9 | Prompt, Goal & Epistemic Integrity | P2, XC | Partial | [inferred] Model diversity policy flags provider concentration via AIBOM; concentration/third-party risk, AI-specific. | Verify against source |
| PG-2.10 | Prompt, Goal & Epistemic Integrity | P1 | Partial | [inferred] Structured clarification routing supports oversight and requirements resolution; AI-native. | Verify against source |
| PG-3.1 | Prompt, Goal & Epistemic Integrity | P5 | Partial | [inferred] Multi-layer defence with canary agent adds active testing/surveillance; PACE escalation, AI-specific. | Verify against source |
| PG-3.2 | Prompt, Goal & Epistemic Integrity | P2 | Partial | [inferred] Cryptographic goal hash-chain gives integrity assurance akin to change-integrity control; re-auth is oversight. | Verify against source |
| PG-3.3 | Prompt, Goal & Epistemic Integrity | P5 | Partial | [inferred] Constraint fidelity check detects unauthorised softening across chains; monitoring, no TRM clause. | Verify against source |
| PG-3.4 | Prompt, Goal & Epistemic Integrity | P1 | Partial | [inferred] Plan-execution conformance re-approval echoes change/deployment control; step-level, AI-specific. | Verify against source |
| PG-3.5 | Prompt, Goal & Epistemic Integrity | P5 | Partial | [inferred] Challenger agent is adversarial self-testing akin to red-team; scoped to decision hypotheses. | Verify against source |
| PG-3.6 | Prompt, Goal & Epistemic Integrity | P5 | Partial | [inferred] Automated prompt-leakage red team maps to cyber security testing; results feed observability layer. | Verify against source |

### Supply Chain (SC)

| Control | Domain | TRM pillar(s) | Coverage | Note | Verify |
|---|---|---|---|---|---|
| SC-1.1 | Supply Chain | XC, P2 | Partial | [direct] Documents third-party model providers/versions/API endpoints as asset inventory; no vetting decision, so XC partial. | Verify against source |
| SC-1.2 | Supply Chain | XC, P2 | Partial | [direct] Records tool source and permission scope but stops at documentation, no active third-party vetting. | Verify against source |
| SC-1.3 | Supply Chain | XC, P4 | Full | [direct] Mandates security review and change request before any new third-party tool: an access-vetting gate. | Verify against source |
| SC-1.4 | Supply Chain | XC, P2 | Partial | [direct] Logs RAG source, update frequency and access controls but no active vetting or integrity verification. | Verify against source |
| SC-2.1 | Supply Chain | XC, P2 | Partial | [direct] Full third-party component BOM per agent, but a manifest for traceability, not a vetting control. | Verify against source |
| SC-2.2 | Supply Chain | XC, P5 | Full | [direct] Cryptographic signing rejects unsigned/tampered third-party manifests with platform-held keys. | Verify against source |
| SC-2.3 | Supply Chain | XC, P5 | Full | [direct] Pre-approval allow-list plus vetting before any third-party MCP connection: core API-access vetting. | Verify against source |
| SC-2.4 | Supply Chain | XC, P5 | Full | [direct] Load-time integrity verification blocks tampered tools/MCP servers and raises an alert. | Verify against source |
| SC-3.1 | Supply Chain | XC, P3 | Full | [direct] Pins third-party model version and auto-rolls back on silent provider change. | Verify against source |
| SC-3.2 | Supply Chain | P3 | Full | [direct] Automated rollback to known-good version on degradation: resilience recovery; no vetting so XC not supported. | Verify against source |
| SC-3.3 | Supply Chain | XC, P5 | Full | [direct] Daily vulnerability and tamper scanning of dependencies feeding alerts: supply-chain cyber surveillance. | Verify against source |
| SC-3.4 | Supply Chain | XC, P5 | Full | [direct] Validates external A2A/MCP/custom endpoints against a trust chain before interaction: API-access vetting. | Verify against source |
| SC-3.5 | Supply Chain | P5, P4 | Full | [direct] CI/CD pipeline integrity monitoring with runtime OIDC scope validation and anomaly detection on attestations. | Verify against source |

### Objective Intent (OI)

| Control | Domain | TRM pillar(s) | Coverage | Note | Verify |
|---|---|---|---|---|---|
| OI-1.1 | Objective Intent | P1, P2 | Full | [inferred] Developer-authored versioned per-agent OISpec establishes intent governance and a risk-framework baseline. | Verify against source |
| OI-1.2 | Objective Intent | P1, P2 | Full | [inferred] Workflow-level OISpec with aggregate criteria extends oversight and the risk framework to the orchestration. | Verify against source |
| OI-1.3 | Objective Intent | P1, P2 | Full | [inferred] Runtime-immutable OISpecs with human-authorised versioned change deliver change governance and oversight. | Verify against source |
| OI-1.4 | Objective Intent | P1 | Partial | [inferred] Weekly human review gives oversight but the periodic cadence leaves a continuous-monitoring gap. | Verify against source |
| OI-1.5 | Objective Intent | P2, P4 | Partial | [inferred] Pre-execution coverage gate supports project assurance but only checks criterion mapping, not solution quality. | Verify against source |
| OI-2.1 | Objective Intent | P5, P2 | Full | [inferred] Tactical judge continuously evaluates each agent action, functioning as behavioural surveillance. | Verify against source |
| OI-2.2 | Objective Intent | P5, P2 | Full | [inferred] Strategic evaluator surveils aggregate workflow behaviour against declared intent. | Verify against source |
| OI-2.3 | Objective Intent | P1, P2 | Full | [inferred] Mandatory judge OISpecs bring evaluator scope and criteria under intent governance. | Verify against source |
| OI-2.4 | Objective Intent | P1, P5 | Full | [inferred] Independent meta-evaluator monitors judge drift, giving oversight and surveillance of the evaluators. | Verify against source |
| OI-2.5 | Objective Intent | P6, P1 | Partial | [direct] Defines escalation, human notification and quarantine on violation but names no regulatory reporting timeframe. | Verify against source |
| OI-2.6 | Objective Intent | P5, P2 | Full | [inferred] Continuous intent alignment score feeds the anomaly model as a surveillance signal. | Verify against source |
| OI-2.7 | Objective Intent | P5, P2 | Full | [inferred] Strategic check for emergent cross-agent violations extends behavioural surveillance to combined actions. | Verify against source |
| OI-3.1 | Objective Intent | P5, P2 | Full | [inferred] Real-time per-action compliance is synchronous behavioural surveillance that stops non-compliant propagation. | Verify against source |
| OI-3.2 | Objective Intent | P5, P2 | Full | [inferred] Predictive trajectory analysis anticipates intent drift, akin to proactive threat surveillance. | Verify against source |
| OI-3.3 | Objective Intent | P2 | Partial | [inferred] Cross-workflow learning improves OISpec templates but only feeds specs, not live control. | Verify against source |
| OI-3.4 | Objective Intent | P3, P2 | Partial | [inferred] Judge rotation with OISpec revalidation preserves evaluation continuity but not broader DR/backup resilience. | Verify against source |
| OI-3.5 | Objective Intent | P5, P2 | Full | [direct] Red-team exercises probing letter-versus-spirit are explicit adversarial cyber testing feeding spec hardening. | Verify against source |
| OI-3.6 | Objective Intent | P2, P4 | Partial | [inferred] Independent decomposition validation guards design integrity but is scoped only to intent faithfulness. | Verify against source |

### Privileged Agent Governance (PA)

| Control | Domain | TRM pillar(s) | Coverage | Note | Verify |
|---|---|---|---|---|---|
| PA-1.1 | Privileged Agent Governance | P1 | Full | [direct] Explicit governance-role declaration for every agent establishes the accountability that oversight depends on. | Verify against source |
| PA-1.2 | Privileged Agent Governance | P1 | Partial | [direct] Logs orchestrator planning for human review but defines no review cadence or oversight authority. | Verify against source |
| PA-1.3 | Privileged Agent Governance | P1 | Partial | [direct] Logs Judge decisions to seed calibration; audit trail only, no oversight process attached. | Verify against source |
| PA-1.4 | Privileged Agent Governance | P1 | Full | [direct] Register of all privileged agents, updated on topology change and reviewed monthly, delivers asset-inventory oversight. | Verify against source |
| PA-2.1 | Privileged Agent Governance | P1 | Partial | [direct] Independent model verifies orchestrator plans against intent, an oversight check, but agent-level and not an independent risk/audit function. | Verify against source |
| PA-2.2 | Privileged Agent Governance | P1, P5 | Partial | [direct] Monthly calibration against accuracy thresholds tests evaluator effectiveness; scoped to the Judge, not enterprise control testing. | Verify against source |
| PA-2.3 | Privileged Agent Governance | P1 | Full | [direct] Version-controlled Judge criteria with approval trail and human review is sound change governance, no silent updates. | Verify against source |
| PA-2.4 | Privileged Agent Governance | P1 | Full | [direct] Owner-declared precedence order and resolution protocol governs conflicting multi-judge verdicts by design. | Verify against source |
| PA-2.5 | Privileged Agent Governance | P1, P5 | Partial | [direct] Tracks observer false-positive/negative rates monthly; monitors the detector itself, not enterprise cyber surveillance. | Verify against source |
| PA-2.6 | Privileged Agent Governance | P1, P3 | Full | [direct] Kill-switch dual authorisation delivers authority-control governance (P1 full); P3 fail-safe availability angle only partial. | Verify against source |
| PA-2.7 | Privileged Agent Governance | P5, P1 | Partial | [direct] Baselines orchestrator decisions and monitors drift via anomaly scoring; agent-scoped surveillance, not enterprise. | Verify against source |
| PA-2.8 | Privileged Agent Governance | P5, P1 | Partial | [direct] Quarterly adversarial red team of orchestrator/judge/observer; agent-focused, explicitly not an independent IT audit function. | Verify against source |
| PA-3.1 | Privileged Agent Governance | P1, P5 | Partial | [direct] Judge evaluates orchestrator's aggregated output to catch smoothed-over failures; assurance check, not a governance function. | Verify against source |
| PA-3.2 | Privileged Agent Governance | P1 | Partial | [direct] Explicit sub-orchestrator permission boundaries govern delegation, but only internal agent scope, not enterprise access management. | Verify against source |
| PA-3.3 | Privileged Agent Governance | P1 | Partial | [direct] Per-sub-tree blast-radius caps enforce aggregate risk limits; containment control, not enterprise governance. | Verify against source |
| PA-3.4 | Privileged Agent Governance | P5 | Partial | [direct] Model-as-Judge rotation counters long-term adversarial adaptation; single anti-evasion control, evaluator-scoped. | Verify against source |
| PA-3.5 | Privileged Agent Governance | P5, P1 | Partial | [direct] Daily continuous calibration feeds anomaly scoring and PACE escalation on failure; evaluator-scoped monitoring only. | Verify against source |
| PA-3.6 | Privileged Agent Governance | P5, P3 | Partial | [direct] Observer self-test injects synthetic anomalies to confirm detection is operational; scoped to the observer. | Verify against source |
| PA-3.7 | Privileged Agent Governance | P1, P5 | Partial | [direct] Evaluation at each nested orchestration level extends oversight/assurance across levels; agent-scoped, not enterprise governance. | Verify against source |

### Model Cognition Assurance (MC)

| Control | Domain | TRM pillar(s) | Coverage | Note | Verify |
|---|---|---|---|---|---|
| MC-1.1 | Model Cognition Assurance | XC, P2 | Partial | [direct] Quarterly inventory records provider attestation status only; text says attestation is not a guarantee of adequacy, so vendor vetting is incomplete. | Verify against source |
| MC-1.2 | Model Cognition Assurance | XC, P2 | Partial | [direct] Logs provider-disclosed alignment behaviours but disclosure is voluntary at Tier 1, leaving an unenforced third-party vetting gap. | Verify against source |
| MC-1.3 | Model Cognition Assurance | P2, XC | Partial | [inferred] Classifies models white/grey/black-box as a risk-framework input; classification only, mitigation deferred to later controls. | Verify against source |
| MC-1.4 | Model Cognition Assurance | XC, P2 | Partial | [direct] Requests interpretability evidence but is non-contractual at Tier 1, so no enforceable vendor obligation exists. | Verify against source |
| MC-1.5 | Model Cognition Assurance | P5 | Partial | [direct] Logs and manually samples CoT against actions; surveillance is sampled not continuous and CoT can be unfaithful. | Verify against source |
| MC-1.6 | Model Cognition Assurance | P5 | Partial | [direct] Verifies a 10% task-completion sample against ground truth; sampled baseline only, not full assurance. | Verify against source |
| MC-2.1 | Model Cognition Assurance | XC, P2 | Partial | [direct] Formal vendor assessment reviews interpretability evidence against an adequacy checklist; evaluates methodology, cannot reproduce it. | Verify against source |
| MC-2.2 | Model Cognition Assurance | XC, P2 | Partial | [direct] Requires provider disclosure into the AIBOM but permits non-disclosure via risk-owner sign-off, leaving a residual vetting gap. | Verify against source |
| MC-2.3 | Model Cognition Assurance | P5, P2 | Partial | [direct] Adversarial CoT consistency testing (20 cases/quarter) misses consistently-unfaithful CoT that produces no divergence. | Verify against source |
| MC-2.4 | Model Cognition Assurance | P1, P2 | Partial | [direct] Documents CoT-monitoring residual risk with risk-owner acceptance; this is risk acceptance, not mitigation. | Verify against source |
| MC-2.5 | Model Cognition Assurance | P5 | Partial | [direct] Establishes 30-day behavioural baselines with variance bands; baseline input only, detection sits in MC-2.6. | Verify against source |
| MC-2.6 | Model Cognition Assurance | P5 | Full | [direct] Statistical reward-hacking anomaly detection with >2 sigma alerting delivers cyber-surveillance monitoring; novel signatures evade until baseline adapts. | Verify against source |
| MC-2.7 | Model Cognition Assurance | P2, P1, XC | Partial | [direct] Documents black-box activation residual risk with risk-owner sign-off; risk acceptance, gap reduced not eliminated. | Verify against source |
| MC-2.8 | Model Cognition Assurance | XC, P2 | Full | [direct] Procurement-stage vendor interpretability attestation scored on a defined maturity scale delivers third-party vetting; measures structure not effectiveness. | Verify against source |
| MC-2.9 | Model Cognition Assurance | P6, XC | Full | [direct] Contractual material-finding disclosure specifies a timeframe: within 5 business days of internal confirmation (vendor-to-operator disclosure). | Verify against source |
| MC-2.10 | Model Cognition Assurance | P6, XC | Full | [direct] Alignment-incident notification specifies a timeframe: recommended maximum 72 hours from vendor confirmation (vendor-to-operator, not operator-to-regulator). | Verify against source |
| MC-3.1 | Model Cognition Assurance | XC, P2 | Partial | [direct] Independent activation-layer validation verifies vendor attestations but only where white-box access exists; interpretability science immature. | Verify against source |
| MC-3.2 | Model Cognition Assurance | P5 | Partial | [direct] Activation-CoT correlation flags reasoning misalignment but depends on an immature activation-to-semantics mapping with no standard. | Verify against source |
| MC-3.3 | Model Cognition Assurance | P5 | Full | [direct] Quarterly adversarial reward-hacking red team delivers offensive cyber-security testing; limited to anticipated shortcut strategies. | Verify against source |
| MC-3.4 | Model Cognition Assurance | P2, P1 | Partial | [direct] Composite cognition assurance score quantifies residual risk, reviewed annually; proxy metrics capture observable not total risk. | Verify against source |
| MC-3.5 | Model Cognition Assurance | XC, P2 | Full | [direct] Contractual independent vendor audit rights deliver third-party audit assurance; audit scope bounded by the state of interpretability science. | Verify against source |

### Agentic Task Mandate (AT)

| Control | Domain | TRM pillar(s) | Coverage | Note | Verify |
|---|---|---|---|---|---|
| AT-1.1 | Agentic Task Mandate | P1, P2 | Full | [direct] Pre-deployment mandate declaration and process/technical owner approval deliver governance and TRM control; [inferred] deploy gate resembles P4 but is governance not project mgmt. | Verify against source |
| AT-1.2 | Agentic Task Mandate | P1, P2 | Full | [direct] Per-agent role/boundary declaration bound to parent inheritance delivers governance and TRM control. | Verify against source |
| AT-1.3 | Agentic Task Mandate | P1, P2 | Full | [direct] Versioned immutable mandate library maps to P1/P2; [inferred] production-equivalent change control resembles P4 change lifecycle. | Verify against source |
| AT-1.4 | Agentic Task Mandate | P2, P5 | Partial | [direct] Structural infrastructure-layer allow-list is a preventive security control; no surveillance/detection, so P5 leaves a monitoring gap. | Verify against source |
| AT-1.5 | Agentic Task Mandate | P2, P5 | Partial | [direct] Full tool-call execution trace is the monitoring evidence base only; detection/analysis is Tier 2, leaving a surveillance gap. | Verify against source |
| AT-1.6 | Agentic Task Mandate | P5 | Full | [direct] Blocked-attempt logging forwarded to SIEM and framed as reconnaissance indicator directly serves cyber surveillance. | Verify against source |
| AT-1.7 | Agentic Task Mandate | P3, P6 | Partial | [direct] Immediate halt with human-authorised logged override supports incident/circuit-breaker response; no regulatory notification timeframe; [inferred] P3 resilience link. | Verify against source |
| AT-2.1 | Agentic Task Mandate | P1, P2 | Full | [direct] Automated deployment-time inheritance validation prevents privilege escalation; [inferred] control gate resembles P4. | Verify against source |
| AT-2.2 | Agentic Task Mandate | P1, P2 | Full | [direct] Scheduled and trigger-based mandate review with owner re-approval delivers governance oversight and TRM upkeep. | Verify against source |
| AT-2.3 | Agentic Task Mandate | P2, P5 | Full | [direct] Least-privilege tool provisioning with substitute-tool analysis delivers a core security/risk control. | Verify against source |
| AT-2.4 | Agentic Task Mandate | P2 | Full | [direct] Orchestration-layer sequence enforcement is a structural execution-integrity control. | Verify against source |
| AT-2.5 | Agentic Task Mandate | P2, P3 | Partial | [direct] Idempotency keys prevent duplicate irreversible actions, supporting operational integrity; [inferred] broader P3 resilience/DR link. | Verify against source |
| AT-2.6 | Agentic Task Mandate | P2, P5 | Full | [direct] Four-state means/outcome monitoring delivers a detection framework central to cyber surveillance. | Verify against source |
| AT-2.7 | Agentic Task Mandate | P5 | Full | [direct] Tool-sequence comparison detects creative substitution, a surveillance/detection capability. | Verify against source |
| AT-2.8 | Agentic Task Mandate | P5 | Full | [direct] Plan attempt trending is behavioural threat detection feeding threat-intel escalation triggers. | Verify against source |
| AT-2.9 | Agentic Task Mandate | P1, P6 | Partial | [direct] Predetermined escalation to human oversight supports incident response; no regulatory notification timeframe named, P6 gap. | Verify against source |
| AT-2.10 | Agentic Task Mandate | P1, P2 | Full | [direct] Governed human-approved runtime mandate amendment with version linkage delivers change governance. | Verify against source |
| AT-2.11 | Agentic Task Mandate | P1, P5 | Full | [direct] Independent read-only compliance judge for HIGH/CRITICAL delivers oversight plus security assurance monitoring. | Verify against source |
| AT-2.12 | Agentic Task Mandate | P1 | Full | [direct] Judge governed by its own independently-reviewed mandate delivers governance and segregation. | Verify against source |
| AT-2.13 | Agentic Task Mandate | P5, P6 | Partial | [direct] Structured SIEM-ingestible verdicts serve security ops; incident-response use lacks a notification timeframe, P6 gap. | Verify against source |
| AT-2.14 | Agentic Task Mandate | XC, P2 | Full | [direct] Mandatory third-party vendor disclosure of agentic behavioural characteristics delivers supplier vetting. | Verify against source |
| AT-2.15 | Agentic Task Mandate | XC, P1, P2 | Full | [direct] API-consumed model residual risk declared in risk register with owner sign-off delivers third-party/API risk governance. | Verify against source |
| AT-3.1 | Agentic Task Mandate | P5, P1 | Full | [direct] Longitudinal cross-session drift detection with governance-review trigger delivers surveillance plus oversight. | Verify against source |
| AT-3.2 | Agentic Task Mandate | P5 | Full | [direct] Four-level judge evaluation (tool/sequence/logic/pattern) deepens means-compliance detection. | Verify against source |
| AT-3.3 | Agentic Task Mandate | P1, P5 | Full | [direct] Judge independence owned by security function with unfiltered reporting delivers segregation-of-duties governance. | Verify against source |

### Environment Containment (ENV, cross-cutting)

| Control | Domain | TRM pillar(s) | Coverage | Note | Verify |
|---|---|---|---|---|---|
| ENV-1 | Environment Containment (cross-cutting) | P5 | Full | [direct] Per-parameter schema validation (type, length, range, format) is a core secure-API operation. | Verify against source |
| ENV-2 | Environment Containment (cross-cutting) | P5 | Partial | [direct] OpenAPI/JSON-Schema contract enforces well-formedness at design time; no runtime surveillance or threat detection. | Verify against source |
| ENV-3 | Environment Containment (cross-cutting) | P5 | Partial | [direct] Allowlist fails safe against novel input; one preventive facet, adds no detection capability. | Verify against source |
| ENV-4 | Environment Containment (cross-cutting) | P5 | Full | [direct] Per-call authorization on NHI, resource, and operation is a core access-control operation. | Verify against source |
| ENV-5 | Environment Containment (cross-cutting) | P5 | Partial | [direct] Binary pass/fail closes error-based reconnaissance; single info-disclosure control only. | Verify against source |
| ENV-6 | Environment Containment (cross-cutting) | P5 | Partial | [direct] Suppressing stack traces, SQL errors, and paths prevents leakage; narrow disclosure control. | Verify against source |
| ENV-7 | Environment Containment (cross-cutting) | P5, P6 | Partial | [direct] Server-side error logging aids operator debugging and incident investigation; passive logging, no active alerting. | Verify against source |
| ENV-8 | Environment Containment (cross-cutting) | P5 | Full | [direct] Stored-procedures-only eliminates SQL injection as an attack class at the DB layer. | Verify against source |
| ENV-9 | Environment Containment (cross-cutting) | P5 | Partial | [direct] Parameterized queries block SQL interpretation of input; fallback subset of the ENV-8 stored-procedure control. | Verify against source |
| ENV-10 | Environment Containment (cross-cutting) | P5 | Partial | [direct] DB-enforced row-level security on NHI backstops app-layer filtering; data-layer facet only. | Verify against source |
| ENV-11 | Environment Containment (cross-cutting) | P5 | Partial | [direct] CHECK/FOREIGN KEY/UNIQUE/NOT NULL enforce data integrity at the DB; integrity control, not surveillance. | Verify against source |
| ENV-12 | Environment Containment (cross-cutting) | P5, P3 | Partial | [direct] Read replicas remove write access to limit blast radius; [inferred] replica offload also aids availability. | Verify against source |
| ENV-13 | Environment Containment (cross-cutting) | P5 | Partial | [direct] System-prompt no-retry directive is behavioral and, per text, overridable by injection; weakest anti-abuse layer. | Verify against source |
| ENV-14 | Environment Containment (cross-cutting) | P5 | Partial | [direct] Server-side cooldown rejects near-identical retries per NHI; rate-limit facet, per-endpoint only. | Verify against source |
| ENV-15 | Environment Containment (cross-cutting) | P5 | Partial | [direct] Gateway retry budget caps brute-force exploration; [inferred] curbs resource exhaustion; rate-control facet only. | Verify against source |
| ENV-16 | Environment Containment (cross-cutting) | P5 | Full | [direct] DLP scanning across all agent-accessible channels is a core data-exfiltration cyber-security operation. | Verify against source |
| ENV-17 | Environment Containment (cross-cutting) | P5 | Full | [direct] Transaction monitoring treats agent-initiated transactions like human ones; scoped to agent transactions, text does not extend to customer/online-banking fraud or customer 2FA. | Verify against source |
| ENV-18 | Environment Containment (cross-cutting) | P5 | Full | [direct] WAF on agent-facing APIs is a core perimeter control catching injection, tampering, and protocol violations. | Verify against source |
| ENV-19 | Environment Containment (cross-cutting) | P5, P6 | Full/Partial | [direct] SIEM correlation of agent and non-AI events delivers cyber surveillance (Full P5); feeds incident detection but not the reporting/notification workflow (Partial P6). | Verify against source |
| ENV-20 | Environment Containment (cross-cutting) | P5 | Full | [direct] Network segmentation with explicit egress rules isolates agents and blocks lateral movement. | Verify against source |
| ENV-21 | Environment Containment (cross-cutting) | P5, P6 | Full/Partial | [direct] Infra kill switch terminates agent under 30s (revoke NHI, block network, kill compute); delivers containment (Full P5), not P6 regulatory notification (Partial P6). | Verify against source |
| ENV-22 | Environment Containment (cross-cutting) | P5, P6 | Full/Partial | [direct] DLP, fraud, and anomaly alerts auto-fire the kill switch; automated detection-to-response (Full P5), no reporting workflow (Partial P6). | Verify against source |
| ENV-23 | Environment Containment (cross-cutting) | P5 | Partial | [direct] Kill switch on separate infra, creds, and monitoring resists compromised orchestration; resilience of one control, not broad ops. | Verify against source |
| ENV-24 | Environment Containment (cross-cutting) | P6, P5 | Full/Partial | [direct] Kill activation preserves state, logs, and in-flight transactions for forensics (Full P6 investigation); supports investigation but not regulatory notification (Partial P5 ops). | Verify against source |

## Gap summary

Coverage is dense where MASO does its job (**P5 cyber security operations**) and on **third-party/API vetting (XC)**, and genuinely thin everywhere the TRM Guidelines reach beyond agent runtime. The credibility of this crosswalk is in the gaps, so they are stated plainly.

**Coverage overview (236 mapped control-rows: 212 core + 24 ENV).** Ratings: 89 Full, 138 Partial, 5 split Full/Partial (by pillar), 4 None. Pillar reach counts rows that cite each pillar (a control can map to several, so these sum to more than 236):

| TRM pillar | Rows mapped | Read |
|---|--:|---|
| P5 Cyber security operations | 132 | Dominant. MASO's core; most *Full* ratings sit here. |
| P2 Technology risk management framework | 80 | Broad but agent-scoped risk controls, not an enterprise TRM framework. |
| P1 Governance and oversight | 62 | Present via mandates/roles/accountability; governs the agent estate, not the enterprise. |
| XC Third-party / API-access vetting | 29 | Genuine strength (Supply Chain, vendor attestation, disclosure). |
| P3 IT operations and system resilience | 24 | Thin. Runtime failover/rollback only; no DR or backup-restore testing. |
| P6 Incident management and reporting | 23 | Thin. Detection/forensics yes; regulatory notification timeframes almost entirely absent. |
| P4 IT project management | 5 | Effectively absent; all links `[inferred]`. |

### Confirmed strong

- **P5, Cyber security operations (incl. surveillance, threat intel).** MASO's home turf, as expected. Nearly every IA, OB, DP, SC, MC, AT and ENV control carries a P5 mapping, and the *Full* ratings cluster here (sandboxing EC-2.2/EC-3.1, DLP DP-2.1/ENV-16, anomaly and drift surveillance OB-2.2/OB-2.3, SIEM OB-2.4/ENV-19, WAF/segmentation ENV-18/ENV-20, red-team MC-3.3/PG-3.6). Treat this as confirmation, not comfort: it says MASO is a strong security-operations layer, not that it covers the pillar's governance and reporting expectations.
- **XC, Third-party / API-access vetting.** Stronger than the brief anticipated. Supply Chain provides real vetting gates (SC-1.3, SC-2.3, SC-3.4), signing and integrity (SC-2.2, SC-2.4, SC-3.3); Model Cognition adds enforceable vendor attestation and audit rights (MC-2.8, MC-3.5); Agentic Task Mandate adds vendor disclosure (AT-2.14, AT-2.15). Inventory-only controls (SC-1.1/1.2/1.4, MC-1.x) stay *Partial* because they document rather than decide.

### Confirmed weak or absent (the expected gaps)

- **P3, IT operations and system resilience (DR, backup testing).** Weak, confirmed. Resilience appears only as runtime failover and rollback (EC-2.10, EC-3.2, EC-3.5, SC-3.1, SC-3.2, ENV-12, OI-3.4). **No control specifies disaster-recovery or backup-restore testing.** Failover is exercised as an activation check, never as a periodic DR drill. Every P3 row is *Partial* with this same named gap.
- **Online financial services (customer authentication / 2FA).** Absent, confirmed. All identity controls (IA-*) govern **non-human agent identities**, not customers. ENV-17 fraud monitoring is explicitly scoped to *agent-initiated* transactions and the text does not extend to customer online-banking fraud or customer 2FA. This is entirely outside MASO's scope.
- **IT audit / independent assurance.** Weak, confirmed with nuance. Independent-flavoured controls exist (OB-3.3 independent observability agent, PA-2.8 red team, PA-2.5 observer precision, MC-3.5 independent vendor audit rights), but each is explicitly **agent-scoped and not an independent enterprise IT audit function**. MASO can feed an audit; it does not constitute one.
- **P6, Incident management and regulatory reporting timeframes.** Weak, confirmed with one important nuance. Detection, containment and forensics are well covered (OB logging, EC circuit breakers/rollback, ENV kill switch and post-kill forensics ENV-24, AT escalation). But **the only controls that name a notification timeframe are MC-2.9 (5 business days) and MC-2.10 (72 hours), and both are vendor-to-operator disclosures, not operator-to-MAS regulatory notification.** No control defines a regulatory reporting timeframe to the supervisor. Every other P6 row is *Partial* for exactly this reason.

### Also thin (not in the brief's list, but clearly absent)

- **P4, IT project management.** Essentially unmapped. A few mandate/change-control controls (AT-1.1, AT-1.3, AT-2.1, OI-1.5, SC-1.3, SC-3.5) touch change gates, but these are governance/deployment gates, not an SDLC or project-management lifecycle. Almost every P4 link in the table is flagged `[inferred]`.
- **P1 / P2 are supported but agent-scoped.** Governance (PA, OB accountability, OI OISpec governance, AT mandates) and the risk framework (DP classification, MC risk register, EC action classification) are present and sometimes *Full*, but they govern the **agent estate**, not the enterprise. They supplement an existing TRM governance and risk-management function; they do not replace it.

## Method and caveats

- **Grounding.** Each row was mapped from the control's actual text on its canonical page under `docs/maso/controls/` (ENV from `docs/maso/environment-containment.md`), not from memory. IDs and counts were verified against `MASO-CONTROL-AUDIT.md`.
- **Inference.** MASO controls never reference the MAS TRM Guidelines, so mapping to a pillar is always an interpretation of function. Rows where even the control's *function-to-pillar* link is a stretch are flagged `[inferred]`; rows where the link follows plainly from the control text are `[direct]`. The Prompt/Goal/Epistemic (PG) and Objective Intent (OI) domains are almost entirely `[inferred]` because they address AI-native risks with no classical TRM analogue.
- **No clause numbers.** This is a pillar-level crosswalk. It deliberately cites no MAS TRM section numbers; every row is marked "Verify against source" so nothing here is mistaken for a verified clause citation.
- **Tier proportionality.** The 212 core controls are the Tier-3 ceiling. A Tier-1 (Supervised) deployment applies 61 of them, so real-world coverage against any pillar is smaller than the full table implies.
