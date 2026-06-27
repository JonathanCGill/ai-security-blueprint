# External Review: Gap Analysis and Build Plan

> A response to the external review of airuntimesecurity.io that maps every recommendation to existing coverage, isolates what is genuinely missing, and proposes a page-by-page plan. No site content has been changed yet. This document exists for sign-off before any building starts.

## How to read this

The review scored the site highly and flagged four areas to strengthen: **identity**, **memory poisoning**, **model provenance/attestation**, and **economic abuse**. After auditing the docs, the headline finding is that the site already covers all four, and three of them in depth. The review appears to be a surface crawl: it did not reach the `extensions/technical/` and `core/` pages where most of this work already lives.

That changes the job. This is not "build four new domains from scratch." It is "elevate, consolidate, and close one real gap." The sections below separate what exists from what is missing so we only build what moves the needle.

## Verdict on the review

The strategic read in the review is sound and worth keeping: the site's strength is that it defines the operating model rather than a product, and the runtime-over-evaluation thesis is the right one. The specific weaknesses it lists are mostly already addressed. Treat its four recommendations as a prompt to check coverage and discoverability, not as a backlog of missing content.

## Recommendation-by-recommendation mapping

### 1. Identity ("add Agent Identity Runtime Control as a formal domain")

| | |
|---|---|
| **Review claim** | Identity is "the biggest gap"; should add a formal agent-identity domain (NHI, workload identity, ephemeral access, OAuth scopes, delegated credentials). |
| **What already exists** | `core/iam-governance.md` (authorisation-bypass-path threat model), `extensions/technical/nhi-lifecycle.md` (full provisioning-to-deprovisioning lifecycle, SPIFFE/SPIRE, OAuth client-credentials, delegation scope ≤ agent scope, user-context intersection), `infrastructure/agentic/delegation-chains.md`, `infrastructure/agentic/tool-access-controls.md`, `infrastructure/controls/identity-and-access.md`, `infrastructure/controls/secrets-and-credentials.md`, `infrastructure/controls/session-and-scope.md`, `maso/controls/identity-and-access.md`. |
| **Genuine gap** | Not content, but **framing and discoverability**. The material is spread across six-plus pages and is described in lifecycle/governance terms, not as *runtime, action-time identity enforcement* (verify the acting identity and its delegated scope at the moment of each tool call, not just at provisioning). There is no single entry point that names this and ties the pieces together. |
| **Proposed action** | A consolidating concept page (working title *Runtime Identity Enforcement*) that frames identity as an action-time control, links the existing lifecycle/delegation/scope pages, and adds the one missing angle: per-action identity-and-scope verification at the tool-call boundary. Light cross-linking from `iam-governance.md` and the architecture overview. **No new sprawling domain tree.** |
| **Effort** | Low to medium (one page plus cross-links). |

### 2. Memory poisoning ("elevate to its own first-class domain")

| | |
|---|---|
| **Review claim** | Memory poisoning is "embedded"; should be elevated; calls out vector-DB poisoning, episodic corruption, long-context manipulation, delayed-trigger attacks. |
| **What already exists** | `core/memory-and-context.md` is already a first-class core control and already covers gradual context poisoning, cross-session leakage, **sleeper memory poisoning** (dormant cross-session payloads, cites arXiv:2605.15338), **memory-targeted tool hijacking** (arXiv:2605.26154), and context-window overflow. `insights/the-memory-problem.md` carries the narrative version. |
| **Genuine gap** | Small. The page is threat-complete but light on two of the review's specifics as *named* vectors: **vector/embedding-store poisoning** (partially covered via OWASP "Vector and Embedding Weaknesses" mapping) and the **episodic vs semantic vs working memory** distinction that makes "delayed trigger" precise. |
| **Proposed action** | Extend `core/memory-and-context.md` in place: add a short memory-taxonomy subsection (working/episodic/semantic/vector) and a vector-store poisoning row with controls. Do **not** spin up a separate domain; it is already a core control and a parallel tree would fragment it. |
| **Effort** | Low (in-place extension). |

### 3. Model provenance / attestation ("signed models, prompts, tools; inference provenance; cryptographic trust")

| | |
|---|---|
| **Review claim** | Site touches evidence but not cryptographic trust; future enterprise/EU demand will require signed models, signed prompts, signed tools, inference provenance, audit attestation. |
| **What already exists** | `core/controls/data-provenance-and-authority-boundaries.md` (strong on *data* provenance and authority boundaries). Supply-chain pages mention signature validation and trusted signing-key registries (`infrastructure/agentic/supply-chain.md`) and model-card review (`extensions/technical/supply-chain.md`), but only as line items. |
| **Genuine gap** | **This is the one real content gap.** Cryptographic *model/prompt/tool* attestation as a discipline is not consolidated: no treatment of model signing (Sigstore/cosign, in-toto provenance), signed tool manifests, signed prompt/OISpec versions, or inference/audit attestation as tamper-evident evidence. Data provenance ≠ artifact attestation. |
| **Proposed action** | New page (working title *Provenance and Attestation*), most likely under `core/controls/` next to the existing data-provenance page. Cover: artifact signing (models, adapters, tool manifests, OISpecs), verification at load/deploy and at runtime, provenance metadata (in-toto/SLSA-style), and attestation as audit evidence, with the EU AI Act evidence angle. Cross-link supply-chain and the flight-recorder/observability pages. |
| **Effort** | Medium to high (genuinely new content; needs accurate sourcing). |

### 4. Economic abuse ("token exhaustion, cost bombs, recursive loops, tool spam; you could own this")

| | |
|---|---|
| **Review claim** | Underrated; could be owned given the earlier token-economics work. |
| **What already exists** | Already owned. `extensions/technical/token-economics.md` (FDoS / financial denial-of-service via token exhaustion, loop prevention, blast-radius caps, adversarial verbose injection) and `extensions/technical/economic-governance.md` (metering, budgets, cost as risk). Execution-control and risk-register MASO pages cover loop caps and cost bombs. |
| **Genuine gap** | Minimal. It is treated as economics/FinOps-plus-security rather than as a **named threat class** ("denial of wallet" / economic abuse) that a security reader would search for, and it is not surfaced in the threat-surface insights or emerging-threats listing. |
| **Proposed action** | Mostly cross-linking and naming. Add a short "economic abuse / denial of wallet" threat framing and route it from the threats insights and `maso/threat-intelligence/emerging-threats.md` into the existing token-economics and economic-governance pages. Optional: one new short insight page if we want a search landing target. **No new domain.** |
| **Effort** | Low. |

## What this nets out to

| Area | Review says | Reality | Real work |
|---|---|---|---|
| Identity | Biggest gap, new domain | Deep coverage, poor consolidation | 1 concept page + cross-links |
| Memory | Elevate to domain | Already a core control, near-complete | In-place extension |
| Provenance/attestation | Missing cryptographic trust | **Genuinely thin** | 1 new page (the real gap) |
| Economic abuse | Underrated | Already owned | Naming + cross-links |

The single highest-value item is **provenance/attestation**. Everything else is consolidation and discoverability, not net-new discipline.

## References to verify before citing

The review cites two arXiv papers as support: *AARM* (arXiv:2602.09433) and *AIRGuard* (arXiv:2605.28914). Neither is currently cited on the site. External-review citations are frequently fabricated or misnumbered, and these IDs are recent (Feb/May 2026), so **both must be verified against arXiv before any reference is added.** If they are real and relevant, they slot naturally into the runtime-identity and provenance pages and into `references.md`. If they cannot be verified, they are dropped, not paraphrased.

## Proposed build order (on approval)

1. **Provenance and Attestation** page under `core/controls/`, navigation entry in `mkdocs.yml`, references section, cross-links to supply-chain and observability. *(the real gap)*
2. **Runtime Identity Enforcement** concept page that consolidates the existing identity pages and adds action-time verification, plus cross-links.
3. **Memory** in-place extension: taxonomy subsection + vector-store poisoning row in `core/memory-and-context.md`.
4. **Economic abuse** naming and cross-links from threat insights and emerging-threats into the existing economics pages.
5. **References** update for any verified citations.

Each item is independent and can be approved or dropped on its own. All content will follow `CLAUDE.md`: front matter with `description`, SVG-only diagrams with `{ .arch-diagram }`, references admonition box, relative internal links, no em dashes.

## Decisions needed from you

1. **Scope**: all four items, or just the provenance gap (item 1) plus whichever of 2 to 4 you want?
2. **Provenance page home**: `core/controls/provenance-and-attestation.md` (recommended, sits beside data-provenance) versus a new top-level area.
3. **Identity page**: do you want the consolidating concept page, or are you happy leaving identity as-is given it is already well covered?
4. **New insight page for economic abuse**: yes (a search landing target) or just cross-link the existing pages?
