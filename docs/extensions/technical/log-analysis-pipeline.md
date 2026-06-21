---
description: "A reproducible seven-step pipeline for analysing AI system logs, adapted from UK AISI's log-analysis methodology, with emphasis on validating the scanners (Judges) that produce runtime security signals."
---

# Log Analysis Pipeline

Logs are the raw material of runtime assurance. Every guardrail decision, tool call, reasoning trace, and Judge verdict ends up in logs, and the quality of every safety claim depends on how rigorously those logs are turned into signal. UK AISI and collaborators published a standardised pipeline for this ([*Seven Simple Steps for Log Analysis in AI Systems*, Dubois et al., 2026](https://doi.org/10.36227/techrxiv.177223089.95759468/v1)), illustrated with the open-source Inspect Scout library. This page adapts it for runtime security work.

The key equivalence: what that paper calls a **scanner** is what this framework calls a **[Judge](../../core/controls.md) or autograder**. A scanner is any automated method for detecting a pattern in logs, programmatic (string match, regex, schema check) or LLM-based. The pipeline below is, in effect, how you build and validate a Judge so its findings are trustworthy.

## Terminology

- **Logs**: every record a system generates: model inputs (prompts, instructions), outputs (responses, reasoning traces, tool calls), environment interactions (tool outputs, API responses), and metadata (timestamps, tokens, error codes).
- **Scanner**: an automated pattern detector over logs. May run in real time (inline) or offline (post-hoc).
- **Primary vs secondary**: original task scores are *primary*; analyses derived from further log exploration are *secondary*. A common secondary question is "did the evaluation even work as intended?"

## The seven steps

| Step | What it means for runtime security |
|---|---|
| **1. Define the purpose** | State the question before touching logs. Primary ("did the agent stay in scope?") or secondary ("can I trust that my Judge fired correctly?"). |
| **2. Prepare a database of logs** | Get logs into structured, queryable form. This is where the [flight-recorder](../../insights/the-flight-recorder-problem.md) and [logging controls](../../infrastructure/controls/logging-and-observability.md) pay off: you can only analyse what you captured. |
| **3. Explore the logs** | Read real transcripts before building anything. Most detection ideas, and most false-positive sources, are visible by eye first. |
| **4. Refine the research question** | Narrow the vague question into a precise, checkable one, with a rubric. A precise question is also what the [semantic firewall](../../core/controls/semantic-firewall.md) and Judge need. |
| **5. Develop the scanner** | Build the detector (the Judge): programmatic where the signal is structural, LLM-based where it is semantic. |
| **6. Validate the scanner** | Prove it detects what you intended, against human ground truth. The detail that matters most for security is below. |
| **7. Use the results** | Act on findings without over-claiming. Resist generalising capability or intent from anecdotes or descriptive statistics. |

## Validating the scanner

This step is the overlap with [Judge Assurance](../../core/judge-assurance.md), and the paper is unusually concrete about it. The workflow is: run the scanner, select a validation set by **stratified sampling**, obtain **ground-truth labels**, then compute metrics against those labels.

**Stratified sampling.** Cover the dimensions that matter: outcomes (pass/fail), uncertainty (near-threshold and low-confidence cases), and every grade of the rubric. If the scanner only flags positives, you must also sample non-detections, or you will never measure false negatives.

**Ground truth depends on the feature type.**

| Feature type | Ground truth | Metrics |
|---|---|---|
| **Objective** (tool-call success, message count, JSON validity) | directly measurable, or one careful annotator | precision, recall, F1, accuracy, confusion matrix; for confidence-scoring scanners, ROC-AUC, Brier score, ECE |
| **Subjective** (harmfulness, tone, quality) | multiple human raters, because they disagree and carry bias | inter-rater agreement (Fleiss or Krippendorff alpha), plus the discrete/confidence metrics above |

**Guard against bias.** Raters should be blind to the scanner's output and to the result you expect. Randomise sample order to avoid position bias when validating your own scanner.

## Pitfalls and open questions

The paper is candid that much of this rests on informal experience, and flags open questions worth treating as live risks in any runtime deployment:

- **Long-transcript degradation.** Scanner reliability drops on long inputs (the "lost in the middle" effect), exactly the agentic trajectories where oversight matters most.
- **Scoring design.** Binary versus ordinal scales, and granularity (0-10 vs 0-100), measurably change results; decomposing multiple behaviours into separate criteria tends to help.
- **Run-to-run variability.** LLM-based scanners vary across repeated runs on the same logs; quantify this before trusting a single pass.
- **Sample sizes.** There is no settled answer for how large a validation set must be across contexts; size deliberately rather than by habit.

## How this maps to AIRS

| AIRS control | Role in the pipeline |
|---|---|
| [Logging & Observability](../../infrastructure/controls/logging-and-observability.md) | Steps 1-2: capture and structure the logs the pipeline consumes. |
| [Model-as-Judge](../../core/controls.md) and [Judge Assurance](../../core/judge-assurance.md) | Steps 5-6: a scanner is a Judge; validation here is Judge calibration. |
| [Output Evaluator](output-evaluator.md) | Session-aware, pre-action scanning is one deployment of a scanner. |
| [Safety Cases and Oversight Durability](../../core/controls/safety-cases-and-oversight-durability.md) | Validated scanner metrics are evidence in a safety case. |

!!! info "References"
    - [*Seven Simple Steps for Log Analysis in AI Systems*, Dubois et al., UK AISI (2026), techRxiv](https://doi.org/10.36227/techrxiv.177223089.95759468/v1)
    - [Inspect (UK AI Security Institute evaluation framework)](https://inspect.aisi.org.uk/)
