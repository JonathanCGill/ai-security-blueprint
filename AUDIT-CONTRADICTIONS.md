---
description: Cross-reference of factual claims across pages on airuntimesecurity.io. Flags every place where one page asserts a value that another page contradicts.
---

# Contradictions Audit

*Audit date: 2026-04-14. Method: every claim is grounded against the actual source files cited; line numbers given so each finding can be verified in seconds.*

This report covers four categories specifically: (1) methodology steps, feature lists, capability descriptions; (2) contact details, social links, addresses; (3) statistics, numbers, named entities; (4) repeated content blocks that have drifted.

## Executive summary

| # | Type | Where | What's wrong | Severity |
|---|---|---|---|---|
| 1 | Methodology | 7 places | "Three-layer" vs "four-layer" defence model | high |
| 2 | Methodology | 6 places | MASO has 7 vs 10 control domains | high |
| 3 | Methodology | 2 places | "Foundation Framework — 80 controls" mis-attribution | high |
| 4 | Capability | 2 places | "128 controls" repeated, never updated for new domains | medium |
| 5 | Methodology | 1 file | NIST RMF and NIST AI RMF used interchangeably in same document | medium |
| 6 | Named entity | 14+ places | OWASP Agentic Top 10 dated "(2026)" vs "(December 2025)" | medium |
| 7 | Named entity | 1 place | OWASP Agentic Top 10 link points at the LLM Top 10 page | high |
| 8 | Named entity | 4 places | "NeMo Guardrails" / "NeMo-Guardrails" / "NVIDIA NeMo" interchangeably | low |
| 9 | Repeated content | 4 places | Air Canada damages: $812 vs $812.02 | low |
| 10 | Repeated content | 3 places | Chevrolet quote drifts: comma vs hyphen separator | low |
| 11 | Repeated content | 2 places | Sister-site description differs subtly | low |
| 12 | Brand | 2 places | "Jonathan C. Gill" with middle initial vs canonical "Jonathan Gill" | low |
| 13 | Metric | 1 place | Repo README "Tests: 99" badge vs 173 actual test functions | low |
| Pass | Contact | — | Email, GitHub, LinkedIn handles all consistent | — |
| Pass | Methodology | — | PACE phases (Primary/Alternate/Contingency/Emergency) consistent | — |
| Pass | Methodology | — | Risk tier counts (4-tier risk + 3-tier implementation) consistent | — |
| Pass | Capability | — | Stakeholder list (9 personas) matches across nav, README, files | — |
| Pass | Capability | — | Red-team scenario count (16) matches between MASO README and playbook | — |
| Pass | Capability | — | Bio numbers ("30+ years IT, 20+ years enterprise security") consistent | — |

## 1. Methodology and capability contradictions

### 1.1 Three-layer vs four-layer defence model — high

Throughout the framework the architecture is called the **three-layer model**: Guardrails → Judge → Human Oversight. The Circuit Breaker is described as a separate construct that activates when all three layers have failed (`docs/PACE-RESILIENCE.md:21`).

Two top-of-funnel pages instead advertise it as **four layers**, listing Circuit Breaker as the fourth layer.

| File | Line | Framing |
|---|---|---|
| `docs/foundations/README.md` | 16 | "**Guardrails** → **Judge** → **Human Oversight** → **Circuit Breaker**" |
| `docs/foundations/README.md` | 38 | "Circuit Breaker stops all AI traffic and activates a non-AI fallback when any layer fails." |
| `docs/README.md` | 26 | "AIRS fixes that with **four layers of runtime defence**: guardrails … judge model … human oversight … and circuit breakers" |
| `docs/foundations/README.md` | 23 | "Explore the technical architecture - **three layers**, what fails when" |
| `docs/PACE-RESILIENCE.md` | 21 | "**Horizontal PACE** operates across the **three control layers**. … If Human Oversight is overwhelmed, the **Circuit Breaker activates**" |
| `docs/maso/README.md` | 100 | "MASO operates on a **three-layer defence model**" |
| `docs/MATURITY.md` | 19 | "The **three-layer model** (Guardrails, Judge, Human Oversight) exists in production at NVIDIA NeMo, AWS Bedrock, …" |

Same page (`foundations/README.md`) uses both framings — line 16 puts Circuit Breaker as a fourth layer, line 23 calls the architecture "three layers".

**Fix:** Pick one. The body of the framework (PACE, MASO, MATURITY, infrastructure mappings) consistently treats Circuit Breaker as a separate infrastructure-level fallback, so the cleanest fix is to rewrite `docs/README.md:26` and `docs/foundations/README.md:16` as three layers plus a circuit-breaker fallback, not as four equal layers.

### 1.2 MASO control domains: 7 or 10 — high

The MASO landing page is current (10 domains) and explicitly admits the framework grew from 7. Six pages still describe the old state.

**Source of truth (10 domains):**
- `docs/maso/README.md:31` — "The **ten control domains**, three implementation tiers, and PACE resilience model describe what needs to be true…"
- `docs/maso/README.md:126` — "**Ten control domains** address specific risk categories…"
- `docs/maso/README.md:136` — "The framework organises controls into **ten domains**."
- `docs/maso/README.md:282` — "All **ten control domains** fully implemented."
- `docs/maso/README.md:116` — explicitly: *"Seven coloured lines represent the **original seven control domains**. … Model Cognition Assurance, Agentic Task Contract, and Objective Intent were added after the tube map was created."*

**Stale (still says 7):**
| File | Line |
|---|---|
| `docs/ARCHITECTURE.md` | 49 |
| `docs/constraining-agents.md` | 170 |
| `docs/core/controls.md` | 158 |
| `docs/downloads.md` | 38 |
| `docs/extensions/regulatory/nist-ir-8596-alignment.md` | 214 |
| `docs/what-is-ai-runtime-security.md` | 76 (implicit; uses old framing) |

### 1.3 "128 controls" — medium (suspect)

The same six pages above also assert "128 controls". The MASO README never names a control count, so the source of truth for "128" is unclear. Adding three new domains without changing the total count is suspicious.

**Fix:** Recount controls under the current ten domains and update every "128 controls" to the new total (or remove the count if it cannot be authoritatively maintained).

### 1.4 "Foundation Framework — 80 controls" — high mis-attribution

The 80 controls live in the **Infrastructure** section. `docs/foundations/README.md:110` states this directly: *"the [infrastructure](../infrastructure/) section defines how — 80 technical controls across 11 domains."* Foundations itself describes the behavioural three-layer pattern; it does not contain 80 controls.

Two pages get the attribution wrong:

| File | Line | Text |
|---|---|---|
| `docs/ARCHITECTURE.md` | 36 | "→ **[Foundation Framework](foundations/)** - **80 controls**, risk tiers, implementation checklists" |
| `docs/what-is-ai-runtime-security.md` | 75 | "The [Foundation Framework](foundations/) for single-agent deployments (**80+ controls**)" |

**Fix:** Re-attribute to the Infrastructure section, or rephrase Foundation as "the three-layer behavioural pattern" without claiming a control count.

### 1.5 NIST RMF vs NIST AI RMF — medium (in-document drift)

`docs/core/risk-assessment.md` uses both names for what is the same standard (NIST AI RMF 1.0). The four functions cited (MAP / MEASURE / GOVERN / MANAGE) are AI-RMF specific; the original NIST RMF (SP 800-37) has different functions (Categorize / Select / Implement / Assess / Authorize / Monitor).

| Line | Wording | Comment |
|---|---|---|
| 9, 11, 13, 22, 377, 416 | "NIST AI RMF" | correct |
| 20 | "the methodology below follows the **NIST RMF lifecycle**: identify (MAP), measure (MEASURE)…" | should be "NIST AI RMF" |
| 379, 418, 423, 428, 433, 438, 442 | "NIST RMF Function" / "NIST RMF: MAP 1.1" etc. | should all be "NIST AI RMF" |

**Fix:** Replace every "NIST RMF" in this file with "NIST AI RMF". Outside this file the terminology is clean.

## 2. Named entities

### 2.1 OWASP Agentic Top 10 — wrong link target — high

`docs/maso/controls/agentic-task-contract.md:213` displays "OWASP Top 10 for Agentic Applications (2026)" but the URL points at the LLM Top 10 project page:

```
[OWASP Top 10 for Agentic Applications (2026)](https://owasp.org/www-project-top-10-for-large-language-model-applications/)
```

The correct URL (used elsewhere) is `https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/`.

### 2.2 OWASP Agentic Top 10 — date drift — medium

The same publication is cited with three different date suffixes:

| Form | Used in | Count |
|---|---|---|
| "(2026)" | `docs/REFERENCES.md:43`, `docs/maso/README.md:233` and 396, `docs/foundations/README.md:141`, `docs/MATURITY.md:18` and 58, `docs/infrastructure/mappings/owasp-llm-top10.md:107` and 219, `docs/insights/when-the-pattern-breaks.md:121` and 156, `docs/stakeholders/security-leaders.md:52`, `docs/core/iam-governance.md:333`, `docs/what-is-ai-runtime-security.md:91`, `docs/maso/controls/agentic-task-contract.md:213` | 12+ |
| "(December 2025)" | `docs/maso/threat-intelligence/threat-intelligence-review.md:18`, 90, 119, 159, 234, 391; `docs/extensions/technical/current-solutions.md:370` | 7 |
| "(Dec 2025)" | `docs/insights/what-scales.md:188`, `docs/insights/the-intent-layer.md:243` | 2 |

`docs/infrastructure/mappings/owasp-llm-top10.md:110` reconciles them: *"Updated March 2026 to align with the official OWASP Top 10 for Agentic Applications **released December 2025** at Black Hat Europe."*

**Fix:** Pick one canonical citation form (the OWASP project itself uses "for 2026" in the URL slug, so "(2026)" with a release-date footnote is the cleanest choice) and apply globally.

### 2.3 NeMo Guardrails name variants — low

| Form | Notable uses |
|---|---|
| "NVIDIA NeMo Guardrails" | full official product name (used in `REFERENCES.md`) |
| "NeMo Guardrails" | spaces, no NVIDIA prefix (`current-solutions.md`, `IMPLEMENTATION_GUIDE.md`) |
| "NeMo-Guardrails" | hyphenated, matches GitHub repo (`current-solutions.md`, `insights/why-guardrails-arent-enough.md`) |
| "NVIDIA NeMo" | shorthand, ambiguous (NeMo is a broader NVIDIA platform) (`MATURITY.md`, `foundations/README.md`) |

**Fix:** "NVIDIA NeMo Guardrails" on first reference; "NeMo Guardrails" thereafter. Reserve "NeMo-Guardrails" for the GitHub URL/repo identifier only.

## 3. Statistics and numbers

### 3.1 Air Canada damages: $812 vs $812.02 — low

| File | Line | Amount |
|---|---|---|
| `docs/REFERENCES.md` | 330 | "$812.02" |
| `docs/maso/threat-intelligence/incident-tracker.md` | 149 | "$812" |
| `docs/insights/risk-stories.md` | 65 | "$812" |
| `docs/insights/risk-stories.md` | 226 | "$812" |

The actual tribunal award was CAD $812.02. The framework rounds in three of four references.

**Fix:** Either standardise on $812.02 (precise) or $812 (rounded with "approximately").

### 3.2 Chevrolet quote drift — low

Same incident, same direct quote, three different transcriptions:

| File | Line | Quote |
|---|---|---|
| `docs/maso/threat-intelligence/incident-tracker.md` | 188 | "a legally binding offer**, ** no takesies backsies." |
| `docs/insights/risk-stories.md` | 11 | "a legally binding offer **-** no takesies backsies." |
| `docs/REFERENCES.md` | 348 | "legally binding **-** no takesies backsies." |

A direct quote should not vary across files. Pick the verified original wording and align.

### 3.3 Sampling-rate guidance vs Tier numbering

These are using two different tier systems (4-tier risk vs 3-tier implementation) and are internally consistent within their own system, but a casual reader will see different sampling percentages and not realise they apply to different things:

| Source | Tier | Recommended sample |
|---|---|---|
| `docs/QUICK_START.md:153-156` | LOW / MEDIUM / HIGH / CRITICAL | 1-5% / 5-10% / 20-50% / 100% |
| `docs/maso/reviews/stakeholder-review-judge-proliferation.md:49` | Tier 2 (Managed) | 25-50% |
| `docs/extensions/regulatory/platform-integration-guide.md:332` | Tier 2 (Managed) | 25% |
| `docs/maso/stress-test/ecommerce-10k-stress-test.md:143` | "HIGH" worker | 10% on advice, 100% on financial actions |

**Fix:** Each table should add a one-line note clarifying which tier system it uses (4-tier risk classification or 3-tier implementation).

### 3.4 Test count badge — low

`README.md:5` shows `Tests-99`. Actual `tests/test_*.py` files contain **173** test functions (10 files). The badge is stale.

## 4. Repeated content blocks that have drifted

### 4.1 Sister-site (AIruntimesecurity.co.za) description

Two near-duplicate marketing blurbs differ:

- `docs/README.md` — "AIruntimesecurity.co.za is a dedicated learning site for the **Multi-Agent Security Operations framework**. Structured guides, walkthroughs, and practical examples to help you get started."
- `docs/maso/README.md` — "AIruntimesecurity.co.za provides structured learning paths for the **Multi-Agent Security Operations framework**, from core concepts through to implementation."

**Fix:** Pick one. Or extract into a shared snippet/include if the templating engine supports it.

### 4.2 Author name — low

Canonical: "Jonathan Gill" (used 20+ times across mkdocs configs, ABOUT, infrastructure README, repo-root README, social handle names).

Variants with middle initial:
- `docs/README.md:162` — "Created by … Jonathan **C.** Gill"
- `docs/what-is-ai-runtime-security.md:95` — "*Jonathan **C.** Gill contributes to the AI Runtime Security discipline…*"

**Fix:** Drop the middle initial in those two places (or add it everywhere else). Pick one.

### 4.3 Framework one-liner

Already documented in §1.3 of `AUDIT-CONSISTENCY.md`. Four core surfaces describe AIRS as a *discipline*, a *framework*, or a *practice*. Same theme, different framing each time.

## 5. Confirmed clean

These were checked and found to be consistent across every place they appear:

- **Contact details.** `feedback@airuntimesecurity.io`, `github.com/JonathanCGill`, `linkedin.com/in/jonathancgill/` — identical wherever they appear, no other emails or social links anywhere.
- **PACE expansion.** "Primary, Alternate, Contingency, Emergency" — every site of expansion matches.
- **PACE phases.** Primary/Alternate/Contingency/Emergency descriptions in `PACE-RESILIENCE.md:91-94` are not contradicted elsewhere.
- **Risk tier counts.** Four-tier (LOW/MEDIUM/HIGH/CRITICAL) and three-tier (1/2/3) are consistently distinguished. Six scoring dimensions consistently cited.
- **MASO implementation tiers.** Tier 1 Supervised / Tier 2 Managed / Tier 3 Autonomous — used identically across `maso/README.md`, the three `tier-N-*.md` pages, and the red-team playbook.
- **Red-team scenarios.** "16 structured test scenarios" claimed in `maso/README.md:305`; the playbook has RT-01 through RT-16. Match.
- **Stakeholder list.** 9 personas in `mkdocs.yml` nav, in `docs/stakeholders/README.md`, and as 9 files. Match.
- **Author bio numbers.** "30+ years in IT, 20+ years in enterprise security" — consistent in `README.md`, `ABOUT.md`, `infrastructure/README.md`. Stylistic variants ("over 30" vs "30+") are not factual contradictions.
- **Package version.** `0.1.9` in `src/airs/__init__.py:3` and `pyproject.toml:7`. Match.
- **Cost rule of thumb.** "Security overhead 15-40% of generator cost at Tier 2, 40-100% at Tier 3" — same numbers in `maso/README.md:369` and `stakeholder-review-judge-proliferation.md:49`. Match.
- **Test cadence.** `red-team-playbook.md:21`: Tier 1 every deployment / Tier 2 monthly / Tier 3 quarterly. No contradicting cadence anywhere else.
- **OWASP LLM Top 10 (2025) version.** Consistently dated 2025 across all references; this is the published OWASP version year.
- **License.** MIT. Asserted consistently in `mkdocs.yml`, `mkdocs-pdf.yml`, `LICENSE`, `pyproject.toml`. (Year mismatch is documented separately in `AUDIT-CONSISTENCY.md`.)

## 6. Recommended remediation order

1. Fix the wrong link in `agentic-task-contract.md:213` (§2.1) — it's actively misleading users.
2. Resolve the three-vs-four layer framing (§1.1) — readers form their first mental model from `docs/README.md`.
3. Update "7 domains" / "128 controls" in the six stale pages (§1.2, §1.3).
4. Fix the Foundation/Infrastructure attribution (§1.4).
5. Standardise the OWASP Agentic Top 10 citation form (§2.2).
6. Standardise NIST RMF terminology in `core/risk-assessment.md` (§1.5).
7. Reconcile sampling-rate tables with explicit tier-system labels (§3.3).
8. Clean up the Air Canada amount, Chevrolet quote, sister-site blurb, author name, and stale test-count badge in one editorial pass.

!!! info "References"
    - [Broken-links audit](./AUDIT-BROKEN-LINKS.md)
    - [Consistency and accuracy audit](./AUDIT-CONSISTENCY.md)
