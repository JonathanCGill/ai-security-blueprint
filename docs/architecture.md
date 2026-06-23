---
title: The Framework
description: "AIRS Framework architecture: risk-proportionate, layered runtime controls for single-agent and multi-agent AI systems."
template: redesign.html
nav_active: framework
---

<section class="airs-section airs-hero airs-hero--narrow airs-section--paper airs-section--first">
  <div class="airs-wrap">
    <p class="airs-eyebrow airs-eyebrow--accent airs-hero__eyebrow">The framework</p>
    <h1 class="airs-hero__title">Four layers, working together.</h1>
    <p class="airs-hero__lead">Four independent layers, each doing one job. If one fails, the others still hold. They start in <strong>detect-only</strong>, watching and logging without blocking, and graduate to <strong>enforcing</strong> once you trust what they catch.</p>
  </div>
</section>

<section class="airs-section airs-section--paper">
  <div class="airs-wrap">
    <div class="airs-layers">
      <div class="airs-layerrow">
        <div class="airs-layerrow__meta">
          <p class="airs-layerrow__num">Layer 01</p>
          <p class="airs-layerrow__latency">~10ms</p>
        </div>
        <div>
          <h2 class="airs-layerrow__title">Guardrails</h2>
          <p class="airs-layerrow__body">Fast, fixed boundaries: content policies, scope limits, tool permissions. These are the locked doors of the system &mdash; cheap, reliable, and impossible to talk your way past.</p>
        </div>
      </div>
      <div class="airs-layerrow">
        <div class="airs-layerrow__meta">
          <p class="airs-layerrow__num">Layer 02</p>
          <p class="airs-layerrow__latency">5ms&ndash;5s</p>
        </div>
        <div>
          <h2 class="airs-layerrow__title">Reviewing controls</h2>
          <p class="airs-layerrow__body">A second opinion before anything reaches the user: scanners, a semantic firewall, and a model-as-judge weighing the response against policy, context, and intent. This is what catches the subtle failures a fixed rule waves straight through.</p>
        </div>
      </div>
      <div class="airs-layerrow">
        <div class="airs-layerrow__meta">
          <p class="airs-layerrow__num">Layer 03</p>
          <p class="airs-layerrow__latency">as needed</p>
        </div>
        <div>
          <h2 class="airs-layerrow__title">Human oversight</h2>
          <p class="airs-layerrow__body">Escalation paths, audit trails, and a real person on the high-stakes decisions. The scope of oversight scales with the consequence &mdash; the more that rides on a call, the closer a human watches.</p>
        </div>
      </div>
      <div class="airs-layerrow">
        <div class="airs-layerrow__meta">
          <p class="airs-layerrow__num">Layer 04</p>
          <p class="airs-layerrow__latency">instant</p>
        </div>
        <div>
          <h2 class="airs-layerrow__title">Circuit breakers</h2>
          <p class="airs-layerrow__body">The emergency stop. It halts the AI and fails over to a safe fallback when the other layers can't hold. You rarely need it &mdash; and you're very glad it's there when you do.</p>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="airs-section airs-section--card">
  <div class="airs-wrap">
    <p class="airs-eyebrow">Three domains</p>
    <h2 class="airs-h2">The same idea, at three scales.</h2>
    <p class="airs-intro">The same layered idea applies whether you are securing one agent, many agents, or the platforms beneath them.</p>
    <div class="airs-cards airs-cards--roles">
      <div class="airs-card">
        <p class="airs-card__title">Foundation</p>
        <p class="airs-card__body">One agent doing one job. This is where everyone starts, and where the four layers are easiest to see.</p>
      </div>
      <div class="airs-card">
        <p class="airs-card__title">MASO</p>
        <p class="airs-card__body">Many agents working together. As they hand work to each other, trust gets complicated and the controls have to follow.</p>
      </div>
      <div class="airs-card">
        <p class="airs-card__title">Infrastructure</p>
        <p class="airs-card__body">The platforms, cloud, tools, and data underneath it all &mdash; the layer everything else depends on.</p>
      </div>
    </div>
  </div>
</section>

<section class="airs-section airs-section--paper airs-center">
  <div class="airs-wrap--article">
    <h2 class="airs-h2">Not sure where to begin?</h2>
    <p class="airs-intro">Start with the plain-language explainer, or jump straight to the entry point that matches your role.</p>
    <div class="airs-btns">
      <a class="airs-btn airs-btn--primary" href="/what-is-ai-runtime-security/">What is AIRS? &rarr;</a>
      <a class="airs-btn airs-btn--secondary" href="/#roles">Find your role</a>
    </div>
  </div>
</section>
