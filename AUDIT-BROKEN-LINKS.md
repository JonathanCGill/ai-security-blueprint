---
description: Focused audit of broken internal links, anchors, assets, and external URLs across the airuntimesecurity.io MkDocs site.
---

# Broken-Links Audit

*Audit date: 2026-04-14. Scope: all 228 markdown files under `docs/`, `mkdocs.yml` nav, and 321 unique external URLs referenced from content.*

## Executive summary

| Class | Count | Severity |
|---|---|---|
| Broken internal file references | 4 | critical |
| Broken anchor links (fragment does not match any heading in target) | 24 | critical |
| Broken external URLs (confirmed 404) | 1 | critical |
| Broken nav entries in `mkdocs.yml` | 0 | pass |
| External URLs not reachable from audit sandbox (inconclusive) | 303 | info |

**Pass criteria:** internal links and anchors must resolve; `mkdocs.yml` nav must point at real files; every external URL must return a 2xx/3xx.

**Verdict: FAIL.** 29 confirmed broken references require fixing before the site can be considered clean.

A note on methodology: a background agent initially reported 191 missing SVGs and 4 missing PDFs. Those findings are false positives: spot-checks confirmed the assets exist on disk. The list below is the result of a second pass that resolves links the way MkDocs does (directory URLs enabled, Python-Markdown default slugifier, README/index as directory index) and has been spot-verified against the actual filesystem and actual headings.

## 1. Broken internal file references

All four fail because the target is not reachable via a URL that MkDocs will serve.

| # | Source | Line | Href | What's wrong | Fix |
|---|---|---|---|---|---|
| 1 | `docs/downloads.md` | 54 | `../LICENSE` | `LICENSE` lives at the repo root, not under `docs/`. MkDocs will not serve it, so `/LICENSE/` 404s. | Either copy `LICENSE` to `docs/LICENSE.md` (with front matter) or link externally to the repo file: `https://github.com/JonathanCGill/airuntimesecurity.io/blob/main/LICENSE`. |
| 2 | `docs/insights/README.md` | 7 | `../extensions` | `docs/extensions/` exists but has no `README.md` / `index.md`. Resolves to `/extensions/` which 404s. | Point at a specific page such as `../extensions/technical/` (only works if that section gets a `README.md`) or link directly to a resource page like `../extensions/regulatory/eu-ai-act-crosswalk.md`. |
| 3 | `docs/infrastructure/README.md` | 219 | `diagrams/` | `docs/infrastructure/diagrams/` exists (contains SVGs) but has no index page. `/infrastructure/diagrams/` 404s. | Drop the link, inline the diagrams in the README, or add an `infrastructure/diagrams/README.md` index. |
| 4 | `docs/extensions/regulatory/nist-ir-8596-alignment.md` | 241 | `../../maso/threat-intelligence/` | `docs/maso/threat-intelligence/` contains `incident-tracker.md`, `emerging-threats.md`, `threat-intelligence-review.md` but no index. `/maso/threat-intelligence/` 404s. | Link to a specific page (e.g. `../../maso/threat-intelligence/incident-tracker.md`) or add `maso/threat-intelligence/README.md`. |

### Not broken, but worth flagging

- `docs/ABOUT.md:8` uses `<img src="../images/Jonathan%20Gill.jpg">`. With `use_directory_urls: true` the page serves at `/ABOUT/`, so the browser resolves `../images/…` to `/images/Jonathan%20Gill.jpg`, which exists. A broken-link checker that walks source paths will flag this, but it works in the built site.

## 2. Broken anchor links

Every anchor below points at a heading slug that does not exist in the target document. MkDocs uses Python-Markdown's default slugifier, which collapses any run of spaces and hyphens (`[-\s]+`) into a single `-`. Many of these links were written as if the slugifier preserved runs of hyphens, which it does not.

### 2a. `docs/extensions/technical/agentic-controls-catalogue.md` (14 broken anchors)

The target headings use ` - ` (space-hyphen-space), which slugifies to a single `-`. The links use `---` (triple hyphen).

| Line | Href | Actual heading | Correct slug |
|---|---|---|---|
| 28 | `…/tool-access-controls.md#tool-04---classify-tool-actions-by-reversibility-and-impact` | `## TOOL-04 - Classify Tool Actions by Reversibility and Impact` | `tool-04-classify-tool-actions-by-reversibility-and-impact` |
| 29 | `…/tool-access-controls.md#tool-05---rate-limit-tool-invocations-per-agent-and-per-tool` | `## TOOL-05 - Rate Limit…` | `tool-05-rate-limit-tool-invocations-per-agent-and-per-tool` |
| 33 | `…/tool-access-controls.md#tool-06---log-every-tool-invocation-with-full-context` | `## TOOL-06 - Log Every Tool…` | `tool-06-log-every-tool-invocation-with-full-context` |
| 53 | `…/supply-chain.md#sup-05---audit-tool-and-plugin-supply-chain` | `## SUP-05 - Audit Tool…` | `sup-05-audit-tool-and-plugin-supply-chain` |
| 55 | `…/supply-chain.md#sup-08---monitor-for-model-and-dependency-vulnerabilities` | `## SUP-08 - Monitor for Model…` | `sup-08-monitor-for-model-and-dependency-vulnerabilities` |
| 56, 149 | `…/supply-chain.md#sup-02---assess-model-risk-before-adoption` | `## SUP-02 - Assess Model…` | `sup-02-assess-model-risk-before-adoption` |
| 58 | `…/supply-chain.md#sup-01---verify-model-provenance-and-integrity` | `## SUP-01 - Verify Model…` | `sup-01-verify-model-provenance-and-integrity` |
| 90 | `…/delegation-chains.md#del-03---limit-delegation-depth` | `## DEL-03 - Limit Delegation Depth` | `del-03-limit-delegation-depth` |
| 108, 137, 139 | `…/identity-and-access.md#iam-03-control-plane--data-plane-separation` | `## IAM-03: Control Plane / Data Plane Separation` | `iam-03-control-plane-data-plane-separation` |
| 130 | `…/tool-access-controls.md#tool-03---constrain-tool-parameters-to-declared-bounds` | `## TOOL-03 - Constrain Tool Parameters to Declared Bounds` | `tool-03-constrain-tool-parameters-to-declared-bounds` |
| 151 | `…/supply-chain.md#sup-06---verify-guardrail-and-safety-model-integrity` | `## SUP-06 - Verify Guardrail…` | `sup-06-verify-guardrail-and-safety-model-integrity` |

**Fix:** Replace every `---` in these anchors with a single `-`. Replace `--` (in `plane--data`) with a single `-`. The cleanest fix is a single global search-and-replace inside `agentic-controls-catalogue.md`.

### 2b. `docs/strategy/enterprise-day-in-the-life.md` (9 broken same-file anchors)

Headings follow the pattern `## 09:00 - CIO's Weekly AI Portfolio Review`. After slugification the `:` and `'` are dropped and runs of `-`/space collapse to a single `-`. The anchors in the file were written as if they preserved the runs. They also include slug variants with extra `--` where headings contain `:` or `&`.

| Line | Href | Correct slug |
|---|---|---|
| 272, 359 | `#0900---cios-weekly-ai-portfolio-review` | `0900-cios-weekly-ai-portfolio-review` |
| 360 | `#1630---business-owner-review-product-line-c-quarterly-planning` | `1630-business-owner-review-product-line-c-quarterly-planning` |
| 361 | `#1500---risk--security-threat-intelligence-update` | `1500-risk-security-threat-intelligence-update` |
| 362 | `#1300---claims-processing-pace-state-change` | `1300-claims-processing-pace-state-change` |
| 363 | `#1030---privacy-dsar-assistant-data-classification-boundary` | `1030-privacy-dsar-assistant-data-classification-boundary` |
| 364 | `#1100---product-line-b-fast-lane-deployment` | `1100-product-line-b-fast-lane-deployment` |
| 364 | `#0815---product-line-a-customer-service-escalation` | `0815-product-line-a-customer-service-escalation` |
| 365 | `#1700---end-of-day-governance-roll-up` | `1700-end-of-day-governance-roll-up` |

**Fix:** Same global search-and-replace of `---` → `-` and `--` → `-` on this file. Consider adding explicit `{#anchor}` identifiers to each time-coded heading so future edits to heading text don't silently break navigation.

### 2c. `docs/strategy/enterprise-day-in-the-life.md:227`

| Line | Href | Heading | Correct slug |
|---|---|---|---|
| 227 | `../core/controls.md#3-human-oversight` | `## 3. Human Oversight (HITL)` | `3-human-oversight-hitl` |

**Fix:** Append `-hitl` to the anchor, or change the heading to `## 3. Human Oversight` if `HITL` is redundant (it is defined elsewhere in the same document).

## 3. External URLs

### 3a. Confirmed broken (return 4xx/5xx)

| Status | URL | Source | Notes |
|---|---|---|---|
| 404 | `https://github.com/lakeraai/b3-benchmark` | `docs/insights/the-backbone-problem.md:186` | Repository not found. The Lakera b³ repo appears to live at a different path. Check `github.com/lakeraai/b3` or the linked project on lakera.ai and update. |
| 503 | `https://www.hashicorp.com/blog/zero-trust-for-agentic-systems-managing-non-human-identities-at-scale` | referenced from `docs/REFERENCES.md` et al. | Likely transient; re-check. |
| 503 | `https://www.microsoft.com/en-us/security/blog/2026/03/18/observability-ai-systems-strengthening-visibility-proactive-risk-detection/` | `docs/REFERENCES.md` et al. | Likely transient; re-check. |
| 503 | `https://www.microsoft.com/en-us/worklab/work-trend-index/` | `docs/REFERENCES.md` et al. | Likely transient; re-check. |

### 3b. Inconclusive (sandbox could not reach the host)

321 unique external URLs were extracted. Only 18 resolved from the audit sandbox (14 × 2xx, 3 × 503, 1 × 404); the other 303 returned `ERR_0`, which in this environment indicates the outbound connection was blocked or timed out rather than that the URL is down. **These URLs have not been verified and should be re-checked from an unrestricted network** (for example with a `lychee --exclude 'mailto:' docs/` run in CI). The deduplicated URL list is at the end of this report.

## 4. Nav integrity

`mkdocs.yml` lines 88-296 define 171 nav entries. All 171 point at files that exist under `docs/`. No broken nav entries.

Separately, **44 orphan pages** (files present under `docs/` but not in nav) were identified in the companion structural audit; those are a discoverability issue, not a broken-link issue, and are listed in `AUDIT-FULL.md`.

## 5. Recommended remediation order

1. Fix the four broken file references (§1) and the 24 broken anchors (§2). These are a mechanical find-and-replace in three files plus one index addition.
2. Replace or remove the confirmed-404 `lakeraai/b3-benchmark` link (§3a).
3. Re-run the external URL check from a host with unrestricted outbound HTTP; triage the 303 inconclusive results and the three 503s.
4. Add a CI check (for example `lychee` or `linkchecker`) to catch regressions.

## Appendix: unique external URLs

The full list of 321 unique external URLs extracted from the site is saved at `/tmp/urls_clean.txt` in the audit run. For a portable list, a `find docs/ -name '*.md' -exec grep -oE 'https?://[^)\" <>]+' {} \; | sort -u` run will regenerate it.

!!! info "References"
    - [Python-Markdown TOC extension (default slugifier)](https://python-markdown.github.io/extensions/toc/#slugify)
    - [MkDocs `use_directory_urls` behaviour](https://www.mkdocs.org/user-guide/configuration/#use_directory_urls)
    - [lychee link checker](https://github.com/lycheeverse/lychee)
