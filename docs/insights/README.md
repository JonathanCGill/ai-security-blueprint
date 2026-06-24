---
title: Insights
description: The insights that drive AI Runtime Security. Each one names a specific, repeatable failure, and the MASO control it forces into being. The why before the how.
template: redesign.html
nav_active: insights
---

<section class="airs-section airs-hero airs-hero--narrow airs-section--paper airs-section--first">
  <div class="airs-wrap">
    <p class="airs-eyebrow airs-eyebrow--accent airs-hero__eyebrow">Insights</p>
    <h1 class="airs-hero__title">The insights drive the <em class="is-accent">design.</em></h1>
    <p class="airs-hero__lead">Every layer in the framework exists because something fails in a specific, repeatable way. These are those failures, and the MASO control each one forces into being.</p>
    <div class="airs-btns">
      <a class="airs-btn airs-btn--primary" href="#core">The core arguments &rarr;</a>
      <a class="airs-btn airs-btn--secondary" href="/insights/reference/">Browse the full library</a>
    </div>
  </div>
</section>

<section class="airs-section airs-section--card" id="core">
  <div class="airs-wrap">
    <p class="airs-eyebrow">The core arguments</p>
    <h2 class="airs-h2">Six failures, six controls.</h2>
    <p class="airs-intro">Read these six and you have the case for runtime security in full. Each one points to the MASO control it produces.</p>
    <div class="airs-cards airs-cards--roles">
      <div class="airs-card">
        <a class="airs-card__titlelink" href="/insights/why-ai-security-is-a-runtime-problem/">A runtime problem</a>
        <p class="airs-card__body">AI is non-deterministic, so pre-deployment testing cannot prove future safety. Security has to run continuously.</p>
        <a class="airs-card__drives" href="/pace-resilience/">Drives: PACE resilience &rarr;</a>
      </div>
      <div class="airs-card">
        <a class="airs-card__titlelink" href="/insights/why-guardrails-arent-enough/">Guardrails aren't enough</a>
        <p class="airs-card__body">Fixed rules block known-bad patterns. Novel injection and semantic violations walk straight past them.</p>
        <a class="airs-card__drives" href="/maso/controls/prompt-goal-and-epistemic-integrity/">Drives: Prompt &amp; Epistemic Integrity &rarr;</a>
      </div>
      <div class="airs-card">
        <a class="airs-card__titlelink" href="/insights/judge-detects-not-decides/">The judge detects</a>
        <p class="airs-card__body">An evaluator surfaces unknown-bad against declared intent. It informs humans, it does not replace them.</p>
        <a class="airs-card__drives" href="/maso/controls/objective-intent/">Drives: Objective Intent &rarr;</a>
      </div>
      <div class="airs-card">
        <a class="airs-card__titlelink" href="/insights/infrastructure-beats-instructions/">Infrastructure beats instructions</a>
        <p class="airs-card__body">Telling an agent what not to do fails. Make the violation technically impossible, outside the agent.</p>
        <a class="airs-card__drives" href="/maso/environment-containment/">Drives: Environment Containment &rarr;</a>
      </div>
      <div class="airs-card">
        <a class="airs-card__titlelink" href="/insights/humans-remain-accountable/">Humans remain accountable</a>
        <p class="airs-card__body">AI assists decisions; humans own outcomes. Oversight scales with consequence, it does not disappear.</p>
        <a class="airs-card__drives" href="/maso/controls/privileged-agent-governance/">Drives: Privileged Agent Governance &rarr;</a>
      </div>
      <div class="airs-card">
        <a class="airs-card__titlelink" href="/insights/feedback-loops/">Feedback loops</a>
        <p class="airs-card__body">Four loops at different speeds turn guardrails, judges, humans, and outcomes into a self-improving system.</p>
        <a class="airs-card__drives" href="/maso/controls/observability/">Drives: Observability &amp; the Flight Recorder &rarr;</a>
      </div>
    </div>
  </div>
</section>

<section class="airs-section airs-section--paper">
  <div class="airs-wrap">
    <p class="airs-eyebrow">Where the threats live</p>
    <h2 class="airs-h2">Each attack surface has an answer in MASO.</h2>
    <p class="airs-intro">The threat insights are not abstract. Every one maps to a concrete control domain in the multi-agent framework.</p>
    <div class="airs-cards airs-cards--roles">
      <div class="airs-card">
        <a class="airs-card__titlelink" href="/insights/rag-is-your-biggest-attack-surface/">RAG is your biggest attack surface</a>
        <p class="airs-card__body">Retrieval pipelines bypass your existing access controls and carry poisoned content into reasoning.</p>
        <a class="airs-card__drives" href="/maso/controls/data-protection/">Drives: Data Protection &rarr;</a>
      </div>
      <div class="airs-card">
        <a class="airs-card__titlelink" href="/insights/the-mcp-problem/">The MCP problem</a>
        <p class="airs-card__body">The protocol everyone is adopting hands agents universal tool access with no auth or monitoring.</p>
        <a class="airs-card__drives" href="/maso/controls/supply-chain/">Drives: Supply Chain &rarr;</a>
      </div>
      <div class="airs-card">
        <a class="airs-card__titlelink" href="/insights/when-agents-talk-to-agents/">When agents talk to agents</a>
        <p class="airs-card__body">Multi-agent systems open accountability gaps and let one agent's output become another's instruction.</p>
        <a class="airs-card__drives" href="/maso/controls/identity-and-access/">Drives: Identity &amp; Access &rarr;</a>
      </div>
      <div class="airs-card">
        <a class="airs-card__titlelink" href="/insights/the-orchestrator-problem/">The orchestrator problem</a>
        <p class="airs-card__body">The most powerful agents in the system, the ones that create and direct others, have the fewest controls.</p>
        <a class="airs-card__drives" href="/maso/controls/privileged-agent-governance/">Drives: Privileged Agent Governance &rarr;</a>
      </div>
      <div class="airs-card">
        <a class="airs-card__titlelink" href="/insights/agentic-drift/">Agentic drift</a>
        <p class="airs-card__body">Objectives, context, and tools drift away from declared intent over a long task horizon.</p>
        <a class="airs-card__drives" href="/maso/controls/agentic-task-mandate/">Drives: Agentic Task Mandate &rarr;</a>
      </div>
      <div class="airs-card">
        <a class="airs-card__titlelink" href="/insights/the-memory-problem/">The memory problem</a>
        <p class="airs-card__body">Long context and persistent memory let poisoned data survive across sessions as a quiet backdoor.</p>
        <a class="airs-card__drives" href="/maso/controls/data-protection/">Drives: Data Protection &rarr;</a>
      </div>
    </div>
  </div>
</section>

<section class="airs-section airs-section--ink airs-center">
  <div class="airs-wrap--narrow">
    <p class="airs-eyebrow">The whole library</p>
    <h2 class="airs-cta__title">Insights are the why. Controls are the how.</h2>
    <p class="airs-cta__body">Forty-plus short reads, grouped by theme, with a curated reading order that walks from problem to control.</p>
    <div class="airs-btns">
      <a class="airs-btn airs-btn--primary" href="/insights/reference/">Open the full guide &rarr;</a>
      <a class="airs-btn airs-btn--secondary" href="/maso/">See MASO</a>
    </div>
  </div>
</section>
