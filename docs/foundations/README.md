---
title: Single-Agent Overview
description: Runtime security controls for single-agent AI deployments. The architecture in one page, with pointers into the Core Controls library for depth.
template: redesign.html
nav_active: framework
---

<section class="airs-section airs-hero airs-hero--narrow airs-section--paper airs-section--first">
  <div class="airs-wrap">
    <p class="airs-eyebrow airs-eyebrow--accent airs-hero__eyebrow">Foundation &middot; Single agent</p>
    <h1 class="airs-hero__title">You can't test your way to a safe AI.</h1>
    <p class="airs-hero__lead">Same prompt, same model, different answer &mdash; every time. Tests prove the system <em>can</em> behave. They can't prove it <strong>will</strong> on the next request. So you verify it live.</p>
    <div class="airs-btns">
      <a class="airs-btn airs-btn--primary" href="/core/">See every control &rarr;</a>
      <a class="airs-btn airs-btn--secondary" href="/core/risk-tiers/">Classify by risk</a>
    </div>
  </div>
</section>

<section class="airs-section airs-section--card airs-center">
  <div class="airs-wrap--narrow">
    <figure class="airs-figure">
      <img class="arch-diagram airs-figure__img" src="/images/single-agent-architecture.svg" alt="Single-agent security architecture: guardrails, reviewing controls, and human oversight wrapped around one AI model, with a circuit breaker behind them">
      <figcaption class="airs-figure__cap">One model, four layers. Each layer catches what the one before it misses &mdash; compound defence by design, not by coincidence.</figcaption>
    </figure>
  </div>
</section>

<section class="airs-section airs-section--paper">
  <div class="airs-wrap">
    <p class="airs-eyebrow">The pattern</p>
    <h2 class="airs-h2">Four layers, one principle: verify in production.</h2>
    <p class="airs-intro">You cannot fully test a non-deterministic system before deployment, so the controls form a closed loop that watches behaviour as it happens.</p>
    <div class="airs-hairgrid airs-hairgrid--4">
      <div class="airs-layer">
        <p class="airs-layer__num">01</p>
        <p class="airs-layer__title">Guardrails</p>
        <p class="airs-layer__body">Deterministic limits at machine speed (~10ms): content filters, PII detection, topic and rate limits.</p>
      </div>
      <div class="airs-layer">
        <p class="airs-layer__num">02</p>
        <p class="airs-layer__title">Reviewing controls</p>
        <p class="airs-layer__body">Scanners, a semantic firewall, and a model-as-judge evaluate the output against policy, grounding, and intent.</p>
      </div>
      <div class="airs-layer">
        <p class="airs-layer__num">03</p>
        <p class="airs-layer__title">Human oversight</p>
        <p class="airs-layer__body">The accountability backstop. Spot checks for low risk, approval before commit for high risk.</p>
      </div>
      <div class="airs-layer">
        <p class="airs-layer__num">04</p>
        <p class="airs-layer__title">Circuit breaker</p>
        <p class="airs-layer__body">Stops AI traffic and switches to a non-AI fallback when any layer fails. A full stop, not a degrade.</p>
      </div>
    </div>
    <a class="airs-textlink" href="/insights/why-containment-beats-evaluation/">Why containment beats evaluation &rarr;</a>
  </div>
</section>

<section class="airs-section airs-section--card">
  <div class="airs-wrap">
    <p class="airs-eyebrow">Risk-scaled controls</p>
    <h2 class="airs-h2">Low-risk AI moves fast. High-risk AI stays safe.</h2>
    <p class="airs-intro">Controls scale to consequence, so you spend scrutiny where it matters and nowhere else.</p>
    <div class="airs-cards airs-cards--roles">
      <a class="airs-card" href="/fast-lane/">
        <p class="airs-card__label">Low</p>
        <p class="airs-card__body">Fast Lane: minimal guardrails and self-certification. PACE runs fail-open with logging.</p>
        <span class="airs-card__more">Deploy low-risk AI fast &rarr;</span>
      </a>
      <a class="airs-card" href="/core/controls/">
        <p class="airs-card__label">Medium &amp; high</p>
        <p class="airs-card__body">Guardrails plus reviewing controls, with human review scaling from periodic to in-the-loop for writes.</p>
        <span class="airs-card__more">Implement the layers &rarr;</span>
      </a>
      <a class="airs-card" href="/pace-resilience/">
        <p class="airs-card__label">Critical</p>
        <p class="airs-card__body">Full architecture, mandatory approval, and the full PACE cycle with tested recovery.</p>
        <span class="airs-card__more">Understand the failure modes &rarr;</span>
      </a>
    </div>
  </div>
</section>

<section class="airs-section airs-section--paper">
  <div class="airs-wrap--article airs-article">
    <h2 id="defence-in-depth-beyond-the-ai-layer">Defence in depth beyond the AI layer</h2>
    <p class="airs-muted">The four-layer model addresses controls specific to non-deterministic AI behaviour. It does not replace the security you already have &mdash; it sits inside it.</p>
    <p class="airs-muted">Your DLP still applies to data flowing in and out. API gateways still validate requests whether the caller is human or AI. Database access controls and parameterised queries still prevent injection even if an agent builds a malicious query. IAM still governs who can invoke AI at all, and your SIEM still correlates AI events with everything else. When one of these catches something, it is your safety net.</p>
    <p class="airs-muted">For multi-agent systems, <a href="/maso/environment-containment/">MASO Environment Containment</a> formalises this: harden every system the agent touches so misbehaviour is structurally harmless, whatever the agent intends.</p>
  </div>
</section>

<section class="airs-section airs-section--card">
  <div class="airs-wrap">
    <p class="airs-eyebrow">Where to next</p>
    <h2 class="airs-h2">Pick the path that matches your job.</h2>
    <div class="airs-cards airs-cards--roles">
      <a class="airs-card" href="/minimum-viable-airs/">
        <p class="airs-card__title">Ship a first feature</p>
        <p class="airs-card__body">AIRSLite: seven controls to get an LLM feature out safely.</p>
        <span class="airs-card__more">Go to AIRSLite &rarr;</span>
      </a>
      <a class="airs-card" href="/core/">
        <p class="airs-card__title">Build it properly</p>
        <p class="airs-card__body">The Core Controls library: every single-agent control, checklist, and risk tier.</p>
        <span class="airs-card__more">Open Core Controls &rarr;</span>
      </a>
      <a class="airs-card" href="/maso/">
        <p class="airs-card__title">Scale to many agents</p>
        <p class="airs-card__body">MASO: securing systems where agents collaborate and trust gets complicated.</p>
        <span class="airs-card__more">Go to MASO &rarr;</span>
      </a>
    </div>
  </div>
</section>
