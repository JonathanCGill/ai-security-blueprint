---
description: "MASO extraction integrity controls: field-level confidence, authoritative cross-referencing, and provenance for document OCR and parsing in agentic pipelines."
---

# MASO Control Domain: Document Extraction Integrity

> Part of the [MASO Framework](../README.md) · Control Specifications
> Covers: LLM04 (Data/Model Poisoning) · LLM09 (Misinformation) · ASI04 (Resource Overload via input) · ASI06 (Memory & Context Poisoning)
> Also covers: EP-03 (Hallucination Amplification) · EP-06 (Uncertainty Stripping) · DR-03 (Derived Data Elevation)

## Principle

Extracted data is not observed data. When an agent performs OCR, PDF parsing, form extraction, or any transformation from a document into structured fields, the output is a probabilistic reading of a source artefact. Downstream agents must not treat that reading as ground truth. Confidence must be measured per field, classified by downstream impact, cross-referenced against authoritative systems for critical fields, and preserved through every subsequent handoff. Agents must not act on uncertain extracted data as though it were verified fact.

In regulated financial services, misextraction of a single identity field creates direct regulatory exposure: KYC and FICA failures, sanctions screening against the wrong person, misdirected payments, and POPIA breaches from records linked to the wrong individual. Extraction is a trust boundary, not a utility function.

## Why This Matters in Multi-Agent Systems

**Extraction output becomes authoritative by default.** Once a value enters the message bus as a field (`id_number: "8001015009087"`), downstream agents have no way to distinguish it from a value read out of a core banking system. The field looks the same. Without explicit confidence metadata, uncertainty is silently dropped at the first handoff, and every subsequent agent treats the value as verified.

**Extraction errors are not edge cases.** OCR misreads a `0` as `O`, a `1` as `I`, a comma as a decimal point. PDF parsers split a surname across two fields. A utility bill's service address is pulled instead of the customer's residential address. These are ordinary operational outcomes at the volumes financial services processes documents, not exceptional failures. The framework must treat them as expected inputs to the pipeline.

**Downstream consequences compound.** A misread ID number flows from an onboarding agent to a sanctions screening agent to a customer record creation agent. Each stage succeeds on its own terms. The sanctions check returns clean because the wrong identity produces no hits. The customer record is created against a different person's identity. The failure is only visible at settlement, recovery, or regulatory inspection.

**Agents cannot self-correct on extraction.** The extracting model cannot tell you that it misread a digit; its confidence score is a property of the extraction, not a ground-truth comparison. Only an external authoritative source, the national ID registry, the existing customer record, the core banking account holder, can contradict the extraction. Self-consistency checks within the agent system do not constitute verification.

**Adversarial documents are an AI security problem, not just a fraud problem.** A tampered utility bill, a synthetic pay slip, or a metadata-altered PDF is an input the extraction agent will read confidently. The model has no prior for "this document is forged." Detection of document integrity sits at the intersection of fraud prevention and AI security, and the extraction pipeline must treat pre-extraction document verification as a first-class control.

## Controls by Tier

### Tier 1 - Supervised

| Control | Requirement | Implementation Notes |
|---------|-------------|---------------------|
| **EI-1.1** Field-level risk classification | Every extracted field mapped to a risk class: **critical identity** (ID number, full name, DOB), **critical operational** (account numbers, addresses, payment amounts), **low-impact** (document dates, reference numbers) | Classification is a property of the field's downstream use, not the source document. The same field can have different classes in different pipelines. |
| **EI-1.2** Per-field confidence scores | Extraction output emits a confidence score per field, not per document | A document-level score is insufficient. A pay slip can be read clearly overall while the employer name is ambiguous. |
| **EI-1.3** Extraction provenance record | Each extracted value carries: source document hash, extraction model/version, confidence score, timestamp, human-validation status | Stored alongside the value, not in a separate log. Travels with the field through subsequent processing. |
| **EI-1.4** Human validation on critical fields | Before any action on a critical identity or critical operational field, a reviewer sees the raw document image and the extracted value side by side | Reviewer must be able to see what the agent read. Presenting only the extracted value invites rubber-stamping. |
| **EI-1.5** Pre-extraction document checks | Before extraction begins: file format validation, metadata consistency checks, page count and size sanity checks, known-bad-template detection | Catches malformed and obviously suspect documents before they reach the extractor. |

### Tier 2 - Managed

All Tier 1 controls remain active, plus:

| Control | Requirement | Implementation Notes |
|---------|-------------|---------------------|
| **EI-2.1** Confidence thresholds by field class | Per-class thresholds enforced as gates. Critical identity fields require aggressive thresholds (recommended: ≥ 0.98). Critical operational fields require high thresholds (recommended: ≥ 0.95). Low-impact fields use tolerant thresholds (recommended: ≥ 0.80). Below threshold, autonomous action is blocked | Thresholds are policy, not model defaults. They are set by the risk owner per pipeline and reviewed as extraction performance is measured. |
| **EI-2.2** Authoritative source cross-referencing | Extracted critical identity and critical operational fields are validated against authoritative internal or external sources: core banking, existing customer record, national ID registry, sanctions list provider's reference data | Cross-reference is performed before the field is used in any material decision. Authoritative sources are named per field in the data flow diagram (DP-1.5). |
| **EI-2.3** Mismatch halt and route | Any mismatch between extracted value and authoritative source halts automated processing and routes to human review. Agents must not silently prefer one value over the other, and must not re-extract in a loop to produce agreement | The agent has no basis to decide which value is correct. Human review is the only correct response. Automatic fallback to the authoritative source is also not permitted without an audit entry. |
| **EI-2.4** Adversarial input detection | Document integrity verification before extraction: tampering indicators (inconsistent fonts, layer artefacts, clone detection), metadata inconsistencies (creation date after document date, mismatched producer strings), format anomalies, synthetic document indicators | Positioned at the boundary between fraud prevention and AI security. Suspect documents are quarantined and routed to a dedicated review queue, not returned to the requester for resubmission. |
| **EI-2.5** Confidence propagation on the message bus | Extracted fields travel with their confidence, provenance, and validation status as part of the message schema. Messages carrying extracted fields without this metadata are rejected by the bus | Extends DP-1.6 (classification metadata propagation) to extraction metadata. Without this, Tier 2 controls downstream are unenforceable. |
| **EI-2.6** Cumulative uncertainty enforcement | Confidence degrades, never improves, across handoffs. A field extracted at 0.82 cannot be presented downstream at 0.95. Where a downstream agent combines extracted fields into a derived value, the derived value's confidence is bounded by the lowest input confidence | Addresses uncertainty stripping (EP-06) in the extraction-specific case. Judge evaluation flags any downstream output that claims higher certainty than its upstream evidence supports. |

### Tier 3 - Autonomous

All Tier 2 controls remain active, plus:

| Control | Requirement | Implementation Notes |
|---------|-------------|---------------------|
| **EI-3.1** Real-time authoritative cross-check at decision point | For material decisions (onboarding, address update, payment above threshold), the authoritative source lookup is re-executed at the point of decision, not only at extraction time | Prevents the scenario where an extracted value was validated at ingestion, then the authoritative record changed before the decision is committed. |
| **EI-3.2** Independent dual extraction for critical fields | Critical identity fields extracted by two independent models on separate infrastructure. Values compared; any disagreement halts automated processing | Analogue of EP-C02 (model diversity) applied to extraction. Catches systematic OCR errors that a single model would reproduce consistently. |
| **EI-3.3** Field-level reconstructability | For any extracted field, the pipeline can reproduce: the source document hash, the model version used, the raw model output, the confidence score, the cross-reference results, and the human-validation decision | Satisfies regulatory inquiry requirements under FICA and POPIA. Reconstruction time from "regulator requests evidence" to "full trace produced" must be under 24 hours. |
| **EI-3.4** Synthetic document detection | Automated detection of AI-generated or heavily modified documents integrated into the pre-extraction pipeline. Detection failures feed back into EI-2.4 rule tuning | Detection capabilities evolve. This control requires an ongoing capability, not a one-time integration. |

## Testing Criteria

### Tier 1 Tests

| Test ID | Test | Pass Criteria |
|---------|------|---------------|
| EI-T1.1 | Field classification audit | Every extracted field in every pipeline has a documented risk class. No unclassified fields in production. |
| EI-T1.2 | Per-field confidence emission | Run 20 extractions across document types. Every output field carries a confidence score. Document-level-only scoring fails the test. |
| EI-T1.3 | Provenance completeness | Select 20 extracted values at random from production. Each has source document hash, model version, confidence, timestamp, and validation status attached. |
| EI-T1.4 | Side-by-side review | Observe 10 human validations on critical fields. In each, the reviewer has direct visual access to the source document image and the extracted value. |
| EI-T1.5 | Pre-extraction rejection | Submit 10 malformed or metadata-inconsistent documents. All are rejected before extraction begins with a reviewable reason. |

### Tier 2 Tests

| Test ID | Test | Pass Criteria |
|---------|------|---------------|
| EI-T2.1 | Threshold enforcement | Inject extractions below class threshold for each risk class. Autonomous action is blocked in 100% of cases and the pipeline routes to human review. |
| EI-T2.2 | Authoritative cross-reference coverage | For each critical identity and critical operational field, the authoritative source is named and the cross-reference is observable in the decision trace. |
| EI-T2.3 | Mismatch halt | Inject a known mismatch between extracted ID number and the core banking record. Processing halts. No silent preference for either value. No auto-retry of extraction. |
| EI-T2.4 | Adversarial document detection | Submit 30 test documents: 10 tampered (font mixing, clone regions), 10 metadata-inconsistent, 10 synthetic. Detection rate ≥ 85%. Missed documents are added to the regression set. |
| EI-T2.5 | Metadata propagation | Send 10 messages containing extracted fields through the bus. Each carries confidence, provenance, and validation status. A message without this metadata is rejected. |
| EI-T2.6 | Cumulative uncertainty | Chain three agents each consuming a prior agent's extracted output. Verify confidence on the final output is at most the minimum of the chain, and that uncertainty markers are preserved through each handoff. |

### Tier 3 Tests

| Test ID | Test | Pass Criteria |
|---------|------|---------------|
| EI-T3.1 | Decision-time re-check | Between extraction and decision, modify the authoritative record. The decision-time cross-check detects the change and halts. |
| EI-T3.2 | Dual extraction divergence | Submit 20 documents to the dual extraction pipeline. Where the two models disagree on a critical field, processing halts in 100% of cases. |
| EI-T3.3 | Reconstructability drill | Select a historical extracted value at random. Reconstruct the full trace end to end within 24 hours. All artefacts present and internally consistent. |
| EI-T3.4 | Synthetic document regression | Quarterly regression suite of known synthetic documents executed. Detection rate reported. Regressions trigger detector review before deployment. |

## Maturity Indicators

| Level | Indicator |
|-------|-----------|
| **Initial** | Extraction output consumed as fact. No per-field confidence. No cross-referencing. Human review present but rubber-stamped. |
| **Managed** | Field-level risk classification documented. Per-field confidence emitted. Provenance record attached. Side-by-side review for critical fields. |
| **Defined** | Confidence thresholds enforced by class. Authoritative cross-referencing operational for critical fields. Mismatches halt processing. Adversarial input detection active. Confidence travels on the bus. |
| **Quantitatively Managed** | Threshold effectiveness measured against downstream error rates. Adversarial detection rate tracked. Cross-reference latency and failure modes reported. Uncertainty propagation verified through regression testing. |
| **Optimising** | Decision-time authoritative re-check. Dual-model extraction for critical identity fields. Full field-level reconstructability within regulatory SLA. Synthetic document detection continuously tuned. |

## Field Risk Classification Reference

The classification below is indicative for a financial services onboarding pipeline. Each organisation must produce its own mapping per pipeline.

| Class | Fields (examples) | Misextraction Consequence | Minimum Control Regime |
|-------|-------------------|---------------------------|------------------------|
| **Critical identity** | National ID number, passport number, full name, date of birth, nationality | Misidentification of customer, sanctions screening against wrong identity, FICA and POPIA breach, account linked to wrong individual | EI-1.1 through EI-1.4, EI-2.1 (aggressive threshold), EI-2.2, EI-2.3, EI-2.6 |
| **Critical operational** | Bank account number, beneficiary details, residential address, payment amount, IBAN/SWIFT | Misdirected funds, correspondence to wrong recipient, payment to unintended account, audit breaks | EI-1.1 through EI-1.4, EI-2.1 (high threshold), EI-2.2 where an authoritative source exists, EI-2.3 |
| **Low-impact** | Document issue date, reference numbers, free-text descriptions, marketing consent flags | Recoverable errors. Operational annoyance, not regulatory or financial loss | EI-1.1, EI-1.2, EI-1.3. EI-2.1 with tolerant threshold. |

Classification drives the control regime. Applying critical-identity controls to low-impact fields creates human review fatigue that degrades attention on the fields that matter. Applying low-impact controls to critical identity fields creates regulatory exposure. Proportionality is the design goal.

## Relationship to Other Control Domains

Extraction integrity sits between several existing domains and does not replace any of them.

**Data Protection (DP).** DP-1.6 mandates classification metadata propagation on the bus. EI-2.5 extends that to extraction metadata. DP-2.5 covers derived data reclassification when fields are combined; EI-2.6 covers confidence degradation over the same handoffs. Both apply where an extracted field enters a combination.

**Observability (OB).** OB-2.1 captures the decision chain. The extraction provenance record in EI-1.3 is the extraction-specific contribution to that chain. OB-2.5a (context utilisation monitoring) is relevant where an extraction agent processes very large documents that can saturate context and degrade extraction reliability.

**Execution Control (EC).** EC-2.5 (judge) evaluates whether an action is within declared bounds. For actions on extracted data, the judge must have visibility to the confidence and cross-reference status, not just the extracted value. Without that visibility, the judge cannot distinguish a verified field from a probabilistic reading.

**Epistemic Risks (Risk Register).** EI-2.6 is the extraction-specific expression of EP-C06 (uncertainty preservation). EI-2.3 addresses the extraction-specific form of EP-03 (hallucination amplification), where an extracted value is treated as ground truth by downstream agents.

## Common Pitfalls

**Treating document-level confidence as sufficient.** A 0.96 document-level score can contain a 0.62 field. Document-level scoring hides the fields that matter and produces false assurance.

**Letting the extraction agent decide between extracted and authoritative values.** When the extracted ID number disagrees with the core banking record, the agent has no basis to pick one. Any silent resolution is wrong. The only correct response is a halt and a human review. Automatic fallback to the authoritative source without audit is also wrong; the discrepancy itself is information.

**Rubber-stamping human review.** Showing the reviewer the extracted value alone trains the reviewer to approve. The raw document image must be visible next to the extracted value, and the review UI must make comparison the primary action, not a secondary one.

**Dropping confidence at the first handoff.** If Agent A extracts `id_number: "8001015009087"` at 0.82 confidence and passes only the string to Agent B, Agent B treats it as fact. Confidence must be a first-class part of the message schema, not optional metadata.

**Confusing extraction confidence with correctness.** Confidence is a property of the extractor's belief, not of the truth. A confidently extracted value can still be wrong, particularly on adversarial documents. Cross-referencing against authoritative sources is the check on correctness, not the confidence score.

**Treating adversarial document detection as a fraud-team problem.** Synthetic and tampered documents are inputs the extraction pipeline will confidently process. Moving detection to a fraud team after extraction misses the point. Detection must precede extraction, and the pipeline must treat "document is suspect" as a first-class output.

**Applying uniform thresholds.** One threshold across all fields either drowns reviewers in alerts on low-impact fields or lets critical identity fields through at unsafe confidence. Thresholds must be set per field class and reviewed as production data accumulates.

**Losing reconstructability.** If the extraction model is updated or the document is re-ingested, the original extraction artefact can be lost. Without the original, regulatory inquiry cannot be answered. Provenance records must be immutable and versioned.

!!! info "References"
    - [MASO Data Protection](data-protection.md)
    - [MASO Observability](observability.md)
    - [MASO Emergent Risk Register](risk-register.md)
    - [Environment Containment](../environment-containment.md)
