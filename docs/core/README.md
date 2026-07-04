---
title: AI Runtime Security - Core
description: Core implementation guide for AI runtime security controls including risk classification, control definitions, and specialised controls for production AI systems.
template: redesign.html
nav_active: framework
---

<section class="airs-section airs-hero airs-hero--narrow airs-section--paper airs-section--first">
  <div class="airs-wrap">
    <p class="airs-eyebrow airs-eyebrow--accent airs-hero__eyebrow">Core controls &middot; Implementation</p>
    <h1 class="airs-hero__title">From design-time testing to runtime verification.</h1>
    <p class="airs-hero__lead">Traditional software is tested before it ships. AI can't be, not fully. This is the implementation library: classify the risk, apply the layers, and deselect what you don't need.</p>
    <div class="airs-btns">
      <a class="airs-btn airs-btn--primary" href="/core/risk-tiers/">Start: classify your system &rarr;</a>
      <a class="airs-btn airs-btn--secondary" href="/core/reference/">Full reference</a>
    </div>
  </div>
</section>

<section class="airs-section airs-section--card">
  <div class="airs-wrap">
    <p class="airs-eyebrow">The essentials</p>
    <h2 class="airs-h2">Seven steps, in order.</h2>
    <p class="airs-intro">Start here and work down. Each step builds on the one before it; branch into specialised controls once the essentials are in place.</p>
    <div class="airs-cards airs-cards--roles">
      <a class="airs-card" href="/core/risk-tiers/">
        <p class="airs-card__label">01</p>
        <p class="airs-card__title">Risk Tiers</p>
        <p class="airs-card__body">Classify your system by impact, so the controls match the consequence.</p>
      </a>
      <a class="airs-card" href="/core/risk-assessment/">
        <p class="airs-card__label">02</p>
        <p class="airs-card__title">Risk Assessment</p>
        <p class="airs-card__body">Quantify control effectiveness and residual risk per tier.</p>
      </a>
      <a class="airs-card" href="/core/controls/">
        <p class="airs-card__label">03</p>
        <p class="airs-card__title">Controls</p>
        <p class="airs-card__body">Implement the layered pattern: guardrails, reviewing controls, oversight.</p>
      </a>
      <a class="airs-card" href="/core/agentic/">
        <p class="airs-card__label">04</p>
        <p class="airs-card__title">Agentic</p>
        <p class="airs-card__body">Add controls when your agent can invoke tools or take actions.</p>
      </a>
      <a class="airs-card" href="/core/iam-governance/">
        <p class="airs-card__label">05</p>
        <p class="airs-card__title">IAM Governance</p>
        <p class="airs-card__body">Identity, lifecycle, and delegation for human and non-human callers.</p>
      </a>
      <a class="airs-card" href="/core/judge-assurance/">
        <p class="airs-card__label">06</p>
        <p class="airs-card__title">Judge Assurance</p>
        <p class="airs-card__body">Measure and calibrate the model-as-judge so you can trust its verdicts.</p>
      </a>
      <a class="airs-card" href="/core/checklist/">
        <p class="airs-card__label">07</p>
        <p class="airs-card__title">Checklist</p>
        <p class="airs-card__body">Track implementation progress against the controls you selected.</p>
      </a>
    </div>
  </div>
</section>

<section class="airs-section airs-section--paper">
  <div class="airs-wrap">
    <p class="airs-eyebrow">Specialised controls</p>
    <h2 class="airs-h2">Reach for these when your deployment needs them.</h2>
    <p class="airs-intro">Match the add-on controls to what you're actually running. Deselect the rest.</p>
    <div class="airs-cards airs-cards--roles">
      <a class="airs-card" href="/core/multimodal-controls/">
        <p class="airs-card__title">Multimodal</p>
        <p class="airs-card__body">Image, audio, and video inputs that bypass text-based guardrails.</p>
      </a>
      <a class="airs-card" href="/core/reasoning-model-controls/">
        <p class="airs-card__title">Reasoning models</p>
        <p class="airs-card__body">Chain-of-thought models where the reasoning itself needs scrutiny.</p>
      </a>
      <a class="airs-card" href="/core/streaming-controls/">
        <p class="airs-card__title">Streaming</p>
        <p class="airs-card__body">Real-time outputs that commit before a full review can finish.</p>
      </a>
      <a class="airs-card" href="/core/memory-and-context/">
        <p class="airs-card__title">Memory &amp; context</p>
        <p class="airs-card__body">Long context and persistent memory that carry risk across sessions.</p>
      </a>
      <a class="airs-card" href="/core/multi-agent-controls/">
        <p class="airs-card__title">Multi-agent</p>
        <p class="airs-card__body">The primer for many-agent systems, before you go deep on MASO (Multi-Agent Security Operations).</p>
      </a>
      <a class="airs-card" href="/pace-resilience/">
        <p class="airs-card__title">PACE resilience</p>
        <p class="airs-card__body">What each layer does when it fails, and the safe state it falls back to.</p>
      </a>
    </div>
  </div>
</section>

<section class="airs-section airs-section--card airs-center">
  <div class="airs-wrap--narrow">
    <p class="airs-eyebrow">The principle</p>
    <p class="airs-statement">Match controls to risk. <em>Guardrails are necessary but not sufficient, the judge is assurance not control, and humans remain accountable.</em> Apply the right controls at the right time, for the right reasons.</p>
    <a class="airs-textlink" href="/core/reference/">All the principles, in full &rarr;</a>
  </div>
</section>
